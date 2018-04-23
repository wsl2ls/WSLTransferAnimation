//
//  WSLTransitionInteractiveTwo.h
//  TransferAnimation
//
//  Created by 王双龙 on 2018/4/15.
//  Copyright © 2018年 王双龙. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WSLInteractiveTwoType) {
    WSLInteractiveTwoTypePresent = 0,//管理present交互
    WSLInteractiveTwoTypeDissmiss,
    WSLInteractiveTwoTypePush,
    WSLInteractiveTwoTypePop,
};

//处理手势过渡的对象
@interface WSLTransitionInteractiveTwo : UIPercentDrivenInteractiveTransition

@property (nonatomic, strong) UIViewController * viewController;

/**
 区分是手势交互转场还是直接pop/push转场
 */
@property (nonatomic, assign) BOOL isInteractive;

@property (nonatomic,assign) WSLInteractiveTwoType interactiveType;

//给控制器的View添加相应的手势
- (void)addPanGestureForViewController:(UIViewController *)viewController;

@end
