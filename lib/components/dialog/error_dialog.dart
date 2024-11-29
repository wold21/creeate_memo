import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorDialog({
    Key? key,
    required this.message,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red),
          SizedBox(width: 8),
          Text('오류가 발생했습니다'),
        ],
      ),
      content: Text(
        // 기술적인 에러 메시지를 사용자 친화적으로 변환
        _getUserFriendlyMessage(message),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('확인'),
        ),
        if (onRetry != null)
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onRetry!();
            },
            child: Text('다시 시도'),
          ),
      ],
    );
  }

  String _getUserFriendlyMessage(String technicalMessage) {
    // 기술적인 에러 메시지를 사용자가 이해하기 쉬운 메시지로 변환
    if (technicalMessage.contains('network')) {
      return '인터넷 연결을 확인해주세요.';
    } else if (technicalMessage.contains('permission')) {
      return '필요한 권한이 없습니다. 설정에서 권한을 확인해주세요.';
    }
    return '일시적인 오류가 발생했습니다. 잠시 후 다시 시도해주세요.';
  }
}
