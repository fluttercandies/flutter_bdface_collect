//
//  IDLFaceLivenessManager.h
//  IDLFaceSDK
//
//  Created by Tong,Shasha on 2017/5/18.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
@class FaceInfo;
@class FaceLivenessState;

#define TIME_THRESHOLD_FOR_ANOTHER_SESSION 2.0

typedef NS_ENUM(NSInteger, LivenessActionType) {
    LivenessActionTypeLiveEye = 0,
    LivenessActionTypeLiveMouth = 1,
    LivenessActionTypeLiveYawRight = 2,
    LivenessActionTypeLiveYawLeft = 3,
    LivenessActionTypeLivePitchUp = 4,
    LivenessActionTypeLivePitchDown = 5,
    LivenessActionTypeLiveYaw = 6,
    LivenessActionTypeNoAction = 7,
};

typedef NS_ENUM(NSUInteger, LivenessRemindCode) {
    LivenessRemindCodeOK = 0,   //成功
    LivenessRemindCodeBeyondPreviewFrame,    //出框
    LivenessRemindCodeNoFaceDetected, //没有检测到人脸
    LivenessRemindCodeMuchIllumination,
    LivenessRemindCodePoorIllumination,   //光照不足
    LivenessRemindCodeImageBlured,    //图像模糊
    LivenessRemindCodeTooFar,    //太远
    LivenessRemindCodeTooClose,  //太近
    LivenessRemindCodePitchOutofDownRange,    //头部偏低
    LivenessRemindCodePitchOutofUpRange,  //头部偏高
    LivenessRemindCodeYawOutofLeftRange,  //头部偏左
    LivenessRemindCodeYawOutofRightRange, //头部偏右
    LivenessRemindCodeOcclusionLeftEye,   //左眼有遮挡
    LivenessRemindCodeOcclusionRightEye,  //右眼有遮挡
    LivenessRemindCodeOcclusionNose, //鼻子有遮挡
    LivenessRemindCodeOcclusionMouth,    //嘴巴有遮挡
    LivenessRemindCodeOcclusionLeftContour,  //左脸颊有遮挡
    LivenessRemindCodeOcclusionRightContour, //右脸颊有遮挡
    LivenessRemindCodeOcclusionChinCoutour,  //下颚有遮挡
    LivenessRemindCodeTimeout,  //超时
    LivenessRemindCodeLiveEye,   //眨眨眼
    LivenessRemindCodeLiveMouth, //张大嘴
    LivenessRemindCodeLiveYawLeft,   //向右摇头
    LivenessRemindCodeLiveYawRight,  //向左摇头
    LivenessRemindCodeLivePitchUp,   //向上抬头
    LivenessRemindCodeLivePitchDown, //向下低头
    LivenessRemindCodeLiveYaw,   //摇摇头
    LivenessRemindCodeSingleLivenessFinished,    //完成一个活体动作
    LivenessRemindActionCodeTimeout, // 当前活体动作超时
    LivenessRemindCodeLeftEyeClosed,
    LivenessRemindCodeRightEyeClosed,
    LivenessRemindCodeVerifyInitError,          //鉴权失败
//    LivenessRemindCodeVerifyDecryptError,
//    LivenessRemindCodeVerifyInfoFormatError,
//    LivenessRemindCodeVerifyExpired,
//    LivenessRemindCodeVerifyMissRequiredInfo,
//    LivenessRemindCodeVerifyInfoCheckError,
//    LivenessRemindCodeVerifyLocalFileError,
//    LivenessRemindCodeVerifyRemoteDataError,
    LivenessRemindCodeConditionMeet,
    LivenessRemindCodeFaceIdChanged,    // faceid 发生变化
    LivenessRemindCodeDataHitOne
//    LivenessRemindCodeDataHitLast,
};

typedef void (^LivenessStrategyCompletion) (NSDictionary * images, FaceInfo *faceInfo, LivenessRemindCode remindCode);
typedef void (^LivenessNormalCompletion) (NSDictionary * images, FaceInfo *faceInfo, LivenessRemindCode remindCode);

/**
 * 活体检测过程中，返回活体总数，当前成功个数，当前活体类型
 */
typedef void (^LivenessProcess) (float numberOfLiveness, float numberOfSuccess, LivenessActionType currenActionType);


@interface IDLFaceLivenessManager : NSObject
@property (nonatomic, assign) BOOL enableSound;

+ (instancetype)sharedInstance;

/**
 *  人脸活体验证，成功之后返回扣图图片，原始图片
 * @param image 镜头拿到的图片
 * @param detectRect 预览的Rect
 * @param previewRect 检测的Rect
 * return completion 回调信息
 */
-(void) livenessNormalWithImage:(UIImage *)image previewRect:(CGRect)previewRect detectRect:(CGRect)detectRect completionHandler:(LivenessNormalCompletion)completion;

/**
 * 活体检测过程中，返回活体总数，当前成功个数，当前活体类型
 */
-(void) livenessProcessHandler:(LivenessProcess) process;

- (void)reset;

-(void)startInitial;

/**
 * 返回无黑边的方法
 * @param array 活体动作数组
 * @param order 是否顺序执行
 * @param numberOfLiveness 活体动作个数
 */
- (void)livenesswithList:(NSArray *)array order:(BOOL)order numberOfLiveness:(NSInteger)numberOfLiveness;

@end
