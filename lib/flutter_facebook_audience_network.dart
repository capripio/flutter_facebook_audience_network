import 'dart:async';

import 'package:flutter/services.dart';

class FlutterFacebookAudienceNetwork {
  static const MethodChannel _channel =
      const MethodChannel('flutter_facebook_audience_network');

  FlutterFacebookAudienceNetwork() {
    _channel.setMethodCallHandler(_handleMethod);
  }

  initInterstitial(String placementId){
    _channel.invokeMethod('initInterstitial',<String, dynamic>{
      'placement_id':placementId
    });
  }

  Future<dynamic> _handleMethod(MethodCall call) {
    MethodCall temp = call;
    return new Future<Null>(null);
  }
}
