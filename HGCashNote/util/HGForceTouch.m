//
//  HGForceTouch.m
//  HGCashNote
//
//  Created by sun on 2016/12/10.
//  Copyright © 2016年 honghao5. All rights reserved.
//

#import "HGForceTouch.h"

NSString *kForchTouchType = @"zhh";

@implementation HGForceTouch

+ (void)defaultSetUp
{
    UIApplicationShortcutIcon *noteIcon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeCompose];
    UIApplicationShortcutItem *noteItem = [[UIApplicationShortcutItem alloc] initWithType:kForchTouchType localizedTitle:@"记账" localizedSubtitle:@"" icon:noteIcon userInfo:@{}];
    UIApplicationShortcutIcon *shareIcon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeShare];
    UIApplicationShortcutItem *shareItem = [[UIApplicationShortcutItem alloc] initWithType:@"TWO" localizedTitle:@"分享" localizedSubtitle:@"" icon:shareIcon userInfo:nil];
    [UIApplication sharedApplication].shortcutItems = @[noteItem, shareItem];
}

@end
