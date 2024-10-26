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
    );
    Provider.of<RecordHelper>(context, listen: false).updateRecord(record);
  }

  void _closePop(bool isSaved) {
    if (isSaved) {
      _saveRecord();
    }
    FocusScope.of(context).unfocus();
    Navigator.pop(context);
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
                      ElevatedButton(
                          onPressed: () {
                            _closePop(false);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xffF0EFEB),
                            foregroundColor: Color(0xff1A1918),
                            textStyle: TextStyle(
                                color: Color(0xff1A1918),
                                fontWeight: FontWeight.bold),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text('Back')),
                      ElevatedButton(
                          onPressed: () {
                            _closePop(true);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xffF0EFEB),
                            foregroundColor: Color(0xff1A1918),
                            textStyle: TextStyle(
                                color: Color(0xff1A1918),
                                fontWeight: FontWeight.bold),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text('Save')),
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
                                color: Color(0xffF0EFEB),
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                              color: Color(0xffF0EFEB),
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          getDate(widget.record.createAt),
                          style: TextStyle(
                              color: Color(0xFF4D4D4D),
                              fontSize: 12,
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
                        hintText: 'Description',
                        hintStyle: TextStyle(
                            color: Color(0xffF0EFEB),
                            fontSize: 15,
                            fontWeight: FontWeight.w300),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                          color: Color(0xffF0EFEB),
                          fontSize: 15,
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
