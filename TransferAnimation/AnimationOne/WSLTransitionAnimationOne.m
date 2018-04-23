//
//  WSLTransitionOne.m
//  TransferAnimation
//
//  Created by 王双龙 on 2018/4/13.
//  Copyright © 2018年 https://www.jianshu.com/u/e15d1f644bea. All rights reserved.
//

#import "WSLTransitionAnimationOne.h"
#import "ViewController.h"
#import "WSLNavigatioController.h"
#import "WSLAnimationOne.h"

@implementation WSLTransitionAnimationOne

//返回动画事件
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.3;
}

//所有的过渡动画事务都在这个方法里面完成
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    switch (_transitionType) {
        case WSLTransitionOneTypePresent:
            [self presentAnimation:transitionContext];
            break;
        case WSLTransitionOneTypeDissmiss:
            [self dismissAnimation:transitionContext];
            break;
        case WSLTransitionOneTypePush:
            [self pushAnimation:transitionContext];
            break;
        case WSLTransitionOneTypePop:
            [self popAnimation:transitionContext];
            break;
    }
    
}

#pragma mark -- transitionType

- (void)presentAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    //通过viewControllerForKey取出转场前后的两个控制器，这里toVC就是转场后的VC、fromVC就是转场前的VC
    WSLAnimationOne * toVC = (WSLAnimationOne *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    ViewController * fromVC;
    if ([[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey] isKindOfClass:[WSLNavigatioController class]]) {
        WSLNavigatioController * na = (WSLNavigatioController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        fromVC = na.viewControllers.lastObject;
    }else if([[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey] isKindOfClass:[ViewController class]]){
        fromVC = (ViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    }
    
    //取出转场前后视图控制器上的视图view
    UIView * toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView * fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    
    //获取点击的cell
    UITableViewCell * cell = [fromVC.tableView cellForRowAtIndexPath:fromVC.currentIndexPath];
    
    //这里有个重要的概念containerView，如果要对视图做转场动画，视图就必须要加入containerView中才能进行，可以理解containerView管理着所有做转场动画的视图
    UIView *containerView = [transitionContext containerView];
    
    //snapshotViewAfterScreenUpdates 对cell的imageView截图保存成另一个视图用于过渡，并将视图转换到当前控制器的坐标
    UIView *tempView = [cell.imageView snapshotViewAfterScreenUpdates:NO];
    tempView.frame = [cell.imageView convertRect:cell.imageView.bounds toView:containerView];
    
    //设置动画前的各个控件的状态
    cell.imageView.hidden = YES;
    toVC.view.alpha = 0;
    toVC.imageView.hidden = YES;
    //tempView 添加到containerView中，要保证在最上层，所以后添加
    [containerView addSubview:toVC.view];
    [containerView addSubview:tempView];
    
    //开始做动画
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        tempView.frame = [toVC.imageView convertRect:toVC.imageView.bounds toView:containerView];
        toVC.view.alpha = 1;
    } completion:^(BOOL finished) {
        [tempView removeFromSuperview];
        toVC.imageView.hidden = NO;
        //如果动画过渡取消了就标记不完成，否则才完成，这里可以直接写YES，如果有手势过渡才需要判断，必须标记，否则系统不会中断动画完成的部署，会出现无法交互之类的bug
        [transitionContext completeTransition:YES];
    }];
    
    
    //    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 usingSpringWithDamping:0.55  initialSpringVelocity:1 / 0.55 options:0 animations:^{
    //    } completion:^(BOOL finished) {
    //    }];
    
}

- (void)dismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    //通过viewControllerForKey取出转场前后的两个控制器，这里toVC就是转场后的VC、fromVC就是转场前的VC
    ViewController * toVC;
    WSLAnimationOne * fromVC = (WSLAnimationOne *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    if ([[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey] isKindOfClass:[WSLNavigatioController class]]) {
        WSLNavigatioController * na = (WSLNavigatioController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        toVC = na.viewControllers.firstObject;
    }else if([[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey] isKindOfClass:[ViewController class]]){
        toVC = (ViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    }
    //取出转场前后视图控制器上的视图view
    UIView * toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView * fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    
    //获取点击的cell
    UITableViewCell * cell = [toVC.tableView cellForRowAtIndexPath:toVC.currentIndexPath];
    
    UIView *containerView = [transitionContext containerView];
    
    //snapshotViewAfterScreenUpdates 对cell的imageView截图保存成另一个视图用于过渡，并将视图转换到当前控制器的坐标
    UIView *tempView = [fromVC.imageView snapshotViewAfterScreenUpdates:NO];
    tempView.frame = [fromVC.imageView convertRect:fromVC.imageView.bounds toView:containerView];
    
    //设置初始状态
    fromVC.imageView.hidden = YES;
    //tempView 添加到containerView中
    [containerView addSubview:tempView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        tempView.frame = [cell.imageView convertRect:cell.imageView.bounds toView:containerView];
        fromVC.view.alpha = 0;
    } completion:^(BOOL finished) {
        //由于加入了手势必须判断
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        if ([transitionContext transitionWasCancelled]) {
            //手势取消了，原来隐藏的imageView要显示出来
            //失败了隐藏tempView，显示fromVC.imageView
            [tempView removeFromSuperview];
            fromVC.imageView.hidden = NO;
        }else{
            //手势成功，cell的imageView也要显示出来
            //成功了移除tempView，下一次pop的时候又要创建，然后显示cell的imageView
            cell.imageView.hidden = NO;
            [tempView removeFromSuperview];
        }
    }];
    
}

- (void)pushAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    
        //如果动画过渡取消了就标记不完成，否则才完成，这里可以直接写YES，必须标记，否则系统不会中断动画完成动作，会一直处于动画过程中，出现无法交互之类的bug
//        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
     //完成转场
     [transitionContext completeTransition:YES];
    
}

- (void)popAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    //由于加入了手势必须判断
    [transitionContext completeTransition:YES];
}


@end
