//
//  WSLTransitionTwo.m
//  TransferAnimation
//
//  Created by 王双龙 on 2018/4/13.
//  Copyright © 2018年 https://www.jianshu.com/u/e15d1f644bea All rights reserved.
//

#import "WSLTransitionAnimationTwo.h"
#import "ViewController.h"
#import "WSLNavigatioController.h"
#import "WSLAnimationTwo.h"

@implementation WSLTransitionAnimationTwo

//返回动画事件
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.5;
}

//所有的过渡动画事务都在这个方法里面完成
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    switch (_transitionType) {
        case WSLTransitionTwoTypePresent:
            [self presentAnimation:transitionContext];
            break;
        case WSLTransitionTwoTypeDissmiss:
            [self dismissAnimation:transitionContext];
            break;
        case WSLTransitionTwoTypePush:
            [self pushAnimation:transitionContext];
            break;
        case WSLTransitionTwoTypePop:
            [self popAnimation:transitionContext];
            break;
    }
    
}

#pragma mark -- transitionType

- (void)presentAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    [transitionContext completeTransition:YES];
    
    //    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 usingSpringWithDamping:0.55  initialSpringVelocity:1 / 0.55 options:0 animations:^{
    //    } completion:^(BOOL finished) {
    //    }];
}

- (void)dismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    [transitionContext completeTransition:YES];
}

- (void)pushAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    //通过viewControllerForKey取出转场前后的两个控制器，这里toVC就是转场后的VC、fromVC就是转场前的VC
    WSLAnimationTwo * toVC = (WSLAnimationTwo *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
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
    
    //使用系统自带的snapshotViewAfterScreenUpdates:方法，参数为YES，代表视图的属性改变渲染完毕后截屏，参数为NO代表立刻将当前状态的视图截图
    UIView *imageViewCopy = [cell.imageView snapshotViewAfterScreenUpdates:NO];
    imageViewCopy.frame = [cell.imageView convertRect:cell.imageView.bounds toView:containerView];
    
    UIView *titleLabelCopy = [cell.detailTextLabel snapshotViewAfterScreenUpdates:NO];
    titleLabelCopy.frame = [cell.detailTextLabel convertRect:cell.detailTextLabel.bounds toView:containerView];
    
    //设置动画前的各个控件的状态
    cell.imageView.hidden = YES;
    cell.detailTextLabel.hidden = YES;
    toVC.imageView.hidden = YES;
    toVC.titleLabel.hidden = YES;

    //tempView 添加到containerView中，要保证在最上层，所以后添加
    [containerView addSubview:toVC.view];
    [containerView addSubview:imageViewCopy];
    [containerView addSubview:titleLabelCopy];
    
    //开始做动画
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                     delay:0.0 usingSpringWithDamping:0.5  initialSpringVelocity: 1 / 0.5 options:0 animations:^{
        imageViewCopy.frame = [toVC.imageView convertRect:toVC.imageView.bounds toView:containerView];
        titleLabelCopy.frame = [toVC.titleLabel convertRect:toVC.titleLabel.bounds toView:containerView];
                         
    } completion:^(BOOL finished) {
        toVC.imageView.hidden = NO;
        toVC.titleLabel.hidden = NO;
        [titleLabelCopy removeFromSuperview];
        [imageViewCopy removeFromSuperview];
        //如果动画过渡取消了就标记不完成，否则才完成，这里可以直接写YES，如果有手势过渡才需要判断，必须标记，否则系统不会中断动画完成的部署，会出现无法交互之类的bug
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
    
}

- (void)popAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    //通过viewControllerForKey取出转场前后的两个控制器，这里toVC就是转场后的VC、fromVC就是转场前的VC
    ViewController * toVC;
    WSLAnimationTwo * fromVC = (WSLAnimationTwo *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
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
    
    //使用系统自带的snapshotViewAfterScreenUpdates:方法，参数为YES，代表视图的属性改变渲染完毕后截屏，参数为NO代表立刻将当前状态的视图截图
    UIView *imageViewCopy = [fromVC.imageView snapshotViewAfterScreenUpdates:NO];
    imageViewCopy.frame = [fromVC.imageView convertRect:fromVC.imageView.bounds toView:containerView];
    
    UIView *titleLabelCopy = [fromVC.titleLabel snapshotViewAfterScreenUpdates:NO];
    titleLabelCopy.frame = [fromVC.titleLabel convertRect:fromVC.titleLabel.bounds toView:containerView];
    
    //设置初始状态
    fromVC.imageView.hidden = YES;
    fromVC.titleLabel.hidden = YES;
    [containerView addSubview:toVC.view];
    
    //背景过渡视图
    UIView * bgView = [[UIView alloc] initWithFrame:fromVC.view.bounds];
    bgView.backgroundColor = [UIColor blackColor];
    [containerView addSubview:bgView];
    
    //imageViewCopy 添加到containerView中
    [containerView addSubview:imageViewCopy];
    [containerView addSubview:titleLabelCopy];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        imageViewCopy.frame = [cell.imageView convertRect:cell.imageView.bounds toView:containerView];
        titleLabelCopy.frame = [cell.detailTextLabel convertRect:cell.detailTextLabel.bounds toView:containerView];
        bgView.alpha = 0;
    } completion:^(BOOL finished) {
        //由于加入了手势必须判断
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        if ([transitionContext transitionWasCancelled]) {
            //手势取消了，原来隐藏的imageView要显示出来
            fromVC.imageView.hidden = NO;
            fromVC.titleLabel.hidden = NO;
        }else{
            //手势成功，cell的imageView也要显示出来
            cell.imageView.hidden = NO;
            cell.detailTextLabel.hidden = NO;
        }
        
        //动画交互动作完成或取消后，移除临时动画文件
        [titleLabelCopy removeFromSuperview];
        [imageViewCopy removeFromSuperview];
        [bgView removeFromSuperview];
        
    }];
    
}


@end
