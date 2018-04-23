//
//  WSLAnimationThree.m
//  TransferAnimation
//
//  Created by 王双龙 on 2018/4/12.
//  Copyright © 2018年 https://www.jianshu.com/u/e15d1f644bea All rights reserved.
//

#import "WSLAnimationThree.h"
#import "PrefixHeader.pch"
#import "WSLTransitionAnimationThree.h"
#import "WSLTransitionInteractiveThree.h"

@interface WSLAnimationThree ()

@property (nonatomic, strong) UIImageView * imageView;

//动画过渡转场
@property (nonatomic, strong) WSLTransitionAnimationThree * transitionAnimation;

//手势过渡转场
@property (nonatomic, strong) WSLTransitionInteractiveThree * transitionInteractive;

@end

@implementation WSLAnimationThree

- (instancetype)init{
    
    if (self == [super init]) {
        
        self.transitionAnimation.transitionType = WSLTransitionThreeTypePresent;
        self.transitionInteractive.interactiveType = WSLInteractiveThreeTypeDissmiss;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.imageView];

}

- (void)tapClicked{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
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

- (WSLTransitionAnimationThree *)transitionAnimation{
    
    if (_transitionAnimation == nil) {
        _transitionAnimation = [[WSLTransitionAnimationThree alloc] init];
        self.transitioningDelegate = self;
    }
    return _transitionAnimation;
}

- (WSLTransitionInteractiveThree *)transitionInteractive{

    if (_transitionInteractive == nil) {
        _transitionInteractive = [[WSLTransitionInteractiveThree alloc] init];
        [_transitionInteractive addPanGestureForViewController:self];
    }
    return _transitionInteractive;
}


#pragma mark -- UIViewControllerTransitioningDelegate

//返回一个处理present动画过渡的对象
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return self.transitionAnimation;
}
//返回一个处理dismiss动画过渡的对象
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    //这里我们初始化dismissType
    self.transitionAnimation.transitionType = WSLTransitionThreeTypeDissmiss;
    return self.transitionAnimation;
}

//返回一个处理present手势过渡的对象
//- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator{
//    self.transitionInteractive.interactiveType = WSLInteractiveThreeTypePresent;
//    return self.transitionInteractive;
//}
//返回一个处理dismiss手势过渡的对象
- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator{
     self.transitionInteractive.interactiveType = WSLInteractiveThreeTypeDissmiss;
    return self.transitionInteractive;
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
