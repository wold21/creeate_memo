import 'package:flutter/material.dart';

class RecordCreate extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSubmit;
  final ValueNotifier<bool> isButtonEnabled = ValueNotifier(false);

  RecordCreate({
    Key? key,
    required this.controller,
    required this.onSubmit,
  }) : super(key: key) {
    controller.addListener(() {
      isButtonEnabled.value = controller.text.isNotEmpty;
    });
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
                  Text(
                    'New Record',
                    style: TextStyle(
                      color: Color(0xffF2F2F2),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      controller.clear();
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
                        controller: controller,
                        style: TextStyle(color: Color(0xffF2F2F2)),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'What\'s new',
                        ),
                        autofocus: true,
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
                          controller.text.trim().isNotEmpty ? true : false;
                      return TextButton(
                        onPressed: currentValue
                            ? () {
                                FocusScope.of(context).unfocus();
                                onSubmit(controller.text);
                                controller.clear();
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
