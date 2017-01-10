//
//  ZYLog.h
//  ZYDoubs
//
//  Created by Momo on 17/1/10.
//  Copyright © 2017年 Momo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYLog : NSObject

/**
 打印log方法示例：
 
 DDLogError(@"[Error]:%@", @"输出错误信息");//输出错误信息
 DDLogWarn(@"[Warn]:%@", @"输出警告信息");//输出警告信息
 DDLogInfo(@"[Info]:%@", @"输出描述信息");//输出描述信息
 DDLogDebug(@"[Debug]:%@", @"输出调试信息");//输出调试信息
 DDLogVerbose(@"[Verbose]:%@", @"输出详细信息");//输出详细信息
 
 DLog(@"User selected file:%@ withSize:%d", @"filePath", 123);
 */

/**
 *  CocoaLumberjack日志输出初始化
 */
+ (void)setupLog;

@end
