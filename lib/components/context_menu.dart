import 'package:flutter/material.dart';

class ContextMenu extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color textColor;
  final Color iconColor;
  final VoidCallback onTap;
  const ContextMenu(
      {super.key,
      required this.title,
      required this.icon,
      required this.textColor,
      required this.iconColor,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
