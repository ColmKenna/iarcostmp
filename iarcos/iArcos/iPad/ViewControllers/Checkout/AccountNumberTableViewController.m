//
//  AccountNumberTableViewController.m
//  Arcos
//
//  Created by David Kilmartin on 14/08/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "AccountNumberTableViewController.h"

@interface AccountNumberTableViewController ()
- (void)alertActionCallBack;
@end

@implementation AccountNumberTableViewController
@synthesize delegate = _delegate;
@synthesize refreshDelegate = _refreshDelegate;
@synthesize displayList = _displayList;
@synthesize locationIUR = _locationIUR;
@synthesize fromLocationIUR = _fromLocationIUR;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backPressed:)];
    [self.navigationItem setLeftBarButtonItem:backButton];
    [backButton release];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(savePressed:)];
    [self.navigationItem setRightBarButtonItem:saveButton];
    [saveButton release];
    self.displayList = [NSMutableArray arrayWithCapacity:1];
    NSMutableDictionary* dataDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [dataDict setObject:@"" forKey:@"fieldValue"];
    [self.displayList addObject:dataDict];
    
}

- (void)dealloc {
    self.displayList = nil;
    self.locationIUR = nil;
    self.fromLocationIUR = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)backPressed:(id)sender {
//    [self.myDelegate didDismissCustomisePresentView];
    [self.delegate didDismissModalView];
}

- (void)savePressed:(id)sender {
    [self.view endEditing:YES];
    NSMutableDictionary* dataDict = [self.displayList objectAtIndex:0];
    NSString* fieldValue = [dataDict objectForKey:@"fieldValue"];
    if ([fieldValue isEqualToString:@""]) {
        [ArcosUtils showDialogBox:[NSString stringWithFormat:@"%@ should not be empty.", [GlobalSharedClass shared].accountNoText] title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
        return;
    }
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] checkAccountNumberFlag]) {
        if (![ArcosValidator isSevenDigitNumberBeginWithFive:fieldValue]) {
            [ArcosUtils showDialogBox:@"Account No. should be a seven digits number and begin with a five" title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
                
            }];
            return;
        }
    }    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"LocationIUR = %d and FromLocationIUR = %d", [self.locationIUR intValue], [self.fromLocationIUR intValue]];
    
    NSMutableArray* locLocLinkList = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"LocLocLink" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
    if ([locLocLinkList count] > 0) {
        LocLocLink* locLocLink = [locLocLinkList objectAtIndex:0];
        NSString* customerCode = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:locLocLink.CustomerCode]];
        if ([customerCode isEqualToString:@""]) {
            customerCode = fieldValue;
        } else {
            NSString* delimiter = @",";
            NSRange rng = [customerCode rangeOfString:delimiter];
            if (rng.location == NSNotFound) {
                NSString* secondDelimiter = @"|";
                NSRange secondRng = [customerCode rangeOfString:secondDelimiter];
                if (secondRng.location != NSNotFound) {
                    delimiter = secondDelimiter;
                }
            }
            NSArray* accountNoComponentList = [customerCode componentsSeparatedByString:delimiter];
            BOOL isFound = NO;
            for (int i = 0; i < [accountNoComponentList count]; i++) {
                NSString* tmpAccountNo = [accountNoComponentList objectAtIndex:i];
                if ([fieldValue isEqualToString:tmpAccountNo]) {
                    isFound = YES;
                    break;
                }
            }
            if (isFound) {
                [ArcosUtils showDialogBox:[NSString stringWithFormat:@"The %@ is already existing.", [GlobalSharedClass shared].accountNoText] title:[GlobalSharedClass shared].errorTitle delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
                    
                }];
                return;
            }
            customerCode = [NSString stringWithFormat:@"%@%@%@",customerCode,delimiter,fieldValue];
        }
        [self populateLocLocLink:self.locationIUR fromLocationIUR:self.fromLocationIUR customerCode:customerCode LocLocLink:locLocLink];
        [[ArcosCoreData sharedArcosCoreData] saveContext:[ArcosCoreData sharedArcosCoreData].fetchManagedObjectContext];
    } else {
        NSManagedObjectContext* context = [[ArcosCoreData sharedArcosCoreData] addManagedObjectContext];
        LocLocLink* locLocLink = [NSEntityDescription
                                  insertNewObjectForEntityForName:@"LocLocLink"
                                  inManagedObjectContext:context];
        [self populateLocLocLink:self.locationIUR fromLocationIUR:self.fromLocationIUR customerCode:fieldValue LocLocLink:locLocLink];
        [[ArcosCoreData sharedArcosCoreData] saveContext:[ArcosCoreData sharedArcosCoreData].addManagedObjectContext];
    }
    NSString* message = [NSString stringWithFormat:@"New %@ has been created.",[GlobalSharedClass shared].accountNoText];
    [ArcosUtils showDialogBox:message title:@"" delegate:self target:self tag:0 handler:^(UIAlertAction *action) {
        [self alertActionCallBack];
    }];
}

#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0){
        //Code that will run after you press ok button
        [self alertActionCallBack];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.displayList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"IdAccountNumberTableCell";
    
    AccountNumberTableCell *cell=(AccountNumberTableCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil) {
        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"AccountNumberTableCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[AccountNumberTableCell class]] && [[(AccountNumberTableCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell= (AccountNumberTableCell *) nibItem;
                cell.delegate = self;
            }
        }
	}
    
    // Configure the cell...
    
    return cell;
}

#pragma mark GenericTextViewInputTableCellDelegate
- (void)inputFinishedWithData:(id)data forIndexpath:(NSIndexPath *)theIndexpath {
    NSMutableDictionary* dataDict = [self.displayList objectAtIndex:theIndexpath.row];
    [dataDict setObject:data forKey:@"fieldValue"];
}

- (void)populateLocLocLink:(NSNumber*)aLocationIUR fromLocationIUR:(NSNumber*)aFromLocationIUR customerCode:(NSString*)aCustomerCode LocLocLink:(LocLocLink*)LocLocLink {
    LocLocLink.LocationIUR = aLocationIUR;
    LocLocLink.FromLocationIUR = aFromLocationIUR;
    LocLocLink.CustomerCode = aCustomerCode;
}

- (void)alertActionCallBack {
    NSMutableDictionary* dataDict = [self.displayList objectAtIndex:0];
    NSMutableDictionary* tmpPickerDataDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [tmpPickerDataDict setObject:[dataDict objectForKey:@"fieldValue"] forKey:@"acctNo"];
    [tmpPickerDataDict setObject:[dataDict objectForKey:@"fieldValue"] forKey:@"Title"];
    [self.refreshDelegate refreshParentContentWithData:tmpPickerDataDict];
    [self backPressed:nil];
}

@end
