//
//  CustomerInfoAccountBalanceDetailTableViewController.m
//  Arcos
//
//  Created by David Kilmartin on 12/01/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import "CustomerInfoAccountBalanceDetailTableViewController.h"

@interface CustomerInfoAccountBalanceDetailTableViewController ()
- (NSMutableDictionary*)createCellData:(NSString*)fieldName fieldValue:(NSNumber*)fieldValue;
@end

@implementation CustomerInfoAccountBalanceDetailTableViewController
@synthesize cancelDelegate = _cancelDelegate;
@synthesize displayList = _displayList;
@synthesize oneMthKey = _oneMthKey;
@synthesize twoMthKey = _twoMthKey;
@synthesize threeMthKey = _threeMthKey;
@synthesize fourMthKey = _fourMthKey;
@synthesize descrDetailHashMap = _descrDetailHashMap;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.oneMthKey = @"CURR";
        self.twoMthKey = @"30";
        self.threeMthKey = @"60";
        self.fourMthKey = @"90";
        NSMutableArray* descrDetailCodeList = [NSMutableArray arrayWithObjects:self.oneMthKey, self.twoMthKey, self.threeMthKey, self.fourMthKey, nil];
        NSMutableArray* objectArray = [[ArcosCoreData sharedArcosCoreData] descrDetailWithDescrTypeCode:@"SD" descrDetailCodeList:descrDetailCodeList];
        self.descrDetailHashMap = [NSMutableDictionary dictionaryWithCapacity:[objectArray count]];
        for (int i = 0; i < [objectArray count]; i++) {
            NSDictionary* tmpDescrDetailDict = [objectArray objectAtIndex:i];
            NSString* tmpDescrDetailCode = [ArcosUtils convertNilToEmpty:[tmpDescrDetailDict objectForKey:@"DescrDetailCode"]];
            [self.descrDetailHashMap setObject:tmpDescrDetailDict forKey:tmpDescrDetailCode];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    if (![ArcosUtils systemVersionGreaterThanSeven]) {
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    }
    self.title = @"A/C Balance Details";
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelPressed:)];
    [self.navigationItem setLeftBarButtonItem:cancelButton];
    [cancelButton release];
}

- (void)cancelPressed:(id)sender {
    [self.cancelDelegate didDismissSelectionCancelPopover];
}

- (void)dealloc {
    self.displayList = nil;
    self.oneMthKey = nil;
    self.twoMthKey = nil;
    self.threeMthKey = nil;
    self.fourMthKey = nil;
    self.descrDetailHashMap = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)processRawData:(NSMutableDictionary*)custDict {
    self.displayList = [NSMutableArray arrayWithCapacity:4];
    NSString* oneMthDesc = @"One Month";
    NSDictionary* oneMthDescrDetailDict = [self.descrDetailHashMap objectForKey:self.oneMthKey];
    if (oneMthDescrDetailDict != nil) {
        oneMthDesc = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:[oneMthDescrDetailDict objectForKey:@"Detail"]]];
    }
    NSString* twoMthDesc = @"Two Months";
    NSDictionary* twoMthDescrDetailDict = [self.descrDetailHashMap objectForKey:self.twoMthKey];
    if (twoMthDescrDetailDict != nil) {
        twoMthDesc = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:[twoMthDescrDetailDict objectForKey:@"Detail"]]];
    }
    NSString* threeMthDesc = @"Three Months";
    NSDictionary* threeMthDescrDetailDict = [self.descrDetailHashMap objectForKey:self.threeMthKey];
    if (threeMthDescrDetailDict != nil) {
        threeMthDesc = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:[threeMthDescrDetailDict objectForKey:@"Detail"]]];
    }
    NSString* fourMthDesc = @"Four Months";
    NSDictionary* fourMthDescrDetailDict = [self.descrDetailHashMap objectForKey:self.fourMthKey];
    if (fourMthDescrDetailDict != nil) {
        fourMthDesc = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:[fourMthDescrDetailDict objectForKey:@"Detail"]]];
    }
    
    [self.displayList addObject:[self createCellData:oneMthDesc fieldValue:[custDict objectForKey:@"AgedAmount1"]]];
    [self.displayList addObject:[self createCellData:twoMthDesc fieldValue:[custDict objectForKey:@"AgedAmount2"]]];
    [self.displayList addObject:[self createCellData:threeMthDesc fieldValue:[custDict objectForKey:@"AgedAmount3"]]];
    [self.displayList addObject:[self createCellData:fourMthDesc fieldValue:[custDict objectForKey:@"AgedAmount4"]]];
}

- (NSMutableDictionary*)createCellData:(NSString*)fieldName fieldValue:(NSNumber*)fieldValue {
    NSMutableDictionary* cellDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [cellDict setObject:fieldName forKey:@"FieldName"];
    [cellDict setObject:fieldValue forKey:@"FieldValue"];
    return cellDict;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.displayList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"IdCustomerInfoAccountBalanceDetailTableViewCell";
    
    CustomerInfoAccountBalanceDetailTableViewCell *cell=(CustomerInfoAccountBalanceDetailTableViewCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"CustomerInfoAccountBalanceDetailTableViewCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[CustomerInfoAccountBalanceDetailTableViewCell class]] && [[(CustomerInfoAccountBalanceDetailTableViewCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell = (CustomerInfoAccountBalanceDetailTableViewCell *) nibItem;
                
            }
        }
    }
    
    // Configure the cell...
    NSMutableDictionary* cellData = [self.displayList objectAtIndex:indexPath.row];
    cell.infoTitle.text = [cellData objectForKey:@"FieldName"];
    cell.infoValue.text = [NSString stringWithFormat:@"%.2f", [[cellData objectForKey:@"FieldValue"] floatValue]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}



@end
