//
//  ZYMessageTableViewCell.h
//  ZYDoubs
//
//  Created by Momo on 17/1/22.
//  Copyright © 2017年 Momo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZYMessageHistoryEntry.h"


@interface ZYMessageTableViewCell : UITableViewCell

@property (nonatomic,strong) ZYMessageHistoryEntry *entry;

-(instancetype)initWithTableview:(UITableView *)tableview;
+(instancetype)cellWithTableview:(UITableView *)tableview;

- (void) setImageIcon:(NSString *)imageName;
@end
