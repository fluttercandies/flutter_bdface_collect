//
//  BDFaceCycleProgressView.m
//  弧形进度条
//
//  Created by 孙明喆 on 2020/5/12.
//  Copyright © 2020 Baidu. All rights reserved.
//

#import "BDFaceCycleProgressView.h"

@interface BDFaceCycleProgressView ()
@property (nonatomic, assign) CGRect fullRect;
@property (nonatomic, assign) CGRect scaleRect;
@property (nonatomic, assign) CGFloat currentLinePointY;
@property (nonatomic, assign) CGFloat targetLinePointY;
// 但前百分比，用于保存第一次显示时的动画效果
@property (nonatomic, assign) CGFloat currentPercent;
@end

@implementation BDFaceCycleProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.fullRect = frame;
        [self initialize];
        
    }
    return self;
}


- (void)initialize {
     _percent = 0;
    _scaleCount = 60;
    _scaleDivisionsLength = 10;
    _scaleDivisionsWidth = 2;
    _lineBgColor = [UIColor colorWithRed:102 / 255.0 green:102 / 255.0 blue:102 / 255.0 alpha:1 / 1.0];
    _scaleColor = [UIColor colorWithRed:0 / 255.0 green:186 / 255.0 blue:242 / 255.0 alpha:1 / 1.0];
    [self initDrawingRects];
}

- (void)initDrawingRects {
    CGFloat offset = _scaleMargin;
    self.scaleRect = CGRectMake(offset,
                           offset,
                           self.fullRect.size.width - 2 * offset,
                           self.fullRect.size.height - 2 * offset);
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawScale:context];
    [self drawProcessScale:context];
    
}
/**
 *  画比例尺
 *
 *  @param context 全局context
 */
- (void)drawScale:(CGContextRef)context {
    
    // 线的宽度
    CGContextSetLineWidth(context, _scaleDivisionsWidth);
    // ======================= 矩阵操作 ============================
    CGContextTranslateCTM(context, self.fullRect.size.width / 2, self.fullRect.size.width / 2);
    // 线框颜色
    CGContextSetStrokeColorWithColor(context, _lineBgColor.CGColor);
    // 2. 绘制一些图形
    for (int i = 0; i < _scaleCount; i++) {
        CGContextMoveToPoint(context, self.scaleRect.size.width / 2 - _scaleDivisionsLength, 0);
        CGContextAddLineToPoint(context, self.scaleRect.size.width / 2, 0);
        //    CGContextScaleCTM(ctx, 0.5, 0.5);
        // 3. 渲染
        CGContextStrokePath(context);
        CGContextRotateCTM(context, 2 * M_PI / _scaleCount);
    }
    // 线框颜色
    CGContextSetStrokeColorWithColor(context, _lineBgColor.CGColor);
    CGContextSetLineWidth(context, 0.5);
    // CGContextAddArc (context, 0, 0, self.scaleRect.size.width/2 - _scaleDivisionsLength - 3, 0, M_PI* 2 , 0);
    CGContextStrokePath(context);
    
    CGContextTranslateCTM(context, -self.fullRect.size.width / 2, -self.fullRect.size.width / 2);
}

/**
 *  比例次进度
 *
 *  @param context 全局context
 */
- (void)drawProcessScale:(CGContextRef)context {
    
    // 线的宽度
    CGContextSetLineWidth(context, _scaleDivisionsWidth);
    // ======================= 矩阵操作 ============================
    CGContextTranslateCTM(context, self.fullRect.size.width / 2, self.fullRect.size.width / 2);
    CGContextRotateCTM(context, M_PI);
    // 线框颜色
    CGContextSetStrokeColorWithColor(context, _scaleColor.CGColor);
    
    int count = _scaleCount * self.currentPercent;
    CGFloat scaleAngle = 2 * M_PI / _scaleCount;
    
    // 2. 绘制一些图形
    for (int i = 0; i < count; i++) {
        CGContextMoveToPoint(context, 0, self.scaleRect.size.width / 2 - _scaleDivisionsLength);
        CGContextAddLineToPoint(context, 0, self.scaleRect.size.width / 2);
        //    CGContextScaleCTM(ctx, 0.5, 0.5);
        // 3. 渲染
        CGContextStrokePath(context);
        CGContextRotateCTM(context, scaleAngle);
    }
    
    CGContextTranslateCTM(context, -self.fullRect.size.width / 2, -self.fullRect.size.width / 2);
}

- (void)setPercent:(CGFloat)percent {
    _percent = percent;
    self.currentPercent = percent;
    [self initDrawingRects];
}
@end
