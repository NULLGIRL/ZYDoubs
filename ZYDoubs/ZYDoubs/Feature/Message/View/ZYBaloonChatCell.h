//
//  BaloonChatCell.h
//  idoubs
//
//  Created by Momo on 16/7/12.
//  Copyright © 2016年 Doubango Telecom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYBaloonChatCell : UITableViewCell
{
    UILabel *_labelContent;
    UILabel *_labelDate;
}

@property(nonatomic,assign) float cellHight;

-(void)setEvent:(NgnHistorySMSEvent*)event forTableView:(UITableView*)tableView withOtherName:(NSString *)otherName;


-(instancetype)initWithTableview:(UITableView *)tableview;
+(instancetype)cellWithTableview:(UITableView *)tableview;



@end
