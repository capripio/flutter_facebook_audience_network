#import <Flutter/Flutter.h>
@import FBAudienceNetwork;
@interface FlutterFacebookAudienceNetworkPlugin : NSObject<FlutterPlugin>
    @property(nonatomic, strong) FBInterstitialAd *interstitialAd;
@end
