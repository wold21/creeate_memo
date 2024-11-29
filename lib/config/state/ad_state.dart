import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class AdState with ChangeNotifier {
  bool _isAdsRemoved = false;
  static const String _adsRemovedKey = 'ads_removed_status';
  static const String _purchaseTokenKey = 'purchase_token';

  bool get isAdsRemoved => _isAdsRemoved;

  AdState() {
    _initializeState();
  }

  Future<void> _initializeState() async {
    try {
      await _loadAdsStatus();

      final inAppPurchase = InAppPurchase.instance;
      final available = await inAppPurchase.isAvailable();

      if (available) {
        await inAppPurchase.restorePurchases();

        const itemIds = {'remove_ads'};
        final response = await inAppPurchase.queryProductDetails(itemIds);

        if (response.error != null) {
          debugPrint('Product details query failed: ${response.error}');
        }
      }
    } catch (e) {
      debugPrint('Failed to initialize ad state: $e');
    }
  }

  Future<void> _loadAdsStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isAdsRemoved = prefs.getBool(_adsRemovedKey) ?? false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading ads status: $e');
    }
  }

  Future<void> removeAds() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_adsRemovedKey, true);
      _isAdsRemoved = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error removing ads: $e');
      throw Exception('An error occurred while removing ads');
    }
  }

  Future<void> restorePurchases() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isAdsRemoved = prefs.getBool(_adsRemovedKey) ?? false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error restoring purchases: $e');
    }
  }

  Future<void> resetIsAds() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_adsRemovedKey, false);
      _isAdsRemoved = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error resetting ads status: $e');
    }
  }

  // 구매 토큰 저장
  Future<void> savePurchaseToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_purchaseTokenKey, token);
    } catch (e) {
      debugPrint('Error saving purchase token: $e');
    }
  }

  // 구매 토큰 확인
  Future<String?> getPurchaseToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_purchaseTokenKey);
    } catch (e) {
      debugPrint('Error getting purchase token: $e');
      return null;
    }
  }
}
