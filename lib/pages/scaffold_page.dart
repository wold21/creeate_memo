import 'dart:ui';

import 'package:create_author/components/custom_bottom_nav_bar.dart';
import 'package:create_author/components/record_create.dart';
import 'package:create_author/pages/favorite_page.dart';
import 'package:create_author/pages/home_page.dart';
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
  final TextEditingController _controller = TextEditingController();

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
      FavotirePage(),
    ];
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index == -1) {
      _showInputSheet();
    } else {
      setState(() {
        _pageIndex = index > 1 ? index - 1 : index;
      });
    }
  }

  void _showInputSheet() {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return RecordCreate(
          controller: _controller,
          onSubmit: (String memo) {
            // 여기에 메모를 저장하는 로직 추가
            Navigator.pop(context); // 다이얼로그 닫기
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('메모가 추가되었습니다: $memo')),
            );
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
                // child: BottomNavigationBar(
                //   backgroundColor: Color(0xff1A1918),
                //   currentIndex: _pageIndex,
                //   onTap: _onItemTapped,
                //   showSelectedLabels: false,
                //   showUnselectedLabels: false,
                //   iconSize: 25,
                //   items: const [
                //     BottomNavigationBarItem(
                //         icon: Icon(
                //           Icons.home_filled,
                //           color: Color.fromARGB(255, 72, 72, 72),
                //         ),
                //         activeIcon:
                //             Icon(Icons.home_filled, color: Color(0xffF0EFEB)),
                //         label: 'Home'),
                //     BottomNavigationBarItem(
                //       icon: Icon(Icons.add_box_outlined,
                //           color: Color.fromARGB(255, 72, 72, 72)),
                //       activeIcon: Icon(Icons.add_box_outlined,
                //           color: Color(0xffF0EFEB)),
                //       label: 'Post',
                //     ),
                //     BottomNavigationBarItem(
                //         icon: Icon(Icons.favorite_border_rounded,
                //             color: Color.fromARGB(255, 72, 72, 72)),
                //         activeIcon: Icon(Icons.favorite_rounded,
                //             color: Color(0xffF0EFEB)),
                //         label: 'Favorite'),
                //   ],
                // ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
