//
//  PriceChangeTableViewController.m
//  iArcos
//
//  Created by David Kilmartin on 13/08/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "PriceChangeTableViewController.h"

@interface PriceChangeTableViewController ()

@end

@implementation PriceChangeTableViewController
@synthesize delegate = _delegate;
@synthesize priceChangeDataManager = _priceChangeDataManager;
@synthesize tableCellFactory = _tableCellFactory;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.priceChangeDataManager = [[[PriceChangeDataManager alloc] init] autorelease];
        self.tableCellFactory = [PriceChangeTableCellFactory factory];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"Price Change";
    [self.priceChangeDataManager processRawData];
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonPressed:)];
    NSMutableArray* leftButtonList = [NSMutableArray arrayWithObjects:cancelButton, nil];
    [self.navigationItem setLeftBarButtonItems:leftButtonList];
    [cancelButton release];
    
    UIBarButtonItem* saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonPressed:)];
    NSMutableArray* rightButtonList = [NSMutableArray arrayWithObjects:saveButton, nil];
    [self.navigationItem setRightBarButtonItems:rightButtonList];
    [saveButton release];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.0 green:0.0 blue:128.0/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTranslucent:NO];
}

- (void)cancelButtonPressed:(id)sender {
    [self.delegate didDismissPriceChangeView];
}

- (void)saveButtonPressed:(id)sender {
    [self.view endEditing:YES];
    NSMutableDictionary* myNewPriceDict = nil;
    for (int i = 0; i < [self.priceChangeDataManager.displayList count]; i++) {
        NSMutableDictionary* auxDataDict = [self.priceChangeDataManager.displayList objectAtIndex:i];
        if ([[auxDataDict objectForKey:@"CellType"] intValue] == 2) {
            myNewPriceDict = auxDataDict;
            break;
        }
    }
//    NSLog(@"abc12 %@", [myNewPriceDict objectForKey:@"FieldData"]);
    NSString* myNewPrice = [myNewPriceDict objectForKey:@"FieldData"];
    if ([myNewPrice isEqualToString:@""]) {
        [ArcosUtils showMsg:@"Please enter a special price" delegate:nil];
        return;
    }
    [self.delegate saveButtonWithNewPrice:[ArcosUtils convertStringToDecimalNumber:myNewPrice]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.priceChangeDataManager = nil;
    self.tableCellFactory = nil;
    
    [super dealloc];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.priceChangeDataManager.displayList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    
    NSMutableDictionary* auxCellData = [self.priceChangeDataManager.displayList objectAtIndex:indexPath.row];
    PriceChangeBaseTableCell* cell = (PriceChangeBaseTableCell*)[tableView dequeueReusableCellWithIdentifier:[self.tableCellFactory identifierWithData:auxCellData]];
    if (cell == nil) {
        cell = (PriceChangeBaseTableCell*)[self.tableCellFactory createPriceChangeBaseTableCellWithData:auxCellData];        
    }
    cell.delegate = self;
    cell.indexPath = indexPath;
    [cell configCellWithData:auxCellData];
    
    return cell;
}

#pragma mark PriceChangeBaseTableCellDelegate
- (void)inputFinishedWithData:(NSString *)aData forIndexPath:(NSIndexPath *)theIndexPath {
    [self.priceChangeDataManager updateDataWithData:aData forIndexPath:theIndexPath];
}




@end
