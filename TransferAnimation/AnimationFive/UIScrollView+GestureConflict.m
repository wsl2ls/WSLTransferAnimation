//
//  UIScrollView+GestureConflict.m
//  TransferAnimation
//
//  Created by 王双龙 on 2018/4/20.
//  Copyright © 2018年 https://www.jianshu.com/u/e15d1f644bea All rights reserved.
//

#import "UIScrollView+GestureConflict.h"

@implementation UIScrollView (GestureConflict)

//处理UIScrollView上的手势和侧滑返回手势的冲突
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{

    // 首先判断otherGestureRecognizer是不是系统pop手势
    if ([otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UILayoutContainerView")]) {
        // 再判断系统手势的state是began还是fail，同时判断scrollView的位置是不是正好在最左边
        if (otherGestureRecognizer.state == UIGestureRecognizerStateBegan && self.contentOffset.x == 0) {
            return YES;
        }
    }
    return NO;
}
//拦截事件的处理 事件传递给谁，就会调用谁的hitTest:withEvent:方法。
//方案二 ：处理UISlider的滑动与UIScrollView的滑动事件冲突
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    /*
     直接拖动UISlider，此时touch时间在150ms以内，UIScrollView会认为是拖动自己，从而拦截了event，导致UISlider接受不到滑动的event。但是只要按住UISlider一会再拖动，此时此时touch时间超过150ms，因此滑动的event会发送到UISlider上。
     */
    UIView *view = [super hitTest:point withEvent:event];
    
    if([view isKindOfClass:[UISlider class]]) {
        //如果接收事件view是UISlider,则scrollview禁止响应滑动
        self.scrollEnabled = NO;
    } else {   //如果不是,则恢复滑动
        self.scrollEnabled = YES;
    }
    return view;
}

@end
