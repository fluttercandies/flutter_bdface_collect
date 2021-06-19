//
//  DetectionViewController.m
//  IDLFaceSDKDemoOC
//
//  Created by 阿凡树 on 2017/5/23.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import "DetectionViewController.h"
#import <IDLFaceSDK/IDLFaceSDK.h>
#import <AVFoundation/AVFoundation.h>

@interface DetectionViewController ()
{
}

@property (nonatomic, readwrite, retain) UIView *animaView;
@end

@implementation DetectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 纯粹为了在照片成功之后，做闪屏幕动画之用
    self.animaView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.animaView.backgroundColor = [UIColor whiteColor];
    self.animaView.alpha = 0;
    [self.view addSubview:self.animaView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IDLFaceDetectionManager sharedInstance] startInitial];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [IDLFaceDetectionManager.sharedInstance reset];
}

- (void)onAppWillResignAction {
    [super onAppWillResignAction];
    [IDLFaceDetectionManager.sharedInstance reset];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)faceProcesss:(UIImage *)image {
    if (self.hasFinished) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [[IDLFaceDetectionManager sharedInstance] detectStratrgyWithImage:image previewRect:self.previewRect detectRect:self.detectRect completionHandler:^(NSDictionary *images, DetectRemindCode remindCode) {
        switch (remindCode) {
            case DetectRemindCodeOK: {
                weakSelf.hasFinished = YES;
                [self warningStatus:CommonStatus warning:@"非常好"];
                if (images[@"bestImage"] != nil && [images[@"bestImage"] count] != 0) {
                    NSData* data = [[NSData alloc] initWithBase64EncodedString:[images[@"bestImage"] lastObject] options:NSDataBase64DecodingIgnoreUnknownCharacters];
                    UIImage* bestImage = [UIImage imageWithData:data];
                    NSLog(@"bestImage = %@",bestImage);
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UIView animateWithDuration:0.5 animations:^{
                        weakSelf.animaView.alpha = 1;
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:0.5 animations:^{
                            weakSelf.animaView.alpha = 0;
                        } completion:^(BOOL finished) {
                            [weakSelf closeAction];
                        }];
                    }];
                });
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (weakSelf.completion) {
                        weakSelf.completion(images,image);
                    }
                });
                [self singleActionSuccess:true];
                break;
            }
            case DetectRemindCodePitchOutofDownRange:
                [self warningStatus:PoseStatus warning:@"建议略微抬头"];
                [self singleActionSuccess:false];
                break;
            case DetectRemindCodePitchOutofUpRange:
                [self warningStatus:PoseStatus warning:@"建议略微低头"];
                [self singleActionSuccess:false];
                break;
            case DetectRemindCodeYawOutofLeftRange:
                [self warningStatus:PoseStatus warning:@"建议略微向右转头"];
                [self singleActionSuccess:false];
                break;
            case DetectRemindCodeYawOutofRightRange:
                [self warningStatus:PoseStatus warning:@"建议略微向左转头"];
                [self singleActionSuccess:false];
                break;
            case DetectRemindCodePoorIllumination:
                [self warningStatus:CommonStatus warning:@"光线再亮些"];
                [self singleActionSuccess:false];
                break;
            case DetectRemindCodeNoFaceDetected:
                [self warningStatus:CommonStatus warning:@"把脸移入框内"];
                [self singleActionSuccess:false];
                break;
            case DetectRemindCodeImageBlured:
                [self warningStatus:CommonStatus warning:@"请保持不动"];
                [self singleActionSuccess:false];
                break;
            case DetectRemindCodeOcclusionLeftEye:
                [self warningStatus:occlusionStatus warning:@"左眼有遮挡"];
                [self singleActionSuccess:false];
                break;
            case DetectRemindCodeOcclusionRightEye:
                [self warningStatus:occlusionStatus warning:@"右眼有遮挡"];
                [self singleActionSuccess:false];
                break;
            case DetectRemindCodeOcclusionNose:
                [self warningStatus:occlusionStatus warning:@"鼻子有遮挡"];
                [self singleActionSuccess:false];
                break;
            case DetectRemindCodeOcclusionMouth:
                [self warningStatus:occlusionStatus warning:@"嘴巴有遮挡"];
                [self singleActionSuccess:false];
                break;
            case DetectRemindCodeOcclusionLeftContour:
                [self warningStatus:occlusionStatus warning:@"左脸颊有遮挡"];
                [self singleActionSuccess:false];
                break;
            case DetectRemindCodeOcclusionRightContour:
                [self warningStatus:occlusionStatus warning:@"右脸颊有遮挡"];
                [self singleActionSuccess:false];
                break;
            case DetectRemindCodeOcclusionChinCoutour:
                [self warningStatus:occlusionStatus warning:@"下颚有遮挡"];
                [self singleActionSuccess:false];
                break;
            case DetectRemindCodeTooClose:
                [self warningStatus:CommonStatus warning:@"手机拿远一点"];
                [self singleActionSuccess:false];
                break;
            case DetectRemindCodeTooFar:
                [self warningStatus:CommonStatus warning:@"手机拿近一点"];
                [self singleActionSuccess:false];
                break;
            case DetectRemindCodeBeyondPreviewFrame:
                [self warningStatus:CommonStatus warning:@"把脸移入框内"];
                [self singleActionSuccess:false];
                break;
            case DetectRemindCodeVerifyInitError:
                [self warningStatus:CommonStatus warning:@"验证失败"];
                break;
            case DetectRemindCodeVerifyDecryptError:
                [self warningStatus:CommonStatus warning:@"验证失败"];
                break;
            case DetectRemindCodeVerifyInfoFormatError:
                [self warningStatus:CommonStatus warning:@"验证失败"];
                break;
            case DetectRemindCodeVerifyExpired:
                [self warningStatus:CommonStatus warning:@"验证失败"];
                break;
            case DetectRemindCodeVerifyMissRequiredInfo:
                [self warningStatus:CommonStatus warning:@"验证失败"];
                break;
            case DetectRemindCodeVerifyInfoCheckError:
                [self warningStatus:CommonStatus warning:@"验证失败"];
                break;
            case DetectRemindCodeVerifyLocalFileError:
                [self warningStatus:CommonStatus warning:@"验证失败"];
                break;
            case DetectRemindCodeVerifyRemoteDataError:
                [self warningStatus:CommonStatus warning:@"验证失败"];
                break;
            case DetectRemindCodeTimeout: {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"remind" message:@"超时" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* action = [UIAlertAction actionWithTitle:@"知道啦" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        NSLog(@"知道啦");
                    }];
                    [alert addAction:action];
                    UIViewController* fatherViewController = weakSelf.presentingViewController;
                    [weakSelf dismissViewControllerAnimated:YES completion:^{
                        [fatherViewController presentViewController:alert animated:YES completion:nil];
                    }];
                });
                break;
            }
            case DetectRemindCodeConditionMeet: {
                self.circleView.conditionStatusFit = true;
            }
                break;
            default:
                break;
        }
        if (remindCode == DetectRemindCodeConditionMeet || remindCode == DetectRemindCodeOK) {
            self.circleView.conditionStatusFit = true;
        }else {
            self.circleView.conditionStatusFit = false;
        }
    }];
}

- (void)dealloc
{
    
}
@end
