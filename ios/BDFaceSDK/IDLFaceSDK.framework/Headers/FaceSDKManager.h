//
//  FaceSDKManager.h
//  IDLFaceSDK
//
//  Created by Tong,Shasha on 2017/5/15.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, FaceLivenessActionType) {
    FaceLivenessActionTypeLiveEye = 0,
    FaceLivenessActionTypeLiveMouth = 1,
    FaceLivenessActionTypeLiveYawRight = 2,
    FaceLivenessActionTypeLiveYawLeft = 3,
    FaceLivenessActionTypeLivePitchUp = 4,
    FaceLivenessActionTypeLivePitchDown = 5,
    FaceLivenessActionTypeLiveYaw = 6,
    FaceLivenessActionTypeNoAction = 7,
};

typedef NS_ENUM(NSUInteger, ResultCode) {
    ResultCodeOK,
    ResultCodePitchOutofDownRange,  //头部偏低
    ResultCodePitchOutofUpRange,   //头部偏高
    ResultCodeYawOutofLeftRange,     //头部偏左
    ResultCodeYawOutofRightRange,     //头部偏右
    ResultCodeTooBrightIllumination,   // 光线过亮
    ResultCodePoorIllumination,      //光照不足
    ResultCodeNoFaceDetected,    //没有检测到人脸
    ResultCodeDataNotReady,
    ResultCodeDataHitOne, //采集到一张照片
    ResultCodeDataHitLast, //采集到最后一张照片
    ResultCodeImageBlured,     //图像模糊
    ResultCodeOcclusionLeftEye,  //左眼有遮挡
    ResultCodeOcclusionRightEye, //右眼有遮挡
    ResultCodeOcclusionNose,     //鼻子有遮挡
    ResultCodeOcclusionMouth,    //嘴巴有遮挡
    ResultCodeOcclusionLeftContour,  //左脸颊有遮挡
    ResultCodeOcclusionRightContour, //右脸颊有遮挡
    ResultCodeOcclusionChinCoutour,  //下颚有遮挡
    ResultCodeVerifyInitError,          //鉴权失败
    ResultCodeVerifyDecryptError,
    ResultCodeVerifyInfoFormatError,
    ResultCodeVerifyExpired,
    ResultCodeVerifyMissRequiredInfo,
    ResultCodeVerifyInfoCheckError,
    ResultCodeVerifyLocalFileError,
    ResultCodeVerifyRemoteDataError,
    ResultCodeLeftEyeClosed,
    ResultCodeRightEyeClosed,
    ResultCodeUnknowType            //未知类型
};


typedef NS_ENUM(NSUInteger, TrackResultCode) {
    TrackResultCodeOK,
    TrackResultCodeImageBlured,     // 图像模糊
    TrackResultCodePoorIllumination, // 光照不行
    TrackResultCodeNoFaceDetected,    //没有检测到人脸
    TrackResultCodeOcclusionLeftEye,  //左眼有遮挡
    TrackResultCodeOcclusionRightEye, //右眼有遮挡
    TrackResultCodeOcclusionNose,     //鼻子有遮挡
    TrackResultCodeOcclusionMouth,    //嘴巴有遮挡
    TrackResultCodeOcclusionLeftContour,  //左脸颊有遮挡
    TrackResultCodeOcclusionRightContour, //右脸颊有遮挡
    TrackResultCodeOcclusionChinCoutour,  //下颚有遮挡
    TrackResultCodeVerifyInitError,          //鉴权失败
    TrackResultCodeVerifyDecryptError,
    TrackResultCodeVerifyInfoFormatError,
    TrackResultCodeVerifyExpired,
    TrackResultCodeVerifyMissRequiredInfo,
    TrackResultCodeVerifyInfoCheckError,
    TrackResultCodeVerifyLocalFileError,
    TrackResultCodeVerifyRemoteDataError,
    TrackResultCodeUnknowType            //未知类型
};


@class FaceInfo;
@class FaceLivenessState;
@class FaceCropImageInfo;

@interface FaceSDKManager : NSObject
/* 超时时间 */
@property (nonatomic, assign) CGFloat conditionTimeout;
/* 语音超时*/
@property (nonatomic, assign) CGFloat intervalOfVoiceRemind;
/* 输出图像个数 */
@property (nonatomic, assign) int imageNum;
/* 图像加密类型，默认0 */
@property (nonatomic, assign) int imageEncrypteType;
/* 图像加密类型，默认0 */
@property (nonatomic, assign) float minRectScale;
/* 图片计数器，用来计当前图片的数量*/
@property (nonatomic, assign) int currentNum;

+ (instancetype)sharedInstance;

/**
 * 获取版本号
 */
- (NSString *)getVersion;

/**
 *  重置计数器
 */
- (void)reset;

/**
 * 获取设备zid 公安验证上传
 */
- (NSString *)getZtoken;

/**
 *  SDK鉴权方法-文件授权
 *  SDK鉴权方法 必须在使用其他方法之前设置，否则会导致SDK不可用
 *
 *  @param licenseID 授权ID
 *  @param licensePath 本地鉴权文件路径
 *  @param remoteAuthorize 是否远程更新过期鉴权文件
 */
- (void)setLicenseID:(NSString *)licenseID andLocalLicenceFile:(NSString *)licensePath andRemoteAuthorize:(BOOL)remoteAuthorize;

/**
 *  初始化采集功能
 */
- (int) initCollect;

/**
 *  卸载采集功能
 */
- (int)uninitCollect;

/**
 *  判断授权是否通过，true 表示通过，false 表示不通过
 */
- (BOOL)canWork;

/**
 *  设置预测库耗能模式
 *  默认 LITE_POWER_NO_BIND
 */
- (void)setLitePower:(int)litePower;

/**
 *  需要检测的最大人脸数目
 *  默认1
 */
- (void)setMaxDetectNum:(int)detectNum ;

/**
 *  需要检测的最小人脸大小
 *  默认40
 */
- (void)setMinFaceSize:(int)width;

/**
 *  人脸置信度阈值（检测分值大于该阈值认为是人脸
 *  RGB
 *  默认 0.5f
 */
- (void)setNotFaceThreshold:(CGFloat)thr ;

/**
 *  质量检测遮挡阈值
 *  默认0.5
 */
- (void)setOccluThreshold:(CGFloat)thr ;

/**
 * 质量检测遮挡阈值-左眼遮挡置信度
 * 默认0.31
 */
-(void)setOccluLeftEyeThreshold:(CGFloat)thr ;

/**
 * 质量检测遮挡阈值- 右眼遮挡置信度
 * 默认0.31
 */
-(void)setOccluRightEyeThreshold:(CGFloat)thr ;

/**
 * 质量检测遮挡阈值-鼻子遮挡置信度
 * 默认0.27
 */
-(void)setOccluNoseThreshold:(CGFloat)thr ;

/**
 * 质量检测遮挡阈值-嘴巴遮挡置信度
 * 默认0.2
 */
-(void)setOccluMouthThreshold:(CGFloat)thr ;

/**
 * 质量检测遮挡阈值-左脸遮挡置信度
 * 默认0.48
 */
-(void)setOccluLeftCheekThreshold:(CGFloat)thr ;

/**
 * 质量检测遮挡阈值-右脸遮挡置信度
 * 默认0.48
 */
-(void)setOccluRightCheekThreshold:(CGFloat)thr ;

/**
 * 质量检测遮挡阈值-下巴遮挡置信度
 * 默认0.4
 */
-(void)setOccluChinThreshold:(CGFloat)thr ;


/**
 * 最大光照阈值
 */
- (void)setMaxIllumThreshold:(CGFloat)thr;

/**
 * 最小光照阈值
 */
- (void)setMinIllumThreshold:(CGFloat)thr ;

/**
 *  质量检测模糊阈值
 *  默认0.5
 */
- (void)setBlurThreshold:(CGFloat)thr ;

/**
 *  姿态检测阈值
 *  默认pitch=12，yaw=12，row=10
 */
- (void)setEulurAngleThrPitch:(float)pitch yaw:(float)yaw roll:(float)roll ;

/**
 * 输出图像个数
 * 默认3
 */
- (void)setMaxCropImageNum:(int)imageNum ;

/**
 * 输出图像宽，设置为有效值(大于0)则对图像进行缩放，否则输出原图抠图结果
 * 默认 480
 */
- (void)setCropFaceSizeWidth:(CGFloat)width ;

/**
 * 输出图像高，设置为有效值(大于0)则对图像进行缩放，否则输出原图抠图结果
 * 默认 680
 */
- (void)setCropFaceSizeHeight:(CGFloat)height ;

/**
 * 输出图像，下巴扩展，大于等于0，0：不进行扩展
 * 默认0.1
 */
- (void)setCropChinExtend:(CGFloat)chinExtend ;

/**
 * 输出图像，额头扩展，大于等于0，0：不进行扩展
 * 默认0.2
 */
- (void)setCropForeheadExtend:(CGFloat)foreheadExtend ;

/**
 * 输出图像，人脸框与背景比例，大于等于1，1：不进行扩展
 * 默认1.5f
 */
- (void)setCropEnlargeRatio:(float)cropEnlargeRatio;

/**
 * 动作超时配置
 */
- (void)setConditionTimeout:(CGFloat)timeout ;

/**
 * 语音间隔提醒配置
 */
- (void)setIntervalOfVoiceRemind:(CGFloat)timeout;

/**
 * 是否开启静默活体，默认false
 */
// - (void)setIsCheckSilentLive:(BOOL)isCheck;

/**
 * 静默活体阈值配置，默认0.8。
 * 大于阈值返回图片，低于阈值返回未检测到人脸
 */
// - (void)setSilentLiveThreshold:(CGFloat)thr ;

/**
 * 是否开启口罩检测，非动作活体检测模型true，动作活体检测模型false
 */
- (void)setIsCheckMouthMask:(BOOL)isCheck;

/**
 * 口罩检测阈值配置，默认0.8。
 * 大于阈值判定为戴口罩，低于阈值判定为未戴口罩
 */
- (void)setMouthMaskThreshold:(CGFloat)thr ;

/**
 * 设置原始图片缩放比例，默认1不缩放，scale 阈值0~1
 */
- (void)setImageWithScale:(CGFloat)scale;

/**
 * 设置图片加密类型，type=0 基于base64 加密；type=1 基于百度安全算法加密
 */
- (void)setImageEncrypteWithType:(int) type;

/**
 *  人脸过远框比例 默认：0.4
 */
- (void)setMinRect:(float) minRectScale;
/**
 * 采集动作验证
 * @param image 检测的图片
 * @param isOriginal 是否返回原始图片
 * @param completion 判断采集是否完成，人脸信息状态是否正常
 */
- (void)detectWithImage:(UIImage *)image isRreturnOriginalValue:(BOOL) isOriginal completion:(void (^)(FaceInfo *faceinfo, ResultCode resultCode))completion;

/**
 * 动作活体动作验证
 * @param image 检测的图片
 * @param actionLiveType 当前要求做的动作
 * @param completion 判断当前动作是否完成，人脸信息状态是否正常
 */
- (void)livenessWithImage:(UIImage *)image withAction:(FaceLivenessActionType)actionLiveType completion:(void (^)(FaceInfo *faceinfo, FaceLivenessState *state, ResultCode resultCode))completion;

@end

@interface FaceLivenessState : NSObject
/**
 *  动作活体-眨眨眼
 */
@property(nonatomic, assign) BOOL isLiveEye;
/**
 *  动作活体-张张嘴
 */
@property(nonatomic, assign) BOOL isLiveMouth;
/**
 *  动作活体-向左转头
 */
@property(nonatomic, assign) BOOL isLiveYawLeft;
/**
 *  动作活体-向右转头
 */
@property(nonatomic, assign) BOOL isLiveYawRight;
/**
 *  动作活体-抬头
 */
@property(nonatomic, assign) BOOL isLivePitchUp;
/**
 *  动作活体-低头
 */
@property(nonatomic, assign) BOOL isLivePitchDown;
@end

@interface FaceCropImageInfo : NSObject
/**
 *  基于质量检测，姿态角度，对图片得分
 */
@property (nonatomic, assign) float qualityScore;
/**
 *  离线RGB 静默活体得分
 */
@property (nonatomic,assign) float silentliveScore;
/**
 *  采集到的矫正，调整宽高图片，会有宽高
 */
@property (nonatomic ,strong) UIImage *cropImageWithBlack;
/**
 *  加密采集到的矫正，调整宽高图片，会有宽高
 */
@property (nonatomic ,strong) NSString *cropImageWithBlackEncryptStr;
/**
 *  原始图片
 */
@property (nonatomic ,strong) UIImage *originalImage;
/**
 *  加密原始图片
 */
@property (nonatomic ,strong) NSString *originalImageEncryptStr;
/**
 *  排序规则
 */
- (NSComparisonResult)compareWithImageInfo:(FaceCropImageInfo *)info;
@end

@interface FaceInfo : NSObject
/**
 *  人脸在图片中的位置
 */
@property (nonatomic, assign) CGRect faceRect;
/**
 *  人脸track 中的faceid
 */
@property (nonatomic, assign) NSInteger faceId;
/**
 *  人脸72关键点
 */
@property (nonatomic, strong) NSArray * landMarks;
/**
 *  人脸角度
 */
@property (nonatomic, assign) float angle;
/**
 *  人脸质量-光照置信度，通过quality 方法调用获取
 */
@property (nonatomic,assign) float illum;

/**
 *  人脸质量-模糊置信度，通过quality 方法调用获取
 */
@property (nonatomic,assign) float blur;
/**
 * 人脸上下偏转角，通过headpose 方法调用获取
 */
@property (nonatomic, assign) float pitch;

/**
 * 人脸左右偏转角，通过headpose 方法调用获取
 */
@property (nonatomic, assign) float yaw;

/**
 * 人脸平行平面内的头部旋转角，通过headpose 方法调用获取
 */
@property (nonatomic, assign) float roll;

/**
 *  离线RGB 静默活体得分
 */
@property (nonatomic,assign) float silentliveScore;

/**
 *  人脸检测得分
 */
@property (nonatomic, assign) CGFloat score;

/**
 * 输出图片结构体，包含图片质量分数，裁剪没有黑边的图片，裁剪有黑边的图片，未裁剪图片，原始图
 */
@property (nonatomic, strong) FaceCropImageInfo * cropImageInfo;

@end
