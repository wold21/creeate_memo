import 'dart:ui';

import 'package:create_author/pages/favorite_page.dart';
import 'package:create_author/pages/home_page.dart';
import 'package:create_author/pages/post_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ScaffoldPage extends StatefulWidget {
  const ScaffoldPage({super.key});

  @override
  State<ScaffoldPage> createState() => _ScaffoldPageState();
}

class _ScaffoldPageState extends State<ScaffoldPage> {
  late final List _pages;
  int _pageIndex = 0;
  bool _isBottomNavVisible = true;
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
          _isBottomNavVisible = false;
          _bottomNavPosition = 100;
        });
      } else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        // 위로 스크롤 시
        setState(() {
          _isBottomNavVisible = true;
          _bottomNavPosition = 20;
        });
      }
    });

    _pages = [
      HomePage(scrollController: _scrollController),
      PostPage(),
      FavotirePage(),
    ];
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _navigateBottomBar(int index) {
    setState(() {
      _pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            duration: Duration(milliseconds: 300),
            transform:
                Matrix4.translationValues(0, _bottomNavPosition, 0), // 슬라이딩 효과
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Theme(
                data: Theme.of(context).copyWith(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                child: BottomNavigationBar(
                  backgroundColor: Color(0xff1A1918),
                  currentIndex: _pageIndex,
                  onTap: (index) {
                    setState(() {
                      _pageIndex = index;
                    });
                  },
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  iconSize: 25,
                  items: const [
                    BottomNavigationBarItem(
                        icon: Icon(
                          Icons.home_filled,
                          color: Color.fromARGB(255, 72, 72, 72),
                        ),
                        activeIcon:
                            Icon(Icons.home_filled, color: Color(0xffF0EFEB)),
                        label: 'Home'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.add_box_outlined,
                            color: Color.fromARGB(255, 72, 72, 72)),
                        activeIcon: Icon(Icons.add_box_outlined,
                            color: Color(0xffF0EFEB)),
                        label: 'Post'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.favorite_border_rounded,
                            color: Color.fromARGB(255, 72, 72, 72)),
                        activeIcon: Icon(Icons.favorite_rounded,
                            color: Color(0xffF0EFEB)),
                        label: 'Favorite'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
