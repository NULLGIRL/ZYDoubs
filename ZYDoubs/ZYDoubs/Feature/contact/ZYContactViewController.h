//
//  ZYContactViewController.h
//  ZYDoubs
//
//  Created by Momo on 17/1/11.
//  Copyright © 2017年 Momo. All rights reserved.
//

#import "ZYBaseTableViewController.h"

typedef enum ContactsFilterGroup_e
{
    FilterGroupAll,
    FilterGroupOnline,
    FilterGroupWiPhone
}
ContactsFilterGroup_t;

typedef enum ContactsDisplayMode_e
{
    Display_None,
    Display_ChooseNumberForFavorite,
    Display_Searching
}
ContactsDisplayMode_t;



@interface ZYContactViewController : ZYBaseTableViewController<UIActionSheetDelegate>

@end
