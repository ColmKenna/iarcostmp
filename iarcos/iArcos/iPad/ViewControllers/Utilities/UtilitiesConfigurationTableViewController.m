//
//  UtilitiesConfigurationTableViewController.m
//  iArcos
//
//  Created by David Kilmartin on 23/04/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import "UtilitiesConfigurationTableViewController.h"

@interface UtilitiesConfigurationTableViewController ()

@end

@implementation UtilitiesConfigurationTableViewController
@synthesize utilitiesConfigurationDataManager = _utilitiesConfigurationDataManager;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"Configuration";
    self.utilitiesConfigurationDataManager = [[[UtilitiesConfigurationDataManager alloc] init] autorelease];
    [self.utilitiesConfigurationDataManager retrieveDescrDetailIOData];
    UIBarButtonItem* saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(savePressed)];
    [self.navigationItem setRightBarButtonItem:saveButton];
    [saveButton release];
}

- (void)savePressed {
    [self.utilitiesConfigurationDataManager retrieveChangedList];
    if ([self.utilitiesConfigurationDataManager.changedList count] == 0) {
        [ArcosUtils showMsg:@"There is no change." delegate:nil];
        return;
    }
    [self.utilitiesConfigurationDataManager saveChangedList];
}

- (void)dealloc {
    self.utilitiesConfigurationDataManager = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.utilitiesConfigurationDataManager.displayList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"IdUtilitiesConfigurationTableCell";
    
    UtilitiesConfigurationTableCell* cell=(UtilitiesConfigurationTableCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"UtilitiesConfigurationTableCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[UtilitiesConfigurationTableCell class]] && [[(UtilitiesConfigurationTableCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell= (UtilitiesConfigurationTableCell *) nibItem;
                cell.myDelegate = self;
            }
        }
    }
    // Configure the cell...
    cell.myIndexPath = indexPath;
    NSMutableDictionary* cellData = [self.utilitiesConfigurationDataManager.displayList objectAtIndex:indexPath.row];
    cell.detail.text = [cellData objectForKey:@"Detail"];
    cell.tooltip.text = [cellData objectForKey:@"Tooltip"];
    NSNumber* toggle1Number = [cellData objectForKey:@"Toggle1"];
    cell.toggleSwitch.on = [toggle1Number boolValue];
    
    return cell;
}

- (void)inputFinishedWithData:(id)data forIndexpath:(NSIndexPath *)theIndexpath {
    [self.utilitiesConfigurationDataManager inputFinishedWithData:data forIndexpath:theIndexpath];
}


@end
