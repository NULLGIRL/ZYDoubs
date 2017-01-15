//
//  CNUIHelper.m
//  UStore
//
//  Created by 黄煜民 on 16/6/8.
//  Copyright © 2016年 Haidu. All rights reserved.
//

#import "CNUIHelper.h"
#import "Toast+UIView.h"

#import<CommonCrypto/CommonDigest.h>


@implementation CNUIHelper

+ (UIView*)getTopView {
    return [[[[UIApplication sharedApplication] keyWindow] subviews] lastObject];
}

+ (void)toast:(NSString *)msg {
    [[CNUIHelper getTopView] makeToast:msg];
}

+ (void)toastByKeyWindow:(NSString *)msg {
    [[UIApplication sharedApplication].keyWindow makeToast:msg];
}

+ (void)toastUsingVC:(NSString*)msg {
    [[CNUIHelper getCurrentRootViewController].view makeToast:msg];
}
+ (UIViewController *)getCurrentRootViewController {
    
    UIViewController *result;
    UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
    
    NSArray *windows = [[UIApplication sharedApplication] windows];
    for(UIWindow* window in windows) {
        if (window.windowLevel == UIWindowLevelNormal) {
            topWindow = window;
        }
    }
    
    UIView *rootView;
    NSArray* subViews = [topWindow subviews];
    if (subViews.count) {
        rootView = [subViews objectAtIndex:0];
    } else {
        rootView = topWindow;
    }
    
    id nextResponder = [rootView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        result = nextResponder;
    } else if ([topWindow respondsToSelector:@selector(rootViewController)] && topWindow.rootViewController != nil) {
        result = topWindow.rootViewController;
    } else {
        NSAssert(NO, @"ShareKit: Could not find a root view controller.  You can assign one manually by calling [[SHK currentHelper] setRootViewController:YOURROOTVIEWCONTROLLER].");
    }
    return result;
}

+ (MBProgressHUD*)showProgressWithTip:(NSString *)tip{
    UIViewController* vc = [CNUIHelper getCurrentRootViewController];
    UIView* parent = vc.view;
    if (!parent) {
        return nil;
    }
    
    return [CNUIHelper showProgressToView:parent withTip:tip];
}
+ (MBProgressHUD*)showProgressToView:(UIView*)parent withTip:(NSString*)tip {
    MBProgressHUD* hud = [[MBProgressHUD alloc] initWithView:parent];
    hud.minSize = CGSizeMake(160, 80);
    [parent addSubview:hud];
    hud.customView = [CNUIHelper createLoadingAnimation];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = tip;
    [hud show:YES];
    
    return hud;
}


+ (MBProgressHUD*)showSimpleProgress {
    UIViewController* vc = [CNUIHelper getCurrentRootViewController];
    UIView* parent = vc.view;
    if (!parent) {
        return nil;
    }
    
    return [CNUIHelper showSimpleProgressToView:parent];
}

+ (MBProgressHUD*)showSimpleProgressToView:(UIView*)parent {
    MBProgressHUD* hud = [[MBProgressHUD alloc] initWithView:parent];
    hud.minSize = CGSizeMake(160, 80);
    [parent addSubview:hud];
    hud.color = [UIColor clearColor];
    [hud show:YES];
    
    return hud;
}





+ (UIView*)createLoadingAnimation {
    
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    
    // 1.加载所有的动画图片
    NSMutableArray *images = [NSMutableArray array];
    
    for (int i = 0; i< 4; i++) {
//        NSString *filename = [NSString stringWithFormat:@"icon_loading_%d", i];
        UIImage *image = [UIImage imageWithCIImage:[CIImage imageWithColor:[CIColor colorWithRed:0 green:0 blue:0 alpha:0.5]]];
        [images addObject:image];
    }
    imgv.animationImages = images;
    
    // 2.设置播放次数
    imgv.animationRepeatCount = 0;
    
    // 3.设置播放时间
    imgv.animationDuration = 1;
    
    [imgv startAnimating];
    
    return imgv;
}


+ (void )setLabelSpacing:(UILabel*) cLabel lfSpacing:(CGFloat ) lfSpacing strContent:(NSString*)strContent {
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:strContent];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:lfSpacing];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [strContent length])];
    [cLabel setAttributedText:attributedString1];
    [cLabel sizeToFit];
}

+ (NSInteger)getDaysOfMonth:(NSInteger)year month:(NSInteger)month {
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:@[ @(31), @(28), @(31),@(30),@(31), @(30), @(31), @(31), @(30), @(31), @(30), @(31) ]];
    
    NSInteger days = 0;
    if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0)
    {
        arr[1] = @(29); // 闰年2月29天
    }
    
    days = [arr[month - 1] integerValue];
    
    return days;
}

+ (void)pushToVcWithIndex:(NSInteger)index owner:(UIViewController *)owner {
  
    
    UINavigationController *currentnav  = owner.tabBarController.selectedViewController;
    UIViewController *currentvc = currentnav.viewControllers.lastObject;

    dispatch_async(dispatch_get_main_queue(), ^{
        owner.tabBarController.selectedIndex = index;
        if (owner.navigationController.viewControllers.count > 1) {
            [currentvc.navigationController popToRootViewControllerAnimated:YES];
        }
    });
}

+ (void)setControlUI:(id)control BorderWidth:(CGFloat )Width CornerRadius:(CGFloat )Radius BorderColor:(UIColor *)color; {
    CALayer *layer=[control layer];
    //是否设置边框以及是否可见
    [layer setMasksToBounds:YES];
    //设置边框圆角的弧度
    [layer setCornerRadius:Radius];
    //设置边框线的宽
    //
    [layer setBorderWidth:Width];
    //设置边框线的颜色
    [layer setBorderColor:[color CGColor]];
}

+ (BOOL)simpleVerifyIdentityCardNum:(NSString *)idCard {
    NSString *regex2 = @"^(\\\\\\\\d{14}|\\\\\\\\d{17})(\\\\\\\\d|[xX])$";
    
    return [self isValidateByRegex:regex2 content:idCard];
}

+ (BOOL)isValidateByRegex:(NSString *)regex content:(NSString *)content{
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    return [pre evaluateWithObject:self];
    
}

+ (BOOL)ispostcodeWith:(NSString *)code {
    NSString *postalRegex = @"^[0-8]\\d{5}(?!\\d)$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",postalRegex];
    
    return [numberPre evaluateWithObject:code];
}

+ (NSString *)stringMD5:(NSString *)input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

+ (NSString *)timeInterval:(long long)timestamp {
    
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp/1000];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
//    NSDate *date = [formatter dateFromString:[NSString stringWithFormat:@"%lld",timestamp]];
    NSLog(@"时间 = %@",[formatter stringFromDate:confromTimesp]);
    return [formatter stringFromDate:confromTimesp];
    
    
}

@end
