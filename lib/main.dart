import 'package:flutter/material.dart';
import 'package:flutternews/views/home.dart';

void main(){
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  bool darkThemeEnabled=false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NewsOpedia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          brightness: Brightness.dark,
              primarySwatch:  Colors.grey
      ),
      home: Home(),
    );
  }
}
