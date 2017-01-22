//
//  ZYTools.m
//  ZYDoubs
//
//  Created by Momo on 17/1/10.
//  Copyright © 2017年 Momo. All rights reserved.
//

#import "ZYTools.h"

@implementation ZYTools

//判断当前是否可以连接到网络
+ (BOOL)connectedToNetwork{
    
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags) {
        return NO;
    }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    BOOL nonWifi = flags & kSCNetworkReachabilityFlagsTransientConnection;
    BOOL moveNet = flags & kSCNetworkReachabilityFlagsIsWWAN;
    
    return ((isReachable && !needsConnection) || nonWifi || moveNet) ? YES : NO;
}

+(BOOL)isNullOrEmpty:(id)string{
    
    if ([string isKindOfClass:[NSString class]] ) {
        return string == nil || string==(id)[NSNull null] || [string isEqualToString: @""] || [string isEqualToString: @"<null>"] || [string isEqualToString: @"(null)"];
    }
    if ([string isKindOfClass:[NSArray class]]) {
        return string == nil || string==(id)[NSNull null] || ((NSArray *)string).count == 0;
    }
    if ([string isKindOfClass:[NSNumber class]]) {
        return string == nil || string==(id)[NSNull null] ;
    }
    else
        return string == nil || string==(id)[NSNull null];
}



+ (UIColor *)colorFromHexRGB:(NSString *)inColorString
{
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:1.0];
    return result;
}

+(NSString *)subStringFromString:(NSString *)str isFrom:(BOOL)isFrom{
    if ([self isNullOrEmpty:str]) {
        return @"";
    }
    else{
        NSInteger length = str.length;
        if (!isFrom) {
            //To
            if (length > 2) {
                return [str substringToIndex:2];
            }
            else{
                return str;
            }
        }
        else{
            
            if (length > 2) {
                return [str substringFromIndex:length - 2];
            }
            else{
                return str;
            }
        }
        
        
    }
}

/**
 *  计算文字尺寸
 *
 *  @param text    需要计算尺寸的文字
 *  @param font    文字的字体
 *  @param maxSize 文字的最大尺寸
 */
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    if ([ZYTools isNullOrEmpty:text]) {
        return CGSizeZero;
    }
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}


@end
