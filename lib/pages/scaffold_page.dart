import 'dart:ui';
import 'package:create_author/components/nav/custom_bottom_nav_bar.dart';
import 'package:create_author/components/record/record_create.dart';
import 'package:create_author/config/%08scroll_notifier.dart';
import 'package:create_author/config/color/custom_theme.dart';
import 'package:create_author/config/state/ad_state.dart';
import 'package:create_author/databases/record/record_helper.dart';
import 'package:create_author/models/record.dart';
import 'package:create_author/pages/favorite_page.dart';
import 'package:create_author/pages/graph_page.dart';
import 'package:create_author/pages/home_page.dart';
import 'package:create_author/pages/search_page.dart';
import 'package:create_author/pages/settings_page.dart';
import 'package:create_author/service/ad_service.dart';
import 'package:create_author/services/version_check_service.dart';
import 'package:create_author/utils/vibrator.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScaffoldPage extends StatefulWidget {
  const ScaffoldPage({super.key});

  @override
  State<ScaffoldPage> createState() => ScaffoldPageState();
}

class ScaffoldPageState extends State<ScaffoldPage> {
  final _versionCheckService = VersionCheckService();
  InterstitialAd? _interstitialAd;
  late final List _pages;
  int _pageIndex = 0;
  final _adOnCounter = 6;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomePage(),
      SearchPage(),
      FavoritePage(),
      GraphPage(),
      SettingsPage()
    ];
    _initializeAds();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeApp();
    });
  }

  Future<void> _initializeApp() async {
    await _versionCheckService.initialize();
    await _versionCheckService.checkForUpdate(context);
  }

  void _initializeAds() {
    final adState = Provider.of<AdState>(context, listen: false);
    if (!adState.isAdsRemoved) {
      _createInterstitialAd();
    }
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index == -1) {
      callVibration();
      showInputSheet();
    } else {
      if (_pageIndex == index) return;
      _onAd();
      setState(() {
        _pageIndex = index;
      });
    }
  }

  void _onAd() async {
    final adState = Provider.of<AdState>(context, listen: false);
    if (adState.isAdsRemoved) return;

    bool isAdPossible = await adCounterCheck();
    if (isAdPossible && _interstitialAd != null) {
      _showInterstitialAd();
    }
  }

  Future<bool> adCounterCheck() async {
    final prefs = await SharedPreferences.getInstance();
    final adCounter = prefs.getInt('adCounterPaging') ?? 0;
    final newCount = adCounter + 1;
    if (adCounter >= _adOnCounter) {
      await prefs.setInt('adCounterPaging', 0);
      return true;
    } else {
      await prefs.setInt('adCounterPaging', newCount);
      return false;
    }
  }

  void _showInterstitialAd() {
    if (_interstitialAd == null) return;

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('Failed to show fullscreen content: $error');
        ad.dispose();
        _createInterstitialAd();
      },
      onAdShowedFullScreenContent: (ad) {
        debugPrint('Ad showed fullscreen content.');
      },
    );

    _interstitialAd!.show();
    _interstitialAd = null;
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdService.interstitialAdUnitId!,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          print("Interstitial ad loaded successfully.");
          setState(() {
            _interstitialAd = ad;
          });
        },
        onAdFailedToLoad: (error) {
          print("Failed to load interstitial ad: $error");
          setState(() {
            _interstitialAd = null;
          });
        },
      ),
    );
  }

  void showInputSheet() {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return RecordCreate(
          onSubmit: (RecordInfo record) {
            Provider.of<RecordHelper>(context, listen: false)
                .insertRecord(record);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).extension<CustomTheme>()!;
    return ChangeNotifierProvider(
      create: (_) => ScrollNotifier(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: themeColor.borderColor,
        extendBody: true,
        body: Stack(
          children: [
            _pages[_pageIndex],
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: ClipRect(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.4),
                        Colors.black.withOpacity(0.0),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Consumer<ScrollNotifier>(
          builder: (context, scrollNotifier, child) {
            return AnimatedContainer(
              duration: Duration(milliseconds: 200),
              transform: Matrix4.translationValues(
                  0, scrollNotifier.bottomNavPosition, 0),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      height: kBottomNavigationBarHeight,
                      decoration: BoxDecoration(
                        color: themeColor.borderColor.withOpacity(0.7),
                      ),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                        ),
                        child: CustomBottomNavBar(
                          currentIndex: _pageIndex,
                          onTap: _onItemTapped,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
