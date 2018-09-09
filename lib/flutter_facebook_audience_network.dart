import 'dart:async';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

enum InterstitialAdEvent{
  diplayed,
  dismissed,
  error,
  loaded,
  clicked,
  impression
}

typedef void InterstitialAdListener(InterstitialAdEvent event);

class FlutterFacebookAudienceNetwork {
  MethodChannel channel =
      const MethodChannel('flutter_facebook_audience_network');


  static final FlutterFacebookAudienceNetwork _instance  =
   new FlutterFacebookAudienceNetwork();

   static FlutterFacebookAudienceNetwork get instance => _instance;

  static const Map<String, InterstitialAdEvent> _interstitialAdEvent = <String, InterstitialAdEvent>{
    'onInterstitialDisplayed': InterstitialAdEvent.diplayed,
    'onInterstitialAdClicked': InterstitialAdEvent.clicked,
    'onInterstitialDismissed': InterstitialAdEvent.dismissed,
    'onInterstitialError': InterstitialAdEvent.error,
    'onInterstitialAdLoaded': InterstitialAdEvent.loaded,
    'onInterstitialLoggingImpression': InterstitialAdEvent.impression,
  };
  FlutterFacebookAudienceNetwork() {
    channel.setMethodCallHandler(_handleMethod);
  }

  Future<dynamic> _handleMethod(MethodCall call) {
    final Map<dynamic, dynamic> argumentsMap = call.arguments;
    final InterstitialAdEvent _event = _interstitialAdEvent[call.method];
    if(_event != null){
      InterstitialAd._instance.listener(_event);
    }
    return new Future<Null>(null);
  }

  void addTestDevice(String deviceHash) {
    this.channel.invokeMethod('addTestDevice',<String, dynamic>{"device_hash": deviceHash});
  }

  
}



class InterstitialAd{

  String _placementID;
  InterstitialAdListener listener;
  FlutterFacebookAudienceNetwork ffan;

  InterstitialAd(){
    ffan = FlutterFacebookAudienceNetwork.instance;
  }

  init({@required String placementID}){
    this._placementID = placementID;
    ffan.channel
      .invokeMethod('initInterstitial',<String, dynamic>{'placement_id': _placementID});
  }

  load(){
    ffan.channel
    .invokeMethod('interstitialLoad');
  }

  static final InterstitialAd _instance = new InterstitialAd();

  static InterstitialAd get instance => _instance;

  void show() {
    ffan.channel.invokeMethod('interstitialShow');
  }

}