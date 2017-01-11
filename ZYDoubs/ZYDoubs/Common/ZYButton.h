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

-(instancetype)initWithTitle:(NSString *)title;

-(instancetype)initWithTitle:(NSString *)title withImage:(NSString *)imageName;

-(instancetype)initWithTitle:(NSString *)title withImage:(NSString *)imageName selectImage:(NSString *)selectImageName;

@property (nonatomic,copy) ZYButtonBlock block;

@end
