//
//  DetailViewController.h
//  HGCashNote
//
//  Created by honghao5 on 16/12/8.
//  Copyright © 2016年 honghao5. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HGCashNote+CoreDataModel.h"
#import "Billing+CoreDataClass.h"
#import "Billing+CoreDataProperties.h"

@interface DetailViewController : UIViewController

@property (strong, nonatomic) Billing *detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

