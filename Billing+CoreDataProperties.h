//
//  Billing+CoreDataProperties.h
//  HGCashNote
//
//  Created by honghao5 on 16/12/8.
//  Copyright © 2016年 honghao5. All rights reserved.
//

#import "Billing+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Billing (CoreDataProperties)

+ (NSFetchRequest<Billing *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *timestamp;
@property (nullable, nonatomic, copy) NSString *event;
@property (nonatomic) double pay;

@end

NS_ASSUME_NONNULL_END
