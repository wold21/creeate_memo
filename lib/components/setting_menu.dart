import 'package:flutter/material.dart';

class SettingMenu extends StatelessWidget {
  Icon icon;
  String itemName;
  SettingMenu({super.key, required this.icon, required this.itemName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [icon, SizedBox(width: 15), Text(itemName)],
      ),
    );
  }
}
