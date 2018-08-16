//
//  WSLAnimationFive.m
//  TransferAnimation
//
//  Created by 王双龙 on 2018/4/20.
//  Copyright © 2018年 https://www.jianshu.com/u/e15d1f644bea All rights reserved.
//

#import "WSLAnimationFive.h"
#import "PrefixHeader.pch"
#import "UIScrollView+GestureConflict.h"

@interface WSLAnimationFive ()

@end

@implementation WSLAnimationFive

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"全屏侧滑返回";
    
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithTitle:@"首页" style:UIBarButtonItemStyleDone target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT - StatusBarAndNavigationBarHeight)];
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    for (int i = 0; i < 2 ; i++) {
        
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(i * SCREEN_WIDTH, 0, SCREEN_WIDTH, scrollView.frame.size.height)];
        view.backgroundColor = RGBRANDOMCOLOR;
        [scrollView addSubview:view];
        
        //滑块视图
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 60, 100)];
        label.center = CGPointMake(SCREEN_WIDTH/2.0, view.frame.size.height/2.0 - 100);
        label.text = i == 0 ? @"全屏侧滑返回、UISlider、UIScrollView相互间的手势冲突" : @"UISlider和UIScrollView的滑动事件冲突";
        label.textColor = RGBRANDOMCOLOR;
        label.numberOfLines = 2;
        label.backgroundColor = [UIColor whiteColor];
        [view addSubview:label];
        
        UISlider * slider = [[UISlider alloc] initWithFrame:CGRectMake(20, label.frame.origin.y + 200, SCREEN_WIDTH - 40, 50)];
        slider.minimumTrackTintColor = RGBRANDOMCOLOR;
        slider.maximumTrackTintColor = RGBRANDOMCOLOR;
        [view addSubview:slider];
        
    }
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * 2, scrollView.frame.size.height);
    [self.view addSubview:scrollView];
    
}

- (void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
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
