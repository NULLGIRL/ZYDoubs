//
//  ZYLabel.h
//  ZYDoubs
//
//  Created by Momo on 17/1/17.
//  Copyright © 2017年 Momo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYLabel : UILabel

- (instancetype) initWithText:(NSString *)text;

- (instancetype) initWithText:(NSString *)text color:(UIColor *)color;

- (instancetype) initWithText:(NSString *)text font:(UIFont *)font;

- (instancetype) initWithText:(NSString *)text font:(UIFont *)font color:(UIColor *)color;

@end
