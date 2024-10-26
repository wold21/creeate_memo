import 'package:create_author/components/record/record_detail.dart';
import 'package:create_author/components/record/record_tile.dart';
import 'package:create_author/databases/record/record_helper.dart';
import 'package:create_author/pages/scaffold_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final ScrollController scrollController;
  const HomePage({super.key, required this.scrollController});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RecordHelper>(context, listen: false).getRecords();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        controller: widget.scrollController,
        child: Column(
          children: [
            SafeArea(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      final scaffoldPageState =
                          context.findAncestorStateOfType<ScaffoldPageState>();
                      scaffoldPageState?.showInputSheet();
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
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
                  Consumer<RecordHelper>(
                    builder: (context, recordHelper, child) {
                      final records = recordHelper.allRecords;
                      if (records.isEmpty) {
                        return Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.4,
                            ),
                            Center(
                              child: Text('Start your first record.',
                                  style: TextStyle(
                                      color: Color(0xFF4D4D4D), fontSize: 18)),
                            ),
                          ],
                        );
                      } else {
                        return ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: records.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => RecordDetail(
                                            record: records[index]),
                                      ),
                                    );
                                  },
                                  child: RecordTile(records: records[index]));
                            });
                      }
                    },
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
