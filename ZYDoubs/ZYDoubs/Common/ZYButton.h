//
//  ZYButton.h
//  ZYDoubs
//
//  Created by Momo on 17/1/11.
//  Copyright © 2017年 Momo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ZYButtonBlock)(NSString * reMark);
@interface ZYButton : UIButton

-(instancetype)initWithTitle:(NSString *)title font:(UIFont *)font;

-(instancetype)initWithTitle:(NSString *)title font:(UIFont *)font color:(UIColor *)color selectColor:(UIColor *) sColor;

-(instancetype)initWithTitle:(NSString *)title font:(UIFont *)font withImage:(NSString *)imageName;

-(instancetype)initWithTitle:(NSString *)title font:(UIFont *)font withImage:(NSString *)imageName selectImage:(NSString *)selectImageName;

/**
    设置layer
 */
- (void) layerCornerRadius:(CGFloat)radius borderWidth:(CGFloat)border borderColor:(UIColor *)color;

@property (nonatomic,copy) ZYButtonBlock block;




/**
 
 标签
 默认设置为title
 */
@property (nonatomic,strong) NSString * reMark;

@end
