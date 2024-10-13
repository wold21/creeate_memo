import 'package:flutter/material.dart';

class DescriptionTile extends StatefulWidget {
  final String description;
  DescriptionTile({super.key, required this.description});

  @override
  State<DescriptionTile> createState() => _DescriptionTileState();
}

class _DescriptionTileState extends State<DescriptionTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.description.length > 100) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _isExpanded
                ? widget.description
                : '${widget.description.substring(0, 300)}...',
            style: TextStyle(
              color: Color(0xffF0EFEB),
              fontWeight: FontWeight.normal,
            ),
            maxLines: _isExpanded ? null : 5, // 줄 수 제한
            overflow: TextOverflow.visible,
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _isExpanded = !_isExpanded; // 상태 토글
              });
            },
            child: Text(
              _isExpanded ? '접기' : '더보기',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      );
    } else {
      // 300자 이하인 경우
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
