//
//  BDFaceRemindAnimationView.m
//  FaceSDKSample_IOS
//
//  Created by Li,Tonghui on 2020/5/11.
//  Copyright © 2020 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BDFaceRemindAnimationView.h"

#define FACESDK_ACTION_BUNDLE_NAME @"com.baidu.idl.face.live.action.image.bundle"
#define FACESDK_ACTION_BUNDLE [[NSBundle alloc] initWithPath:[[NSBundle mainBundle] pathForResource:FACESDK_ACTION_BUNDLE_NAME ofType:nil]]

@interface BDFaceRemindAnimationView ()
@property (nonatomic, assign) BOOL isImageSuccess;
@property (nonatomic, readwrite, retain) UIImageView *imageView;
@property (nonatomic, strong) NSMutableDictionary *imageDict;
@end


@implementation BDFaceRemindAnimationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width-86.7)/2
                                                                       , (frame.size.height-113.3)/2
                                                                       , 86.7, 113.3)];
        [self addSubview:self.imageView];
        self.isImageSuccess = false;
    }
    return self;
}

- (void)setActionImages {
    
    if (self.isImageSuccess){
           return;
    }
    
    int typeDigits[] = {18, 23, 31, 31, 31, 31};
    self.imageDict = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < 6; i++){
        NSMutableArray<UIImage *> *imageArr = [[NSMutableArray alloc] init];
        for (int k = 1; k <= typeDigits[i]; k++){
            NSString *imageName;
            if (k < 10){
                imageName = [NSString stringWithFormat:@"%d_0%d", i, k];
            } else {
                imageName = [NSString stringWithFormat:@"%d_%d", i, k];
            }
            NSString * path = [FACESDK_ACTION_BUNDLE pathForResource:imageName ofType:@"png"];
            UIImage *image = [UIImage imageNamed:path];
            [imageArr addObject:image];
        }
        self.imageDict[[NSString stringWithFormat:@"%d", i]] = imageArr;
    }
    self.isImageSuccess = true;
}

- (BOOL)isActionAnimating {
    return [self.imageView isAnimating];
}

- (void)startActionAnimating:(int)type {
    
    if (!self.isImageSuccess){
        return;
    }
    
    NSMutableArray<UIImage *> *imageArr = self.imageDict[[NSString stringWithFormat:@"%d", type]];
    
    // 设置动画图片
    self.imageView.animationImages = imageArr;
    
    // 设置动画图片
   // self.imageView.animationImages = self.imageArr;

    // 设置动画的播放次数
    self.imageView.animationRepeatCount = 1;

    // 设置播放时长
    // 1秒30帧, 一张图片的时间 = 1/30 = 0.03333 20 * 0.0333
    self.imageView.animationDuration = 3.0;

    // 开始动画
    [self.imageView startAnimating];
}

- (void)stopActionAnimating {
    [self.imageView stopAnimating];
}


@end
