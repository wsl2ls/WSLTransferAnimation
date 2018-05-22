//
//  WSLAnimationTwo.m
//  TransferAnimation
//
//  Created by 王双龙 on 2018/4/7.
//  Copyright © 2018年 https://www.jianshu.com/u/e15d1f644bea All rights reserved.
//

#import "WSLAnimationTwo.h"
#import "PrefixHeader.pch"
#import "WSLTransitionAnimationTwo.h"
#import "WSLTransitionInteractiveTwo.h"

@interface WSLAnimationTwo () <UINavigationControllerDelegate>

//动画过渡转场
@property (nonatomic, strong) WSLTransitionAnimationTwo * transitionAnimation;

//手势过渡转场
@property (nonatomic, strong) WSLTransitionInteractiveTwo * transitionInteractive;

@end

@implementation WSLAnimationTwo

- (instancetype)init{
    
    if (self == [super init]) {
       
        self.transitionAnimation.transitionType = WSLTransitionTwoTypePush;
        self.transitionInteractive.interactiveType = WSLInteractiveTwoTypePop;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.titleLabel];
    
}

#pragma mark -- Events Handel

- (void)tapClicked{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark -- Getter

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

- (UILabel *)titleLabel{
    
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT - StatusBarAndNavigationBarHeight - 30, SCREEN_WIDTH, 40)];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.text = @"手势过渡动画";
    }
    return _titleLabel;
}

- (WSLTransitionAnimationTwo *)transitionAnimation{
    
    if (_transitionAnimation == nil) {
        _transitionAnimation = [[WSLTransitionAnimationTwo alloc] init];
    }
    return _transitionAnimation;
}

- (WSLTransitionInteractiveTwo *)transitionInteractive{
    
    if (_transitionInteractive == nil) {
        _transitionInteractive = [[WSLTransitionInteractiveTwo alloc] init];
        [_transitionInteractive addPanGestureForViewController:self];
    }
    return _transitionInteractive;
}

#pragma mark -- UINavigationControllerDelegate

//返回处理push/pop动画过渡的对象
- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC{
    
    if (operation == UINavigationControllerOperationPush) {
        self.transitionAnimation.transitionType = WSLTransitionTwoTypePush;
        return self.transitionAnimation;
    }else if (operation == UINavigationControllerOperationPop){
        self.transitionAnimation.transitionType = WSLTransitionTwoTypePop;
    }
    return self.transitionAnimation;
}

//返回处理push/pop手势过渡的对象 这个代理方法依赖于上方的方法 ，这个代理实际上是根据交互百分比来控制上方的动画过程百分比
- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                   interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController{
    
    //手势开始的时候才需要传入手势过渡代理，如果直接pop或push，应该返回nil，否者无法正常完成pop/push动作
    if ( self.transitionAnimation.transitionType == WSLTransitionTwoTypePop) {
        return self.transitionInteractive.isInteractive == YES ? self.transitionInteractive : nil;
    }
    return nil;
}

- (void)viewDidDisappear:(BOOL)animated{
    self.navigationController.delegate = nil;
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
