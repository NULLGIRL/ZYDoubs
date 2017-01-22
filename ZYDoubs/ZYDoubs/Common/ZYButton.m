//
//  ZYButton.m
//  ZYDoubs
//
//  Created by Momo on 17/1/11.
//  Copyright © 2017年 Momo. All rights reserved.
//

#import "ZYButton.h"

@interface ZYButton ()


@end

@implementation ZYButton

-(instancetype)initWithTitle:(NSString *)title font:(UIFont *)font{
    
    if (self = [super init]) {
        
        [self title:title image:nil selectImage:nil font:font];
        
    }
    return self;
}

-(instancetype)initWithTitle:(NSString *)title font:(UIFont *)font color:(UIColor *)color selectColor:(UIColor *) sColor{
    
    if (self = [super init]) {
        
        
        [self title:title image:nil selectImage:nil font:font];
        
        
        if (color) {
            [self setTitleColor:color forState:UIControlStateNormal];
        }
        
        if (sColor) {
            [self setTitleColor:sColor forState:UIControlStateSelected];
        }
        
    }
    return self;
}

-(instancetype)initWithTitle:(NSString *)title font:(UIFont *)font withImage:(NSString *)imageName{
    
    if (self = [super init]) {
        
        [self title:title image:imageName selectImage:nil font:font];
    }
    return self;
}


-(instancetype)initWithTitle:(NSString *)title font:(UIFont *)font withImage:(NSString *)imageName selectImage:(NSString *)selectImageName{
    
    if (self = [super init]) {
        [self title:title image:imageName selectImage:selectImageName font:font];
    }
    return self;
}


- (void)title:(NSString *)title image:(NSString *)image selectImage:(NSString *)selectImage font:(UIFont *)font {
    
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
    
    if (font) {
        self.titleLabel.font = font;
    }
    
    [self addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
}

-(void)btnClick{
    
    if (self.block) {
        self.block(self.reMark);
    }
}

/**
 设置layer
 */
- (void) layerCornerRadius:(CGFloat)radius borderWidth:(CGFloat)border borderColor:(UIColor *)color{
    self.layer.cornerRadius = radius;
    self.layer.borderWidth = border;
    self.layer.borderColor = color.CGColor;
}


@end
