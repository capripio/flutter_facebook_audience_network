import 'dart:async';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

enum InterstitialAdEvent {
  diplayed,
  dismissed,
  error,
  loaded,
  clicked,
  impression
}

typedef void InterstitialAdListener(InterstitialAdEvent event);

class InterstitialAd {
  MethodChannel channel =
      const MethodChannel('flutter_facebook_audience_network');
  String _placementID;
  InterstitialAdListener listener;

  static const Map<String, InterstitialAdEvent> _interstitialAdEvent =
      <String, InterstitialAdEvent>{
    'onInterstitialDisplayed': InterstitialAdEvent.diplayed,
    'onInterstitialAdClicked': InterstitialAdEvent.clicked,
    'onInterstitialDismissed': InterstitialAdEvent.dismissed,
    'onInterstitialError': InterstitialAdEvent.error,
    'onInterstitialAdLoaded': InterstitialAdEvent.loaded,
    'onInterstitialLoggingImpression': InterstitialAdEvent.impression,
  };

  InterstitialAd() {
    channel.setMethodCallHandler(_handleMethod);
  }

  Future<dynamic> _handleMethod(MethodCall call) {
    // final Map<dynamic, dynamic> argumentsMap = call.arguments;
    final InterstitialAdEvent _event = _interstitialAdEvent[call.method];
    if (_event != null) {
      listener(_event);
    }
    return new Future<Null>(null);
  }

  init({@required String placementID}) {
    _placementID = placementID;
    channel.invokeMethod(
        'initInterstitial', <String, dynamic>{'placement_id': _placementID});
  }

  load() {
    channel.invokeMethod('interstitialLoad');
  }

  void show() {
    channel.invokeMethod('interstitialShow');
  }
}

class FlutterFacebookAudienceNetwork {
  MethodChannel _channel =
      const MethodChannel('flutter_facebook_audience_network');
  addTestDevice(String testDeviceHash){
    _channel.invokeMethod('addTestDevice', <String, dynamic>{
      'device_hash': testDeviceHash
    });
  }
}
