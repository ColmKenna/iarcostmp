//
//  CustomerGDPRTableCell.h
//  iArcos
//
//  Created by David Kilmartin on 11/05/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerGDPRTableCellDelegate.h"

@interface CustomerGDPRTableCell : UITableViewCell {
    id<CustomerGDPRTableCellDelegate> _actionDelegate;
    UILabel* _fieldDesc;
    UIButton* _radioButton;
    NSIndexPath* _indexPath;
}

@property(nonatomic, assign) id<CustomerGDPRTableCellDelegate> actionDelegate;
@property(nonatomic, retain) IBOutlet UILabel* fieldDesc;
@property(nonatomic, retain) IBOutlet UIButton* radioButton;
@property(nonatomic, retain) NSIndexPath* indexPath;

- (void)configCellWithData:(NSMutableDictionary*)aCellData;
- (IBAction)radioButtonPressed:(id)sender;

@end
