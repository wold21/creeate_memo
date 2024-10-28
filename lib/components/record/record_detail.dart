import 'package:create_author/databases/record/record_helper.dart';
import 'package:create_author/models/record.dart';
import 'package:create_author/utils/date.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecordDetail extends StatefulWidget {
  final RecordInfo record;
  RecordDetail({super.key, required this.record});

  @override
  State<RecordDetail> createState() => _RecordDetailState();
}

class _RecordDetailState extends State<RecordDetail> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  late String _title;
  late String _description;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.record.title);
    _descriptionController =
        TextEditingController(text: widget.record.description);
    _title = widget.record.title;
    _description = widget.record.description;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveRecord() {
    final record = RecordInfo.update(
      id: widget.record.id,
      title: _title,
      description: _description,
      createAt: widget.record.createAt,
      isFavorite: widget.record.isFavorite,
    );
    Provider.of<RecordHelper>(context, listen: false).updateRecord(record);
  }

  void _closePop(bool isSaved) {
    if (isSaved) {
      _saveRecord();
    }
    if (MediaQuery.of(context).viewInsets.bottom > 0) {
      FocusScope.of(context).unfocus();
    } else {
      Navigator.pop(context);
    }
  }

  bool get _isFormValid {
    return _titleController.text.trim().isNotEmpty &&
        _descriptionController.text.trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1A1918),
      body: FocusScope(
        node: FocusScopeNode(),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          _closePop(false);
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Color(0xff1A1918),
                          foregroundColor: Colors.white,
                          textStyle: TextStyle(fontWeight: FontWeight.bold),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Back')),
                      ),
                      TextButton(
                        onPressed: () {
                          _isFormValid ? _closePop(true) : null;
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Color(0xff1A1918),
                          foregroundColor: _isFormValid
                              ? Color(0xffF0EFEB)
                              : Colors.grey[700],
                          textStyle: TextStyle(
                              color: _isFormValid
                                  ? Color(0xff1A1918)
                                  : Color(0xFF444444),
                              fontWeight: FontWeight.bold),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text('Save'),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _titleController,
                          onChanged: (value) {
                            setState(() {
                              _title = value;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Title',
                            hintStyle: TextStyle(
                                color: Color(0xFF4D4D4D),
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                              color: Color(0xffF0EFEB),
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          getDate(widget.record.createAt),
                          style: TextStyle(
                              color: Color(0xFF4D4D4D),
                              fontSize: 11,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: TextField(
                      controller: _descriptionController,
                      onChanged: (value) {
                        setState(() {
                          _description = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'What\'s new',
                        hintStyle: TextStyle(
                            color: Color(0xFF4D4D4D),
                            fontSize: 14,
                            fontWeight: FontWeight.w300),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                          color: Color(0xffF0EFEB),
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
        ),
      ),
    );
  }
}
