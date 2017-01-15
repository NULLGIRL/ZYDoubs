//
//  ZYAppDelegate+Private.h
//  ZYDoubs
//
//  Created by Momo on 17/1/10.
//  Copyright © 2017年 Momo. All rights reserved.
//

#import "ZYAppDelegate.h"

@interface ZYAppDelegate (Private)

-(void) networkAlert:(NSString*)message;
-(void) newMessageAlert:(NSString*)message;
-(BOOL) queryConfigurationAndRegister;
-(void) setAudioInterrupt: (BOOL)interrupt;


-(void)MyNetReachability;
@end
