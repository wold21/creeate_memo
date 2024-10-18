import 'package:create_author/pages/scaffold_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(CreateAnAuthor());

class CreateAnAuthor extends StatelessWidget {
  const CreateAnAuthor({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: ScaffoldPage(),
    );
  }
}
