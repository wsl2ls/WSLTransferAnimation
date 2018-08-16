//
//  ViewController.m
//  TransferAnimation
//
//  Created by 王双龙 on 2018/3/30.
//  Copyright © 2018年 https://www.jianshu.com/u/e15d1f644bea All rights reserved.
//

#import "ViewController.h"
#import "PrefixHeader.pch"
#import "WSLAnimationOne.h"
#import "WSLAnimationTwo.h"
#import "WSLAnimationThree.h"
#import "WSLAnimationFour.h"
#import "WSLAnimationFive.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray * dataSource;

@property (nonatomic, strong) NSArray * describeArray;

@property (nonatomic, strong) NSArray * vcArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    self.title = @"转场动画";
    _dataSource = @[@"Present/Dissmiss转场1", @"Push/Pop转场2", @"Present/Dissmiss转场3", @"Push/Pop转场4",@"Push/Pop转场5"];
    _describeArray = @[@"新浪微博图集浏览转场效果", @"手势过渡动画", @"网易音乐启动屏转场动画", @"开关门动画", @"全屏侧滑返回、UIScrollView、UISlider三者手势滑动事件冲突"];
    _vcArray = @[[WSLAnimationOne class], [WSLAnimationTwo class], [WSLAnimationThree class], [WSLAnimationFour class], [WSLAnimationFive class]];
}

#pragma mark -- Getter

- (UITableView *)tableView{
    
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight ,SCREEN_WIDTH , SCREEN_HEIGHT - StatusBarAndNavigationBarHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}


#pragma mark -- UITableViewDelegate  UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellID"];
    }
    //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageView.image = [UIImage imageNamed:@"piao"];
    cell.textLabel.text = _dataSource[indexPath.row];
    cell.detailTextLabel.text = _describeArray[indexPath.row];
    cell.detailTextLabel.numberOfLines = 2;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (_vcArray[indexPath.row] == [WSLAnimationOne class]) {
        self.currentIndexPath = indexPath;
        WSLAnimationOne * animationOne = [[_vcArray[indexPath.row] alloc] init];
        [self presentViewController:animationOne animated:YES completion:nil];
    }else if (_vcArray[indexPath.row] == [WSLAnimationTwo class]){
        WSLAnimationTwo * animationTwo = [[_vcArray[indexPath.row] alloc] init];
        self.currentIndexPath = indexPath;
        //在push动画之前设置动画代理
        self.navigationController.delegate = animationTwo;
        [self.navigationController pushViewController:animationTwo animated:YES];
    }else if (_vcArray[indexPath.row] == [WSLAnimationThree class]){
        WSLAnimationThree * animationThree = [[_vcArray[indexPath.row] alloc] init];
        [self presentViewController:animationThree animated:YES completion:nil];
    }else if (_vcArray[indexPath.row] == [WSLAnimationFour class]){
        WSLAnimationFour * animationFour = [[_vcArray[indexPath.row] alloc] init];
        //在push动画之前设置动画代理
        self.navigationController.delegate = animationFour;
        [self.navigationController pushViewController:animationFour animated:YES];
    }else if (_vcArray[indexPath.row] == [WSLAnimationFive class]){
        self.navigationController.delegate = nil;
        WSLAnimationFive * animationFive = [[_vcArray[indexPath.row] alloc] init];
        [self.navigationController pushViewController:animationFive animated:YES];
    }
    
}

- (void)dealloc{
    self.navigationController.delegate = nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
