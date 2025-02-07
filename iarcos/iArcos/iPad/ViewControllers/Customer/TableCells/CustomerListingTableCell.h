//
//  CustomerListingTableCell.h
//  iArcos
//
//  Created by David Kilmartin on 08/12/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderHeader.h"

@interface CustomerListingTableCell : UITableViewCell {
    UILabel* _nameLabel;
    UILabel* _addressLabel;
    UIButton* _locationStatusButton;
    UIButton* _creditStatusButton;
    UILabel* _locationCodeLabel;
    UILabel* _dateLabel;
    UILabel* _contactLabel;
    UITextView* _memoTextView;
    UILabel* _weekDayCallNumberLabel;
}

@property(nonatomic, retain) IBOutlet UILabel* nameLabel;
@property(nonatomic, retain) IBOutlet UILabel* addressLabel;
@property(nonatomic, retain) IBOutlet UIButton* locationStatusButton;
@property(nonatomic, retain) IBOutlet UIButton* creditStatusButton;
@property(nonatomic, retain) IBOutlet UILabel* locationCodeLabel;
@property(nonatomic, retain) IBOutlet UILabel* dateLabel;
@property(nonatomic, retain) IBOutlet UILabel* contactLabel;
@property(nonatomic, retain) IBOutlet UITextView* memoTextView;
@property(nonatomic, retain) IBOutlet UILabel* weekDayCallNumberLabel;

- (void)configCallInfoWithCallHeader:(OrderHeader*)aCallHeader;

@end
