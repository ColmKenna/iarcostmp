//
//  MeetingAttendeesOthersItemTableViewController.m
//  iArcos
//
//  Created by David Kilmartin on 08/03/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import "MeetingAttendeesOthersItemTableViewController.h"

@interface MeetingAttendeesOthersItemTableViewController ()

@end

@implementation MeetingAttendeesOthersItemTableViewController
@synthesize displayList = _displayList;
@synthesize actionDelegate = _actionDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonPressed)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    [cancelButton release];
    
    UIBarButtonItem* saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveButtonPressed)];
    self.navigationItem.rightBarButtonItem = saveButton;
    [saveButton release];
    [self createBasicData];
}

- (void)dealloc {
    self.displayList = nil;
    
    [super dealloc];
}

- (void)cancelButtonPressed {
    [self.actionDelegate didDismissOthersItemPopover];
}

- (void)saveButtonPressed {
    [self.view endEditing:YES];
    NSMutableDictionary* nameDataDict = [self.displayList objectAtIndex:0];
    NSString* name = [nameDataDict objectForKey:@"FieldData"];
    NSMutableDictionary* organisationDataDict = [self.displayList objectAtIndex:1];
    NSString* organisation = [organisationDataDict objectForKey:@"FieldData"];
    [self.actionDelegate saveButtonPressedWithName:name organisation:organisation];
    [self.actionDelegate didDismissOthersItemPopover];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.displayList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* otherItemCellIdentifier = @"IdMeetingAttendeesOthersItemTableViewCell";
    NSMutableDictionary* auxOtherItemCellData = [self.displayList objectAtIndex:indexPath.row];
    MeetingAttendeesOthersItemTableViewCell* cell = (MeetingAttendeesOthersItemTableViewCell*)[tableView dequeueReusableCellWithIdentifier:otherItemCellIdentifier];
    if (cell == nil) {
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"MeetingAttendeesOthersItemTableViewCell" owner:self options:nil];

        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[MeetingAttendeesOthersItemTableViewCell class]] && [[(MeetingAttendeesOthersItemTableViewCell*)nibItem reuseIdentifier] isEqualToString:otherItemCellIdentifier]) {
                cell = (MeetingAttendeesOthersItemTableViewCell*)nibItem;
            }
        }
    }

    // Configure the cell...
    cell.actionDelegate = self;
    cell.myIndexPath = indexPath;
    [cell configCellWithData:auxOtherItemCellData];
    
    return cell;
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

- (void)createBasicData {
    self.displayList = [NSMutableArray arrayWithCapacity:2];
    [self.displayList addObject:[self createTextFieldDataWithFieldName:@"Name"]];
    [self.displayList addObject:[self createTextFieldDataWithFieldName:@"Organisation"]];
}

- (NSMutableDictionary*)createTextFieldDataWithFieldName:(NSString*)aFieldName {
    NSMutableDictionary* auxCellDataDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [auxCellDataDict setObject:aFieldName forKey:@"FieldName"];
    [auxCellDataDict setObject:@"" forKey:@"FieldData"];
    
    return auxCellDataDict;
}

#pragma mark MeetingAttendeesOthersItemTableViewCellDelegate
- (void)inputFinishedWithData:(NSString *)aData atIndexPath:(NSIndexPath *)anIndexPath {
    NSMutableDictionary* tmpCellDataDict = [self.displayList objectAtIndex:anIndexPath.row];
    [tmpCellDataDict setObject:aData forKey:@"FieldData"];
}

@end
