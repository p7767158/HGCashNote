//
//  HGTopPopWindow.h
//  HGCashNote
//
//  Created by honghao5 on 16/12/8.
//  Copyright © 2016年 honghao5. All rights reserved.
//

#import <Foundation/Foundation.h>

extern int kShowTime;

@interface HGTopPopWindow : NSObject

+ (void)title:(NSString *)title message:(NSString *)message time:(NSInteger)seconds;

@end
