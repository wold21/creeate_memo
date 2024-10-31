import 'package:create_author/components/indicator/indicator.dart';
import 'package:create_author/config/color/custom_theme.dart';
import 'package:create_author/databases/contribution/contribution_helper.dart';
import 'package:create_author/databases/record/record_helper.dart';
import 'package:flutter/material.dart';

class DeleteDialog extends StatefulWidget {
  const DeleteDialog({super.key});

  @override
  State<DeleteDialog> createState() => _DeleteDialogState();
}

class _DeleteDialogState extends State<DeleteDialog> {
  OverlayEntry? _overlayEntry;

  void showOverlay(BuildContext context) {
    if (_overlayEntry == null) {
      _overlayEntry = OverlayEntry(
        builder: (context) => Positioned.fill(
          child: Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(child: BouncingDotsIndicator()),
          ),
        ),
      );

      Overlay.of(context).insert(_overlayEntry!);
    }
  }

  void hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    hideOverlay();
    super.dispose();
  }

  Future<void> deleteAllData() async {
    try {
      await RecordHelper().resetRecords();
      await ContributionHelper().resetContributions();
    } catch (e) {
      throw Exception('Failed to delete all data');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).extension<CustomTheme>()!;
    return AlertDialog(
      backgroundColor: themeColor.borderColor,
      title: Text(
        'Confirm Deletion',
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
      content: Text('Are you sure you want to delete all records?',
          style: TextStyle(fontSize: 14)),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            if (context.mounted) showOverlay(context);

            try {
              await deleteAllData();
            } catch (e) {
              if (context.mounted) hideOverlay();
            } finally {
              if (context.mounted) {
                hideOverlay();
                Navigator.of(context).pop();
              }
            }
          },
          child: Text('Delete'),
        ),
      ],
    );
  }
}
