//
//  BDFaceBaseViewController.h
//  FaceSDKSample_IOS
//
//  Created by 阿凡树 on 2017/5/23.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BDFaceCircleView.h"
#import "BDFaceCycleProgressView.h"
#import "BDFaceRemindAnimationView.h"
#import "IDLFaceSDK/IDLFaceSDK.h"

typedef enum : NSUInteger {
    CommonStatus,
    PoseStatus,
    occlusionStatus
} WarningStatus;

typedef void (^successCompletion)(FaceCropImageInfo* bestImage);

@interface BDFaceBaseViewController : UIViewController

@property (nonatomic, readwrite, assign) BOOL hasFinished;
/**
 *  视频i流回显view
 */
@property (nonatomic, readwrite, retain) UIImageView *displayImageView;

/**
 * 人脸检测view，与视频流rect 一致
 */
@property (nonatomic, readwrite, assign) CGRect previewRect;

/**
 *  人脸预览view ，最大预览框之内，最小预览框之外，根据该view 提示离远离近
 */

@property (nonatomic, readwrite, assign) CGRect detectRect;

/**
 *  超时弹出view
 */
@property (nonatomic, readwrite, retain) UIView *timeOutView;

/**
 *  进度条view，活体检测页面
 */
@property (nonatomic, readwrite, retain) BDFaceCycleProgressView *circleProgressView;

/*
 *  动作活体动画
 */
@property (nonatomic,readwrite,retain) BDFaceRemindAnimationView *remindAnimationView;

/*
 * 采集完成回调
 */
@property (nonatomic, readwrite, copy) successCompletion completion;

- (void)isTimeOut:(BOOL)isOrNot;

- (void)selfReplayFunction; // 重新开始

- (void)faceProcesss:(UIImage *)image;

- (void)closeAction;

- (void)onAppWillResignAction;
- (void)onAppBecomeActive;

- (void)warningStatus:(WarningStatus)status warning:(NSString *)warning;
- (void)singleActionSuccess:(BOOL)success;

- (UIImageView *)creatRectangle:(UIImageView *)imageView withRect:(CGRect) rect withcolor:(UIColor *)color;

@end
