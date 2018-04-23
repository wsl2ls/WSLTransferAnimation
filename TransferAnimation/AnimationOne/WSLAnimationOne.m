//
//  WSLAnimationOne.m
//  TransferAnimation
//
//  Created by 王双龙 on 2018/4/2.
//  Copyright © 2018年 https://www.jianshu.com/u/e15d1f644bea All rights reserved.
//

#import "WSLAnimationOne.h"
#import "PrefixHeader.pch"
#import "WSLTransitionAnimationOne.h"

@interface WSLAnimationOne ()<UIViewControllerTransitioningDelegate>

//动画过渡转场
@property (nonatomic, strong) WSLTransitionAnimationOne * transitionAnimation;

@end

@implementation WSLAnimationOne


- (instancetype)init{
    
    if (self == [super init]) {
        
        self.transitionAnimation.transitionType = WSLTransitionOneTypePresent;
        
        //设置了这个属性之后，在present转场动画处理时，转场前的视图fromVC的view一直都在管理转场动画视图的容器containerView中，会被转场后,后加入到containerView中视图toVC的View遮住，类似于入栈出栈的原理；如果没有设置的话，present转场时，fromVC.view就会先出栈从containerView移除，然后toVC.View入栈，那之后再进行disMiss转场返回时，需要重新把fromVC.view加入containerView中。
        //在push转场动画处理时,设置这个属性是没有效果的，也就是没用的。
        self.modalPresentationStyle = UIModalPresentationCustom;
        
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.imageView];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [self.imageView addGestureRecognizer:pan];
    
}

#pragma mark -- setupUI

#pragma mark -- Help Methods

#pragma mark -- Events Handel

- (void)tapClicked{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)handleGesture:(UIPanGestureRecognizer *)panGesture{
    
    CGPoint  translation = [panGesture translationInView:self.imageView];
    CGFloat percentComplete = 0.0;
    
    self.imageView.center = CGPointMake(self.imageView.center.x + translation.x,
                                        self.imageView.center.y + translation.y);
    [panGesture setTranslation:CGPointZero inView:self.imageView];
    
    percentComplete = (self.imageView.center.y - self.view.frame.size.height/ 2) / (self.view.frame.size.height/2);
    percentComplete = fabs(percentComplete);
    NSLog(@"%f",percentComplete);
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateChanged:
            self.view.alpha = 1 - percentComplete;
            break;
        case UIGestureRecognizerStateEnded:{
            
            if (percentComplete > 0.5) {
                [self dismissViewControllerAnimated:YES completion:nil];

            }else{
                self.imageView.center = CGPointMake(self.view.center.x,
                                                    self.view.center.y);
                self.view.alpha = 1;
            }
            break;
        }
        default:
            break;
    }
    
}

#pragma mark -- Getter

- (WSLTransitionAnimationOne *)transitionAnimation{
    
    if (_transitionAnimation == nil) {
        _transitionAnimation = [[WSLTransitionAnimationOne alloc] init];
        self.transitioningDelegate = self;
    }
    return _transitionAnimation;
}


- (UIImageView *)imageView{
    
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT/2)];
        _imageView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
        _imageView.image = [UIImage imageNamed:@"piao"];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClicked)];
        _imageView.userInteractionEnabled = YES;
        [_imageView addGestureRecognizer:tap];
    }
    return _imageView;
}

#pragma mark -- UIViewControllerTransitioningDelegate

//返回一个处理present动画过渡的对象
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return self.transitionAnimation;
}
//返回一个处理dismiss动画过渡的对象
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    //这里我们初始化dismissType
    self.transitionAnimation.transitionType = WSLTransitionOneTypeDissmiss;
    return self.transitionAnimation;
}

//返回一个处理present手势过渡的对象
//- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator{
//    return self.transitionInteractive;
//}
//返回一个处理dismiss手势过渡的对象
//- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator{
//    return self.transitionInteractive;
//}

- (void)dealloc{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
