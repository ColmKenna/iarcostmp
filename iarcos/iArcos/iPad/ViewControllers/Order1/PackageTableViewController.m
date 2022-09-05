//
//  PackageTableViewController.m
//  iArcos
//
//  Created by Richard on 21/07/2022.
//  Copyright © 2022 Strata IT Limited. All rights reserved.
//

#import "PackageTableViewController.h"

@interface PackageTableViewController ()

@end

@implementation PackageTableViewController
@synthesize modalDelegate = _modalDelegate;
@synthesize actionDelegate = _actionDelegate;
@synthesize packageDataManager = _packageDataManager;

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.packageDataManager = [[[PackageDataManager alloc] init] autorelease];
        [self.packageDataManager retrievePackageDataWithLocationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithTitle:[GlobalSharedClass shared].cancelButtonText style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonPressed)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    [cancelButton release];
    
    UIBarButtonItem* saveButton = [[UIBarButtonItem alloc] initWithTitle:[GlobalSharedClass shared].saveButtonText style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonPressed)];
    self.navigationItem.rightBarButtonItem = saveButton;
    [saveButton release];
    
    
}

- (void)cancelButtonPressed {
    if ([GlobalSharedClass shared].packageViewCount == 0) return;
    [self.modalDelegate didDismissModalPresentViewController];
}

- (void)saveButtonPressed {
    [GlobalSharedClass shared].packageViewCount = 1;
    if ([self.packageDataManager.displayList count] == 0) {
        [self.modalDelegate didDismissModalPresentViewController];
        return;
    }
    [self.packageDataManager saveButtonPressedProcessor];
    [self.actionDelegate packageSaveButtonPressed];
    [self.modalDelegate didDismissModalPresentViewController];
}

- (void)dealloc {
    self.packageDataManager = nil;
    
    [super dealloc];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.packageDataManager.displayList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"IdPackageTableViewCell";
    
    PackageTableViewCell* cell = (PackageTableViewCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"PackageTableViewCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[PackageTableViewCell class]] && [[(PackageTableViewCell*)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell = (PackageTableViewCell*)nibItem;
            }
        }
    }
    
    // Configure the cell...
    cell.actionDelegate = self;
    cell.myIndexPath = indexPath;
    NSMutableDictionary* cellData = [self.packageDataManager.displayList objectAtIndex:indexPath.row];
    [cell configCellWithData:cellData];
    
    return cell;
}

#pragma mark - PackageTableViewCellDelegate
- (NSMutableDictionary*)retrieveWholesalerIurImageIurHashMap {
    return self.packageDataManager.wholesalerIurImageIurHashMap;
}

- (NSMutableDictionary*)retrievePGiurDetailHashMap {
    return self.packageDataManager.pGiurDetailHashMap;
}

- (void)rowPressedWithIndexPath:(NSIndexPath*)anIndexPath {
    [self.packageDataManager resetSelectedFlagOnList];
    [self.packageDataManager configSelectedFlagWithIndexPath:anIndexPath];
    [self.tableView reloadData];
}





@end
