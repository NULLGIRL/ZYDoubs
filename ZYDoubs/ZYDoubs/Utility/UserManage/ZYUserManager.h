//
//  ZYUserManager.h
//  ZYDoubs
//
//  Created by Momo on 17/1/11.
//  Copyright © 2017年 Momo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYUserManager : NSObject

//用户信息（属性）
@property (nonatomic,copy) NSString * username;
@property (nonatomic,copy) NSString * user_sip;  //sip账号
@property (nonatomic,copy) NSString * user_password;  //sip密码
@property (nonatomic,copy) NSString * sip_host_addr; //地址
@property (nonatomic,copy) NSString * sip_host_port;//端口
@property (nonatomic,copy) NSString * registrationTimeout; //注册周期
@property (nonatomic,copy) NSString * transport; //协议


//创建用户管理单例
+ (ZYUserManager *)manager;



+ (instancetype)userManagerWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

/**
 注销用户单例子
 */
+(void)cancelManage;

/**
 归档
 */
+ (void)saveUserManager:(ZYUserManager *)userManager;

/**
 取出归档单例
 */
+ (ZYUserManager *)fileUserManager;
@end
