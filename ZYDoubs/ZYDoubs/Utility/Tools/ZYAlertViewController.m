//
//  ZYAlertViewController.m
//  ZYDoubs
//
//  Created by Momo on 17/2/16.
//  Copyright © 2017年 Momo. All rights reserved.
//

#import "ZYAlertViewController.h"

@interface ZYAlertViewController ()

@end

@implementation ZYAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 一个文本框
 */
+ (void) showOneTextFieldWithTitle:(NSString *)title withMsg:(NSString *)msg withPlaceholder:(NSString *)place withVC:(UIViewController *)vc Block:(void(^)(NSString * impi))block{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = place;
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField * textF = alertController.textFields.firstObject;

        
        if ([ZYTools isNullOrEmpty:textF.text]) {
            [SVProgressHUD showErrorWithStatus:@"您没有输入任何文字"];
            return ;
        }
        if (block) {
            block(textF.text);
        }
    }];
    
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    
    [vc presentViewController:alertController animated:YES completion:nil];

    
}


@end
