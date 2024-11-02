import 'dart:async';

import 'package:create_author/components/record/record_detail.dart';
import 'package:create_author/components/record/record_tile.dart';
import 'package:create_author/config/%08scroll_notifier.dart';
import 'package:create_author/config/color/custom_theme.dart';
import 'package:create_author/databases/record/record_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late ScrollNotifier? _scrollNotifier;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollNotifier = Provider.of<ScrollNotifier>(context, listen: false);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    print(_searchController.text);
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      // Provider.of<RecordHelper>(context, listen: false)
      //     .getSearchRecords(_searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).extension<CustomTheme>()!;
    return SingleChildScrollView(
        controller: _scrollNotifier?.scrollController,
        child: FocusScope(
          node: FocusScopeNode(),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Column(
              children: [
                SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 10.0, left: 25.0, right: 25.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Search',
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                width: 40,
                              ),
                              Expanded(
                                  child: SizedBox(
                                height: 30,
                                child: TextField(
                                  controller: _searchController,
                                  decoration: InputDecoration(
                                    hintText: 'title and description',
                                    hintStyle: TextStyle(
                                        color: themeColor.colorSubGrey,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400),
                                    prefixIcon: IconButton(
                                      icon:
                                          Icon(Icons.search_rounded, size: 20),
                                      onPressed: () {
                                        Provider.of<RecordHelper>(context,
                                                listen: false)
                                            .getSearchRecords(
                                                _searchController.text);
                                      },
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(Icons.clear_rounded, size: 20),
                                      onPressed: () {
                                        _searchController.clear();
                                        Provider.of<RecordHelper>(context,
                                                listen: false)
                                            .getSearchRecords('');
                                      },
                                    ),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 5),
                                  ),
                                ),
                              ))
                            ]),
                      ),
                      Consumer<RecordHelper>(
                        builder: (context, recordHelper, child) {
                          final records = recordHelper.searchRecords;
                          if (records.isEmpty) {
                            return Column(
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                ),
                                Center(
                                  child: Text('No search records',
                                      style: TextStyle(
                                          color: themeColor.colorSubGrey,
                                          fontSize: 18)),
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
                                      child:
                                          RecordTile(records: records[index]));
                                });
                          }
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
