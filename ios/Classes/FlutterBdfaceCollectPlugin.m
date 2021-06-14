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
  if ([@"getPlatformVersion"
       isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

///  初始化
- (void)init:(NSString*)licenseId result:(FlutterResult)result{
    NSString* licensePath = [[NSBundle mainBundle] pathForResource:@"idl-license" ofType:@"face-ios"];
    NSAssert([[NSFileManager defaultManager] fileExistsAtPath:licensePath], @"license文件路径不对，请仔细查看文档");
    [[FaceSDKManager sharedInstance] setLicenseID:licenseId andLocalLicenceFile:licensePath andRemoteAuthorize:true];
    result([NSNumber numberWithBool:[[FaceSDKManager sharedInstance] canWork]]);
}

/// 采集
- (void)collect:(NSDictionary*)faceConfigMap result:(FlutterResult)result{
    NSNumber* minFaceSize = faceConfigMap[@"minFaceSize"];
    NSNumber* notFace = faceConfigMap[@"notFace"];
    NSNumber* brightness = faceConfigMap[@"brightness"];
    NSNumber* brightnessMax = faceConfigMap[@"brightnessMax"];
    NSNumber* blurness = faceConfigMap[@"blurness"];
    NSNumber* occlusionLeftEye = faceConfigMap[@"occlusionLeftEye"];
    NSNumber* occlusionRightEye = faceConfigMap[@"occlusionRightEye"];
    NSNumber* occlusionNose = faceConfigMap[@"occlusionNose"];
    NSNumber* occlusionMouth = faceConfigMap[@"occlusionMouth"];
    NSNumber* occlusionLeftContour = faceConfigMap[@"occlusionLeftContour"];
    NSNumber* occlusionRightContour = faceConfigMap[@"occlusionRightContour"];
    NSNumber* occlusionChin = faceConfigMap[@"occlusionChin"];
    NSNumber* headPitch = faceConfigMap[@"headPitch"];
    NSNumber* headYaw = faceConfigMap[@"headYaw"];
    NSNumber* headRoll = faceConfigMap[@"headRoll"];
    NSNumber* eyeClosed = faceConfigMap[@"eyeClosed"];
    NSNumber* cacheImageNum = faceConfigMap[@"cacheImageNum"];
    NSNumber* scale = faceConfigMap[@"cacheImageNum"];
    NSNumber* cropHeight = faceConfigMap[@"cropHeight"];
    NSNumber* cropWidth = faceConfigMap[@"cropWidth"];
    NSNumber* enlargeRatio = faceConfigMap[@"enlargeRatio"];
    NSNumber* faceFarRatio = faceConfigMap[@"faceFarRatio"];
    NSNumber* faceClosedRatio = faceConfigMap[@"faceClosedRatio"];
    NSNumber* sund = faceConfigMap[@"sund"];
    NSNumber* livenessRandom = faceConfigMap[@"livenessRandom"];
    NSNumber* livenessRandomCount = faceConfigMap[@"livenessRandomCount"];
    NSNumber* secType = faceConfigMap[@"secType"];
    NSArray* livenessTypes = faceConfigMap[@"livenessTypes"];
    // 设置最小检测人脸阈值
    [[FaceSDKManager sharedInstance] setMinFaceSize:minFaceSize.intValue];
    // 设置人脸检测精度阀值
    [[FaceSDKManager sharedInstance] setNotFaceThreshold:notFace.floatValue];
    // 设置质量检测模糊阈值
    [[FaceSDKManager sharedInstance] setBlurThreshold:blurness.floatValue];
    // 左眼遮挡阀值
    [[FaceSDKManager sharedInstance] setOccluLeftEyeThreshold:occlusionLeftEye.floatValue];
    // 右眼遮挡阀值
    [[FaceSDKManager sharedInstance] setOccluRightEyeThreshold:occlusionRightEye.floatValue];
    // 左脸颊遮挡阀值
    [[FaceSDKManager sharedInstance] setOccluLeftCheekThreshold:occlusionLeftContour.floatValue];
    // 右右脸颊遮挡阀值眼遮挡阀值
    [[FaceSDKManager sharedInstance] setOccluLeftCheekThreshold:occlusionRightContour.floatValue];
    // 鼻子遮挡阀值
    [[FaceSDKManager sharedInstance] setOccluNoseThreshold:occlusionNose.floatValue];
    // 嘴巴遮挡阀值
    [[FaceSDKManager sharedInstance] setOccluMouthThreshold:occlusionMouth.floatValue];
    // 下巴遮挡阀值
    [[FaceSDKManager sharedInstance] setCropChinExtend:occlusionChin.floatValue];
    // 嘴巴遮设置人脸姿态角阈值阀值
    [[FaceSDKManager sharedInstance] setEulurAngleThrPitch:headPitch.floatValue yaw:headYaw.floatValue roll:headRoll.floatValue];
    // 设置输出图像个数
    [[FaceSDKManager sharedInstance] setMaxCropImageNum:cacheImageNum.intValue];
    
    
    // 设置图片加密类型，type=0 基于base64 加密；type=1 基于百度安全算法加密
    [[FaceSDKManager sharedInstance] setImageEncrypteType:secType.intValue];
    // 设置是否开启提示音
    [[IDLFaceDetectionManager sharedInstance] setEnableSound:sund.boolValue];
    [[IDLFaceLivenessManager sharedInstance] setEnableSound:sund.boolValue];
    
}
@end
