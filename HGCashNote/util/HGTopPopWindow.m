//
//  HGTopPopWindow.m
//  HGCashNote
//
//  Created by honghao5 on 16/12/8.
//  Copyright © 2016年 honghao5. All rights reserved.
//

#import "HGTopPopWindow.h"
#import <RKDropdownAlert/RKDropdownAlert.h>

int kShowTime = 3;

@implementation HGTopPopWindow

+ (void)title:(NSString *)title message:(NSString *)message time:(NSInteger)seconds
{
    [RKDropdownAlert title:title message:message time:seconds];
}

@end
