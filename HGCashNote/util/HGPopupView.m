//
//  HGPopupView.m
//  HGCashNote
//
//  Created by honghao5 on 16/12/8.
//  Copyright © 2016年 honghao5. All rights reserved.
//

#import "HGPopupView.h"
#import <MMPopupView/MMAlertView.h>

static int const kInputLimit = 40;

@implementation HGPopupView

+ (void)showInputViewWithTitle:(NSString *)title confirmStr:(NSString *)confirmStr closeStr:(NSString *)closeStr handle:(void(^)(NSString *text))handle
{
    MMAlertViewConfig *config = [MMAlertViewConfig globalConfig];
    config.defaultTextConfirm = confirmStr;
    config.defaultTextCancel = closeStr;
    config.titleColor = [UIColor redColor];
    config.itemNormalColor = [UIColor redColor];
    
    MMAlertView *inputView = [[MMAlertView alloc] initWithInputTitle:title detail:@"" placeholder:@"" handler:^(NSString *text) {
        handle(text);
    }];
    inputView.maxInputLength = kInputLimit;
    
    [inputView show];
}

+ (void)showInputViewWithTitle:(NSString *)title confirmStr:(NSString *)confirmStr closeStr:(NSString *)closeStr keyBoardType:(UIKeyboardType)keyBoardType handle:(void (^)(NSString *))handle
{
    MMAlertViewConfig *config = [MMAlertViewConfig globalConfig];
    config.defaultTextConfirm = confirmStr;
    config.defaultTextCancel = closeStr;
    config.titleColor = [UIColor redColor];
    config.itemNormalColor = [UIColor redColor];
    
    MMAlertView *inputView = [[MMAlertView alloc] initWithInputTitle:title detail:@"" placeholder:@"" handler:^(NSString *text) {
        handle(text);
    }];
    inputView.inputView.keyboardType = keyBoardType;
    
    [inputView show];
}

@end
