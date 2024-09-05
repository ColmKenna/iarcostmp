//
//  FormRowsFooterMatTableViewController.m
//  iArcos
//
//  Created by Richard on 12/08/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import "FormRowsFooterMatTableViewController.h"

@interface FormRowsFooterMatTableViewController ()

@end

@implementation FormRowsFooterMatTableViewController
@synthesize formRowsFooterMatDataManager = _formRowsFooterMatDataManager;
@synthesize formRowsFooterMatHeaderView = _formRowsFooterMatHeaderView;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.formRowsFooterMatDataManager = [[[FormRowsFooterMatDataManager alloc] init] autorelease];
        [self.formRowsFooterMatDataManager createBasicData];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)dealloc {
    self.formRowsFooterMatDataManager = nil;
    self.formRowsFooterMatHeaderView = nil;
    
    [super dealloc];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.formRowsFooterMatDataManager.displayList count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    @try {
        if (self.formRowsFooterMatDataManager.matDataFoundFlag) {
            for (int i = 0; i < 12; i++) {
                NSString* methodNameString = [NSString stringWithFormat:@"monthLabel%d", i];
                SEL methodSelector = NSSelectorFromString(methodNameString);
                NSString* valueNameString = [NSString stringWithFormat:@"setText:"];
                SEL valueSelector = NSSelectorFromString(valueNameString);
                [[self.formRowsFooterMatHeaderView performSelector:methodSelector] performSelector:valueSelector withObject:[self.formRowsFooterMatDataManager.headerMonthList objectAtIndex:i]];
            }
        } else {
            for (int i = 0; i < 12; i++) {
                NSString* methodNameString = [NSString stringWithFormat:@"monthLabel%d", i];
                SEL methodSelector = NSSelectorFromString(methodNameString);
                NSString* valueNameString = [NSString stringWithFormat:@"setText:"];
                SEL valueSelector = NSSelectorFromString(valueNameString);
                [[self.formRowsFooterMatHeaderView performSelector:methodSelector] performSelector:valueSelector withObject:@""];
            }
        }
    } @catch (NSException *exception) {
        NSLog(@"%@", [exception reason]);
    }
    return self.formRowsFooterMatHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 29;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 29;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    static NSString* CellIdentifier = @"IdFormRowsFooterMatTableViewCell";
    
    FormRowsFooterMatTableViewCell* cell = (FormRowsFooterMatTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"FormRowsFooterMatTableViewCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[FormRowsFooterMatTableViewCell class]] && [[(FormRowsFooterMatTableViewCell*)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell = (FormRowsFooterMatTableViewCell *) nibItem;
            }
        }
    }
    // Configure the cell...
    NSMutableDictionary* cellData = [self.formRowsFooterMatDataManager.displayList objectAtIndex:indexPath.row];
    
    [cell configCellWithData:cellData matDataFoundFlag:self.formRowsFooterMatDataManager.matDataFoundFlag];
    return cell;
}










@end
