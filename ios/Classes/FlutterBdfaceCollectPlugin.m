#import "FlutterBdfaceCollectPlugin.h"
#import "FaceBaseViewController.h"
#import "LivenessViewController.h"
#import "DetectionViewController.h"

@implementation FlutterBdfaceCollectPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"com.fluttercandies.bdface_collect"
            binaryMessenger:[registrar messenger]];
  FlutterBdfaceCollectPlugin* instance = [[FlutterBdfaceCollectPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([call.method isEqualToString:GetPlatformVersion]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if ([call.method isEqualToString:Init]) {
      [self init:call.arguments result:result];
  } else if ([call.method isEqualToString:Collect]) {
      [self collect:call.arguments result:result];
  } else if ([call.method isEqualToString:UnInit]) {
      [self unInit:result];
  } else {
    result(FlutterMethodNotImplemented);
  }
}

///  初始化
- (void)init:(NSString*)licenseId result:(FlutterResult)result{
    NSString* licensePath = [[NSBundle mainBundle] pathForResource:@"idl-license" ofType:@"face-ios"];
    NSAssert([[NSFileManager defaultManager] fileExistsAtPath:licensePath], @"license文件路径不对，请仔细查看文档");
    [[FaceSDKManager sharedInstance] setLicenseID:licenseId andLocalLicenceFile:licensePath];
    if ([[FaceSDKManager sharedInstance] canWork] == 0){
        result(NULL);
    }
    result(@"初始化失败");
}

/// 释放
- (void)unInit:(FlutterResult)result{
    [[FaceSDKManager sharedInstance] clearTrackedFaces];
    result(NULL);
}


/// 采集
- (void)collect:(NSDictionary*)faceConfigMap result:(FlutterResult)result{
    NSNumber* minFaceSize = faceConfigMap[@"minFaceSize"];
    NSNumber* notFace = faceConfigMap[@"notFace"];
    NSNumber* brightness = faceConfigMap[@"brightness"];
    NSNumber* blurness = faceConfigMap[@"blurness"];
    NSNumber* occlusion = faceConfigMap[@"occlusion"];
    NSNumber* headPitch = faceConfigMap[@"headPitch"];
    NSNumber* headYaw = faceConfigMap[@"headYaw"];
    NSNumber* headRoll = faceConfigMap[@"headRoll"];
    NSNumber* cropFace = faceConfigMap[@"cropFace"];
    NSNumber* sund = faceConfigMap[@"sund"];
    NSNumber* livenessRandom = faceConfigMap[@"livenessRandom"];
    NSArray* livenessTypes = faceConfigMap[@"livenessTypes"];
    // 设置最小检测人脸阈值
    [[FaceSDKManager sharedInstance] setMinFaceSize:minFaceSize.intValue];
    // 设置人脸检测精度阀值
    [[FaceSDKManager sharedInstance] setNotFaceThreshold:notFace.floatValue];
    // 设置亮度阀值
    [[FaceSDKManager sharedInstance] setIllumThreshold:brightness.floatValue];
    // 设置质量检测模糊阈值
    [[FaceSDKManager sharedInstance] setBlurThreshold:blurness.floatValue];
    // 左眼遮挡阀值
    [[FaceSDKManager sharedInstance] setOccluThreshold:occlusion.floatValue];
   // 设置人脸姿态角阈值阀值
    [[FaceSDKManager sharedInstance] setEulurAngleThrPitch:headPitch.floatValue yaw:headYaw.floatValue roll:headRoll.floatValue];
    // 截取人脸图片大小
    [[FaceSDKManager sharedInstance] setCropFaceSizeWidth:cropFace.floatValue];
    
    FaceBaseViewController* lvc;
    if (livenessTypes.count > 0){
        // 设置是否开启提示音
        [[IDLFaceLivenessManager sharedInstance] setEnableSound:sund.boolValue];
        NSMutableArray* liveActionArray = [NSMutableArray new];
        for (NSString *typeStr in livenessTypes) {
            if ([typeStr isEqualToString:@"Eye"]){
                [liveActionArray addObject:@(FaceLivenessActionTypeLiveEye)];
            } else if ([typeStr isEqualToString:@"Mouth"]){
                [liveActionArray addObject:@(FaceLivenessActionTypeLiveMouth)];
            } else if ([typeStr isEqualToString:@"HeadLeft"]){
                [liveActionArray addObject:@(FaceLivenessActionTypeLiveYawLeft)];
            } else if ([typeStr isEqualToString:@"HeadRight"]){
                [liveActionArray addObject:@(FaceLivenessActionTypeLiveYawRight)];
            } else if ([typeStr isEqualToString:@"HeadUp"]){
                [liveActionArray addObject:@(FaceLivenessActionTypeLivePitchUp)];
            } else if ([typeStr isEqualToString:@"HeadDown"]){
                [liveActionArray addObject:@(FaceLivenessActionTypeLivePitchDown)];
            }
        }
        LivenessViewController* lvc2 = [[LivenessViewController alloc] init];
        [lvc2 livenesswithList:liveActionArray order:!livenessRandom.boolValue numberOfLiveness:3];
        lvc = lvc2;
    } else {
        // 设置是否开启提示音
        [[IDLFaceDetectionManager sharedInstance] setEnableSound:sund.boolValue];
        lvc = [[DetectionViewController alloc] init];
    }
    lvc.completion = ^(NSDictionary* images, UIImage* originImage){
        if (images != nil && images[@"bestImage"] != nil && [images[@"bestImage"] count] != 0) {
            result(@{@"imageBase64":[images[@"bestImage"] lastObject]});
        } else {
            result(@{@"error":@"识别失败"});
        }
    };
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:lvc];
    navi.navigationBarHidden = true;
    navi.modalPresentationStyle = UIModalPresentationFullScreen;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:navi animated:YES completion:nil];
}
@end
