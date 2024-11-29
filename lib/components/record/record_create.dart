import 'package:create_author/config/color/custom_theme.dart';
import 'package:create_author/config/state/ad_state.dart';
import 'package:create_author/models/record.dart';
import 'package:create_author/service/ad_service.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecordCreate extends StatefulWidget {
  final Function(RecordInfo) onSubmit;
  const RecordCreate({super.key, required this.onSubmit});

  @override
  State<RecordCreate> createState() => _RecordCreateState();
}

class _RecordCreateState extends State<RecordCreate> with RestorationMixin {
  InterstitialAd? _interstitialAd;
  late final RestorableTextEditingController _titleController;
  late final RestorableTextEditingController _descriptionController;
  final ValueNotifier<bool> isButtonEnabled = ValueNotifier(false);
  final _adOnCounter = 3;

  @override
  void initState() {
    super.initState();
    final adState = Provider.of<AdState>(context, listen: false);
    if (!adState.isAdsRemoved) {
      _createInterstitialAd();
    }
    _titleController = RestorableTextEditingController();
    _descriptionController = RestorableTextEditingController();
    _descriptionController.value.addListener(() {
      isButtonEnabled.value =
          _descriptionController.value.text.trim().isNotEmpty;
    });
  }

  @override
  String? get restorationId => 'record_create_bottom_sheet';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_titleController, 'title');
    registerForRestoration(_descriptionController, 'description');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    isButtonEnabled.dispose();
    super.dispose();
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

  void _onAd() async {
    if (Provider.of<AdState>(context, listen: false).isAdsRemoved) return;

    bool isAdPossible = await adCounterCheck();
    if (isAdPossible && _interstitialAd != null) {
      _showInterstitialAd(); // 광고 표시
    } else {
      print("Ad is not ready or ad counter does not allow showing an ad.");
    }
  }

  Future<bool> adCounterCheck() async {
    final prefs = await SharedPreferences.getInstance();
    final adCounter = prefs.getInt('adCounter') ?? 0;
    if (adCounter >= _adOnCounter) {
      await prefs.setInt('adCounter', 0);
    } else {
      await prefs.setInt('adCounter', adCounter + 1);
    }
    return adCounter == _adOnCounter ? true : false;
  }

  void _showInterstitialAd() {
    if (_interstitialAd != null) {
      print("Showing ad");
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _createInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _createInterstitialAd();
        },
      );
      _interstitialAd!.show();
      _interstitialAd = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).extension<CustomTheme>()!;
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom, // 키보드가 올라오면 하단 패딩 추가
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.52,
        decoration: BoxDecoration(
          color: themeColor.borderColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _titleController.value,
                      onChanged: (value) {
                        // setState(() {
                        //   _title = value;
                        // });
                      },
                      decoration: InputDecoration(
                        hintText: 'Title',
                        hintStyle: TextStyle(
                            color: themeColor.colorSubGrey,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                      autofocus: true,
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      _titleController.value.text = '';
                      _descriptionController.value.text = '';
                      Navigator.pop(context);
                      _onAd();
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _descriptionController.value,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'What\'s new',
                          hintStyle: TextStyle(
                              color: themeColor.colorSubGrey,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        textInputAction: TextInputAction.newline,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ValueListenableBuilder<bool>(
                    valueListenable: isButtonEnabled,
                    builder: (context, value, child) {
                      bool currentValue = _titleController.value.text
                              .trim()
                              .isNotEmpty &&
                          _descriptionController.value.text.trim().isNotEmpty;
                      return GestureDetector(
                        onTap: currentValue
                            ? () {
                                FocusScope.of(context).unfocus();
                                widget.onSubmit(RecordInfo.insert(
                                  title: _titleController.value.text,
                                  description:
                                      _descriptionController.value.text,
                                ));
                                _titleController.value.text = '';
                                _descriptionController.value.text = '';
                                Navigator.pop(context);
                                _onAd();
                              }
                            : null,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Icon(
                            Icons.send_rounded,
                            size: 25,
                            color: currentValue
                                ? themeColor.onColor
                                : themeColor.offColor,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
