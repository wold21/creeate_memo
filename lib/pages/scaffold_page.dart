import 'package:create_author/components/nav/custom_bottom_nav_bar.dart';
import 'package:create_author/components/record/record_create.dart';
import 'package:create_author/config/%08scroll_notifier.dart';
import 'package:create_author/config/color/custom_theme.dart';
import 'package:create_author/databases/record/record_helper.dart';
import 'package:create_author/models/record.dart';
import 'package:create_author/pages/favorite_page.dart';
import 'package:create_author/pages/graph_page.dart';
import 'package:create_author/pages/home_page.dart';
import 'package:create_author/pages/settings_page.dart';
import 'package:create_author/utils/vibrator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScaffoldPage extends StatefulWidget {
  const ScaffoldPage({super.key});

  @override
  State<ScaffoldPage> createState() => ScaffoldPageState();
}

class ScaffoldPageState extends State<ScaffoldPage> {
  late final List _pages;
  int _pageIndex = 0;

  @override
  void initState() {
    super.initState();

    // // 스크롤 이벤트 리스너 등록
    // _scrollController.addListener(() {
    //   if (_scrollController.position.userScrollDirection ==
    //       ScrollDirection.reverse) {
    //     setState(() {
    //       _bottomNavPosition = 100;
    //     });
    //   } else if (_scrollController.position.userScrollDirection ==
    //       ScrollDirection.forward) {
    //     // 위로 스크롤 시
    //     setState(() {
    //       _bottomNavPosition = 0;
    //     });
    //   }
    // });

    _pages = [HomePage(), FavoritePage(), GraphPage(), SettingsPage()];
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index == -1) {
      callVibration();
      showInputSheet();
    } else {
      setState(() {
        _pageIndex = index;
      });
    }
  }

  void showInputSheet() {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return RecordCreate(
          onSubmit: (RecordInfo record) {
            Provider.of<RecordHelper>(context, listen: false)
                .insertRecord(record);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).extension<CustomTheme>()!;
    return ChangeNotifierProvider(
      create: (_) => ScrollNotifier(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: themeColor.borderColor,
        body: Stack(
          children: [
            _pages[_pageIndex],
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: ClipRect(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.7), // 위쪽
                        Colors.black.withOpacity(0.0), // 아래쪽
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
            ),
            Consumer<ScrollNotifier>(
              builder: (context, scrollNotifier, child) {
                return AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  transform: Matrix4.translationValues(
                      0, scrollNotifier.bottomNavPosition, 0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                      ),
                      child: CustomBottomNavBar(
                          currentIndex: _pageIndex, onTap: _onItemTapped),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
