import 'package:create_author/components/indicator/indicator.dart';
import 'package:create_author/components/record/record_detail.dart';
import 'package:create_author/components/record/record_tile.dart';
import 'package:create_author/config/%08scroll_notifier.dart';
import 'package:create_author/config/color/custom_theme.dart';
import 'package:create_author/databases/record/record_helper.dart';
import 'package:create_author/pages/scaffold_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ScrollNotifier? _scrollNotifier;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RecordHelper>(context, listen: false)
          .getRecordsPage(refresh: true);
    });
    final scrollNotifier = Provider.of<ScrollNotifier>(context, listen: false);
    scrollNotifier.scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    final scrollController = _scrollNotifier!.scrollController;

    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (mounted) {
        Provider.of<RecordHelper>(context, listen: false).getRecordsPage();
      }
    }

    _scrollNotifier!
        .updateScrollDirection(scrollController.position.userScrollDirection);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _scrollNotifier = Provider.of<ScrollNotifier>(context, listen: false);
    _scrollNotifier?.scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollNotifier?.scrollController.removeListener(_scrollListener);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).extension<CustomTheme>()!;
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 20, left: 25, right: 25, bottom: 5),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Records',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              final scaffoldPageState =
                  context.findAncestorStateOfType<ScaffoldPageState>();
              scaffoldPageState?.showInputSheet();
            },
            child: Padding(
              padding:
                  EdgeInsets.only(top: 10, left: 25, right: 25, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(
                      'What\'s new',
                      style: TextStyle(
                          color: themeColor.colorDeepGrey, fontSize: 20),
                    ),
                  ),
                  Icon(
                    Icons.add_circle_outline_rounded,
                    size: 30,
                    color: themeColor.colorDeepGrey,
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification notification) {
                if (notification is OverscrollNotification) {
                  final double overscroll = notification.overscroll;
                  if (overscroll > 0) {
                    _scrollNotifier?.updateBottomNavPosition(100.0);
                  } else if (overscroll < 0) {
                    _scrollNotifier?.updateBottomNavPosition(0.0);
                  }
                }
                return true;
              },
              child: Consumer<RecordHelper>(
                builder: (context, recordHelper, child) {
                  final records = recordHelper.allRecords;

                  if (records.isEmpty && !recordHelper.isLoading) {
                    return Center(
                      child: Text('Start your first record.',
                          style: TextStyle(
                              color: themeColor.colorSubGrey, fontSize: 15)),
                    );
                  }

                  return ListView.builder(
                    controller: _scrollNotifier?.scrollController,
                    physics: AlwaysScrollableScrollPhysics(),
                    padding:
                        EdgeInsets.only(bottom: kBottomNavigationBarHeight),
                    itemCount:
                        records.length + (recordHelper.isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == records.length) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          child: Center(
                            child: BouncingDotsIndicator(),
                          ),
                        );
                      }

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  RecordDetail(record: records[index]),
                            ),
                          );
                        },
                        child: RecordTile(records: records[index]),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
