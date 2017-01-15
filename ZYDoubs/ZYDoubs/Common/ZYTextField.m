//
//  ZYTextField.m
//  ZYDoubs
//
//  Created by Momo on 17/1/12.
//  Copyright © 2017年 Momo. All rights reserved.
//

#import "ZYTextField.h"

@interface ZYTextField ()<UITextFieldDelegate>

/**
 
    tag
 */
@property (nonatomic,assign) NSInteger tag;

@end

@implementation ZYTextField


- (instancetype) initWithPlaceText:(NSString *)placeText font:(UIFont *)fieldFont tag:(NSInteger)tag{
    if (self = [super init]) {
        
        self.delegate = self;
        
        if (placeText) {
            self.placeholder = placeText;
        }
        
        self.text = @"";
        
        if (fieldFont) {
            self.font = fieldFont;
        }
        
        self.tag = 0;
        self.tag = tag;
    }
    return self;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (self.block) {
        self.block(self.tag,textField.text);
    }
}

@end
