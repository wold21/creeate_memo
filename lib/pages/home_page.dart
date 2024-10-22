import 'package:create_author/components/record/record_detail.dart';
import 'package:create_author/components/record/record_tile.dart';
import 'package:create_author/databases/record_helper.dart';
import 'package:create_author/models/record.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    final recordHelper = Provider.of<RecordHelper>(context);

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
                          vertical: 15.0, horizontal: 20.0),
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
                  FutureBuilder<List<RecordInfo>>(
                      future: recordHelper.getRecords(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // 로딩 중일 때
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          // 에러 발생 시
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          // 데이터가 없을 때
                          return Column(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                              ),
                              Center(
                                child: Text('Start your first record.',
                                    style: TextStyle(
                                        color: Color(0xFF4D4D4D),
                                        fontSize: 18)),
                              ),
                            ],
                          );
                        }
                        final records = snapshot.data!;
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
                      })
                ],
              ),
            ),
          ],
        ));
  }
}
