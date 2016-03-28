//
//  UIViewController+scrollerHidden.m
//  自定义导航控制器
//
//  Created by HelloYeah on 16/3/12.
//  Copyright © 2016年 HelloYeah. All rights reserved.
//

#import "UIViewController+NavBarHidden.h"
#import <objc/runtime.h>

@implementation UIViewController (NavBarHidden)

#pragma mark - 通过运行时动态添加存储属性
//定义关联的Key
static const char * key = "keyScrollView";

- (UIScrollView *)keyScrollView{
    return objc_getAssociatedObject(self, key);
}

- (void)setKeyScrollView:(UIScrollView *)keyScrollView{
    objc_setAssociatedObject(self, key, keyScrollView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//定义关联的Key
static const char * isLeftAlphaKey = "isLeftAlpha";
- (BOOL)isLeftAlpha{

    return [objc_getAssociatedObject(self,isLeftAlphaKey) boolValue];
}
- (void)setIsLeftAlpha:(BOOL)isLeftAlpha{
    
    objc_setAssociatedObject(self, isLeftAlphaKey, @(isLeftAlpha), OBJC_ASSOCIATION_ASSIGN);
}
//定义关联的Key
static const char * isRightAlphaKey = "isRightAlpha";
- (BOOL)isRightAlpha{
    
    return [objc_getAssociatedObject(self,isRightAlphaKey) boolValue];
}
- (void)setIsRightAlpha:(BOOL)isRightAlpha{
    
    objc_setAssociatedObject(self, isRightAlphaKey, @(isRightAlpha), OBJC_ASSOCIATION_ASSIGN);
}
//定义关联的Key
static const char * isTitleAlphaKey = "isTitleAlpha";
- (BOOL)isTitleAlpha{
    
    return [objc_getAssociatedObject(self,isTitleAlphaKey) boolValue];
}
- (void)setIsTitleAlpha:(BOOL)isTitleAlpha{
    
    objc_setAssociatedObject(self, isTitleAlphaKey, @(isTitleAlpha), OBJC_ASSOCIATION_ASSIGN);
}

#pragma mark - custom方法

static CGFloat alpha = 0; //透明度
- (void)scrollControlRate:(CGFloat)rate{

    //传值处理
    if (rate >= 1) {
        rate = 0.999999;
    }else if(rate <= 0.000001){
        rate = 0.000001;
    }
    
    //根据滚动距离计算透明度
    CGFloat height = (1 - rate) * [UIScreen mainScreen].bounds.size.height;
    
    if ([self getScrollerView]){
        
        UIScrollView * scrollerView = [self getScrollerView];
        alpha =  scrollerView.contentOffset.y/height;
    }
    alpha = (alpha <= 0)?0.00001:alpha;
 
    [[[self.navigationController.navigationBar subviews]objectAtIndex:0] setAlpha:alpha];
    
    //设置导航条上的标签是否跟着透明
    self.navigationItem.leftBarButtonItem.customView.alpha = self.isLeftAlpha?alpha:1;
    self.navigationItem.titleView.alpha = self.isTitleAlpha?alpha:1;
    self.navigationItem.rightBarButtonItem.customView.alpha = self.isRightAlpha?alpha:1;
}



// 获取tableView 或者 collectionView
- (UIScrollView *)getScrollerView{
    
    if ([self isKindOfClass:[UITableViewController class]]) {
        
        return  (UIScrollView *)self.view;
        
    }else if ([self isKindOfClass:[UICollectionViewController class]]){
        
        return  (UIScrollView *)self.view;
        
    }else{
        for (UIView * view in self.view.subviews) {
            
            if ([view isEqual:self.keyScrollView] & [view isKindOfClass:[UIScrollView class]]) {
                
                return (UIScrollView *)view;
            }
        }
    }
    return nil;
}


- (void)setInViewWillAppear{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
    
        [self scrollControlRate:0.999999];

    });
    //设置背景图片
    [self.navigationController.navigationBar setBackgroundImage:[self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault] forBarMetrics:UIBarMetricsDefault];
    //清除边框，设置一张空的图片
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
    [self scrollControlRate:1];
    
}

- (void)setInViewWillDisappear{
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

@end
