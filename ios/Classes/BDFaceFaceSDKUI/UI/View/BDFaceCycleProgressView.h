//
//  BDFaceCycleProgressView.h
//  弧形进度条
//
//  Created by 孙明喆 on 2020/5/12.
//  Copyright © 2020 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BDFaceCycleProgressView : UIView
/**
 *  比例尺长度
 */
@property (nonatomic, readwrite, assign) CGFloat scaleDivisionsLength;
/**
 *  比例尺刻度宽度
 */
@property (nonatomic, readwrite, assign) CGFloat scaleDivisionsWidth;
/**
 *  比例尺到self边距
 */
@property (nonatomic, readwrite, assign) CGFloat scaleMargin;
/**
 *  比例尺的个数
 */
@property (nonatomic, readwrite, assign) CGFloat scaleCount;
/**
 *  百分比
 */
@property (nonatomic, readwrite, assign) CGFloat percent;

/**
 *  刻度线背颜色
 */
@property (nonatomic, readwrite, retain) UIColor *lineBgColor;

/**
 *  刻度线进度颜色
 */
@property (nonatomic, readwrite, retain) UIColor *scaleColor;

@end

NS_ASSUME_NONNULL_END
