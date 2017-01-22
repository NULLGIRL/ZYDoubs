//
//  ZYMessageViewController.h
//  ZYDoubs
//
//  Created by Momo on 17/1/10.
//  Copyright © 2017年 Momo. All rights reserved.
//

#import "ZYBaseTableViewController.h"

@interface ZYMessageViewController : ZYBaseTableViewController
{
    NSMutableArray* messages;
    NgnContact *pickedContact;
    NgnPhoneNumber *pickedNumber;
}
@end
