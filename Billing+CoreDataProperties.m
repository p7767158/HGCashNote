//
//  Billing+CoreDataProperties.m
//  HGCashNote
//
//  Created by honghao5 on 16/12/8.
//  Copyright © 2016年 honghao5. All rights reserved.
//

#import "Billing+CoreDataProperties.h"

@implementation Billing (CoreDataProperties)

+ (NSFetchRequest<Billing *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Billing"];
}

@dynamic timestamp;
@dynamic event;
@dynamic pay;

@end
