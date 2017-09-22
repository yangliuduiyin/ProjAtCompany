//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

// MARK: - 适配iOS 11 和 iPhone X
// MARK: 一.导航栏:
// MARK: - 1.导航栏高度的变化:
let navigationBar = UINavigationBar.init()
navigationBar.prefersLargeTitles = true
/**iOS11之前导航栏默认高度为64pt(这里高度指statusBar + NavigationBar)，
 iOS11之后如果设置了prefersLargeTitles = YES则为96pt，默认情况下还是64pt，
 但在iPhoneX上由于刘海的出现statusBar由以前的20pt变成了44pt，
 所以iPhoneX上高度变为88pt。*/

// MARK: - 2.导航栏图层及对titleView布局的影响
/**
 * iOS11之前导航栏的title是添加在UINavigationItemView上面，而navigationBarButton则直接添加在UINavigationBar上面，如果设置了titleView，则titleView也是直接添加在UINavigationBar上面。iOS11之后，大概因为largeTitle的原因，视图层级发生了变化，如果没有给titleView赋值，则titleView会直接添加在_UINavigationBarContentView上面，如果赋值了titleView，则会把titleView添加在_UITAMICAdaptorView上，而navigationBarButton被加在了_UIButtonBarStackView上，然后他们都被加在了_UINavigationBarContentView上。
 * 自定义的navigationBar在iOS 11 上运行时出现布局错乱的bug的解决办法:重写UINavigationBar的layoutSubviews方法，调整布局 ,ex:
 */
/**
 - (void)layoutSubviews {
 [super layoutSubviews];
 
 //注意导航栏及状态栏高度适配
 self.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), naviBarHeight);
 for (UIView *view in self.subviews) {
 if([NSStringFromClass([view class]) containsString:@"Background"]) {
 view.frame = self.bounds;
 }
 else if ([NSStringFromClass([view class]) containsString:@"ContentView"]) {
 CGRect frame = view.frame;
 frame.origin.y = statusBarHeight;
 frame.size.height = self.bounds.size.height - frame.origin.y;
 view.frame = frame;
 }
 }
 }
 */

// MARK: - 3.itleView支持autolayout，这要求titleView必须是能够自撑开的或实现了- intrinsicContentSize方法:
/**
 - (CGSize)intrinsicContentSize {
 return UILayoutFittingExpandedSize;
 }
 */

// MARK: - ps:简书app适配iOS 11.
// http://www.jianshu.com/p/26fc39135c34

// MARK: - 二.安全区域适配:
/* 1.iOS 11中ViewController的automaticallyAdjustsScrollViewInsets属性被废弃了,对于隐藏了系统导航栏,自定义导航栏的界面就会出现问题,如:
 self.automaticallyAdjustsScrollViewInsets = NO;
 self.extendedLayoutIncludesOpaqueBars = YES;
 self.edgesForExtendedLayout = UIRectEdgeTop;
 * automaticallyAdjustsScrollViewInsets属性被废弃了，顶部就多了一定的inset,比较简单的解决办法:
 if (@available(iOS 11.0, *)) {
 self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
 } else {
 self.automaticallyAdjustsScrollViewInsets = NO;
 }

 */

// MARK: - ps:iOS11安全区域适配总结: http://www.jianshu.com/p/efbc8619d56b
// Ex Masonry适配安全区域:
/*
 if (@available(iOS 11.0, *)) {
 make.edges.equalTo()(self.view.safeAreaInsets)
 } else {
 make.edges.equalTo()(self.view)
 }
 */

// MARK: - 2.导航栏返回按钮
/**
 a.对于自定义的返回按钮,iOS 11 中setBackButtonTitlePositionAdjustment:UIOffsetMake没法把按钮移出navigation bar。
 解决方法是设置navigationController的backIndicatorImage和backIndicatorTransitionMaskImage
 ex:
 UIImage *backButtonImage = [[UIImage imageNamed:@"icon_tabbar_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
 self.navigationBar.backIndicatorImage = backButtonImage;
 self.navigationBar.backIndicatorTransitionMaskImage = backButtonImage;
 
 */

// MARK: - tableView的问题

// MARK: - 第三方依赖库的问题:
// 1、ReactiveCocoa Unknown warning group ‘-Wreceiver-is-weak’,ignored警告


// MARK: - iPhone X
/**
 LaunchImage:
 如果你的APP在iPhoneX上运行发现没有充满屏幕，上下有黑色区域，那么你应该也像我一样LaunchImage没有用storyboard而是用的Assets，解决办法如图，启动图的尺寸为1125x2436，or you can iOS开发时如何使用 Launch Screen Storyboard。
 */

// MARK: - ps: iOS开发时如何使用 Launch Screen Storyboard:http://www.jianshu.com/p/77054dccafdb
















