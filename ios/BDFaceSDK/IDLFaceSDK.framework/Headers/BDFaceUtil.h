//
//  Util.h
//  IDLFaceSDK
//
//  Created by Tong,Shasha on 2017/5/24.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

#define FACESDK_BUNDLE_Name @"com.baidu.idl.face.faceSDK.bundle"
#define FACESDK_BUNDLE [[NSBundle alloc] initWithPath:[[NSBundle mainBundle] pathForResource:FACESDK_BUNDLE_Name ofType:nil]]

@interface BDFaceUtil : NSObject

+ (CGRect)convertRectFrom:(CGRect)imageRect image:(UIImage *)image previewRect:(CGRect)previewRect;

+ (NSString *)iphoneType;

@end
