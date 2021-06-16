//
//  BDFaceRemindAnimationView.h
//  FaceSDKSample_IOS
//
//  Created by Li,Tonghui on 2020/5/11.
//  Copyright © 2020 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BDFaceRemindAnimationView : UIView

- (void)setActionImages;

- (BOOL)isActionAnimating;

- (void)startActionAnimating:(int)type;

- (void) stopActionAnimating;

@end

