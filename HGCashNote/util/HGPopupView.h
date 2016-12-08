//
//  HGPopupView.h
//  HGCashNote
//
//  Created by honghao5 on 16/12/8.
//  Copyright © 2016年 honghao5. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HGPopupView : NSObject

+ (void)showInputViewWithTitle:(NSString *)title confirmStr:(NSString *)confirmStr closeStr:(NSString *)closeStr handle:(void(^)(NSString *text))handle;
+ (void)showInputViewWithTitle:(NSString *)title confirmStr:(NSString *)confirmStr closeStr:(NSString *)closeStr keyBoardType:(UIKeyboardType)keyBoardType handle:(void(^)(NSString *text))handle;

@end
