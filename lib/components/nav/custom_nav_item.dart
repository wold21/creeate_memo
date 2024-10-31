import 'package:create_author/config/color/custom_theme.dart';
import 'package:flutter/material.dart';

class CustomNavItem extends StatelessWidget {
  final int index;
  final Function(int) onTap;
  final IconData icon;
  final bool isActive;
  const CustomNavItem(
      {super.key,
      required this.index,
      required this.onTap,
      required this.icon,
      required this.isActive});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(index),
      child: Container(
        padding: const EdgeInsets.all(5),
        child: Icon(
          icon,
          size: 25,
          color: isActive
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }
}
