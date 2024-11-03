import 'package:create_author/components/record/record_detail.dart';
import 'package:create_author/components/record/record_tile.dart';
import 'package:create_author/config/%08scroll_notifier.dart';
import 'package:create_author/config/color/custom_theme.dart';
import 'package:create_author/databases/record/record_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  late ScrollNotifier? _scrollNotifier;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _scrollNotifier = Provider.of<ScrollNotifier>(context, listen: false);
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RecordHelper>(context, listen: false).getFavoriteRecords();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).extension<CustomTheme>()!;
    return SingleChildScrollView(
        controller: _scrollNotifier?.scrollController,
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
                      final records = recordHelper.favoriteRecords;
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
                                      fontSize: 15)),
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
