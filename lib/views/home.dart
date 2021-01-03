import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutternews/helper/data.dart';
import 'package:flutternews/helper/news.dart';
import 'package:flutternews/model/Category_model.dart';
import 'package:flutternews/model/article_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutternews/views/article_view.dart';
import 'package:flutternews/views/category_news.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoryModel> categories = new List<CategoryModel>();
  List<ArticleModel> articles = new List<ArticleModel>();

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    categories = getCategories();
    get();
  }

  get() async{
    News newsClass = News();
    await newsClass.getNews();
    articles=newsClass.news;
    setState(() {
      _loading=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('News',style: TextStyle(letterSpacing: 0.5),),
            Text(
              'Opedia',
              style: TextStyle(color: Colors.deepOrangeAccent,letterSpacing: 0.5)
              ,
            ),
          ],

        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30.0)),
        ),
        elevation: 0.0,
      ),

        body: _loading?Center(
        child: Container(
          child: CircularProgressIndicator(),
        ),
      ):SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 16.0),
                height: 90,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return CategoryTile(
                          imageUrl: categories[index].imageUrl,
                          categoryName: categories[index].categoryName);
                    }),
              ),
              Container(
                padding: EdgeInsets.only(top: 16.0),
                child: ListView.builder(
                  itemCount: articles.length,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemBuilder: (context,index){
                    return BlogTile(
                      imageUrl: articles[index].urlToImage,
                      title: articles[index].title,
                      desc: articles[index].description,
                      url: articles[index].url,
                    );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  final String imageUrl, categoryName;

  CategoryTile({this.imageUrl, this.categoryName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context){
                  return CategoryNews(category: categoryName.toString().toLowerCase(),);
                }
            )
        );
      },
      child: Container(
        margin: EdgeInsets.only(right: 16),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                width: 130.0,
                height: 80.0,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.black38,
              ),
              width: 130.0,
              height: 80.0,
              child: Text(
                categoryName,
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w500,
                  fontSize: 14.0,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BlogTile extends StatelessWidget {
  final String imageUrl, title, desc,url;

  BlogTile({@required this.imageUrl, @required this.title, @required this.desc,@required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context){
                return ArticleView(blogUrl: url,);
              }
            )
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.0),
        width: MediaQuery.of(context).size.width,
        child: Container(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 2),
            alignment: Alignment.bottomCenter,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(6),bottomLeft:  Radius.circular(6))
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(imageUrl)
                ),
                SizedBox(height: 4.0,),
                Text(title,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600
                  ),
                ),
                SizedBox(height: 6.0,),
                Text(desc,
                  style: TextStyle(
                    color: Colors.grey
                  ),
                ),
                Padding(
                  padding:EdgeInsets.only(right: 10.0),
                  child: Text(">>>",
                    style: TextStyle(
                        color: Colors.deepOrangeAccent[100],
                        fontSize: 18.0
                    ),
                  ),
                ),
                Divider(
                  height: 20.0,
                  color: Colors.deepOrangeAccent[100],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
