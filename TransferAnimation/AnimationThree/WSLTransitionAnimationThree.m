//
//  WSLTransitionThree.m
//  TransferAnimation
//
//  Created by 王双龙 on 2018/4/13.
//  Copyright © 2018年 https://www.jianshu.com/u/e15d1f644bea All rights reserved.
//

#import "WSLTransitionAnimationThree.h"

@implementation WSLTransitionAnimationThree

//返回动画事件
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.4;
}

//所有的过渡动画事务都在这个方法里面完成
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    switch (_transitionType) {
        case WSLTransitionThreeTypePresent:
            [self presentAnimation:transitionContext];
            break;
        case WSLTransitionThreeTypeDissmiss:
            [self dismissAnimation:transitionContext];
            break;
        case WSLTransitionThreeTypePush:
            [self pushAnimation:transitionContext];
            break;
        case WSLTransitionThreeTypePop:
            [self popAnimation:transitionContext];
            break;
    }
    
}

#pragma mark -- transitionType

- (void)presentAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    UIViewController * fromVC = (UIViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    //取出转场前后视图控制器上的视图view
    UIView * toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView * fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    
    UIView *containerView = [transitionContext containerView];
    
    //使用系统自带的snapshotViewAfterScreenUpdates:方法，参数为YES，代表视图的属性改变渲染完毕后截屏，参数为NO代表立刻将当前状态的视图截图
    UIView *tempView = [fromView snapshotViewAfterScreenUpdates:YES];
    [containerView addSubview:toView];
    [containerView addSubview:tempView];
    
    fromView.hidden = YES;
    toView.hidden = YES;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
                        options:UIViewAnimationOptionTransitionFlipFromRight
                     animations:^{
                         //你想绕哪个轴哪个轴就为 1，其中的参数（角度， x, y, z）
                         tempView.layer.transform = CATransform3DMakeRotation(M_PI/2, 0, 1, 0);
                         tempView.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         //你想绕哪个轴哪个轴就为 1，其中的参数（角度， x, y, z）
                         toView.hidden = NO;
                         toView.layer.transform = CATransform3DMakeRotation(M_PI/2 * 3, 0, 1, 0);
                         
                         [UIView animateWithDuration:0.3
                                               delay:0
                                             options:UIViewAnimationOptionTransitionFlipFromRight
                                          animations:^{
                                              toView.layer.transform = CATransform3DMakeRotation(M_PI * 2, 0, 1, 0);
                                          } completion:^(BOOL finished) {
                                              [tempView removeFromSuperview];
                                              fromView.hidden = NO;
                                              [transitionContext completeTransition:YES];
                                          }];
                         
                     }];
    
}

- (void)dismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    //取出转场前后视图控制器上的视图view
    UIView * toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView * fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    
    UIView *containerView = [transitionContext containerView];
    
    //使用系统自带的snapshotViewAfterScreenUpdates:方法，参数为YES，代表视图的属性改变渲染完毕后截屏，参数为NO代表立刻将当前状态的视图截图
    UIView *fromViewCopy = [fromView snapshotViewAfterScreenUpdates:YES];
    
    [containerView addSubview:toView];
    [containerView addSubview:fromViewCopy];
    
    fromView.hidden = YES;
    toView.hidden = YES;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
                        options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         //你想绕哪个轴哪个轴就为 1，其中的参数（角度， x, y, z）
                         fromViewCopy.layer.transform = CATransform3DMakeRotation(-M_PI/2, 0, 1, 0);
                         fromViewCopy.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         
                         [fromViewCopy removeFromSuperview];
                         
                         if ([transitionContext transitionWasCancelled]){
                         }else{
                             //你想绕哪个轴哪个轴就为 1，其中的参数（角度， x, y, z）
                             toView.hidden = NO;
                             toView.layer.transform = CATransform3DMakeRotation(M_PI/2 * 3, 0, 1, 0);
                         }
                         
                         [UIView animateWithDuration:0.3
                                               delay:0
                                             options:UIViewAnimationOptionTransitionNone
                                          animations:^{
                                              toView.layer.transform = CATransform3DMakeRotation(M_PI * 2, 0, 1, 0);
                                          } completion:^(BOOL finished) {
                                              fromView.hidden = NO;
                                              
                                              //由于加入了手势交互转场，所以需要根据手势动作是否完成/取消来做操作
                                              [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                                              
                                              if ([transitionContext transitionWasCancelled]) {
                                                  //取消手势
                                                  toView.hidden = YES;
                                              }else{
                                              }
                                              
                                          }];
                         
                     }];
}

- (void)pushAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    [transitionContext completeTransition:YES];
}

- (void)popAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    [transitionContext completeTransition:YES];
}


@end
