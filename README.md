简书地址：https://www.jianshu.com/p/a9b1307b305b

![自定义转场动画集锦.gif](https://upload-images.jianshu.io/upload_images/1708447-3807c33b5a7185d9.gif?imageMogr2/auto-orient/strip)

>本文只是记录分享下自定义转场动画的实现方法，具体到动画效果的代码可以到Github下载查看，注释还算清晰。

### 模态化present和dismiss 自定义转场


1、创建一个遵循<UIViewControllerAnimatedTransitioning>协议的动画过渡管理对象(第一步需要返回的)，并实现如下两个方法：

```
//返回动画事件
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.3;
}
//所有的过渡动画事务都在这个方法里面完成
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{

 //取出转场前后的视图控制器
  UIViewController * fromVC = (UIViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  UIViewController * toVC = (UIViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

 //取出转场前后视图控制器上的视图view
    UIView * toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView * fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];

 //这里有个重要的概念containerView，要做转场动画的视图就必须要加入containerView上才能进行，可以理解containerView管理着所有做转场动画的视图
    UIView *containerView = [transitionContext containerView];

  //如果加入了手势交互转场，就需要根据手势交互动作是否完成/取消来做操作，完成标记YES，取消标记NO，必须标记，否则系统认为还处于动画过程中，会出现无法交互之类的bug
   [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
     if ([transitionContext transitionWasCancelled]) { 
    //如果取消转场
          }else{
   //完成转场
     }
}
```

2、自定义一个继承于UIPercentDrivenInteractiveTransition的手势过渡管理对象(第一步需要返回的)，可以根据手势需要设置控制动画转场进度的百分比。
```
//必要调用实现的系统方法

//手势过程中，通过updateInteractiveTransition设置转场过程动画进行的百分比，然后系统会根据百分比自动布局动画控件，不用我们控制了
 [self updateInteractiveTransition:percentComplete];
//完成转场操作
 [self finishInteractiveTransition];
//取消转场操作
 [self cancelInteractiveTransition];

```
3、转场时最上层的视图控制器需要遵循<UIViewControllerTransitioningDelegate>的协议，并设置为代理，并实现如下代理方法：

```
//设置转场代理
self.transitioningDelegate = self;

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
- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator{
    return self.transitionInteractive;
}
//返回一个处理dismiss手势过渡的对象
- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator{
    return self.transitionInteractive;
}
```

### 导航控制器push和pop 自定义转场

1、同上
2、同上
3、在push动画之前设置导航控制器的转场动画代理，转场时最上层的视图控制器需要遵循<UINavigationControllerDelegate>的协议，并设置为代理，并实现如下代理方法：

```
 //在push动画之前设置转场动画代理
 self.navigationController.delegate = animationFour;

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

```

### 全屏侧滑返回

> 创建一个继承于UINavigationController的一个对象WSLNavigatioController，遵守协议<UIGestureRecognizerDelegate>,实现如下方法：

```
  // 获取系统自带滑动手势的target对象
    id target = self.interactivePopGestureRecognizer.delegate;
    // 创建全屏滑动手势，调用系统自带滑动手势的target的action方法
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    // 设置手势代理，拦截手势触发
    pan.delegate = self;
    // 给导航控制器的view添加全屏滑动手势
    [self.view addGestureRecognizer:pan];
    // 禁止使用系统自带的滑动手势
    self.interactivePopGestureRecognizer.enabled = NO;

#pragma mark -- UIGestureRecognizerDelegate
// 什么时候调用：每次触发手势之前都会询问下代理，是否触发。
// 作用：拦截手势触发
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // 注意：只有非根控制器才有滑动返回功能，根控制器没有。
    // 判断导航控制器是否只有一个子控制器，如果只有一个子控制器，肯定是根控制器
    if (self.childViewControllers.count == 1) {
        // 表示用户在根控制器界面，就不需要触发滑动手势，
        return NO;
    }
    return YES;
}

```

##### 解决UIScrollView的滑动手势与全屏侧滑手势的冲突
>创建一个UIScrollView的类别UIScrollView+GestureConflict，重写如下方法：
```
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
```

学习文章：
https://www.jianshu.com/p/45434f73019e     
http://www.cocoachina.com/ios/20150811/12897.html
