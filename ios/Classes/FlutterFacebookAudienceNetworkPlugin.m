 #import "FlutterFacebookAudienceNetworkPlugin.h"
#import <flutter_facebook_audience_network/flutter_facebook_audience_network-Swift.h>

@implementation FlutterFacebookAudienceNetworkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterFacebookAudienceNetworkPlugin registerWithRegistrar:registrar];
}
@end
