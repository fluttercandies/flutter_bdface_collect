#import "FlutterBdfaceCollectPlugin.h"
#import "BDFaceLivenessViewController.h"
#import "BDFaceDetectionViewController.h"

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
    [[FaceSDKManager sharedInstance] setLicenseID:licenseId andLocalLicenceFile:licensePath andRemoteAuthorize:true];
    if ([[FaceSDKManager sharedInstance] canWork]){
        result(NULL);
    }
    result(@"初始化失败");
}

/// 释放
- (void)unInit:(FlutterResult)result{
    [[FaceSDKManager sharedInstance] uninitCollect];
    result(NULL);
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
//    NSNumber* eyeClosed = faceConfigMap[@"eyeClosed"];
//     NSNumber* cacheImageNum = faceConfigMap[@"cacheImageNum"];
    NSNumber* scale = faceConfigMap[@"scale"];
    NSNumber* cropHeight = faceConfigMap[@"cropHeight"];
    NSNumber* cropWidth = faceConfigMap[@"cropWidth"];
    NSNumber* enlargeRatio = faceConfigMap[@"enlargeRatio"];
    NSNumber* faceFarRatio = faceConfigMap[@"faceFarRatio"];
//    NSNumber* faceClosedRatio = faceConfigMap[@"faceClosedRatio"];
    NSNumber* sound = faceConfigMap[@"sound"];
    NSNumber* livenessRandom = faceConfigMap[@"livenessRandom"];
    NSNumber* secType = faceConfigMap[@"secType"];
    NSArray* livenessTypes = faceConfigMap[@"livenessTypes"];
    // 设置最小检测人脸阈值
    [[FaceSDKManager sharedInstance] setMinFaceSize:minFaceSize.intValue];
    // 设置人脸检测精度阀值
    [[FaceSDKManager sharedInstance] setNotFaceThreshold:notFace.floatValue];
    // 设置图片最小光照阈值
    [[FaceSDKManager sharedInstance] setMinIllumThreshold:brightness.floatValue];
    // 设置图片最大光照阈值
    [[FaceSDKManager sharedInstance] setMaxIllumThreshold:brightnessMax.floatValue];
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
    [[FaceSDKManager sharedInstance] setMaxCropImageNum: 3];
//     [[FaceSDKManager sharedInstance] setMaxCropImageNum:cacheImageNum.intValue];
    // 设置原始图片缩放比例，默认1不缩放，scale 阈值0~1
    [[FaceSDKManager sharedInstance] setImageWithScale:scale.floatValue];
    // 设置截取人脸图片高
    [[FaceSDKManager sharedInstance] setCropFaceSizeHeight:cropHeight.floatValue];
    // 设置截取人脸图片宽
    [[FaceSDKManager sharedInstance] setCropFaceSizeWidth:cropWidth.floatValue];
    // 输出图像，人脸框与背景比例，大于等于1，1：不进行扩展
    [[FaceSDKManager sharedInstance] setCropEnlargeRatio:enlargeRatio.floatValue];
    // 输出人脸过远框比例 默认：0.4
    [[FaceSDKManager sharedInstance] setMinRect:faceFarRatio.floatValue];
    // 设置图片加密类型，type=0 基于base64 加密；type=1 基于百度安全算法加密
    [[FaceSDKManager sharedInstance] setImageEncrypteType:secType.intValue];
    // 初始化SDK功能
    [[FaceSDKManager sharedInstance] initCollect];
    BDFaceBaseViewController* lvc;
    if (livenessTypes.count > 0){
        // 设置是否开启提示音
        [[IDLFaceLivenessManager sharedInstance] setEnableSound:sound.boolValue];
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
        BDFaceLivenessViewController* lvc2 = [[BDFaceLivenessViewController alloc] init];
        [lvc2 livenesswithList:liveActionArray order:!livenessRandom.boolValue numberOfLiveness:3];
        lvc = lvc2;
    } else {
        // 设置是否开启提示音
        [[IDLFaceDetectionManager sharedInstance] setEnableSound:sound.boolValue];
        lvc = [[BDFaceDetectionViewController alloc] init];
    }
    lvc.completion = ^(FaceCropImageInfo* bestImage){
        if (bestImage == NULL) {
            result(NULL);
        } else {
            NSDictionary *res = @{@"imageCropBase64": bestImage.cropImageWithBlackEncryptStr,
                                  @"imageSrcBase64": bestImage.originalImageEncryptStr};
            result(res);
        }        
    };
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:lvc];
    navi.navigationBarHidden = true;
    navi.modalPresentationStyle = UIModalPresentationFullScreen;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:navi animated:YES completion:nil];
}
@end
