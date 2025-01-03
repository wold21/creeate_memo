import 'package:create_author/components/nav/custom_nav_item.dart';
import 'package:create_author/config/color/custom_theme.dart';
import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  const CustomBottomNavBar(
      {super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).extension<CustomTheme>()!;
    return Container(
      height:
          MediaQuery.of(context).padding.bottom + kBottomNavigationBarHeight,
      decoration: BoxDecoration(
        color: themeColor.borderColor,
      ),
      padding: EdgeInsets.only(top: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
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
                icon: Icons.search_rounded,
                isActive: currentIndex == 1,
              ),
              CustomNavItem(
                index: 2,
                onTap: onTap,
                icon: Icons.star_border_sharp,
                isActive: currentIndex == 2,
              ),
              Container(
                decoration: BoxDecoration(
                  color: themeColor.recordCreateColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 5.0),
                  child: CustomNavItem(
                    index: -1,
                    icon: Icons.add_box_outlined,
                    onTap: onTap,
                    isActive: currentIndex == -1,
                  ),
                ),
              ),
              CustomNavItem(
                index: 3,
                onTap: onTap,
                icon: Icons.access_time_rounded,
                isActive: currentIndex == 3,
              ),
              CustomNavItem(
                index: 4,
                onTap: onTap,
                icon: Icons.settings,
                isActive: currentIndex == 4,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
