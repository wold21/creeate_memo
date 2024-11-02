import 'package:create_author/components/text_widget.dart';
import 'package:create_author/config/color/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ReportFeedbackPage extends StatefulWidget {
  const ReportFeedbackPage({super.key});

  @override
  State<ReportFeedbackPage> createState() => _ReportFeedbackPageState();
}

class _ReportFeedbackPageState extends State<ReportFeedbackPage> {
  Future<void>? _launched;
  final Uri formUrl = Uri.parse('https://forms.gle/tHk59ggPJH1Dmikk7');
  Future<void> _launchInAppWithBrowserOptions() async {
    if (!await launchUrl(
      formUrl,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $formUrl');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).extension<CustomTheme>()!;
    return Scaffold(
        backgroundColor: themeColor.borderColor,
        appBar: AppBar(
          title: Text(
            'Bug Report & Feedback',
            style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
          backgroundColor: themeColor.borderColor,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              TextWidget(
                  text:
                      'If you find a feature or bug that you think we should improve, please fill out the form below and we\'ll update it as soon as possible.',
                  fontSize: 14),
              TextWidget(text: 'Thank you for your efforts.', fontSize: 14),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: ElevatedButton(
                  onPressed: () => setState(() {
                    _launched = _launchInAppWithBrowserOptions();
                  }),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor.calenderColor,
                  ),
                  child: TextWidget(text: 'Move to Form.', fontSize: 14),
                ),
              ),
            ],
          ),
        ));
  }
}

// Center(
//           child: ElevatedButton(
//             onPressed: () => setState(() {
//               _launched = _launchInAppWithBrowserOptions();
//             }),
//             child: const Text('Launch in app with title displayed'),
//           ),
//         ));