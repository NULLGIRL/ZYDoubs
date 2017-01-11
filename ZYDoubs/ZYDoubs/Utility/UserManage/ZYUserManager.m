//
//  ZYUserManager.m
//  ZYDoubs
//
//  Created by Momo on 17/1/11.
//  Copyright © 2017年 Momo. All rights reserved.
//

#import "ZYUserManager.h"
#define saveFilePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]  stringByAppendingPathComponent:@"userManager.data"]

@implementation ZYUserManager


+(ZYUserManager *)manager {
    static ZYUserManager * _manager;
    if (_manager == nil) {
        _manager = [[ZYUserManager alloc]init];
    }
    return _manager;
}
/**
 取出归档单例
 */
+ (ZYUserManager *)fileUserManager{
    return (ZYUserManager *)[NSKeyedUnarchiver unarchiveObjectWithFile:saveFilePath];
}

+(void) cancelManage{
    
    
    [ZYUserManager manager].username = nil;
    [ZYUserManager manager].user_sip = nil;
    [ZYUserManager manager].user_password = nil;
    [ZYUserManager manager].sip_host_addr = nil;
    [ZYUserManager manager].sip_host_port = nil;
    [ZYUserManager manager].registrationTimeout = nil;
    [ZYUserManager manager].transport = nil;
    
}



+ (instancetype)userManagerWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}



- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        
        if (![ZYTools isNullOrEmpty:dict[@"username"]]) {
            self.username = dict[@"username"];
        }
        else{
            self.username = @"";
        }

    
        if (![ZYTools isNullOrEmpty:dict[@"user_sip"]]) {
            self.user_sip = dict[@"user_sip"];
        }
        else{
            self.user_sip = @"";
        }
        
        if (![ZYTools isNullOrEmpty:dict[@"user_password"]]) {
            self.user_password = dict[@"user_password"];
        }
        else{
            self.user_password = @"";
        }
        
        if (![ZYTools isNullOrEmpty:dict[@"sip_host_addr"]]) {
            self.sip_host_addr = dict[@"sip_host_addr"];
        }
        else{
            self.sip_host_addr = @"";
        }
        
        if (![ZYTools isNullOrEmpty:dict[@"sip_host_port"]]) {
            self.sip_host_port = dict[@"sip_host_port"];
        }
        else{
            self.sip_host_port = @"";
        }
        
        if (![ZYTools isNullOrEmpty:dict[@"registrationTimeout"]]) {
            self.registrationTimeout = dict[@"registrationTimeout"];
        }
        else{
            self.registrationTimeout = @"";
        }
        
        if (![ZYTools isNullOrEmpty:dict[@"transport"]]) {
            self.transport = dict[@"transport"];
        }
        else{
            self.transport = @"";
        }
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{

    [encoder encodeObject:self.username forKey:@"username"];
    [encoder encodeObject:self.user_sip forKey:@"user_sip"];
    [encoder encodeObject:self.user_password forKey:@"user_password"];
    
    [encoder encodeObject:self.sip_host_addr forKey:@"sip_host_addr"];
    [encoder encodeObject:self.sip_host_port forKey:@"sip_host_port"];
    [encoder encodeObject:self.registrationTimeout forKey:@"registrationTimeout"];
    [encoder encodeObject:self.transport forKey:@"transport"];
    
}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {

        self.username = [decoder decodeObjectForKey:@"username"];
        self.user_sip = [decoder decodeObjectForKey:@"user_sip"];
        self.user_password = [decoder decodeObjectForKey:@"user_password"];
        
        self.sip_host_addr = [decoder decodeObjectForKey:@"sip_host_addr"];
        self.sip_host_port = [decoder decodeObjectForKey:@"sip_host_port"];
        self.registrationTimeout = [decoder decodeObjectForKey:@"registrationTimeout"];
        self.transport = [decoder decodeObjectForKey:@"transport"];
        
    }
    
    return self;
}

+ (void)saveUserManager:(ZYUserManager *)userManager
{
    [NSKeyedArchiver archiveRootObject:userManager toFile:saveFilePath];
}


@end
