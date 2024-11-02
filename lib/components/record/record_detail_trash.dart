import 'package:create_author/config/color/custom_theme.dart';
import 'package:create_author/models/record.dart';
import 'package:create_author/utils/date.dart';
import 'package:flutter/material.dart';

class RecordDetailTrash extends StatefulWidget {
  final RecordInfo record;
  RecordDetailTrash({super.key, required this.record});

  @override
  State<RecordDetailTrash> createState() => _RecordDetailTrashState();
}

class _RecordDetailTrashState extends State<RecordDetailTrash> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.record.title);
    _descriptionController =
        TextEditingController(text: widget.record.description);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).extension<CustomTheme>()!;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TextField(
                enabled: false,
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Title',
                  hintStyle: TextStyle(
                      color: themeColor.colorSubGrey,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  border: InputBorder.none,
                ),
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                getDate(widget.record.createAt),
                style: TextStyle(
                    color: themeColor.colorSubGrey,
                    fontSize: 11,
                    fontWeight: FontWeight.w300),
              ),
            ),
          ],
        ),
        backgroundColor: themeColor.borderColor,
        elevation: 0,
      ),
      backgroundColor: themeColor.borderColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
          child: Column(
            children: [
              Expanded(
                child: TextField(
                  enabled: false,
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    hintText: 'What\'s new',
                    hintStyle: TextStyle(
                        color: themeColor.colorSubGrey,
                        fontSize: 14,
                        fontWeight: FontWeight.w300),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w300),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  textInputAction: TextInputAction.newline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
