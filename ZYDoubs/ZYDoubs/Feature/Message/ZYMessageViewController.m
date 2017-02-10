//
//  ZYMessageViewController.m
//  ZYDoubs
//
//  Created by Momo on 17/1/10.
//  Copyright © 2017年 Momo. All rights reserved.
//

#import "ZYMessageViewController.h"
#import "ZYMessageHistoryEntry.h"
#import "ZYMessageTableViewCell.h"


@interface ZYMessageViewController (Private)
-(void) refreshData;
-(void) refreshDataAndReload;
-(void) onHistoryEvent:(NSNotification*)notification;
@end

@implementation ZYMessageViewController(Private)
-(void) refreshData{
    @synchronized(self->messages){
        NSMutableDictionary* entries = [[NSMutableDictionary alloc] init];
        NSArray* events = [[[NgnEngine sharedInstance].historyService events] allValues];
        
        for (NgnHistoryEvent *event in events) {
            if(!event || !(event.mediaType & MediaType_SMS)){
                continue;
            }
            
            ZYMessageHistoryEntry* entry = [entries objectForKey:event.remoteParty];
            if(entry == nil || ((entry.start - event.start) < 0)){
                ZYMessageHistoryEntry* newEntry = [[ZYMessageHistoryEntry alloc] initWithEvent:(NgnHistorySMSEvent*)event];
                [entries setObject:newEntry forKey:newEntry.remoteParty];
                
            }
        }
        
        //        SYLog(@"messages  ====  %@",messages);
        
        NSArray* sortedEntries = [[entries allValues] sortedArrayUsingSelector:@selector(compareEntryByDate:)];
        [self->messages removeAllObjects];
        [self->messages addObjectsFromArray:sortedEntries];
        
        
    }
}

-(void) refreshDataAndReload{
    [self refreshData];
    [self.tableView reloadData];
}

-(void) onHistoryEvent:(NSNotification*)notification{
    NgnHistoryEventArgs* eargs = [notification object];
    
    switch (eargs.eventType) {
        case HISTORY_EVENT_ITEM_ADDED:
        {
            if((eargs.mediaType & MediaType_SMS)){
                
                //FIXME
                [self refreshDataAndReload];
            }
            break;
        }
            
        case HISTORY_EVENT_ITEM_MOVED:
        case HISTORY_EVENT_ITEM_UPDATED:
        {
            [self.tableView reloadData];
            break;
        }
            
        case HISTORY_EVENT_ITEM_REMOVED:
        {
            if((eargs.mediaType & MediaType_SMS)){
                //FIXME
                [self refreshDataAndReload];
                
            }
            break;
        }
            
        case HISTORY_EVENT_RESET:
            [[NgnEngine sharedInstance].historyService deleteEventWithId:eargs.eventId];
        default:
        {
            [self refreshDataAndReload];
            break;
        }
    }
}

//== PagerMode IM (MESSAGE) events == //
-(void) onMessagingEvent:(NSNotification*)notification {
    NgnMessagingEventArgs* eargs = [notification object];
    
    switch (eargs.eventType) {
        case MESSAGING_EVENT_CONNECTING:
        case MESSAGING_EVENT_CONNECTED:
        case MESSAGING_EVENT_TERMINATING:
        case MESSAGING_EVENT_TERMINATED:
        case MESSAGING_EVENT_FAILURE:
        case MESSAGING_EVENT_SUCCESS:
        case MESSAGING_EVENT_OUTGOING:
        default:
        {
            break;
        }
            
        case MESSAGING_EVENT_INCOMING:
        {
            if(eargs.payload){
                // The payload is a NSData object which means that it could contain binary data
                // here I consider that it's utf8 text message
                
                [self refreshDataAndReload];
                
                
            }
            break;
        }
    }
    
    
    
    //    labelDebugInfo.text = [NSString stringWithFormat: @"onMessagingEvent: %@", eargs.sipPhrase];
}

@end


@interface ZYMessageViewController ()
@property(nonatomic,retain) NgnContact *pickedContact;
@property(nonatomic,retain) NgnPhoneNumber *pickedNumber;
@property(nonatomic,readonly) NSMutableArray *messages;
@end

@implementation ZYMessageViewController

@synthesize pickedContact;
@synthesize pickedNumber;
@synthesize messages;



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setBlackTitle:@"我的消息" smallTitle:@"Message" withVC:self.tabBarController];
    [self createRightBarButtonItemWithImage:@"Plus" WithTitle:@"" withMethod:@selector(PlusBtnClick) withVC:self.tabBarController];
}

-(void)PlusBtnClick{
    NSLog(@"添加会话");
    if ([self checkNetWork] && [ZYSipTools sipIsRegister]) {
        
        if(![ZYTools isNullOrEmpty:@"测试点击"]){
            NgnHistorySMSEvent* event = [NgnHistoryEvent createSMSEventWithStatus:HistoryEventStatus_Outgoing
                                                                   andRemoteParty:@"2000001850"
                                                                       andContent:[@"测试点击" dataUsingEncoding:NSUTF8StringEncoding]];
            NgnMessagingSession* session = [NgnMessagingSession createOutgoingSessionWithStack:[[NgnEngine sharedInstance].sipService getSipStack] andToUri:@"2000001850"];
            event.status = [session sendTextMessage:@"测试点击" contentType: kContentTypePlainText] ? HistoryEventStatus_Outgoing : HistoryEventStatus_Failed;
            BOOL ret = [[NgnEngine sharedInstance].historyService addEvent: event];
            NSLog(@"%@",ret?@"YES":@"NO");
            NgnHistoryEventDictionary* dic = [[NgnEngine sharedInstance].historyService events];
            NSLog(@"%@",dic);
        }
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [[NgnEngine sharedInstance].historyService load];
    
    if(!self.messages){
        self->messages = [[NSMutableArray alloc] init];
    }
    // refresh data set datasource
    [self refreshData];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(onHistoryEvent:) name:kNgnHistoryEventArgs_Name object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(onMessagingEvent:) name:kNgnMessagingEventArgs_Name object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(pushChatVC:) name:@"pushChatVC" object:nil];
    
    

}

-(void)pushChatVC:(NSNotification *)noti{
    NSString * remoteParty = [noti object];
    
//    MyNewsChatViewController * myChatDetailVC = [[MyNewsChatViewController alloc]initWithRemoteParty:remoteParty withContactName:name];
//    [self.navigationController pushViewController:myChatDetailVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [messages count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZYMessageTableViewCell *cell = [ZYMessageTableViewCell cellWithTableview:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ZYMessageHistoryEntry* entry = [messages objectAtIndex: indexPath.row];
    if (entry) {
        cell.entry = [messages objectAtIndex: indexPath.row];
        
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZYMessageTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.entry) {
//               [[NgnEngine sharedInstance].historyService load];
        NSString * strSip = [NSString stringWithFormat:@"%@",cell.entry.remoteParty];
        
        [[Routable sharedRouter] open:ZYCHAT_VIEWCONTROLLER animated:YES extraParams:@{@"strSip":strSip,@"name":@"测试"}];
    }
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
