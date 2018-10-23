//
//  UtilitiesConfigurationTableCell.h
//  iArcos
//
//  Created by David Kilmartin on 23/04/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GenericTextViewInputTableCellDelegate.h"

@interface UtilitiesConfigurationTableCell : UITableViewCell {
    UILabel* _detail;
    UILabel* _tooltip;
    UISwitch* _toggleSwitch;
    id<GenericTextViewInputTableCellDelegate> _myDelegate;
    NSIndexPath* _myIndexPath;
}

@property(nonatomic, retain) IBOutlet UILabel* detail;
@property(nonatomic, retain) IBOutlet UILabel* tooltip;
@property(nonatomic, retain) IBOutlet UISwitch* toggleSwitch;
@property(nonatomic, assign) id<GenericTextViewInputTableCellDelegate> myDelegate;
@property(nonatomic, retain) NSIndexPath* myIndexPath;

- (IBAction)updateSwitchValue:(id)sender;

@end
