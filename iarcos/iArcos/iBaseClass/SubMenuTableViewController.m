//
//  SubMenuTableViewController.m
//  iArcos
//
//  Created by David Kilmartin on 05/08/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "SubMenuTableViewController.h"

@interface SubMenuTableViewController ()

@end

@implementation SubMenuTableViewController
@synthesize subMenuDelegate = _subMenuDelegate;
@synthesize displayList = _displayList;
@synthesize currentIndexPath = _currentIndexPath;
@synthesize requestSourceName = _requestSourceName;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    self.displayList = nil;
    self.currentIndexPath = nil;
    self.requestSourceName = nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 59;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSMutableDictionary*)createItemCellData:(NSString*)title imageFile:(NSString*)imageFile {
    NSMutableDictionary* cellDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [cellDict setObject:title forKey:@"Title"];
    [cellDict setObject:imageFile forKey:@"ImageFile"];
    return cellDict;
}

- (NSMutableDictionary*)createItemCellData:(NSString*)title imageFile:(NSString*)imageFile myCustomController:(UIViewController*)aViewController {
    NSMutableDictionary* cellDict = [NSMutableDictionary dictionaryWithCapacity:3];
    [cellDict setObject:title forKey:@"Title"];
    [cellDict setObject:imageFile forKey:@"ImageFile"];
    [cellDict setObject:aViewController forKey:@"MyCustomController"];
    return cellDict;
}

- (NSMutableDictionary*)createItemCellData:(NSString*)title imageFile:(NSString*)imageFile myCustomControllerIndex:(NSNumber*)aViewControllerIndex {
    NSMutableDictionary* cellDict = [NSMutableDictionary dictionaryWithCapacity:3];
    [cellDict setObject:title forKey:@"Title"];
    [cellDict setObject:imageFile forKey:@"ImageFile"];
    return cellDict;
}

- (UIViewController*)pickCustomViewController:(NSString*)aTitle {
    return nil;
}

- (void)removeAllInstances {

}

- (void)selectBottomRecordByTitle:(NSString*)aTitle {

}

@end
