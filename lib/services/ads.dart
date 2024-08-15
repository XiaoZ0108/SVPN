import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class Ads {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  final adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/2934735716';

  void displayBannerAds(VoidCallback onAdLoadedCallback) {
    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          // Notify the UI that the ad has loaded.
          _isLoaded = true;
          onAdLoadedCallback();
        },
        onAdFailedToLoad: (ad, err) {
          // Dispose of the ad if it fails to load.
          ad.dispose();
          _isLoaded = false;
        },
      ),
    )..load();
  }

  bool get isLoaded => _isLoaded;

  Widget getAdWidget() {
    if (_bannerAd != null && _isLoaded) {
      return Container(
        alignment: Alignment.center,
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  void dispose() {
    _bannerAd?.dispose();
  }
}
