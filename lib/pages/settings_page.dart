import 'dart:async';
import 'package:create_author/config/state/ad_state.dart';
import 'package:create_author/components/dialog/delete_dialog.dart';
import 'package:create_author/components/setting_menu.dart';
import 'package:create_author/config/state/theme_state.dart';
import 'package:create_author/pages/about_page.dart';
import 'package:create_author/pages/report_feedback_page.dart';
import 'package:create_author/pages/trash_page.dart';
import 'package:create_author/service/ad_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  BannerAd? _bannerAd;
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<ProductDetails>? _products;

  @override
  void initState() {
    super.initState();
    final adState = Provider.of<AdState>(context, listen: false);
    if (!adState.isAdsRemoved) {
      _createBannerAd();
    }
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen(_listenToPurchaseUpdated);
    _initializeInAppPurchase();
    _checkPurchaseHistory();
  }

  void _createBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: AdService.bannerAdUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: AdService.bannerAdListener,
    )..load();
  }

  Future<void> _handlePurchaseButton() async {
    if (!Provider.of<AdState>(context, listen: false).isAdsRemoved) {
      if (_products != null && _products!.isNotEmpty) {
        final PurchaseParam purchaseParam =
            PurchaseParam(productDetails: _products!.first);
        try {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('구매를 진행중입니다...')),
          );
          await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('구매 실패: $e\n구매 내역을 복원합니다.')),
          );
          await _inAppPurchase.restorePurchases();
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('상품 정보를 불러올 수 없습니다.')),
        );
      }
    } else {
      try {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('구매 내역을 복원중입니다...')),
        );
        await _inAppPurchase.restorePurchases();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('구매 내역 복원 실패: $e')),
        );
      }
    }
  }

  Future<void> _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (final purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        final adState = Provider.of<AdState>(context, listen: false);
        await adState.removeAds();
        setState(() {
          _bannerAd?.dispose();
          _bannerAd = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('광고가 제거되었습니다!')),
        );
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('오류가 발생했습니다: ${purchaseDetails.error}')),
        );
      }
    }
  }

  void _initializeInAppPurchase() async {
    bool available = await _inAppPurchase.isAvailable();
    if (available) {
      _getInAppInstance();
    } else {}
  }

  void _getInAppInstance() async {
    const Set<String> itemIds = {'remove_ads'};
    final ProductDetailsResponse response =
        await _inAppPurchase.queryProductDetails(itemIds);

    if (response.notFoundIDs.isNotEmpty) {
      return;
    }
    setState(() {
      _products = response.productDetails;
    });
  }

  Future<void> _checkPurchaseHistory() async {
    try {
      // 구매 이력 확인 시도
      await _inAppPurchase.restorePurchases();
    } catch (e) {
      // 오류 발생시 처리
      debugPrint('Purchase history check failed: $e');
    }
  }

  void test() {
    AdState().resetIsAds();
  }

  @override
  void dispose() {
    _subscription.cancel();
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<ThemeState>(context);

    void showDeleteConfirmationDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return DeleteDialog();
        },
      );
    }

    return Consumer<AdState>(builder: (context, adState, child) {
      return SafeArea(
        child: Stack(children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: 20.0, bottom: 10.0, left: 25.0, right: 25.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Settings',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: 10.0, bottom: 10.0, left: 20.0, right: 25.0),
                child: Column(
                  children: [
                    if (_bannerAd != null)
                      SizedBox(
                        height: 60, // 광고의 높이 설정
                        child: AdWidget(ad: _bannerAd!),
                      ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Theme'),
                          ToggleButtons(
                            borderRadius: BorderRadius.circular(10),
                            isSelected: [
                              themeState.isThemeToggle,
                              !themeState.isThemeToggle,
                            ],
                            onPressed: (index) {
                              themeState.toggleTheme(); // 테마 변경
                            },
                            children: const [
                              Icon(Icons.light_mode_rounded),
                              Icon(Icons.dark_mode_rounded),
                            ],
                          )
                        ],
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: 10.0),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Text('Language'),
                    //       ToggleButtons(children: [
                    //         Text('Kor'),
                    //         Text('Eng'),
                    //       ], isSelected: [
                    //         true,
                    //         false
                    //       ])
                    //     ],
                    //   ),
                    // ),
                    GestureDetector(
                      onTap: () {
                        showDeleteConfirmationDialog(context);
                      },
                      child: SettingMenu(
                        icon: Icon(Icons.restore_rounded),
                        itemName: 'Reset Records',
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => TrashPage(),
                            ));
                      },
                      child: SettingMenu(
                        icon: Icon(Icons.delete_rounded),
                        itemName: 'Trash',
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => ReportFeedbackPage(),
                            ));
                      },
                      child: SettingMenu(
                        icon: Icon(Icons.feedback),
                        itemName: 'Bug Report & Feedback',
                      ),
                    ),
                    GestureDetector(
                      onTap:
                          adState.isAdsRemoved ? null : _handlePurchaseButton,
                      child: SettingMenu(
                        icon: adState.isAdsRemoved
                            ? Icon(Icons.shopping_cart_rounded)
                            : Icon(Icons.highlight_remove_sharp),
                        itemName:
                            adState.isAdsRemoved ? 'Restore' : 'Remove Ads',
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => AboutPage(),
                            ));
                      },
                      child: SettingMenu(
                        icon: Icon(Icons.info_outline_rounded),
                        itemName: 'About',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ]),
      );
    });
  }
}
