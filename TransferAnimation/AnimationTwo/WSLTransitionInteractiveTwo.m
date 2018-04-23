//
//  WSLTransitionInteractiveTwo.m
//  TransferAnimation
//
//  Created by 王双龙 on 2018/4/15.
//  Copyright © 2018年 https://www.jianshu.com/u/e15d1f644bea All rights reserved.
//

#import "WSLTransitionInteractiveTwo.h"
#import "WSLAnimationOne.h"
#import "WSLAnimationTwo.h"
#import "WSLNavigatioController.h"

@interface WSLTransitionInteractiveTwo ()

@property (nonatomic, strong) UIView *tempView;

@end

@implementation WSLTransitionInteractiveTwo

//给控制器的View添加相应的手势
- (void)addPanGestureForViewController:(UIViewController *)viewController{
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    self.viewController = viewController;
    [viewController.view addGestureRecognizer:pan];
}

//关键的手势过渡的过程
- (void)handleGesture:(UIPanGestureRecognizer *)panGesture{
    
    switch (_interactiveType) {
        case WSLInteractiveTwoTypePresent:
            [self doInteractiveTypePresent:panGesture];
            break;
        case WSLInteractiveTwoTypeDissmiss:
            [self doInteractiveTypeDissmiss:panGesture];
            break;
        case WSLInteractiveTwoTypePush:
            [self doInteractiveTypePush:panGesture];
            break;
        case WSLInteractiveTwoTypePop:
            [self doInteractiveTypePop:panGesture];
            break;
        default:
            break;
    }
    
}

- (void)doInteractiveTypePresent:(UIPanGestureRecognizer *)panGesture{
    
}

- (void)doInteractiveTypeDissmiss:(UIPanGestureRecognizer *)panGesture{
    
}


- (void)doInteractiveTypePush:(UIPanGestureRecognizer *)panGesture{
    
}

- (void)doInteractiveTypePop:(UIPanGestureRecognizer *)panGesture{
    
    CGPoint  translation = [panGesture translationInView:panGesture.view];
    CGFloat percentComplete = 0.0;
    
    //左右滑动的百分比
    percentComplete = translation.x / (_viewController.view.frame.size.width);
    percentComplete = fabs(percentComplete);
    NSLog(@"%f",percentComplete);
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
            _isInteractive = YES;
            [_viewController.navigationController  popViewControllerAnimated:YES];
            break;
        case UIGestureRecognizerStateChanged:{
            //手势过程中，通过updateInteractiveTransition设置转场过程动画进行的百分比，然后系统会根据百分比自动布局动画控件，不用我们控制了
            [self updateInteractiveTransition:percentComplete];
            break;
        }
        case UIGestureRecognizerStateEnded:{
            _isInteractive = NO;
            //手势完成后结束标记并且判断移动距离是否过半，过则finishInteractiveTransition完成转场操作，否者取消转场操作，转场失败
            if (percentComplete > 0.5) {
                [self finishInteractiveTransition];
            }else{
                [self cancelInteractiveTransition];
            }
            break;
        }
        default:
            break;
    }
    
}



@end
