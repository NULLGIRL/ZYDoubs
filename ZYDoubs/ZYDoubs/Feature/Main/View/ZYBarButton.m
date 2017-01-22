//
//  ZYBarButton.m
//  ZYDoubs
//
//  Created by Momo on 17/1/10.
//  Copyright © 2017年 Momo. All rights reserved.
//

#import "ZYBarButton.h"

@implementation ZYBarButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.imageView.contentMode = UIViewContentModeCenter;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setTitleColor:[ZYTools colorFromHexRGB:@"#909090"] forState:UIControlStateNormal];
        [self setTitleColor:mainTextColor forState:UIControlStateSelected];
        self.titleLabel.font = [UIFont systemFontOfSize:10];
        
        [self setBackgroundImage:[UIImage imageNamed:@"Tab-bj"] forState:UIControlStateNormal];
    }
    
    return self;
}

- (void)setHighlighted:(BOOL)highlighted
{}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = 0;
    CGFloat titleY = contentRect.size.height * 0.7;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = contentRect.size.height - titleY;
    
    return CGRectMake(titleX, titleY, titleW, titleH);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = contentRect.size.width;
    CGFloat imageH = contentRect.size.height * 0.7;
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    
    return CGRectMake(imageX, imageY, imageW, imageH);
}



@end
