//
//  ZYUtilsMacros.h
//  ZYDoubs
//
//  Created by Momo on 17/1/17.
//  Copyright © 2017年 Momo. All rights reserved.
//

#ifndef ZYUtilsMacros_h
#define ZYUtilsMacros_h


#define WEAKSELF __typeof__(self) __weak weakSelf = self;
#define STRONGSELF __typeof__(weakSelf) __strong strongSelf = weakSelf;


// ************************ 屏幕宽高 *****************************
/**
 *  屏幕宽度
 */
#define ScreenWidth [[UIScreen mainScreen]bounds].size.width
/**
 *  屏幕高度
 */
#define ScreenHeight [[UIScreen mainScreen]bounds].size.height

// ************************ 字号 *****************************
/**
 *  小号字体
 */
#define SmallFont [UIFont systemFontOfSize:11]
/**
 *  中号字体
 */
#define MiddleFont [UIFont systemFontOfSize:14]
/**
 *  正常字体
 */
#define LargeFont [UIFont systemFontOfSize:16]


// ************************ 颜色 *****************************
#define WHITECOLOR      [UIColor whiteColor]
#define REDCOLOR        [UIColor redColor]
#define GREENCOLOR      [UIColor greenColor]
/**
 *  主色调颜色
 */
#define MainColor       [ZYTools colorFromHexRGB:@"f7f7f7"]
/**
 *  提醒色 图标背景
 */
#define TImageColor     [ZYTools colorFromHexRGB:@"ffaf05"]
/**
 *  提醒色 文字
 */
#define ITextColor      [ZYTools colorFromHexRGB:@"ec5f05"]
/**
 *  正常文字
 */
#define mainTextColor   [ZYTools colorFromHexRGB:@"323232"]
/**
 *  线 描述性非重要文字
 */
#define LINE_COLOR       [ZYTools colorFromHexRGB:@"d1d1d1"]
/**
 *  背景色
 */
#define BGColor         [ZYTools colorFromHexRGB:@"ebebeb"]
/**
 *  辅助性背景色
 */
#define sBGColor        [ZYTools colorFromHexRGB:@"fafafa"]
/**
 *  rgb
 */
#define MYColor(r,g,b)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]


// ************************ 打印 *****************************
/**
 *  日志输出
 */
#define SYFunc SYLog(@"%s",__func__);

#ifdef DEBUG // 调试

#define SYLog(...) NSLog(__VA_ARGS__);

#else // 发布

#define SYLog(...)

#endif

// ************************ 设备系统 *****************************
/**
 *  设备系统版本相关
 */
#define SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define iOSVersion [[[UIDevice currentDevice] systemVersion] doubleValue]
#define iPhone4s ([UIScreen mainScreen].bounds.size.height == 480 ? YES : NO)
#define iPhone5s ([UIScreen mainScreen].bounds.size.height == 568 ? YES : NO)
#define iPhone6s ([UIScreen mainScreen].bounds.size.height == 667 ? YES : NO)
#define iPhone6plus ([UIScreen mainScreen].bounds.size.height == 736 ? YES : NO)


#endif /* ZYUtilsMacros_h */
