//
//  ZYMessageTableViewCell.m
//  ZYDoubs
//
//  Created by Momo on 17/1/22.
//  Copyright © 2017年 Momo. All rights reserved.
//

#import "ZYMessageTableViewCell.h"

@interface ZYMessageTableViewCell ()

@property (nonatomic,strong) UIButton * photoBtn;
@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) UILabel * timeLabel;
@property (nonatomic,strong) UILabel * desLabel;
@property (nonatomic,strong) UILabel * statusLabel;


@end

@implementation ZYMessageTableViewCell
+(instancetype)cellWithTableview:(UITableView *)tableview{
    
    return [[self alloc]initWithTableview:tableview];
}

-(instancetype)initWithTableview:(UITableView *)tableview{
    
    static NSString * identify = @"MyMessageCell";
    ZYMessageTableViewCell * cell = [tableview dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[ZYMessageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        
    }
    
    return cell;
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubviews];
    }
    
    return self;
}

-(void)createSubviews{
    
    self.photoBtn = [[UIButton alloc]init];
    self.photoBtn.backgroundColor = MainColor;
    self.photoBtn.layer.cornerRadius = 20;
    self.photoBtn.titleLabel.font = LargeFont;
    [self.photoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.contentView addSubview:self.photoBtn];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = LargeFont;
    self.titleLabel.textColor = mainTextColor;
    [self.contentView addSubview:self.titleLabel];
    
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.textColor = LINE_COLOR;
    self.timeLabel.font = SmallFont;
    [self.contentView addSubview:self.timeLabel];
    
    self.desLabel = [[UILabel alloc]init];
    self.desLabel.textColor = mainTextColor;
    self.desLabel.font = MiddleFont;
    [self.contentView addSubview:self.desLabel];
    
    self.statusLabel = [[UILabel alloc]init];
    self.statusLabel.textColor = ITextColor;
    self.statusLabel.font = SmallFont;
    [self.contentView addSubview:self.statusLabel];
    
    
    [self.photoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(15);
        make.top.equalTo(self.contentView).with.offset(15);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
    
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.photoBtn.mas_right).with.offset(15);
        make.right.equalTo(self.contentView).with.offset(-15);
        make.top.equalTo(self.contentView).with.offset(10);
        make.height.equalTo(@20);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.height.equalTo(@10);
    }];
    
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.right.equalTo(self.titleLabel);
        make.top.equalTo(self.timeLabel.mas_bottom).with.offset(2);
        make.bottom.equalTo(self.contentView);
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.photoBtn).with.offset(7);
        make.top.equalTo(self.photoBtn).with.offset(-7);
        make.height.equalTo(@15);
    }];
    
}

-(void)setEntry:(ZYMessageHistoryEntry*)entry{
    _entry = entry;
    if(entry){
        // remote party
        //        NgnContact* contact = [[NgnEngine sharedInstance].contactService getContactByPhoneNumber:self.entry.remoteParty];
        //        self.titleLabel.text = (contact && contact.displayName) ? contact.displayName :
        //        (self.entry.remoteParty ? self.entry.remoteParty : @"Unknown");
        
        
        
        if (![ZYTools isNullOrEmpty:entry.remoteParty]) {
            self.titleLabel.text = entry.remoteParty;
            NSString * btnName = [ZYTools subStringFromString:entry.remoteParty isFrom:NO];
            [self.photoBtn setTitle:btnName forState:UIControlStateNormal];
        }
        
        
        // content
        self.desLabel.text =  self.entry.content ? self.entry.content : @"";
        //        SYLog(@"content === %@",self.entry.content);
        
        // date
        self.timeLabel.text = [[NgnDateTimeUtils historyEventDate] stringFromDate:self.entry.date];
        //        SYLog(@"date === %@",self.entry.date);
        
    }
}


@end
