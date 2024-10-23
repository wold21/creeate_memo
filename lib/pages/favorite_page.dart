import 'package:create_author/components/record/record_detail.dart';
import 'package:create_author/components/record/record_tile.dart';
import 'package:create_author/databases/record_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritePage extends StatefulWidget {
  final ScrollController scrollController;
  const FavoritePage({super.key, required this.scrollController});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RecordHelper>(context, listen: false).getFavoriteRecords();
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
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Favorites',
                        style: TextStyle(
                            color: Color(0xffF0EFEB),
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Consumer<RecordHelper>(
                    builder: (context, recordHelper, child) {
                      final records = recordHelper.favoriteRecords;
                      if (records.isEmpty) {
                        return Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.4,
                            ),
                            Center(
                              child: Text('No favorite posts...',
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
