//
//  ZYLabel.m
//  ZYDoubs
//
//  Created by Momo on 17/1/17.
//  Copyright © 2017年 Momo. All rights reserved.
//

#import "ZYLabel.h"

@implementation ZYLabel

- (instancetype) initWithText:(NSString *)text{
    if (self = [super init]) {
        [self text:text color:nil font:nil];
    }
    return self;
}

- (instancetype) initWithText:(NSString *)text color:(UIColor *)color{
    if (self = [super init]) {
        [self text:text color:color font:nil];
    }
    return self;
}

- (instancetype) initWithText:(NSString *)text font:(UIFont *)font{
    if (self = [super init]) {
        [self text:text color:nil font:font];
    }
    return self;
}

- (instancetype) initWithText:(NSString *)text font:(UIFont *)font color:(UIColor *)color{
    if (self = [super init]) {
        [self text:text color:color font:font];
    }
    return self;
}

- (void) text:(NSString *)text color:(UIColor *)color font:(UIFont *)font{
    
    self.textAlignment = NSTextAlignmentCenter;
    
    if (text) {
        self.text = text;
    }
    
    if (color) {
        self.textColor = color;
    }
    
    if (font) {
        self.font = font;
    }

}

@end
