//
//  ZYChatViewController.m
//  ZYDoubs
//
//  Created by Momo on 17/1/22.
//  Copyright © 2017年 Momo. All rights reserved.
//

#import "ZYChatViewController.h"
#import "BaloonChatCell.h"
//
//	History Data
//

@interface ZYChatViewController(Private)
-(void) scrollToBottom:(BOOL)animated;
-(void) refreshData;
-(void) reloadData;
-(void) refreshDataAndReload;
-(void) onHistoryEvent:(NSNotification*)notification;
@end

@implementation ZYChatViewController(Private)

-(void) refreshData{
    @synchronized(messages){
        [messages removeAllObjects];
        
        NSArray* events = [[[[NgnEngine sharedInstance].historyService events] allValues] sortedArrayUsingSelector:@selector(compareHistoryEventByDateDESC:)];
        SYLog(@" 事件列表   ======   %@",events);
        for (int i = 0 ; i < events.count; i ++) {
            NgnHistoryEvent* event = events[i];
            if (!event) {
                continue;
            }
            if (!(event.mediaType & MediaType_SMS)) {
                continue;
            }
            if (![event.remoteParty isEqualToString: self.remoteParty]) {
                continue;
            }
            if(!event || !(event.mediaType & MediaType_SMS) || ![event.remoteParty isEqualToString: self.remoteParty]){
                continue;
            }
            [messages addObject:event];
        }
        SYLog(@" 信息列表   ======   %@",messages);
        
    }
    
}

-(void) scrollToBottom:(BOOL)animated{
    if([messages count] >0){
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:([messages count] - 1) inSection:0]
                         atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    }
}

-(void) reloadData{
    [self.tableView reloadData];
    [self scrollToBottom:YES];
}

-(void) refreshDataAndReload{
    [self refreshData];
    [self reloadData];
}

-(void) onHistoryEvent:(NSNotification*)notification{
    NgnHistoryEventArgs* eargs = [notification object];
    
    switch (eargs.eventType) {
        case HISTORY_EVENT_ITEM_ADDED:
        {
            if((eargs.mediaType & MediaType_SMS)){
                NgnHistoryEvent* event = [[[NgnEngine sharedInstance].historyService events] objectForKey: [NSNumber numberWithLongLong: eargs.eventId]];
                NSInteger eventInt = [event.remoteParty integerValue];
                NSInteger remotInt = [self.remoteParty integerValue];
                if (event) {
                    if (eventInt == remotInt) {
                        [messages addObject: event];
                        [self reloadData];
                    }
                }
            }
            break;
        }
            
        case HISTORY_EVENT_ITEM_MOVED:
        case HISTORY_EVENT_ITEM_UPDATED:
        {
            [self reloadData];
            break;
        }
            
        case HISTORY_EVENT_ITEM_REMOVED:
        {
            if((eargs.mediaType & MediaType_SMS)){
                for (NgnHistoryEvent* event in messages) {
                    if(event.id == eargs.eventId){
                        [messages removeObject: event];
                        [self.tableView reloadData];
                        break;
                    }
                }
            }
            break;
        }
            
        case HISTORY_EVENT_RESET:{
            [[NgnEngine sharedInstance].historyService deleteEventWithId:eargs.eventId];
        }
        default:
        {
            [self refreshDataAndReload];
            break;
        }
    }
}

@end


@interface ZYChatViewController ()

@end

@implementation ZYChatViewController
@synthesize remoteParty;
@synthesize viewFooter;
@synthesize textView;

#pragma mark - 使用Routable必须实现该方法

- (id)initWithRouterParams:(NSDictionary *)params {
    if ((self = [self initWithNibName:nil bundle:nil])) {
        NSString *string = [params objectForKey:@"id"];
        NSLog(@"ZYSipSettingViewController - %@",string);
        
        messages = [[NSMutableArray alloc] init];
        self.remoteParty = params[@"strSip"];
        self.contact = [[NgnEngine sharedInstance].contactService getContactByPhoneNumber: self.remoteParty];
        self.remotePartyUri = [NgnUriUtils makeValidSipUri:self.remoteParty];
        self.myNewsTitle = params[@"name"];

    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createLeftBarButtonItemWithTitle:self.myNewsTitle withVC:self];
    [self createRightBarButtonItemWithImage:nil WithTitle:@"发送" withMethod:@selector(sendMessageBtnClick) withVC:self];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [self refreshDataAndReload];
    
    
    [[NSNotificationCenter defaultCenter]	addObserver:self
                                             selector:@selector(onHistoryEvent:)
                                                 name:kNgnHistoryEventArgs_Name
                                               object:nil];
    
    //注册键盘监听事件
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardUP:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDown:) name:UIKeyboardWillHideNotification object:nil];
    
}
#pragma mark - 键盘上升
-(void)keyboardUP:(NSNotification *)noti{
    SYLog(@"键盘上升");
    
    //获取键盘的高度
    NSDictionary *userInfo = [noti userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;


}
#pragma mark - 键盘下降
-(void)keyboardDown:(NSNotification *)noti{
    SYLog(@"键盘下降");

}



- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [messages removeAllObjects];
}

- (void)sendMessageBtnClick{
    
    if ([self checkNetWork] && [self cheakSip]) {
        
//        if(![ZYTools isNullOrEmpty:text]){
//            NgnHistorySMSEvent* event = [NgnHistoryEvent createSMSEventWithStatus:HistoryEventStatus_Outgoing
//                                                                   andRemoteParty: self.remoteParty
//                                                                       andContent:[text dataUsingEncoding:NSUTF8StringEncoding]];
//            NgnMessagingSession* session = [NgnMessagingSession createOutgoingSessionWithStack:[[NgnEngine sharedInstance].sipService getSipStack] andToUri: self.remotePartyUri];
//            event.status = [session sendTextMessage:text contentType: kContentTypePlainText] ? HistoryEventStatus_Outgoing : HistoryEventStatus_Failed;
//            [[NgnEngine sharedInstance].historyService addEvent: event];
//            
//        }
        
    }
}

-(void)setRemoteParty:(NSString *) myRemoteParty{
    
    remoteParty = myRemoteParty;
    self.contact = [[NgnEngine sharedInstance].contactService getContactByPhoneNumber: remoteParty];
    self.remotePartyUri = [NgnUriUtils makeValidSipUri:self.remoteParty];
}

-(void)setRemoteParty:(NSString *)remoteParty_ andContact:(NgnContact*)contact_{
    
    self->remoteParty = remoteParty_ ;
    self.contact = contact_;
    self.remotePartyUri = [NgnUriUtils makeValidSipUri:self.remoteParty];
}

-(NSString*)remoteParty{
    return self->remoteParty;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    @synchronized(messages){
        return [messages count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BaloonChatCell *cell = [BaloonChatCell cellWithTableview:self.tableView];
    
    @synchronized(messages){
        [cell setEvent:[messages objectAtIndex: indexPath.row] forTableView:_tableView withOtherName:self.myNewsTitle];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;{
    @synchronized(messages){
        NgnHistorySMSEvent * event = [messages objectAtIndex: indexPath.row];
        if(event){
            NSString* content = event.contentAsString ? event.contentAsString : @"";
            CGSize constraintSize = [ZYTools sizeWithText:content font:MiddleFont maxSize:CGSizeMake(ScreenWidth - 120, 2500)];
            if (constraintSize.height < 30) {
                return 60;
            }
            else{
                return 40 + constraintSize.height;
            }
        }
        return 0.0;
    }
}

- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete){
        NgnHistoryEvent* event = [messages objectAtIndex: indexPath.row];
        if (event) {
            [[NgnEngine sharedInstance].historyService deleteEvent: event];
        }
    }
}


-(BOOL)cheakSip{
    
    if ([[NgnEngine sharedInstance].sipService isRegistered]){
        
        return YES;
    }
    else{
        [self.view endEditing:YES];
        
        [self createAlertWithMessage:@"网络不好，请稍后尝试！"];
        
//        [WJYAlertView showTwoButtonsWithTitle:@"提示" Message:@"网络不好，请稍后尝试！" ButtonType:WJYAlertViewButtonTypeNone ButtonTitle:@"确定" Click:^{
//            
//            [PMSipTools sipRegister];
//            
//        } ButtonType:WJYAlertViewButtonTypeNone ButtonTitle:@"取消" Click:^{
//            
//        }];
        
        
        
        return NO;
    }
    
    
}

@end
