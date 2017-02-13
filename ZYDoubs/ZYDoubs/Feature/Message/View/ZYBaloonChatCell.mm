//
//  BaloonChatCell.m
//  idoubs
//
//  Created by Momo on 16/7/12.
//  Copyright © 2016年 Doubango Telecom. All rights reserved.
//

#import "ZYBaloonChatCell.h"

@interface ZYBaloonChatCell()

@property (nonatomic,strong) UIButton * iconBtn; // 头像
@property (retain, nonatomic) UILabel *labelContent; //内容
@property (retain, nonatomic) UILabel *labelDate; //时间
@property (nonatomic,strong)  UIImageView * bgImageView;

@property (nonatomic,strong) NSString * myName;

@end

@implementation ZYBaloonChatCell

+(instancetype)cellWithTableview:(UITableView *)tableview{
    
    return [[self alloc]initWithTableview:tableview];
}

-(instancetype)initWithTableview:(UITableView *)tableview{
    
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    static NSString * identify = @"ZYBaloonChatCell";
    ZYBaloonChatCell * cell = [tableview dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[ZYBaloonChatCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        self.labelContent.numberOfLines = 0;
    }
    
    return cell;
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = WHITECOLOR;
        
        ZYUserManager * user = [ZYUserManager fileUserManager];
        self.myName = [ZYTools subStringFromString:user.username isFrom:NO];
        [self createSubviews];
    }
    
    return self;
}

-(void)createSubviews{

    self.iconBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
    self.iconBtn.layer.cornerRadius = 20;
    self.iconBtn.backgroundColor = MainColor;
    self.iconBtn.titleLabel.font = LargeFont;
    [self.contentView addSubview:self.iconBtn];
    
    self.bgImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:self.bgImageView];
    
    self.labelContent = [[UILabel alloc]init];
    self.labelContent.font = MiddleFont;
    self.labelContent.numberOfLines = 0;
    self.labelContent.textColor = mainTextColor;
    [self.contentView addSubview:self.labelContent];
    
    
    self.labelDate = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    self.labelDate.font = SmallFont;
    self.labelDate.textAlignment = NSTextAlignmentCenter;
    self.labelDate.textColor = mainTextColor;
    [self.contentView addSubview:self.labelDate];
    

}

-(void)setEvent:(NgnHistorySMSEvent*)event forTableView:(UITableView*)tableView withOtherName:(NSString *)otherName{
    if(event){
        
        NSString* content = event.contentAsString ? event.contentAsString : @"";
        CGSize constraintSize = [ZYTools sizeWithText:content font:MiddleFont maxSize:CGSizeMake(ScreenWidth - 120, 2500)];
        self.labelContent.text = content;
        SYLog(@" 信息内容   ======   %@",content);
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:event.start];
        NSDateFormatter *datef =[[NSDateFormatter alloc] init];
        
        [datef setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString * dateS = [datef stringFromDate:date];
        self.labelDate.text = dateS;
        
        switch (event.status) {
            case HistoryEventStatus_Outgoing:
            case HistoryEventStatus_Failed:
            case HistoryEventStatus_Missed:
            {
                self.labelContent.frame = CGRectMake(ScreenWidth - 15 - constraintSize.width,
                                                     20,
                                                     constraintSize.width,
                                                     constraintSize.height < 40 ? 40:constraintSize.height);
                self.labelContent.backgroundColor = [UIColor greenColor];
                self.iconBtn.hidden = YES;
                
                self.bgImageView.frame = CGRectMake(self.labelContent.frame.origin.x - 10, 18, self.labelContent.frame.size.width + 30, constraintSize.height < 40 ?  40 : constraintSize.height + 10);
                UIImage * image = [UIImage imageNamed:@"chat_me"];
                image = [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height - 10];
                self.bgImageView.image = image;
                [self.iconBtn setTitle:self.myName forState:UIControlStateNormal];
                break;
            }
                
            case HistoryEventStatus_Incoming:
            default:
            {
                
                self.iconBtn.hidden = NO;
                self.labelContent.frame = CGRectMake(65,
                                                     20,
                                                     constraintSize.width,
                                                     constraintSize.height <40? 40:constraintSize.height);
                self.labelContent.textAlignment = NSTextAlignmentLeft;
                self.iconBtn.frame =CGRectMake(10, 20, 40, 40);
                
                self.labelContent.backgroundColor = LINE_COLOR;

                
                UIImage * image = [UIImage imageNamed:@"chat_other"];
                image = [image stretchableImageWithLeftCapWidth:40 topCapHeight:image.size.height - 10];
                self.bgImageView.frame = CGRectMake(50, 19, self.labelContent.frame.size.width + 20, constraintSize.height < 40 ?40 : constraintSize.height + 10);
                self.bgImageView.image = image;
                
                [self.iconBtn setTitle:[ZYTools subStringFromString:otherName isFrom:NO] forState:UIControlStateNormal];
                break;
            }
        }
        
        
    }
}



@end
