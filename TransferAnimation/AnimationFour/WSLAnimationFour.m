//
//  WSLAnimationFour.m
//  TransferAnimation
//
//  Created by 王双龙 on 2018/4/18.
//  Copyright © 2018年 https://www.jianshu.com/u/e15d1f644bea All rights reserved.
//

#import "WSLAnimationFour.h"
#import "PrefixHeader.pch"
#import "WSLTransitionAnimationFour.h"
#import "WSLTransitionInteractiveFour.h"

@interface WSLAnimationFour ()

@property (nonatomic, strong) UIImageView * imageView;

//动画过渡转场
@property (nonatomic, strong) WSLTransitionAnimationFour * transitionAnimation;

//手势过渡转场
@property (nonatomic, strong) WSLTransitionInteractiveFour * transitionInteractive;

@end

@implementation WSLAnimationFour

- (instancetype)init{
    
    if (self == [super init]) {
        
        self.transitionAnimation.transitionType = WSLTransitionFourTypePush;
        self.transitionInteractive.interactiveType = WSLInteractiveFourTypePop;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"开关门动画";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.imageView];
    
}

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

- (WSLTransitionAnimationFour *)transitionAnimation{
    
    if (_transitionAnimation == nil) {
        _transitionAnimation = [[WSLTransitionAnimationFour alloc] init];
    }
    return _transitionAnimation;
}

- (WSLTransitionInteractiveFour *)transitionInteractive{
    
    if (_transitionInteractive == nil) {
        _transitionInteractive = [[WSLTransitionInteractiveFour alloc] init];
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
        self.transitionAnimation.transitionType = WSLTransitionFourTypePush;
        return self.transitionAnimation;
    }else if (operation == UINavigationControllerOperationPop){
        self.transitionAnimation.transitionType = WSLTransitionFourTypePop;
    }
    return self.transitionAnimation;
}

//返回处理push/pop手势过渡的对象 这个代理方法依赖于上方的方法 ，这个代理实际上是根据交互百分比来控制上方的动画过程百分比
- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                   interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController{
    
    //手势开始的时候才需要传入手势过渡代理，如果直接pop或push，应该返回nil，否者无法正常完成pop/push动作
    if ( self.transitionAnimation.transitionType == WSLTransitionFourTypePop) {
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
