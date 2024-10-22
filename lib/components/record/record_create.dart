import 'package:create_author/models/record.dart';
import 'package:flutter/material.dart';

class RecordCreate extends StatefulWidget {
  final Function(RecordInfo) onSubmit;
  const RecordCreate({super.key, required this.onSubmit});

  @override
  State<RecordCreate> createState() => _RecordCreateState();
}

class _RecordCreateState extends State<RecordCreate> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  final ValueNotifier<bool> isButtonEnabled = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _descriptionController.addListener(() {
      isButtonEnabled.value = _descriptionController.text.trim().isNotEmpty;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    isButtonEnabled.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom, // 키보드가 올라오면 하단 패딩 추가
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.52,
        decoration: BoxDecoration(
          color: Color(0xff1A1918),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _titleController,
                      onChanged: (value) {
                        // setState(() {
                        //   _title = value;
                        // });
                      },
                      decoration: InputDecoration(
                        hintText: 'Title',
                        hintStyle: TextStyle(
                            color: Color(0xFF4D4D4D),
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                          color: Color(0xffF0EFEB),
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                      autofocus: true,
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      _titleController.clear();
                      _descriptionController.clear();
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Color(0xffF2F2F2),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _descriptionController,
                        style: TextStyle(color: Color(0xffF2F2F2)),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'What\'s new',
                          hintStyle: TextStyle(
                              color: Color(0xFF4D4D4D),
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        textInputAction: TextInputAction.newline,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ValueListenableBuilder<bool>(
                    valueListenable: isButtonEnabled,
                    builder: (context, value, child) {
                      bool currentValue =
                          _titleController.text.trim().isNotEmpty &&
                              _descriptionController.text.trim().isNotEmpty;
                      return TextButton(
                        onPressed: currentValue
                            ? () {
                                FocusScope.of(context).unfocus();
                                widget.onSubmit(RecordInfo.create(
                                  title: _titleController.text,
                                  description: _descriptionController.text,
                                ));
                                _titleController.clear();
                                _descriptionController.clear();
                                Navigator.pop(context);
                              }
                            : null,
                        style: TextButton.styleFrom(
                          backgroundColor:
                              currentValue ? Colors.white : Colors.grey[700],
                          foregroundColor: currentValue
                              ? Color(0xff1A1918)
                              : Colors.grey[700],
                          textStyle: TextStyle(
                              color: currentValue
                                  ? Color(0xff1A1918)
                                  : Color.fromARGB(255, 68, 68, 68)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text('Save'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
