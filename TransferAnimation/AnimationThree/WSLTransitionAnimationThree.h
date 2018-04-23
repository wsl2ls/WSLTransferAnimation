//
//  WSLTransitionThree.h
//  TransferAnimation
//
//  Created by 王双龙 on 2018/4/13.
//  Copyright © 2018年 王双龙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WSLTransitionThreeType) {
    WSLTransitionThreeTypePresent = 0,//管理present动画
    WSLTransitionThreeTypeDissmiss,
    WSLTransitionThreeTypePush,
    WSLTransitionThreeTypePop,
};

@interface WSLTransitionAnimationThree : NSObject <UIViewControllerAnimatedTransitioning>

//动画转场类型
@property (nonatomic,assign) WSLTransitionThreeType transitionType;

@end
