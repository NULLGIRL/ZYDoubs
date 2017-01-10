//
//  ZYTools.h
//  ZYDoubs
//
//  Created by Momo on 17/1/10.
//  Copyright © 2017年 Momo. All rights reserved.
//

#import <Foundation/Foundation.h>
//需要用到UIKit框架里的文件
#import <UIKit/UIKit.h>

//针对判断是否有网络需要的头文件
#import <CommonCrypto/CommonHMAC.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netdb.h>
#import <arpa/inet.h>

@interface ZYTools : NSObject

/**
 判断当前是否可以连接到网络
 */
+ (BOOL) connectedToNetwork;


/**
 判断字符串是否为空
 */
+ (BOOL) isNullOrEmpty:(id)string;


/**
 16进制颜色转换
 */
+ (UIColor *) colorFromHexRGB:(NSString *)inColorString;


@end
