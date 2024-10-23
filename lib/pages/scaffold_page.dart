import 'package:create_author/components/nav/custom_bottom_nav_bar.dart';
import 'package:create_author/components/record/record_create.dart';
import 'package:create_author/databases/record_helper.dart';
import 'package:create_author/models/record.dart';
import 'package:create_author/pages/favorite_page.dart';
import 'package:create_author/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class ScaffoldPage extends StatefulWidget {
  const ScaffoldPage({super.key});

  @override
  State<ScaffoldPage> createState() => ScaffoldPageState();
}

class ScaffoldPageState extends State<ScaffoldPage> {
  late final List _pages;
  int _pageIndex = 0;
  double _bottomNavPosition = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // 스크롤 이벤트 리스너 등록
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        setState(() {
          _bottomNavPosition = 100;
        });
      } else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        // 위로 스크롤 시
        setState(() {
          _bottomNavPosition = 0;
        });
      }
    });

    _pages = [
      HomePage(scrollController: _scrollController),
      FavoritePage(scrollController: _scrollController),
    ];
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index == -1) {
      showInputSheet();
    } else {
      setState(() {
        _pageIndex = index > 1 ? index - 1 : index;
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
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xff1A1918),
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
          AnimatedContainer(
            duration: Duration(milliseconds: 200),
            transform:
                Matrix4.translationValues(0, _bottomNavPosition, 0), // 슬라이딩 효과
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
          ),
        ],
      ),
    );
  }
}
