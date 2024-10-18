import 'package:flutter/material.dart';

class CustomNavItem extends StatelessWidget {
  int index;
  final Function(int) onTap;
  IconData icon;
  bool isActive;
  CustomNavItem(
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color:
                isActive ? Color(0xffF0EFEB) : Color.fromARGB(255, 72, 72, 72),
          ),
        ],
      ),
    );
  }
}
