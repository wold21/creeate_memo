import 'package:create_author/config/%08scroll_notifier.dart';
import 'package:create_author/config/state/ad_state.dart';
import 'package:create_author/config/state/theme_state.dart';
import 'package:create_author/databases/record/record_helper.dart';
import 'package:create_author/pages/scaffold_page.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase 초기화
  await Firebase.initializeApp();

  // Crashlytics 설정
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  MobileAds.instance.initialize();

  final adState = AdState();
  await adState.restorePurchases();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => RecordHelper()),
    ChangeNotifierProvider(create: (_) => ThemeState()),
    ChangeNotifierProvider(create: (_) => ScrollNotifier()),
    ChangeNotifierProvider(create: (_) => AdState()),
  ], child: CreateAnAuthor()));
}

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
