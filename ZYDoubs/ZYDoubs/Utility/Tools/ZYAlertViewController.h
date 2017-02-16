//
//  ZYAlertViewController.h
//  ZYDoubs
//
//  Created by Momo on 17/2/16.
//  Copyright © 2017年 Momo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYAlertViewController : UIAlertController

/**
    一个文本框
 */
+ (void) showOneTextFieldWithTitle:(NSString *)title withMsg:(NSString *)msg withPlaceholder:(NSString *)place withVC:(UIViewController *)vc Block:(void(^)(NSString * text))block;

@end
