import 'package:create_author/components/record_tile.dart';
import 'package:create_author/models/record.dart';
import 'package:create_author/pages/scaffold_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final ScrollController scrollController;
  HomePage({super.key, required this.scrollController});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final List<RecordInfo> records = [
      RecordInfo(
        id: 1,
        title: 'First Title',
        description:
            'Why do we use it? It is a long established fact that a reader will be distracted...',
        createAt: '2021-10-10',
        isFavorite: true,
        replyCount: 3,
      ),
      RecordInfo(
          id: 2,
          title: 'Second Title',
          description: 'This is another description for the second record.',
          createAt: '2021-10-11',
          isFavorite: false,
          replyCount: 1),
      RecordInfo(
        id: 3,
        title: 'Third Title',
        description: 'Another description goes here.',
        createAt: '2021-10-12',
        isFavorite: true,
        replyCount: 0,
      ),
      RecordInfo(
          id: 4,
          title: 'Fourth Title',
          description: 'Description for the fourth record.',
          createAt: '2021-10-13',
          isFavorite: false,
          replyCount: 6),
      RecordInfo(
        id: 5,
        title: 'Fifth Title',
        description: 'Description for the fifth record.',
        createAt: '2021-10-13',
        isFavorite: false,
        replyCount: 0,
      ),
      RecordInfo(
        id: 6,
        title: 'Sixth Title',
        description: 'Description for the sixth record.',
        createAt: '2021-10-13',
        isFavorite: false,
        replyCount: 2,
      ),
      RecordInfo(
        id: 7,
        title: 'Seventh Title',
        description: 'Description for the seventh record.',
        createAt: '2021-10-13',
        isFavorite: false,
        replyCount: 0,
      ),
      RecordInfo(
        id: 8,
        title: 'Eighth Title',
        description: 'Description for the eighth record.',
        createAt: '2021-10-13',
        isFavorite: false,
        replyCount: 0,
      ),
      RecordInfo(
        id: 9,
        title: 'Ninth Title',
        description: 'Description for the ninth record.',
        createAt: '2021-10-13',
        isFavorite: false,
        replyCount: 0,
      ),
      RecordInfo(
        id: 10,
        title: 'Tenth Title',
        description: 'Description for the tenth record.',
        createAt: '2021-10-13',
        isFavorite: false,
        replyCount: 10,
      ),
    ];
    return SingleChildScrollView(
        controller: widget.scrollController,
        child: Column(
          children: [
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      final scaffoldPageState =
                          context.findAncestorStateOfType<ScaffoldPageState>();
                      scaffoldPageState?.showInputSheet();
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Text(
                            'What\'s new',
                            style: TextStyle(
                                color: Color(0xFF5F5F5F), fontSize: 20),
                          ),
                          Icon(
                            Icons.add_circle_outline_rounded,
                            size: 30,
                            color: Color(0xFF5F5F5F),
                          )
                        ],
                      ),
                    ),
                  ),
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: records.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return RecordTile(records: records[index]);
                      }),
                ],
              ),
            ),
          ],
        ));
  }
}
