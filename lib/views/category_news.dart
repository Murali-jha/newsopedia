import 'package:flutter/material.dart';
import 'package:flutternews/helper/news.dart';
import 'package:flutternews/model/article_model.dart';
import 'package:flutternews/views/article_view.dart';

class CategoryNews extends StatefulWidget {
  final String category;
  CategoryNews({this.category});
  @override
  _CategoryNewsState createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<CategoryNews> {

  List<ArticleModel> articles = new List<ArticleModel>();
  bool _loading =true;

  @override
  void initState() {
    super.initState();
    getCategories();
  }

  getCategories() async{
    CategoryNewsClass newsClass = CategoryNewsClass();
    await newsClass.getNews(widget.category);
    articles=newsClass.news;
    setState(() {
      _loading=false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Text(
              widget.category.toUpperCase(),
              style: TextStyle(
                color: Colors.deepOrangeAccent,
                letterSpacing: 0.5
              ),
            )
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30.0)),
        ),
        elevation: 0.0,
        actions: [
          Opacity(
            opacity: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Icon(
                  Icons.refresh
              ),
            ),
          )
        ],
      ),
      body: _loading?Center(
        child: Container(
          child: CircularProgressIndicator(),
        ),
      ):SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(15.0),
          child: Column(
            children: [
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
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 2),
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(6),bottomLeft:  Radius.circular(6))
          ),
          child: Container(
            margin: EdgeInsets.only(bottom: 16.0),
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
                    color: Colors.grey,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 320.0),
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
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

