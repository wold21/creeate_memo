import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  static String? get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/1033173712';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/4411468910';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static final BannerAdListener bannerAdListener = BannerAdListener(
    onAdLoaded: (ad) {
      // print('Ad loaded: ${ad.adUnitId}.');
    },
    onAdFailedToLoad: (ad, error) {
      ad.dispose();
      // print('Ad failed to load: $error');
    },
    onAdOpened: (ad) {
      // print('Ad opened: ${ad.adUnitId}.');
    },
    onAdClosed: (ad) {
      // print('Ad closed: ${ad.adUnitId}.');
    },
  );
}
