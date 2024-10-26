import 'package:create_author/components/nav/custom_nav_item.dart';
import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  const CustomBottomNavBar(
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
            index: 1,
            onTap: onTap,
            icon: Icons.star_border_sharp,
            isActive: currentIndex == 1,
          ),
          CustomNavItem(
            index: -1,
            icon: Icons.add_box_outlined,
            onTap: onTap,
            isActive: currentIndex == -1,
          ),
          CustomNavItem(
            index: 2,
            onTap: onTap,
            icon: Icons.access_time_rounded,
            isActive: currentIndex == 2,
          ),
          CustomNavItem(
            index: 3,
            onTap: onTap,
            icon: Icons.settings,
            isActive: currentIndex == 3,
          ),
        ],
      ),
    );
  }
}
