//
//  HGNotification.m
//  HGCashNote
//
//  Created by honghao5 on 16/12/9.
//  Copyright © 2016年 honghao5. All rights reserved.
//

#import "HGNotification.h"
#import <UserNotifications/UserNotifications.h>
#import "AppDelegate.h"

static NSString * const kInputNotification = @"kInputNotification";
static NSString * const kCategoryIdentifier = @"kCategoryIdentifier";

@interface HGNotification () <UNUserNotificationCenterDelegate>

@property (nonatomic, strong) NSMutableDictionary *notificationDict;

@end

@implementation HGNotification

+ (HGNotification *)sharedHGNotification
{
    static dispatch_once_t onceToken;
    static HGNotification *notification = nil;
    dispatch_once(&onceToken, ^{
        notification = [[HGNotification alloc] init];
    });
    return notification;
}

+ (void)addDelegate:(id)delegate
{
    [HGNotification sharedHGNotification].delegate = delegate;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _notificationDict = @{}.mutableCopy;
    }
    return self;
}

- (void)requestAuth
{
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound |  UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            
            [self addAction];
            
            [self.notificationDict enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, UNNotificationRequest *  _Nonnull obj, BOOL * _Nonnull stop) {
                [center addNotificationRequest:obj withCompletionHandler:^(NSError * _Nullable error) {
                    
                }];
            }];
        }
        if (!error) {
            NSLog(@"request authorization succeeded!");
        }
    }];
}

- (void)addNotification
{
    UNMutableNotificationContent *notificationContent = [[UNMutableNotificationContent alloc] init];
    notificationContent.title = @"嘿，浩哥";
    notificationContent.body = @"该记账啦";
    notificationContent.sound = [UNNotificationSound defaultSound];
    notificationContent.categoryIdentifier = kCategoryIdentifier;
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5 repeats:NO];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"zz" content:notificationContent trigger:trigger];
    [self.notificationDict setObject:request forKey:@"zz"];
}

- (void)addAction
{
    UNTextInputNotificationAction *inputAction = [UNTextInputNotificationAction actionWithIdentifier:kInputNotification title:@"记账" options:UNNotificationActionOptionForeground textInputButtonTitle:@"添加" textInputPlaceholder:@"形如：吃饭/15"];
    
    UNNotificationAction *cancelAction = [UNNotificationAction actionWithIdentifier:@"cancel" title:@"取消" options:UNNotificationActionOptionDestructive];
    
    UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:kCategoryIdentifier actions:@[inputAction, cancelAction] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
    NSSet *set = [NSSet setWithObjects:category, nil];
    
    [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:set];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler
{
    NSString *actionIdentifier = response.actionIdentifier;
    if ([actionIdentifier isEqualToString:kInputNotification]) {
        UNTextInputNotificationResponse *input = (UNTextInputNotificationResponse *)response;
        NSArray *para = [input.userText componentsSeparatedByString:@"/"];
        if (self.delegate) {
            [self.delegate addBillingWithEvent:para.firstObject pay:[para.lastObject doubleValue]];
        }
    }
}

@end
