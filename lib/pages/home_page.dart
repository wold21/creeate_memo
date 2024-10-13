import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  ScrollController scrollController;
  HomePage({super.key, required this.scrollController});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          controller: widget.scrollController,
          itemCount: 30,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                'Item $index',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Text('Subtitle $index'),
              leading: Icon(Icons.account_circle),
              trailing: Icon(Icons.arrow_forward_ios),
            );
          }),
    );
  }
}
