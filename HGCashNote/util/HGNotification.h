//
//  HGNotification.h
//  HGCashNote
//
//  Created by honghao5 on 16/12/9.
//  Copyright © 2016年 honghao5. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HGNotificationDelegate <NSObject>

- (void)addBillingWithEvent:(NSString *)event pay:(double)pay;

@end

@interface HGNotification : NSObject

@property (nonatomic, weak) id <HGNotificationDelegate> delegate;

+ (HGNotification *)sharedHGNotification;
+ (void)addDelegate:(id)delegate;

- (void)requestAuth;
- (void)addNotification;

@end
