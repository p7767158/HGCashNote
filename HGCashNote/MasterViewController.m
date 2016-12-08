//
//  MasterViewController.m
//  HGCashNote
//
//  Created by honghao5 on 16/12/8.
//  Copyright © 2016年 honghao5. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "HGPopupView.h"
#import <Masonry/Masonry.h>

@interface MasterViewController ()

@property (nonatomic, copy) NSString *event;
@property (nonatomic, assign) double pay;

@property (nonatomic, assign) double totalPay;
@property (nonatomic, strong) UIView *totalView;
@property (nonatomic, strong) UILabel *totalLb;

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addEvent:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    [self calculateSumOfPay];
}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTotalPay:(double)totalPay
{
    _totalPay = totalPay;
    if (!_totalView) {
        [self totalView];
    }
    _totalLb.text = [NSString stringWithFormat:@"总计：￥%.2f", _totalPay];
}

- (UIView *)totalView
{
    if (!_totalView) {
        _totalView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60)];
        _totalView.backgroundColor = [UIColor whiteColor];
        _totalLb = [[UILabel alloc] init];
        _totalLb.font = [UIFont systemFontOfSize:18];
        _totalLb.textColor = [UIColor redColor];
        
        UIView *sep = [[UIView alloc] init];
        sep.backgroundColor = [UIColor lightGrayColor];
        
        [_totalView addSubview:_totalLb];
        [_totalView addSubview:sep];
        [_totalLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_totalView).offset(-15);
            make.centerY.equalTo(_totalView);
        }];
        [sep mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(_totalView);
            make.height.equalTo(@.5);
        }];
    }
    return _totalView;
}

- (IBAction)addEvent:(id)sender
{
    __weak typeof(self) welf = self;
    [HGPopupView showInputViewWithTitle:@"干啥了？" confirmStr:@"确定" closeStr:@"取消" handle:^(NSString *text) {
        if (text.length == 0) {
            return;
        }
        welf.event = text;
        [welf addPay];
    }];
}

- (void)addPay
{
    __weak typeof(self) welf = self;
    [HGPopupView showInputViewWithTitle:@"花多钱？" confirmStr:@"确定" closeStr:@"取消" keyBoardType:UIKeyboardTypeNumberPad handle:^(NSString *text) {
        if (text.length == 0) {
            return;
        }
        welf.pay = text.doubleValue;
        [welf insertNewBilling];
    }];
}

- (void)insertNewBilling
{
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    Billing *newBilling = [[Billing alloc] initWithContext:context];
    newBilling.event = self.event;
    newBilling.pay = self.pay;
    newBilling.timestamp = [NSDate date];
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

- (void)insertNewObject:(id)sender {
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    Event *newEvent = [[Event alloc] initWithContext:context];
        
    // If appropriate, configure the new managed object.
    newEvent.timestamp = [NSDate date];
        
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort(); //TODO HG:exit applicantion
    }
}


#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Billing *billing = [self.fetchedResultsController objectAtIndexPath:indexPath];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:billing];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    Billing *billing = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self configureCell:cell withBilling:billing];
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
            
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, error.userInfo);
            abort();
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.totalView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60.f;
}

- (void)configureCell:(UITableViewCell *)cell withBilling:(Billing *)billing
{
    cell.textLabel.text = billing.event;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%.2f", billing.pay];
}

- (void)calculateSumOfPay
{
    NSFetchRequest<Billing *> *fetchRequest = Billing.fetchRequest;
    fetchRequest.resultType = NSDictionaryResultType;
    
    NSExpressionDescription *expressionDes = [[NSExpressionDescription alloc]init];
    expressionDes.name = @"sumOperation";
    expressionDes.expressionResultType = NSDoubleAttributeType;
    NSExpression *expression = [NSExpression expressionForFunction:@"sum:" arguments:@[[NSExpression expressionForKeyPath:@"pay"]]];
    expressionDes.expression = expression;
    fetchRequest.propertiesToFetch = @[expressionDes];
    NSError *error = nil;
    NSArray *resultArr = [[self.fetchedResultsController managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    // 通过上面设置的name值，当做请求结果的key取出计算结果
    NSNumber *number = resultArr.firstObject[@"sumOperation"];
    self.totalPay = number.doubleValue;
    // 错误处理
    if (error) {
        NSLog(@"fetch request result error : %@", error);
    }
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController<Billing *> *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest<Billing *> *fetchRequest = Billing.fetchRequest;
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO];

    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController<Billing *> *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    
    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
    
    _fetchedResultsController = aFetchedResultsController;
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            return;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] withBilling:anObject];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self calculateSumOfPay];
    });
    
    [self.tableView endUpdates];
}

/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */

@end
