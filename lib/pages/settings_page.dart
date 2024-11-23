import 'dart:async';
import 'package:create_author/components/indicator/indicator.dart';
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

class _SettingsPageState extends State<SettingsPage>
    with WidgetsBindingObserver {
  BannerAd? _bannerAd;
  OverlayEntry? _overlayEntry;
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<ProductDetails>? _products;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeAds();
    });
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen(_listenToPurchaseUpdated);
    _initializeInAppPurchase();
    _checkPurchaseHistory();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      debugPrint('App resumed - checking purchase status');
      _checkPurchaseHistory();
    }
  }

  void _initializeAds() {
    final adState = Provider.of<AdState>(context, listen: false);
    debugPrint('Current ad state: ${adState.isAdsRemoved}'); // 디버그 로그 추가
    if (!adState.isAdsRemoved) {
      _createBannerAd();
    }
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
    try {
      showOverlay(context);
      if (!Provider.of<AdState>(context, listen: false).isAdsRemoved) {
        if (_products != null && _products!.isNotEmpty) {
          debugPrint('Product ID: ${_products!.first.id}');
          debugPrint('Product Price: ${_products!.first.price}');

          final PurchaseParam purchaseParam = PurchaseParam(
            productDetails: _products!.first,
          );

          await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
        } else {
          throw Exception('No products available');
        }
      } else {
        await _inAppPurchase.restorePurchases();
      }
    } catch (e) {
      debugPrint('Purchase error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      hideOverlay();
    }
  }

  Future<void> _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (final purchaseDetails in purchaseDetailsList) {
      debugPrint('Purchase status: ${purchaseDetails.status}');
      debugPrint(
          'Purchase transactionDate: ${purchaseDetails.transactionDate}');

      if (purchaseDetails.status == PurchaseStatus.pending) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Purchase pending...')),
        );
      } else if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        final adState = Provider.of<AdState>(context, listen: false);
        await adState.removeAds();
        setState(() {
          _bannerAd?.dispose();
          _bannerAd = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Purchase successful!')),
        );
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        final error = purchaseDetails.error;
        if (error != null &&
            error.message != null &&
            error.message.contains('canceled')) {
          debugPrint('Purchase was canceled or refunded');
          final adState = Provider.of<AdState>(context, listen: false);
          await adState.resetIsAds();
          setState(() {
            _createBannerAd();
          });
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${purchaseDetails.error}')),
        );
      }

      if (purchaseDetails.pendingCompletePurchase) {
        await _inAppPurchase.completePurchase(purchaseDetails);
      }
    }
  }

  void _initializeInAppPurchase() async {
    bool available = await _inAppPurchase.isAvailable();
    if (available) {
      _getInAppInstance();
    } else {
      debugPrint('In-app purchases not available');
    }
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
      debugPrint('Verifying purchase status...');
      await _inAppPurchase.restorePurchases();
    } catch (e) {
      debugPrint('Purchase history check failed: $e');
    }
  }

  void test() {
    AdState().resetIsAds();
  }

  void showOverlay(BuildContext context) {
    if (_overlayEntry == null) {
      _overlayEntry = OverlayEntry(
        builder: (context) => Positioned.fill(
          child: Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(child: BouncingDotsIndicator()),
          ),
        ),
      );

      Overlay.of(context).insert(_overlayEntry!);
    }
  }

  void hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
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
                      Container(
                        width: _bannerAd!.size.width.toDouble(),
                        height: _bannerAd!.size.height.toDouble(),
                        margin: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey), // 디버깅용 테두리
                        ),
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
                      onTap: () {
                        showOverlay(context);
                        _handlePurchaseButton();
                      },
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
