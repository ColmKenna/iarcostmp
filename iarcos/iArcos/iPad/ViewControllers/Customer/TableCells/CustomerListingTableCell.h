//
//  CustomerListingTableCell.h
//  iArcos
//
//  Created by David Kilmartin on 08/12/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerListingTableCell : UITableViewCell {
    UILabel* _nameLabel;
    UILabel* _addressLabel;
    UIButton* _locationStatusButton;
    UIButton* _creditStatusButton;
    UILabel* _locationCodeLabel;
}

@property(nonatomic, retain) IBOutlet UILabel* nameLabel;
@property(nonatomic, retain) IBOutlet UILabel* addressLabel;
@property(nonatomic, retain) IBOutlet UIButton* locationStatusButton;
@property(nonatomic, retain) IBOutlet UIButton* creditStatusButton;
@property(nonatomic, retain) IBOutlet UILabel* locationCodeLabel;

@end
