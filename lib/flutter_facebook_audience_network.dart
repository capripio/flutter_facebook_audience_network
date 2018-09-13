import 'dart:async';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

enum AdEvent { diplayed, dismissed, error, loaded, clicked, impression }

typedef void AdListener(AdEvent event);

abstract class Ad {
  MethodChannel channel =
      const MethodChannel('flutter_facebook_audience_network');
  AdListener listener;
  final String placementID;

  static const Map<String, AdEvent> _adEvent = <String, AdEvent>{
    'onAdDisplayed': AdEvent.diplayed,
    'onAdClicked': AdEvent.clicked,
    'onAdDismissed': AdEvent.dismissed,
    'onAdError': AdEvent.error,
    'onAdLoaded': AdEvent.loaded,
    'onAdLoggingImpression': AdEvent.impression,
  };

  int get id => hashCode;

  Ad({@required this.placementID}) {
    channel.setMethodCallHandler(_handleMethod);
  }
  Future<dynamic> _handleMethod(MethodCall call) {
    // final Map<dynamic, dynamic> argumentsMap = call.arguments;
    final AdEvent _event = _adEvent[call.method];
    if (_event != null) {
      listener(_event);
    }
    return new Future<Null>(null);
  }

  void load();
}

class BannerAd extends Ad {
  BannerAd({@required String placementID}) : super(placementID: placementID) {
    channel.invokeMethod(
        'initBanner', <String, dynamic>{
          'placement_id': this.placementID
          });
  }

  @override
  void load() {
    channel.invokeMethod('bannerLoad', <String, dynamic>{
      'id': this.id,
    });
  }

  
}

class InterstitialAd extends Ad {
  InterstitialAd({@required String placementID})
      : super(placementID: placementID) {
    channel.invokeMethod('initInterstitial',
        <String, dynamic>{'placement_id': this.placementID});
  }

  @override
  void load() {
    channel.invokeMethod('interstitialLoad');
  }

  void show() {
    channel.invokeMethod('interstitialShow');
  }
}

class FlutterFacebookAudienceNetwork {
  MethodChannel _channel =
      const MethodChannel('flutter_facebook_audience_network');
  addTestDevice(String testDeviceHash) {
    _channel.invokeMethod(
        'addTestDevice', <String, dynamic>{'device_hash': testDeviceHash});
  }
}
