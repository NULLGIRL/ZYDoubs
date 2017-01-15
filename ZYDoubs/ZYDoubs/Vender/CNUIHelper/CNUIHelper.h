//
//  CNUIHelper.h
//  UStore
//
//  Created by 黄煜民 on 16/6/8.
//  Copyright © 2016年 Haidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CNUIHelper : NSObject
+ (UIViewController *)getCurrentRootViewController;
+ (UIView*)getTopView;
/**
 *  飘字显示消息
 *
 *  @param msg 消息内容
 */
+ (void)toast:(NSString*)msg;
+ (void)toastByKeyWindow:(NSString *)msg;
+ (void)toastUsingVC:(NSString*)msg;


/**
 *  显示进度条
 *
 *  @param tip 提示信息
 *
 *  @return 进度条实例
 */
+ (MBProgressHUD*)showSimpleProgress;
+ (MBProgressHUD*)showSimpleProgressToView:(UIView*)parent;
+ (MBProgressHUD*)showProgressWithTip:(NSString*)tip;
+ (MBProgressHUD*)showProgressToView:(UIView*)parent withTip:(NSString*)tip;

/**
 *  设置lable行间距
 *
 *  @param cLabel label
 *  @param lfSpacing 行间距
 *  @param strContent 内容
 */
+ (void )setLabelSpacing:(UILabel*) cLabel lfSpacing:(CGFloat ) lfSpacing strContent:(NSString*)strContent;

/**
 *  设置商品icon
 *
 *  @param imageview
 *  @param path
 */
+ (void)updateGoodImage:(UIImageView*)imageview path:(NSString*)path;

/**
 *  设置商品icon
 *
 *  @param imageview
 *  @param path
 */
+ (void)updateheadImage:(UIImageView*)imageview path:(NSString*)path;


/**
 *  获取莫个月的天数
 *
 *  @param year  年
 *  @param month 月
 *
 *  @return 天数
 */
+ (NSInteger)getDaysOfMonth:(NSInteger)year month:(NSInteger)month;


/**
 *  tab切换
 *
 *  @param index <#index description#>
 *  @param owner <#owner description#>
 */
+ (void)pushToVcWithIndex:(NSInteger)index owner:(UIViewController *)owner;

/**
 *  设置控件边框、圆角、边框颜色
 *
 *  @param control 控件
 *  @param Width   边框宽度
 *  @param Radius  圆角
 *  @param color   边框颜色
 */
+ (void)setControlUI:(id)control BorderWidth:(CGFloat )Width CornerRadius:(CGFloat )Radius BorderColor:(UIColor *)color;


+ (BOOL)simpleVerifyIdentityCardNum:(NSString *)idCard;

+ (BOOL)ispostcodeWith:(NSString *)code;

/**
 *  md5加密
 *
 *  @param input <#input description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)stringMD5:(NSString *)input;


// 时间戳穿换成时间

+ (NSString *)timeInterval:(long long)timestamp;

@end
