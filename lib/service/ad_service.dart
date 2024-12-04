import 'dart:io';

import 'package:create_author/config/state/ad_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class AdService {
  static String? get interstitialAdUnitId {
    if (Platform.isAndroid) {
      if (kDebugMode) {
        return 'ca-app-pub-3940256099942544/1033173712';
      }
      return 'ca-app-pub-7804050256012308/2527278419';
    } else if (Platform.isIOS) {
      if (kDebugMode) {
        return 'ca-app-pub-3940256099942544/4411468910';
      }
      return 'ca-app-pub-7804050256012308/2016443847';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      if (kDebugMode) {
        return 'ca-app-pub-3940256099942544/6300978111';
      }
      return 'ca-app-pub-7804050256012308/7268770523';
    } else if (Platform.isIOS) {
      if (kDebugMode) {
        return 'ca-app-pub-3940256099942544/2934735716';
      }
      return 'ca-app-pub-7804050256012308/7967478794';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static final BannerAdListener bannerAdListener = BannerAdListener(
    onAdLoaded: (ad) => debugPrint('Ad loaded.'),
    onAdFailedToLoad: (ad, err) {
      ad.dispose();
      debugPrint('Ad failed to load: $err');
    },
    onAdOpened: (ad) => debugPrint('Ad opened.'),
    onAdClosed: (ad) => debugPrint('Ad closed.'),
  );

  static Future<void> initAds(BuildContext context) async {
    final adState = Provider.of<AdState>(context, listen: false);
    if (!adState.isAdsRemoved) {
      await MobileAds.instance.initialize();
    }
  }

  static void disposeAd(InterstitialAd? interstitialAd, BannerAd? bannerAd) {
    interstitialAd?.dispose();
    bannerAd?.dispose();
  }
}
