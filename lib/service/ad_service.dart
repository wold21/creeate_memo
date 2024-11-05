import 'dart:io';

class AdService {
  static String? get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/8691691433';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/5135589807';
    }
  }
}
