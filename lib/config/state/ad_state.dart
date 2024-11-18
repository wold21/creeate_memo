import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdState extends ChangeNotifier {
  bool _isAdsRemoved = false;
  bool get isAdsRemoved => _isAdsRemoved;

  AdState() {
    _loadAdsStatus();
  }

  Future<void> _loadAdsStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isAdsRemoved = prefs.getBool('ads_removed') ?? false;
    notifyListeners();
  }

  Future<void> removeAds() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('ads_removed', true);
    _isAdsRemoved = true;
    notifyListeners();
  }

  Future<void> resetIsAds() async {
    print("in");
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('ads_removed', false);
    print("out");
  }

  Future<bool> restorePurchases() async {
    final available = await InAppPurchase.instance.isAvailable();
    if (!available) {
      return false;
    }

    try {
      await InAppPurchase.instance.restorePurchases();
      await removeAds();
      return true;
    } catch (e) {
      print('Restore failed: $e');
      return false;
    }
  }
}
