//
//  ZYButton.m
//  ZYDoubs
//
//  Created by Momo on 17/1/11.
//  Copyright © 2017年 Momo. All rights reserved.
//

#import "ZYButton.h"

@interface ZYButton ()

/**
 
 标签
 默认设置为title
 */
@property (nonatomic,strong) NSString * reMark;

@end

@implementation ZYButton

-(instancetype)initWithTitle:(NSString *)title{
    
    if (self = [super init]) {
        
        [self title:title image:nil selectImage:nil];
        
    }
    return self;
}

-(instancetype)initWithTitle:(NSString *)title withImage:(NSString *)imageName{
    
    if (self = [super init]) {
        
        [self title:title image:imageName selectImage:nil];
    }
    return self;
}


-(instancetype)initWithTitle:(NSString *)title withImage:(NSString *)imageName selectImage:(NSString *)selectImageName{
    
    if (self = [super init]) {
        [self title:title image:imageName selectImage:selectImageName];
    }
    return self;
}


- (void)title:(NSString *)title image:(NSString *)image selectImage:(NSString *)selectImage{
    
    self.reMark = @"";
    
    if (title) {
        self.reMark = title;
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:mainTextColor forState:UIControlStateNormal];
    }
    
    if (image) {
        [self setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    }
    
    if (selectImage) {
        [self setImage:[UIImage imageNamed:selectImage] forState:UIControlStateSelected];
    }
    
    [self addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
}

-(void)btnClick{
    
    if (self.block) {
        self.block(self.reMark);
    }
}


@end
