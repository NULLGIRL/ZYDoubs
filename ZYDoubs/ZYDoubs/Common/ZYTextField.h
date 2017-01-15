//
//  ZYTextField.h
//  ZYDoubs
//
//  Created by Momo on 17/1/12.
//  Copyright © 2017年 Momo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ZYTextFieldBlock)(NSInteger tag,NSString * text);
@interface ZYTextField : UITextField


- (instancetype) initWithPlaceText:(NSString *)placeText font:(UIFont *)fieldFont tag:(NSInteger)tag;

@property (nonatomic,copy) ZYTextFieldBlock block;

@end
