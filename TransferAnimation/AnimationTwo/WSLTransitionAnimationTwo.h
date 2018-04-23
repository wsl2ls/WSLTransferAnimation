//
//  WSLTransitionTwo.h
//  TransferAnimation
//
//  Created by 王双龙 on 2018/4/13.
//  Copyright © 2018年 王双龙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WSLTransitionTwoType) {
    WSLTransitionTwoTypePresent = 0,//管理present动画
    WSLTransitionTwoTypeDissmiss,
    WSLTransitionTwoTypePush,
    WSLTransitionTwoTypePop,
};

//处理动画转场过渡的对象
@interface WSLTransitionAnimationTwo : NSObject<UIViewControllerAnimatedTransitioning>

//动画转场类型
@property (nonatomic,assign) WSLTransitionTwoType transitionType;

@end
