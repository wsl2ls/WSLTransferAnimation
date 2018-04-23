//
//  WSLTransitionInteractiveThree.h
//  TransferAnimation
//
//  Created by 王双龙 on 2018/4/18.
//  Copyright © 2018年 王双龙. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WSLInteractiveThreeType) {
    WSLInteractiveThreeTypePresent = 0,//管理present交互
    WSLInteractiveThreeTypeDissmiss,
    WSLInteractiveThreeTypePush,
    WSLInteractiveThreeTypePop,
};

@interface WSLTransitionInteractiveThree : UIPercentDrivenInteractiveTransition

@property (nonatomic, strong) UIViewController * viewController;

/**
 区分是手势交互转场还是直接pop/push、present/dissmiss转场
 */
@property (nonatomic, assign) BOOL isInteractive;

@property (nonatomic,assign) WSLInteractiveThreeType interactiveType;

//给控制器的View添加相应的手势
- (void)addPanGestureForViewController:(UIViewController *)viewController;

@end
