//
//  FlagsSelectedContactTableViewController.m
//  iArcos
//
//  Created by Richard on 05/10/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import "FlagsSelectedContactTableViewController.h"

@interface FlagsSelectedContactTableViewController ()

@end

@implementation FlagsSelectedContactTableViewController
@synthesize actionDelegate = _actionDelegate;
@synthesize flagsSelectedContactDataManager = _flagsSelectedContactDataManager;
@synthesize globalWidgetViewController = _globalWidgetViewController;
@synthesize widgetFactory = _widgetFactory;
@synthesize flagsButton = _flagsButton;
@synthesize arcosService = _arcosService;

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.flagsSelectedContactDataManager = [[[FlagsSelectedContactDataManager alloc] init] autorelease];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.widgetFactory = [WidgetFactory factory];
    self.widgetFactory.delegate = self;
    
    self.flagsButton = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"flags_banner.png"] style:UIBarButtonItemStylePlain target:self action:@selector(flagsButtonPressed)] autorelease];
    NSMutableArray* buttonList = [NSMutableArray arrayWithObjects:self.flagsButton, nil];
    [self.navigationItem setRightBarButtonItems:buttonList];
    self.arcosService = [ArcosService service];
}

- (void)flagsButtonPressed {
    [self.flagsSelectedContactDataManager retrieveContactFlagData];
    NSMutableDictionary* miscDataDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [miscDataDict setObject:@"Contact Flag" forKey:@"Title"];
    self.globalWidgetViewController = [self.widgetFactory CreateTargetGenericCategoryWidgetWithPickerValue:self.flagsSelectedContactDataManager.contactFlagDictList miscDataDict:miscDataDict];
    if (self.globalWidgetViewController != nil) {
        self.globalWidgetViewController.modalPresentationStyle = UIModalPresentationPopover;
        self.globalWidgetViewController.popoverPresentationController.barButtonItem = self.flagsButton;
        self.globalWidgetViewController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
        self.globalWidgetViewController.popoverPresentationController.delegate = self;
        [self presentViewController:self.globalWidgetViewController animated:YES completion:nil];
    }
}

- (void)dealloc {
    self.flagsSelectedContactDataManager = nil;
    self.globalWidgetViewController = nil;
    self.widgetFactory = nil;
    self.flagsButton = nil;
    self.arcosService = nil;
    
    [super dealloc];
}

#pragma mark - WidgetFactoryDelegate
- (void)operationDone:(id)data {    
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.flagsSelectedContactDataManager.displayList count] == 0) {
            [ArcosUtils showDialogBox:@"Please select a contact" title:@"" target:self handler:nil];
            return;
        }
        [[self.actionDelegate retrieveProgressHUDFromParentViewController] show:YES];
        NSNumber* flagiur = [data objectForKey:@"DescrDetailIUR"];
        NSNumber* employeeIUR = [SettingManager employeeIUR];
        NSMutableString* contactiurNodeString = [NSMutableString string];
        for (int i = 0; i < [self.flagsSelectedContactDataManager.displayList count]; i++) {
            NSMutableDictionary* tmpContactDict = [self.flagsSelectedContactDataManager.displayList objectAtIndex:i];
            [contactiurNodeString appendFormat:@"<int>%@</int>",[tmpContactDict objectForKey:@"IUR"]];
        }
        
        [self.arcosService GlobalFlagAssignment:self action:@selector(backFromGlobalFlagAssignment:) type:@"C" addremoveoption:@"Add" flagiur:[flagiur intValue] iurs:contactiurNodeString employeeiur:[employeeIUR intValue]];
    }];
}

- (void)backFromGlobalFlagAssignment:(id)aResult {
    if ([aResult isKindOfClass:[NSError class]]) {
        NSError* anError = (NSError*)aResult;
        [ArcosUtils showDialogBox:[NSString stringWithFormat:@"%@",[anError localizedDescription]] title:@"" target:[self.actionDelegate retrieveSelectedContactParentViewController] handler:nil];
    } else if ([aResult isKindOfClass:[SoapFault class]]) {
        SoapFault* aSoapFault = (SoapFault*)aResult;
        [ArcosUtils showDialogBox:[NSString stringWithFormat:@"%@",[aSoapFault faultString]] title:@"" target:[self.actionDelegate retrieveSelectedContactParentViewController] handler:nil];
    } else {
        ArcosGenericReturnObject* replyResult = (ArcosGenericReturnObject*)aResult;
        if ([replyResult.ArrayOfData count] > 0) {
            ArcosGenericClass* arcosGenericClass = [replyResult.ArrayOfData objectAtIndex:0];
            [ArcosUtils showDialogBox:[ArcosUtils trim:[NSString stringWithFormat:@"%@ %@", arcosGenericClass.Field2, arcosGenericClass.Field1]] title:@"" target:[self.actionDelegate retrieveSelectedContactParentViewController] handler:nil];
        }
    }
    [[self.actionDelegate retrieveProgressHUDFromParentViewController] hide:YES];
}

- (BOOL)allowToShowAddContactFlagButton {
    return YES;
}

#pragma mark UIPopoverPresentationControllerDelegate
- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    self.globalWidgetViewController = nil;
}

- (void)resetSelectedContact:(NSMutableArray*)aContactList {
    self.flagsSelectedContactDataManager.displayList = aContactList;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.flagsSelectedContactDataManager.displayList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    NSMutableDictionary* tmpContactDict = [self.flagsSelectedContactDataManager.displayList objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [tmpContactDict objectForKey:@"LocationName"];
    cell.detailTextLabel.text = [tmpContactDict objectForKey:@"Name"];
    
    for (UIGestureRecognizer* recognizer in cell.contentView.gestureRecognizers) {
        [cell.contentView removeGestureRecognizer:recognizer];
    }
    UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapGesture:)];
    doubleTap.numberOfTapsRequired = 2;
    [cell.contentView addGestureRecognizer:doubleTap];
    [doubleTap release];
    
    return cell;
}

- (void)handleDoubleTapGesture:(id)sender {
    UITapGestureRecognizer* recognizer = (UITapGestureRecognizer*)sender;
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        NSIndexPath* swipedIndexPath = [ArcosUtils indexPathWithRecognizer:recognizer tableview:self.tableView];
        NSMutableDictionary* tmpContactDict = [self.flagsSelectedContactDataManager.displayList objectAtIndex:swipedIndexPath.row];
        [tmpContactDict setObject:[NSNumber numberWithBool:NO] forKey:@"IsSelected"];
        [self.actionDelegate didSelectFlagsSelectedContactRecord:tmpContactDict];
    }
}

@end
