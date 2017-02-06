//
//  ZYContactTableViewCell.m
//  ZYDoubs
//
//  Created by Momo on 17/2/6.
//  Copyright © 2017年 Momo. All rights reserved.
//

#import "ZYContactTableViewCell.h"

#undef kContactViewCellIdentifier
#define kContactViewCellIdentifier	@"ZYContactViewCellIdentifier"

#define kContactViewCellHeight 48.f

@interface ZYContactTableViewCell ()

@property (nonatomic,strong) ZYLabel *label_DisplayName;

@end

@implementation ZYContactTableViewCell

+(instancetype)cellWithTableview:(UITableView *)tableview{
    
    return [[self alloc]initWithTableview:tableview];
}

-(instancetype)initWithTableview:(UITableView *)tableview{
    
    static NSString * identify = @"ZYContactTableViewCell";
    ZYContactTableViewCell * cell = [tableview dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[ZYContactTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        
    }
    
    return cell;
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self.contentView addSubview:self.label_DisplayName];
    }
    
    return self;
}

- (void)setDisplayName:(NSString *)displayName{
    self.label_DisplayName.text = displayName;
}

- (ZYLabel *)label_DisplayName{
    if (!_label_DisplayName) {
        _label_DisplayName = [[ZYLabel alloc]initWithText:@"" font:LargeFont color:mainTextColor];
        
    }
    return _label_DisplayName;
}


@end
