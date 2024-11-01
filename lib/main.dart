import 'package:create_author/config/%08scroll_notifier.dart';
import 'package:create_author/config/state/theme_state.dart';
import 'package:create_author/databases/record/record_helper.dart';
import 'package:create_author/pages/scaffold_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => RecordHelper()),
      ChangeNotifierProvider(create: (_) => ThemeState()),
      ChangeNotifierProvider(create: (_) => ScrollNotifier())
    ], child: CreateAnAuthor()));

class CreateAnAuthor extends StatefulWidget {
  const CreateAnAuthor({super.key});

  @override
  State<CreateAnAuthor> createState() => _CreateAnAuthorState();
}

class _CreateAnAuthorState extends State<CreateAnAuthor> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeState>(builder: (context, themeState, child) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: themeState.currentTheme,
        home: ScaffoldPage(),
      );
    });
  }
}
