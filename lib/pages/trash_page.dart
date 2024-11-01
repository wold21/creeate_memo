import 'package:create_author/config/color/custom_theme.dart';
import 'package:create_author/databases/record/record_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TrashPage extends StatefulWidget {
  const TrashPage({super.key});

  @override
  State<TrashPage> createState() => _TrashPageState();
}

class _TrashPageState extends State<TrashPage> {
  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).extension<CustomTheme>()!;
    return SingleChildScrollView(
        controller: ScrollController(),
        child: Column(
          children: [
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: 20.0, bottom: 10.0, left: 25.0, right: 25.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Favorites',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  Consumer<RecordHelper>(
                    builder: (context, recordHelper, child) {
                      final records = recordHelper.deletedRecords;
                      if (records.isEmpty) {
                        return Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.4,
                            ),
                            Center(
                              child: Text('No favorite records',
                                  style: TextStyle(
                                      color: themeColor.colorSubGrey,
                                      fontSize: 18)),
                            ),
                          ],
                        );
                      } else {
                        return Center(child: Text('on Data'));
                        // return ListView.builder(
                        //     physics: NeverScrollableScrollPhysics(),
                        //     itemCount: records.length,
                        //     shrinkWrap: true,
                        //     itemBuilder: (context, index) {
                        //       return GestureDetector(
                        //           onTap: () {
                        //             Navigator.push(
                        //               context,
                        //               MaterialPageRoute(
                        //                 builder: (context) => RecordDetail(
                        //                     record: records[index]),
                        //               ),
                        //             );
                        //           },
                        //           child: RecordTile(records: records[index]));
                        //     });
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