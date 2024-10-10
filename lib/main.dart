import 'package:create_author/pages/favorite_page.dart';
import 'package:create_author/pages/home_page.dart';
import 'package:create_author/pages/post_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(CreateAnAuthor());

class CreateAnAuthor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      routes: {
        '/home': (context) => HomePage(),
        '/favorite': (context) => Favotire(),
        '/post': (context) => PostPage(),
      },
    );
  }
}
