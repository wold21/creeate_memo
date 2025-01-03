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
import 'package:flutter/foundation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase 초기화
  await Firebase.initializeApp();

  // Crashlytics 설정
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  // 플랫폼 에러도 Crashlytics에 기록
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // 디버그 모드에서 Crashlytics 수집 비활성화 (선택사항)
  await FirebaseCrashlytics.instance
      .setCrashlyticsCollectionEnabled(!kDebugMode);

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

class CreateAnAuthor extends StatelessWidget {
  const CreateAnAuthor({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeState>(builder: (context, themeState, child) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: themeState.currentTheme,
        restorationScopeId: 'app',
        home: ScaffoldPage(),
      );
    });
  }
}
