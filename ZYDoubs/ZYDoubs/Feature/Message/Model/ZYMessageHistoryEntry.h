//
//  ZYMessageHistoryEntry.h
//  ZYDoubs
//
//  Created by Momo on 17/1/22.
//  Copyright © 2017年 Momo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "model/NgnHistorySMSEvent.h"
@interface ZYMessageHistoryEntry : NSObject
{
    long long eventId;
    NSString* remoteParty;
    NSString* content;
    NSDate* date;
    NSTimeInterval start;
}

@property(nonatomic,readonly) long long eventId;
@property(nonatomic,retain) NSString *remoteParty;
@property(nonatomic,retain) NSString *content;
@property(nonatomic,retain) NSDate *date;
@property(nonatomic,assign) NSTimeInterval start;

-(ZYMessageHistoryEntry*)initWithEvent: (NgnHistorySMSEvent*)event;

@end
