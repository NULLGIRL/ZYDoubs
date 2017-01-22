//
//  ZYMessageHistoryEntry.m
//  ZYDoubs
//
//  Created by Momo on 17/1/22.
//  Copyright © 2017年 Momo. All rights reserved.
//

#import "ZYMessageHistoryEntry.h"

@implementation ZYMessageHistoryEntry

@synthesize eventId;
@synthesize remoteParty;
@synthesize content;
@synthesize date;
@synthesize start;

-(NSComparisonResult)compareEntryByDate:(ZYMessageHistoryEntry *)otherEntry{
    NSTimeInterval diff = self->start - otherEntry->start;
    return diff==0 ? NSOrderedSame : (diff > 0 ?  NSOrderedAscending : NSOrderedDescending);
}


-(ZYMessageHistoryEntry*)initWithEvent: (NgnHistorySMSEvent*)event{
    if((self = [super init])){
        self->eventId = event.id;
        self.remoteParty = event.remoteParty;
        self->start = event.start;
        self.date = [NSDate dateWithTimeIntervalSince1970: self.start];
        self.content = event.contentAsString;
    }
    return self;
}
@end
