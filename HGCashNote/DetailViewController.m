//
//  DetailViewController.m
//  HGCashNote
//
//  Created by honghao5 on 16/12/8.
//  Copyright © 2016年 honghao5. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        NSString *timestamp = self.detailItem.timestamp.description.length > 20 ? [self.detailItem.timestamp.description substringToIndex:20] : self.detailItem.timestamp.description;
        self.detailDescriptionLabel.text = [NSString stringWithFormat:@"%@\n\n%@\n\n%@\n\n", self.detailItem.event, [NSString stringWithFormat:@"￥%.2f", self.detailItem.pay], timestamp];
        NSLog(@"%@", [NSString stringWithFormat:@"￥%.2f", self.detailItem.pay]);
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initUI];
    [self configureView];
}

- (void)initUI
{
    self.detailDescriptionLabel.numberOfLines = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Managing the detail item

- (void)setDetailItem:(Billing *)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}


@end
