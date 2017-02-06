//
//  ZYContactTableViewCell.h
//  ZYDoubs
//
//  Created by Momo on 17/2/6.
//  Copyright © 2017年 Momo. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ZYContactTableViewCell : UITableViewCell

-(instancetype)initWithTableview:(UITableView *)tableview;
+(instancetype)cellWithTableview:(UITableView *)tableview;

- (void)setDisplayName:(NSString *)displayName;
@end
