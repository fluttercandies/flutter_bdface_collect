//
//  LivenessViewController.m
//  FaceSDKSample_IOS
//
//  Created by 阿凡树 on 2017/5/23.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import "BDFaceLivenessViewController.h"
#import <IDLFaceSDK/IDLFaceSDK.h>

@interface BDFaceLivenessViewController ()
{
    UIImageView * newImage;
    BOOL isPaint;
}
@property (nonatomic, strong) NSArray *livenessArray;
@property (nonatomic, assign) BOOL order;
@property (nonatomic, assign) NSInteger numberOfLiveness;
@property (nonatomic, assign) BOOL isAnimating;
@end

@implementation BDFaceLivenessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 刻度线背颜色
    self.circleProgressView.lineBgColor = [UIColor colorWithRed:102 / 255.0 green:102 / 255.0 blue:102 / 255.0 alpha:1 / 1.0];
    // 刻度线进度颜色
    self.circleProgressView.scaleColor =  [UIColor colorWithRed:0 / 255.0 green:186 / 255.0 blue:242 / 255.0 alpha:1 / 1.0];
    [self.view addSubview:self.circleProgressView];
    
    // 提示动画设置
    [self.view addSubview:self.remindAnimationView];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.remindAnimationView setActionImages];
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IDLFaceLivenessManager sharedInstance] startInitial];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [IDLFaceLivenessManager.sharedInstance reset];
}

- (void)onAppBecomeActive {
    [super onAppBecomeActive];
    [[IDLFaceLivenessManager sharedInstance] livenesswithList:_livenessArray order:_order numberOfLiveness:_numberOfLiveness];
}

- (void)onAppWillResignAction {
    [super onAppWillResignAction];
    [IDLFaceLivenessManager.sharedInstance reset];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)livenesswithList:(NSArray *)livenessArray order:(BOOL)order numberOfLiveness:(NSInteger)numberOfLiveness {
    _livenessArray = [NSArray arrayWithArray:livenessArray];
    _order = order;
    _numberOfLiveness = numberOfLiveness;
    [[IDLFaceLivenessManager sharedInstance] livenesswithList:livenessArray order:order numberOfLiveness:numberOfLiveness];
}

- (void)faceProcesss:(UIImage *)image {
    if (self.hasFinished) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.isAnimating = [self.remindAnimationView isActionAnimating];
    });
    /*
     显示提示动画的过程中还可以做动作
     */
//    if (self.isAnimating){
//        return;
//    }
    
    __weak typeof(self) weakSelf = self;
    [[IDLFaceLivenessManager sharedInstance] livenessNormalWithImage:image previewRect:self.previewRect detectRect:self.detectRect completionHandler:^(NSDictionary *images, FaceInfo *faceInfo, LivenessRemindCode remindCode) {
//        NSLog(@"remindCode = %lu", (unsigned long)remindCode);
/*
 此注释里的代码用于显示人脸框，调试过程中需要显示人脸款可打开注释
 
 //        绘制人脸框功能，开发者可以通过观察人脸框_faceRectFit 在  previewRect 包含关系判断是框内还是框外
         dispatch_async(dispatch_get_main_queue(), ^{
             CGRect faceRect = [BDFaceQualityUtil getFaceRect:faceInfo.landMarks withCount:faceInfo.landMarks.count];
             CGRect faceRectFit = [BDFaceUtil convertRectFrom:faceRect image:image previewRect:previewRect];
             if (!isPaint) {
                 newImage= [[UIImageView alloc]init];
                 [self.view addSubview:newImage];
                 isPaint = !isPaint;
             }
             newImage = [self creatRectangle:newImage withRect:faceRectFit  withcolor:[UIColor blackColor]];
         });
 
 */
        switch (remindCode) {
            case LivenessRemindCodeOK: {
                weakSelf.hasFinished = YES;
                [self warningStatus:CommonStatus warning:@"非常好"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.remindAnimationView stopActionAnimating];
                });
                [self singleActionSuccess:true];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (weakSelf.completion) {
                        FaceCropImageInfo *bestImage;
                        if (images[@"image"] != nil && [images[@"image"] count] != 0) {
                            NSArray *imageArr = images[@"image"];
                            bestImage = imageArr[0];
                        }else{
                            bestImage = faceInfo.cropImageInfo;
                        }
                        weakSelf.completion(bestImage);
                    }
                    [weakSelf closeAction];
                });
                break;
            }
            case LivenessRemindCodeTimeout: {
                // 时间超时，重置之前采集数据
                 [[IDLFaceLivenessManager sharedInstance] reset];
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 时间超时，ui进度重置0
                    [self.circleProgressView setPercent:0];
                    [self isTimeOut:YES];
                });
                break;
            }
            case LivenessRemindCodePitchOutofDownRange:
                [self warningStatus:PoseStatus warning:@"请略微抬头" conditionMeet:false];
                [self singleActionSuccess:false];
                break;
            case LivenessRemindCodePitchOutofUpRange:
                [self warningStatus:PoseStatus warning:@"请略微低头" conditionMeet:false];
                [self singleActionSuccess:false];
                break;
            case LivenessRemindCodeYawOutofRightRange:
                [self warningStatus:PoseStatus warning:@"请略微向右转头" conditionMeet:false];
                [self singleActionSuccess:false];
                break;
            case LivenessRemindCodeYawOutofLeftRange:
                [self warningStatus:PoseStatus warning:@"请略微向左转头" conditionMeet:false];
                [self singleActionSuccess:false];
                break;
            case LivenessRemindCodePoorIllumination:
                [self warningStatus:CommonStatus warning:@"请使环境光线再亮些" conditionMeet:false];
                [self singleActionSuccess:false];
                break;
            case LivenessRemindCodeNoFaceDetected:
                [self warningStatus:CommonStatus warning:@"把脸移入框内" conditionMeet:false];
                [self singleActionSuccess:false];
                break;
            case LivenessRemindCodeImageBlured:
                [self warningStatus:PoseStatus warning:@"请握稳手机" conditionMeet:false];
                [self singleActionSuccess:false];
                break;
            case LivenessRemindCodeOcclusionLeftEye:
                [self warningStatus:occlusionStatus warning:@"左眼有遮挡" conditionMeet:false];
                [self singleActionSuccess:false];
                break;
            case LivenessRemindCodeOcclusionRightEye:
                [self warningStatus:occlusionStatus warning:@"右眼有遮挡" conditionMeet:false];
                [self singleActionSuccess:false];
                break;
            case LivenessRemindCodeOcclusionNose:
                [self warningStatus:occlusionStatus warning:@"鼻子有遮挡" conditionMeet:false];
                [self singleActionSuccess:false];
                break;
            case LivenessRemindCodeOcclusionMouth:
                [self warningStatus:occlusionStatus warning:@"嘴巴有遮挡" conditionMeet:false];
                [self singleActionSuccess:false];
                break;
            case LivenessRemindCodeOcclusionLeftContour:
                [self warningStatus:occlusionStatus warning:@"左脸颊有遮挡" conditionMeet:false];
                [self singleActionSuccess:false];
                break;
            case LivenessRemindCodeOcclusionRightContour:
                [self warningStatus:occlusionStatus warning:@"右脸颊有遮挡" conditionMeet:false];
                [self singleActionSuccess:false];
                break;
            case LivenessRemindCodeOcclusionChinCoutour:
                [self warningStatus:occlusionStatus warning:@"下颚有遮挡" conditionMeet:false];
                [self singleActionSuccess:false];
                break;
            case LivenessRemindCodeLeftEyeClosed:
                [self warningStatus:occlusionStatus warning:@"左眼未睁开" conditionMeet:false];
                [self singleActionSuccess:false];
                break;
            case LivenessRemindCodeRightEyeClosed:
                [self warningStatus:occlusionStatus warning:@"右眼未睁开" conditionMeet:false];
                [self singleActionSuccess:false];
                break;
            case LivenessRemindCodeTooClose:
                [self warningStatus:CommonStatus warning:@"请将脸部离远一点" conditionMeet:false];
                [self singleActionSuccess:false];
                break;
            case LivenessRemindCodeTooFar:
                [self warningStatus:CommonStatus warning:@"请将脸部靠近一点" conditionMeet:false];
                [self singleActionSuccess:false];
                break;
            case LivenessRemindCodeBeyondPreviewFrame:
                [self warningStatus:CommonStatus warning:@"把脸移入框内" conditionMeet:false];
                [self singleActionSuccess:false];
                break;
            case LivenessRemindCodeLiveEye:
                [self warningStatus:CommonStatus warning:@"眨眨眼" conditionMeet:true];
                [self singleActionSuccess:false];
                break;
            case LivenessRemindCodeLiveMouth:
                [self warningStatus:CommonStatus warning:@"张张嘴" conditionMeet:true];
                [self singleActionSuccess:false];
                break;
            case LivenessRemindCodeLiveYawRight:
                [self warningStatus:CommonStatus warning:@"向右缓慢转头" conditionMeet:true];
                [self singleActionSuccess:false];
                break;
            case LivenessRemindCodeLiveYawLeft:
                [self warningStatus:CommonStatus warning:@"向左缓慢转头" conditionMeet:true];
                [self singleActionSuccess:false];
                break;
            case LivenessRemindCodeLivePitchUp:
                [self warningStatus:CommonStatus warning:@"缓慢抬头" conditionMeet:true];
                [self singleActionSuccess:false];
                break;
            case LivenessRemindCodeLivePitchDown:
                [self warningStatus:CommonStatus warning:@"缓慢低头" conditionMeet:true];
                [self singleActionSuccess:false];
                break;
            case LivenessRemindCodeLiveYaw:
                [self warningStatus:CommonStatus warning:@"左右摇头" conditionMeet:true];
                [self singleActionSuccess:false];
                break;
            case LivenessRemindCodeSingleLivenessFinished:
            {
                [[IDLFaceLivenessManager sharedInstance] livenessProcessHandler:^(float numberOfLiveness, float numberOfSuccess, LivenessActionType currenActionType) {
                    NSLog(@"Finished 非常好 %d %d %d", (int)numberOfLiveness, (int)numberOfSuccess, (int)currenActionType);
                   dispatch_async(dispatch_get_main_queue(), ^{
                       [self.circleProgressView setPercent:(CGFloat)(numberOfSuccess / numberOfLiveness)];
                   });
                }];
                [self warningStatus:CommonStatus warning:@"非常好" conditionMeet:true];
                [self singleActionSuccess:true];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.remindAnimationView stopActionAnimating];
                });
            }
                break;
            case LivenessRemindCodeFaceIdChanged:
            {
                [[IDLFaceLivenessManager sharedInstance] livenessProcessHandler:^(float numberOfLiveness, float numberOfSuccess, LivenessActionType currenActionType) {
                    NSLog(@"face id changed %d %d %d", (int)numberOfLiveness, (int)numberOfSuccess, (int)currenActionType);
                   dispatch_async(dispatch_get_main_queue(), ^{
                       [self.circleProgressView setPercent:0];
                   });
                }];
                [self warningStatus:CommonStatus warning:@"把脸移入框内" conditionMeet:true];
            }
                break;
            case LivenessRemindCodeVerifyInitError:
                [self warningStatus:CommonStatus warning:@"验证失败"];
                break;
//            case LivenessRemindCodeVerifyDecryptError:
//                [self warningStatus:CommonStatus warning:@"验证失败"];
//                break;
//            case LivenessRemindCodeVerifyInfoFormatError:
//                [self warningStatus:CommonStatus warning:@"验证失败"];
//                break;
//            case LivenessRemindCodeVerifyExpired:
//                [self warningStatus:CommonStatus warning:@"验证失败"];
//                break;
//            case LivenessRemindCodeVerifyMissRequiredInfo:
//                [self warningStatus:CommonStatus warning:@"验证失败"];
//                break;
//            case LivenessRemindCodeVerifyInfoCheckError:
//                [self warningStatus:CommonStatus warning:@"验证失败"];
//                break;
//            case LivenessRemindCodeVerifyLocalFileError:
//                [self warningStatus:CommonStatus warning:@"验证失败"];
//                break;
//            case LivenessRemindCodeVerifyRemoteDataError:
//                [self warningStatus:CommonStatus warning:@"验证失败"];
//                break;
            case LivenessRemindActionCodeTimeout:{
                [[IDLFaceLivenessManager sharedInstance] livenessProcessHandler:^(float numberOfLiveness, float numberOfSuccess, LivenessActionType currenActionType) {
                    NSLog(@"动作超时 %d %d %d", (int)numberOfLiveness, (int)numberOfSuccess, (int)currenActionType);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.remindAnimationView startActionAnimating:(int)currenActionType];
                    });
                }];
                break;
            }
            case LivenessRemindCodeConditionMeet: {
                break;
            }
            default:
                break;
        }
    }];
}

- (void)selfReplayFunction{
     [[IDLFaceLivenessManager sharedInstance] reset];
}

- (void)warningStatus:(WarningStatus)status warning:(NSString *)warning conditionMeet:(BOOL)meet{
    [self warningStatus:status warning:warning];
}
@end
