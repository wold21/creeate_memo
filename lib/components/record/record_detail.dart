import 'package:create_author/config/color/custom_theme.dart';
import 'package:create_author/databases/record/record_helper.dart';
import 'package:create_author/models/record.dart';
import 'package:create_author/service/ad_service.dart';
import 'package:create_author/utils/date.dart';
import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class RecordDetail extends StatefulWidget {
  final RecordInfo record;
  RecordDetail({super.key, required this.record});

  @override
  State<RecordDetail> createState() => _RecordDetailState();
}

class _RecordDetailState extends State<RecordDetail> {
  // InterstitialAd? _interstitialAd;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  late String _title;
  late String _description;

  @override
  void initState() {
    super.initState();
    // _createInterstitialAd();
    _titleController = TextEditingController(text: widget.record.title);
    _descriptionController =
        TextEditingController(text: widget.record.description);
    _title = widget.record.title;
    _description = widget.record.description;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // void _createInterstitialAd() {
  //   print("interstitial ad created");
  //   InterstitialAd.load(
  //     adUnitId: AdService.interstitialAdUnitId!,
  //     request: const AdRequest(),
  //     adLoadCallback: InterstitialAdLoadCallback(
  //       onAdLoaded: (ad) {
  //         setState(() {
  //           _interstitialAd = ad;
  //         });
  //       },
  //       onAdFailedToLoad: (error) {
  //         print('InterstitialAd failed to load: $error');
  //         setState(() {
  //           _interstitialAd = null;
  //         });
  //       },
  //     ),
  //   );
  // }

  void _saveRecord() {
    final record = RecordInfo.update(
      id: widget.record.id,
      title: _title,
      description: _description,
      createAt: widget.record.createAt,
      isFavorite: widget.record.isFavorite,
    );
    Provider.of<RecordHelper>(context, listen: false).updateRecord(record);
  }

  void _closePop(bool isSaved) {
    if (isSaved) {
      _saveRecord();
    }
    if (MediaQuery.of(context).viewInsets.bottom > 0) {
      FocusScope.of(context).unfocus();
    } else {
      Navigator.pop(context);
    }
  }

  // void _showInterstitialAd() {
  //   print("showing interstitial ad");
  //   if (_interstitialAd != null) {
  //     _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
  //       onAdDismissedFullScreenContent: (ad) {
  //         ad.dispose();
  //         _createInterstitialAd();
  //       },
  //       onAdFailedToShowFullScreenContent: (ad, error) {
  //         ad.dispose();
  //         _createInterstitialAd();
  //       },
  //     );
  //     _interstitialAd!.show();
  //     _interstitialAd = null;
  //   }
  // }

  bool get _isFormValid {
    return _titleController.text.trim().isNotEmpty &&
        _descriptionController.text.trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).extension<CustomTheme>()!;
    return Scaffold(
      backgroundColor: themeColor.borderColor,
      body: FocusScope(
        node: FocusScopeNode(),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          _closePop(false);
                          // _showInterstitialAd();
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: themeColor.borderColor,
                          foregroundColor:
                              Theme.of(context).colorScheme.primary,
                          textStyle: TextStyle(fontWeight: FontWeight.bold),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Back')),
                      ),
                      TextButton(
                        onPressed: () {
                          _isFormValid ? _closePop(true) : null;
                          // _showInterstitialAd();
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: themeColor.borderColor,
                          foregroundColor: _isFormValid
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.secondary,
                          textStyle: TextStyle(
                              color: _isFormValid
                                  ? themeColor.colorDeepGrey
                                  : Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.bold),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text('Save'),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _titleController,
                          onChanged: (value) {
                            setState(() {
                              _title = value;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Title',
                            hintStyle: TextStyle(
                                color: themeColor.colorSubGrey,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: TextField(
                      controller: _descriptionController,
                      onChanged: (value) {
                        setState(() {
                          _description = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'What\'s new',
                        hintStyle: TextStyle(
                            color: themeColor.colorSubGrey,
                            fontSize: 14,
                            fontWeight: FontWeight.w300),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w300),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      textInputAction: TextInputAction.newline,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          getDate(widget.record.createAt),
                          style: TextStyle(
                              color: themeColor.colorDeepGrey,
                              fontSize: 12,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
