//
//  ZYChatViewController.h
//  ZYDoubs
//
//  Created by Momo on 17/1/22.
//  Copyright © 2017年 Momo. All rights reserved.
//

#import "ZYBaseTableViewController.h"

@interface ZYChatViewController : ZYBaseTableViewController<UITextViewDelegate>
{
    UITextView *textView;
    UIView *viewFooter;
    
    NSMutableArray* messages;
    NgnContact* contact;
    NSString* remoteParty;
    NSString* remotePartyUri;
}

@property (nonatomic,strong) NSString * myNewsTitle;

@property(nonatomic,retain) UITextView *textView;
@property(nonatomic,retain) UIView *viewFooter;
@property(nonatomic,retain) NSString *remoteParty;
@property(nonatomic,retain) NgnContact* contact;
@property(nonatomic,retain) NSString* remotePartyUri;

-(void)setRemoteParty:(NSString *)remoteParty andContact:(NgnContact*)contact;
@end
