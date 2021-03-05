//
//  MeetingLocationTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 02/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "MeetingLocationTableViewCell.h"

@implementation MeetingLocationTableViewCell
@synthesize fieldNameLabel = _fieldNameLabel;
@synthesize fieldValueTextField = _fieldValueTextField;
@synthesize searchButton = _searchButton;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.fieldNameLabel = nil;
    self.fieldValueTextField = nil;
    self.searchButton = nil;
    
    [super dealloc];
}

- (void)configCellWithData:(NSMutableDictionary *)aCellData {
    [super configCellWithData:aCellData];
    self.fieldNameLabel.text = [aCellData objectForKey:@"FieldName"];
    self.fieldValueTextField.text = [aCellData objectForKey:@"FieldData"];
}

- (IBAction)searchButtonPressed:(id)sender {
    CustomerSelectionListingTableViewController* CSLTVC = [[CustomerSelectionListingTableViewController alloc] initWithNibName:@"CustomerSelectionListingTableViewController" bundle:nil];
    CSLTVC.selectionDelegate = self;
    CSLTVC.isNotShowingAllButton = YES;
    NSMutableArray* locationList = [[ArcosCoreData sharedArcosCoreData]outletsWithMasterIUR:[NSNumber numberWithInt:-1] withResultType:NSDictionaryResultType];
    [CSLTVC resetCustomer:locationList];
    UINavigationController* tmpNavigationController = [[UINavigationController alloc] initWithRootViewController:CSLTVC];
    tmpNavigationController.preferredContentSize = CGSizeMake(700.0f, 700.0f);
    tmpNavigationController.modalPresentationStyle = UIModalPresentationPopover;
    tmpNavigationController.popoverPresentationController.sourceView = self.searchButton;
    [[self.actionDelegate retrieveMeetingMainViewController] presentViewController:tmpNavigationController animated:YES completion:nil];
    [CSLTVC release];
    [tmpNavigationController release];
}

#pragma mark CustomerSelectionListingDelegate
- (void)didDismissSelectionPopover {
    [[self.actionDelegate retrieveMeetingMainViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)didSelectCustomerSelectionListingRecord:(NSMutableDictionary*)aCustDict {
    //    NSLog(@"aCustDict %@", aCustDict);
    self.fieldValueTextField.text = [NSString stringWithFormat:@"%@ - %@",[ArcosUtils convertNilToEmpty:[aCustDict objectForKey:@"Name"]], [ArcosUtils convertNilToEmpty:[aCustDict objectForKey:@"Address1"]]];
    [self.actionDelegate meetingBaseInputFinishedWithData:self.fieldValueTextField.text atIndexPath:self.myIndexPath];
    [self.actionDelegate updateMeetingLocationIUR:[aCustDict objectForKey:@"LocationIUR"]];
    [[self.actionDelegate retrieveMeetingMainViewController] dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.actionDelegate meetingBaseInputFinishedWithData:textField.text atIndexPath:self.myIndexPath];
    [self.actionDelegate updateMeetingLocationIUR:[NSNumber numberWithInt:0]];
}


@end
