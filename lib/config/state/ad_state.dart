import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdState extends ChangeNotifier {
  static const String _adsKey = 'ads_removed';
  bool _isAdsRemoved = false;
  bool get isAdsRemoved => _isAdsRemoved;

  AdState() {
    debugPrint('AdState initialized with default: $_isAdsRemoved');
    _loadAdsStatus();
  }

  Future<void> _loadAdsStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isAdsRemoved = prefs.getBool(_adsKey) ?? false;
      debugPrint('Loaded ads status: $_isAdsRemoved');
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading ads status: $e');
      _isAdsRemoved = false;
      notifyListeners();
    }
  }

  Future<void> removeAds() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_adsKey, true);
      _isAdsRemoved = true;
      debugPrint('Ads removed successfully');
      notifyListeners();
    } catch (e) {
      debugPrint('Error removing ads: $e');
    }
  }

  Future<void> resetIsAds() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_adsKey, false);
      _isAdsRemoved = false;
      debugPrint('Ads reset successfully');
      notifyListeners();
    } catch (e) {
      debugPrint('Error resetting ads: $e');
    }
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
