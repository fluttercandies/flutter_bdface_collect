//
//  BDFaceLogoView.m
//  FaceSDKSample_IOS
//
//  Created by 孙明喆 on 2020/3/12.
//  Copyright © 2020 Baidu. All rights reserved.
//

#import "BDFaceLogoView.h"

@implementation BDFaceLogoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *logoLabel = [[UILabel alloc] init];
        logoLabel.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        logoLabel.text = @"— 百度大脑技术支持 —";
        logoLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        logoLabel.textColor = [UIColor colorWithRed:204 / 255.0 green:204 / 255.0 blue:204 / 255.0 alpha:1 / 1.0];
        logoLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:logoLabel];
    }
    return self;
}

@end
