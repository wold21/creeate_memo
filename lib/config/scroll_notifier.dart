import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ScrollNotifier extends ChangeNotifier {
  final ScrollController scrollController = ScrollController();
  double _bottomNavPosition = 0;
  double get bottomNavPosition => _bottomNavPosition;

  void updateScrollDirection(ScrollDirection scrollDirection) {
    if (scrollDirection == ScrollDirection.reverse) {
      _bottomNavPosition = 100;
    } else if (scrollDirection == ScrollDirection.forward) {
      _bottomNavPosition = 0;
    }
    notifyListeners();
  }

  void updateBottomNavPosition(double amount) {
    _bottomNavPosition = amount;
    notifyListeners();
  }

  void keyboardVisibilityListener(
      BuildContext context, ScrollDirection scrollDirection) {
    if (scrollDirection == ScrollDirection.reverse) {
      updateBottomNavPosition(MediaQuery.of(context).viewInsets.bottom);
    } else if (scrollDirection == ScrollDirection.forward) {
      updateBottomNavPosition(0);
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
