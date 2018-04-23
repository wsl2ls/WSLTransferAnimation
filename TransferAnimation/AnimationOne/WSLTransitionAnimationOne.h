//
//  WSLTransitionOne.h
//  TransferAnimation
//
//  Created by 王双龙 on 2018/4/13.
//  Copyright © 2018年 王双龙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WSLTransitionOneType) {
    WSLTransitionOneTypePresent = 0,//管理present动画
    WSLTransitionOneTypeDissmiss,
    WSLTransitionOneTypePush,
    WSLTransitionOneTypePop,
};

//处理动画转场过渡的对象
@interface WSLTransitionAnimationOne : NSObject <UIViewControllerAnimatedTransitioning>

//动画转场类型
@property (nonatomic,assign) WSLTransitionOneType transitionType;

@end
