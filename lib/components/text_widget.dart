import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final double fontSize;
  final bool isPadding;
  final bool isBold;
  const TextWidget(
      {super.key,
      required this.text,
      required this.fontSize,
      this.isPadding = true,
      this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return isPadding
        ? Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Text(
              text,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: fontSize,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
            ))
        : Text(
            text,
            style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: fontSize,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
          );
  }
}
