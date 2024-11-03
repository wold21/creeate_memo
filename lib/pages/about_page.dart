import 'package:create_author/components/text_widget.dart';
import 'package:create_author/config/color/custom_theme.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).extension<CustomTheme>()!;
    return Scaffold(
      backgroundColor: themeColor.borderColor,
      appBar: AppBar(
        title: Text(
          'About NoteByDay',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: themeColor.borderColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'About the app',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(height: 10),
              TextWidget(
                  text:
                      'NoteByDay is a note-taking app that helps users keep track of how often they take notes with a calendar.'
                      'With a simple interface and visualization features, you can see and manage your daily notes.',
                  fontSize: 12,
                  isPadding: false),
              const SizedBox(height: 20),
              TextWidget(
                  text: 'About developers',
                  fontSize: 16,
                  isPadding: false,
                  isBold: true),
              const SizedBox(height: 10),
              TextWidget(
                  text: 'Developers: SeoHae\nEmail: seohae9513@gmail.com',
                  fontSize: 12,
                  isPadding: false,
                  isBold: false),
              const SizedBox(height: 20),
              TextWidget(
                  text: 'Licenses',
                  fontSize: 16,
                  isPadding: false,
                  isBold: true),
              const SizedBox(height: 10),
              TextWidget(
                  text:
                      'NoteByDay is an application licensed for personal, non-commercial use only. Some features of the app may include open source libraries, the licenses of which are subject to the policies of the respective library providers.',
                  fontSize: 12,
                  isPadding: false,
                  isBold: false),
              const SizedBox(height: 20),
              TextWidget(
                  text: 'Copyrights',
                  fontSize: 16,
                  isPadding: false,
                  isBold: true),
              const SizedBox(height: 10),
              TextWidget(
                  text: '© 2024 SeoHae. All rights reserved.',
                  fontSize: 12,
                  isPadding: false,
                  isBold: false),
            ],
          ),
        ),
      ),
    );
  }
}
