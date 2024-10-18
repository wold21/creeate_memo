import 'package:create_author/components/custom_nav_item.dart';
import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  CustomBottomNavBar(
      {super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.07,
      decoration: BoxDecoration(
        color: Color(0xff1A1918),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CustomNavItem(
            index: 0,
            onTap: onTap,
            icon: Icons.home_filled,
            isActive: currentIndex == 0,
          ),
          CustomNavItem(
            index: -1,
            icon: Icons.add_box_outlined,
            onTap: onTap,
            isActive: currentIndex == -1,
          ),
          CustomNavItem(
            index: 1,
            onTap: onTap,
            icon: Icons.favorite_border_rounded,
            isActive: currentIndex == 1,
          ),
        ],
      ),
    );
  }
}
