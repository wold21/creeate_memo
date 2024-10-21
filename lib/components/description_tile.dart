import 'package:flutter/material.dart';

class DescriptionTile extends StatefulWidget {
  final String description;
  const DescriptionTile({super.key, required this.description});

  @override
  State<DescriptionTile> createState() => _DescriptionTileState();
}

class _DescriptionTileState extends State<DescriptionTile> {
  @override
  Widget build(BuildContext context) {
    if (widget.description.length > 300) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${widget.description.substring(0, 300)}...',
            style: TextStyle(
              color: Color(0xffF0EFEB),
              fontWeight: FontWeight.normal,
            ),
            maxLines: 5,
            overflow: TextOverflow.visible,
          ),
        ],
      );
    } else {
      return Text(
        widget.description,
        style: TextStyle(
          color: Color(0xffF0EFEB),
          fontWeight: FontWeight.normal,
        ),
      );
    }
  }
}
