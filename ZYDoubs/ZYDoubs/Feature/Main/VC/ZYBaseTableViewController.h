//
//  ZYBaseTableViewController.h
//  ZYDoubs
//
//  Created by Momo on 17/1/10.
//  Copyright © 2017年 Momo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYBaseTableViewController : UITableViewController

/** 检查网络是否通畅 */
- (BOOL)checkNetWork;

/** 取消对话框*/
- (void)dismissAction;

/** SVP对话框 取消SVP后并带方法*/
-(void)createSVProgressMessage:(NSString *)str withMethod:(SEL)method;


/**设置导航栏标题黑色字体（单行）*/
-(void)setBlackTitle:(NSString *)title withVC:(UIViewController*)vc;

//设置导航栏标题黑色字体（双行）
-(void)setBlackTitle:(NSString *)title smallTitle:(NSString *)smallTitle withVC:(UIViewController*)vc;


/** 创建导航栏左边的图标（无方法）*/
- (void)createLeftImage:(NSString *)imageName withVC:(UIViewController*)vc;

/** 创建导航栏左边的返回按钮 (文字） 默认有返回按钮*/
- (void)createLeftBarButtonItemWithTitle:(NSString *)title withVC:(UIViewController*)vc;

/** 创建导航栏左边的按钮 (文字+图片）*/
- (void)createLeftBarButtonItemWithImage:(NSString *)imageName WithTitle:(NSString *)title withMethod:(SEL)method withVC:(UIViewController*)vc;

/** 创建导航栏右边的按钮 （图片+文字）*/
- (void)createRightBarButtonItemWithImage:(NSString *)imageName WithTitle:(NSString *)title withMethod:(SEL)method withVC:(UIViewController*)vc;

// alertView
-(void)createAlertWithMessage:(NSString *)message;


@end
