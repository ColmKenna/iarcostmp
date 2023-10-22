//
//  FlagsContactFlagTableViewController.m
//  iArcos
//
//  Created by Richard on 16/10/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import "FlagsContactFlagTableViewController.h"

@interface FlagsContactFlagTableViewController ()

@end

@implementation FlagsContactFlagTableViewController
@synthesize actionDelegate = _actionDelegate;
@synthesize refreshDelegate = _refreshDelegate;
@synthesize callGenericServices = _callGenericServices;
@synthesize flagsContactFlagDataManager = _flagsContactFlagDataManager;

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.flagsContactFlagDataManager = [[[FlagsContactFlagDataManager alloc] init] autorelease];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.callGenericServices = [[[CallGenericServices alloc] initWithView:self.navigationController.view] autorelease];
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backPressed:)];
    [self.navigationItem setLeftBarButtonItem:backButton];
    [backButton release];
    UIBarButtonItem* saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(savePressed:)];
    [self.navigationItem setRightBarButtonItem:saveButton];
    [saveButton release];
    
    [self.flagsContactFlagDataManager createBasicData];
}

- (void)dealloc {
    self.callGenericServices = nil;
    self.flagsContactFlagDataManager = nil;
    
    [super dealloc];
}

- (void)backPressed:(id)sender {
    [self.actionDelegate didDismissModalView];
}

- (void)savePressed:(id)sender {
    [self.view endEditing:YES];
    NSMutableDictionary* dataDict = [self.flagsContactFlagDataManager.displayList objectAtIndex:0];
    NSString* fieldValue = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:[dataDict objectForKey:@"fieldValue"]]];
    if ([fieldValue isEqualToString:@""]) {
        [ArcosUtils showDialogBox:@"Details should not be empty." title:@"" target:self handler:nil];
        return;
    }
    self.flagsContactFlagDataManager.ACRO = [[[ArcosCreateRecordObject alloc] init] autorelease];
    NSMutableArray* fieldNameList = [NSMutableArray arrayWithCapacity:2];
    NSMutableArray* fieldValueList = [NSMutableArray arrayWithCapacity:2];
    [fieldNameList addObject:@"DescrTypeCode"];
    [fieldValueList addObject:@"CF"];
    [fieldNameList addObject:@"DescrDetailCode"];
    
    NSDictionary* employeeDict = [[ArcosCoreData sharedArcosCoreData] employeeWithIUR:[SettingManager employeeIUR]];
    NSString* employeeInitials = @"";
    NSString* foreName = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:[employeeDict objectForKey:@"ForeName"]]];
    NSString* foreNameInitial = @"";
    if (foreName.length > 0) {
        foreNameInitial = [foreName substringToIndex:1];
    }
    NSString* surname = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:[employeeDict objectForKey:@"Surname"]]];
    NSString* surnameInitial = @"";
    if (surname.length > 0) {
        surnameInitial = [surname substringToIndex:1];
    }
    employeeInitials = [NSString stringWithFormat:@"%@%@",foreNameInitial,surnameInitial];
    NSString* customiseDescrDetailCode = [NSString stringWithFormat:@"%@%@",employeeInitials, [ArcosUtils stringFromDate:[NSDate date] format:@"ddMMyyHHmm"]];
    [fieldValueList addObject:customiseDescrDetailCode];
    [fieldNameList addObject:@"Details"];
    [fieldValueList addObject:fieldValue];
    [fieldNameList addObject:@"Active"];
    [fieldValueList addObject:@"1"];
    self.flagsContactFlagDataManager.ACRO.FieldNames = fieldNameList;
    self.flagsContactFlagDataManager.ACRO.FieldValues = fieldValueList;
    [self.callGenericServices genericCreateRecord:@"DescrDetail" fields:self.flagsContactFlagDataManager.ACRO action:@selector(backFromCreateRecordResult:) target:self];
}

- (void)backFromCreateRecordResult:(id)result {
    result = [self.callGenericServices handleResultErrorProcess:result];
    if (result == nil) {
        return;
    }
    ArcosGenericClass* replyResult = (ArcosGenericClass*)result;
    if (replyResult.Field1 != nil && ![replyResult.Field1 isEqualToString:@""] && ![replyResult.Field1 isEqualToString:@"0"]) {
        NSNumber* resDescrDetailIUR = [ArcosUtils convertStringToNumber:replyResult.Field1];
        [self.flagsContactFlagDataManager contactFlagWithFieldNameList:self.flagsContactFlagDataManager.ACRO.FieldNames fieldValueList:self.flagsContactFlagDataManager.ACRO.FieldValues iur:resDescrDetailIUR];
        [self.refreshDelegate refreshParentContentWithContactFlagIUR:resDescrDetailIUR];
        NSString* message = @"New contact flag has been created.";
        [ArcosUtils showDialogBox:message title:@"" target:self handler:^(UIAlertAction *action) {
            [self.actionDelegate didDismissModalView];
        }];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.flagsContactFlagDataManager.displayList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* CellIdentifier = @"IdFlagsContactFlagTableViewCell";
    
    FlagsContactFlagTableViewCell* cell = (FlagsContactFlagTableViewCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"FlagsContactFlagTableViewCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[FlagsContactFlagTableViewCell class]] && [[(FlagsContactFlagTableViewCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell= (FlagsContactFlagTableViewCell*)nibItem;
                cell.delegate = self;
            }
        }
    }
    
    // Configure the cell...
    cell.indexPath = indexPath;
    return cell;
}

#pragma mark - GenericTextInputTableViewCellDelegate
- (void)inputFinishedWithData:(NSString*)aData forIndexPath:(NSIndexPath*)anIndexPath {
    NSMutableDictionary* dataDict = [self.flagsContactFlagDataManager.displayList objectAtIndex:anIndexPath.row];
    [dataDict setObject:aData forKey:@"fieldValue"];
}

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/



@end
