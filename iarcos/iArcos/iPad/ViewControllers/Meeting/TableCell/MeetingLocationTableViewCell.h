//
//  MeetingLocationTableViewCell.h
//  iArcos
//
//  Created by David Kilmartin on 02/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "MeetingBaseTableViewCell.h"
#import "CustomerSelectionListingTableViewController.h"

@interface MeetingLocationTableViewCell : MeetingBaseTableViewCell <CustomerSelectionListingDelegate, UITextFieldDelegate>{
    UILabel* _fieldNameLabel;
    UITextField* _fieldValueTextField;
    UIButton* _searchButton;
}

@property(nonatomic, retain) IBOutlet UILabel* fieldNameLabel;
@property(nonatomic, retain) IBOutlet UITextField* fieldValueTextField;
@property(nonatomic, retain) IBOutlet UIButton* searchButton;

- (IBAction)searchButtonPressed:(id)sender;

@end

