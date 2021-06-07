//
//  QualityUtil.h
//  IDLFaceSDK
//
//  Created by Tong,Shasha on 2017/5/24.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface BDFaceQualityUtil : NSObject
+ (CGRect)getFaceRect:(NSArray *) trackingPoints  withCount:(NSUInteger) count;

@end
