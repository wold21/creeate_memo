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
    return GestureDetector(
      onTap: () {
        onTap(index);
      },
      child: Icon(
        icon,
        color: isActive ? Color(0xffF0EFEB) : Color.fromARGB(255, 72, 72, 72),
        size: 25,
      ),
    );
  }
}
