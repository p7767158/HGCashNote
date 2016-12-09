//
//  MasterViewController.h
//  HGCashNote
//
//  Created by honghao5 on 16/12/8.
//  Copyright © 2016年 honghao5. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "HGCashNote+CoreDataModel.h"
#import "Billing+CoreDataClass.h"
#import "Billing+CoreDataProperties.h"
#import "HGNotification.h"

@class DetailViewController;

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate, HGNotificationDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController<Billing *> *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (void)insertNewBillingWithEvent:(NSString *)event pay:(double)pay;

@end

