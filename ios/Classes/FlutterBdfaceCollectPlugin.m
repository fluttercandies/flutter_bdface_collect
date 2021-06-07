#import "FlutterBdfaceCollectPlugin.h"

@implementation FlutterBdfaceCollectPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_bdface_collect"
            binaryMessenger:[registrar messenger]];
  FlutterBdfaceCollectPlugin* instance = [[FlutterBdfaceCollectPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

///  初始化
- (void)init:(NSDictionary*)arguments result:(FlutterResult)result{
    NSString *licenseId  = arguments[@"licenseId"];
    NSString* licensePath = [[NSBundle mainBundle] pathForResource:@"idl-license" ofType:@"face-ios"];
    NSAssert([[NSFileManager defaultManager] fileExistsAtPath:licensePath], @"license文件路径不对，请仔细查看文档");
    [[FaceSDKManager sharedInstance] setLicenseID:licenseId andLocalLicenceFile:licensePath andRemoteAuthorize:true];
    result([NSNumber numberWithBool:[[FaceSDKManager sharedInstance] canWork]]);
}

@end
