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





> 更新于 2018/8/17   [iOS 全屏侧滑手势/UIScrollView/UISlider间滑动手势冲突](https://www.jianshu.com/p/a9a322052f26)

![效果预览](https://upload-images.jianshu.io/upload_images/1708447-83ae3654030d8414.gif?imageMogr2/auto-orient/strip)

####  一、前期准备

> 有一个支持全屏侧滑返回的视图控制器ViewController，ViewController.view上有一个UIScrollView，UIScrollView上有UISlider。俺直接在之前的示例Demo上演示，简书地址：[iOS 自定义转场动画](https://www.jianshu.com/p/a9b1307b305b) ，Github地址 ：[WSLTransferAnimation](https://github.com/wslcmk/WSLTransferAnimation.git) 

#### 二、问题展示

*  **现象 1**、*UIScrollView当前在第一页即contentOffset.x=0时，左滑不能触发全屏侧滑pop返回的手势* ；

![UIScrollView和全屏侧滑pop返回手势冲突示意图](https://upload-images.jianshu.io/upload_images/1708447-a9eacdbc7092ff36.gif?imageMogr2/auto-orient/strip)

*  **现象2** 、*问题1解决后，你会发现拖拽UIScrollView第一页上的UISlider时，向右拖拽时却触发了全屏侧滑pop返回的手势，而UISlider本身的拖拽事件却没有响应；向左拖拽UISlider时，响应的是UIScrollView的拖动事件，而UISlider本身的拖拽事件也没有响应*。

![UISlider与UIScrollView、全屏侧滑pop返回手势冲突示意图](https://upload-images.jianshu.io/upload_images/1708447-dd07d227fe222ecb.gif?imageMogr2/auto-orient/strip)

* **现象3** 、*当你长按UISlider超过150ms后直接拖拽，就不存在现象2中UISlider与UIScrollView、全屏侧滑返回的冲突问题了*。

![手势冲突.gif](https://upload-images.jianshu.io/upload_images/1708447-418b5c5d99e7de6c.gif?imageMogr2/auto-orient/strip)

####  三、分析解决问题

> 这些问题很显然，肯定跟iOS事件的传递和响应链机制有关系，不了解的可以看看这篇文章 [史上最详细的iOS之事件的传递和响应机制-原理篇](https://www.jianshu.com/p/2e074db792ba)。

*  **分析解决问题 1**
*如果你了解事件的传递和响应链机制的话，应该能想到，是由于UIScrollView的内部手势方法阻断了全屏侧滑返回手势的的响应，那我们就找到这个方法，代码如下* ；

> 创建一个UIScrollView的类别UIScrollView+GestureConflict，重写如下方法：

```
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

```

*  **分析解决问题 2和3**  

*方案一：这个跟UIScrollView的一个属性delaysContentTouches有关。*
>  scrollView.delaysContentTouches = NO; 
delaysContentTouches 默认值为YES 表示延迟scrollView上子视图的响应，所以当直接拖动UISlider时，如果此时touch时间在150ms以内，UIScrollView会认为是拖动自己，从而拦截了event，导致UISlider接收不到滑动的event。但是只要长按住UISlider一会儿再拖动，此时touch时间超过150ms，因此滑动的event会发送到UISlider上，然后UISlider再作出响应；设置为NO后，拖动UISlider时就可以直接做出响应，解决了UISlider与UIScrollView之间的冲突，同时也解决了向右拖拽时却触发了全屏侧滑pop返回的问题。
   


*方案二： 重写类别UIScrollView+GestureConflict中的如下方法来解决UISlider与UIScrollView之间的冲突，然后还需要执行下面 ***问题补充*** 中的操作来处理UISlider的滑动与全屏侧滑pop返回事件的冲突。*
```
//拦截事件的处理 事件传递给谁，就会调用谁的hitTest:withEvent:方法。
//处理UISlider的滑动与UIScrollView的滑动事件冲突
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

```

*  **问题补充**  
*示例Demo中的UISlider是在UIScrollView上的，如果UISlider不是在UIScrollView上，而是直接就在ViewController.view上，那也就会出现拖拽UISlider时却响应了全屏侧滑pop返回手势的问题。*

>在支持全屏侧滑返回的UINavigationController的子类WSLNavigatioController中，遵守协议<UIGestureRecognizerDelegate>,实现如下方法：

```
#pragma mark -- UIGestureRecognizerDelegate
//触发之后是否响应手势事件
//处理侧滑返回与UISlider的拖动手势冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    //如果手势是触摸的UISlider滑块触发的，侧滑返回手势就不响应
    if ([touch.view isKindOfClass:[UISlider class]]) {
        return NO;
    }
    return YES;
}
```

####  四、应用示例

![手势冲突应用示例.gif](https://upload-images.jianshu.io/upload_images/1708447-9652702e9c19bc57.gif?imageMogr2/auto-orient/strip)


> 好了，俺要去鹊桥跟俺家织女相会咯✌️😊(*❦ω❦)，就说这么多了，今天七夕节，也祝各位单身猿告白成功，玩的开心😊O(∩_∩)O哈哈~

![表白🌹](https://upload-images.jianshu.io/upload_images/1708447-03c8b6f0c64ef56d.gif?imageMogr2/auto-orient/strip)



推荐阅读：
[iOS 自定义转场动画](https://www.jianshu.com/p/a9b1307b305b)
[iOS 瀑布流封装](https://www.jianshu.com/p/9fafd89c97ad)
[WKWebView的使用](https://www.jianshu.com/p/5cf0d241ae12)
[UIScrollView视觉差动画](https://www.jianshu.com/p/3b30b9cdd274)
[iOS 传感器集锦](https://www.jianshu.com/p/5fc26af852b6)
[iOS 音乐播放器之锁屏歌词+歌词解析+锁屏效果](https://www.jianshu.com/p/35ce7e1076d2)
[UIActivityViewController系统原生分享-仿简书分享](https://www.jianshu.com/p/b6b44662dfda)
[iOS UITableView获取特定位置的cell](https://www.jianshu.com/p/70cdcdcb6764)


欢迎扫描下方二维码关注——iOS开发进阶之路——微信公众号：iOS2679114653 本公众号是一个iOS开发者们的分享，交流，学习平台，会不定时的发送技术干货，源码,也欢迎大家积极踊跃投稿，(择优上头条) ^_^分享自己开发攻城的过程，心得，相互学习，共同进步，成为攻城狮中的翘楚！

![iOS开发进阶之路.jpg](http://upload-images.jianshu.io/upload_images/1708447-c2471528cadd7c86.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


