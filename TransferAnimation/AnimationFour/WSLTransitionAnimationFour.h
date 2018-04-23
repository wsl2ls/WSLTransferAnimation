//
//  WSLTransitionAnimationFour.h
//  TransferAnimation
//
//  Created by 王双龙 on 2018/4/18.
//  Copyright © 2018年 王双龙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WSLTransitionFourType) {
    WSLTransitionFourTypePresent = 0,//管理present动画
    WSLTransitionFourTypeDissmiss,
    WSLTransitionFourTypePush,
    WSLTransitionFourTypePop,
};

@interface WSLTransitionAnimationFour : NSObject <UIViewControllerAnimatedTransitioning>

//动画转场类型
@property (nonatomic,assign) WSLTransitionFourType transitionType;

@end
