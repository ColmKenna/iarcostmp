//
//  CustomerInfoButtonCell.h
//  Arcos
//
//  Created by David Kilmartin on 12/01/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerInfoAccountBalanceDetailTableViewController.h"
#import "CustomerInfoButtonCellDelegate.h"

@interface CustomerInfoButtonCell : UITableViewCell<GenericSelectionCancelDelegate, UIPopoverPresentationControllerDelegate> {
    id<CustomerInfoButtonCellDelegate> _actionDelegate;
    UILabel* _infoTitle;
    UILabel* _infoValue;
    UIButton* _actionBtn;
    NSMutableDictionary* _cellData;
//    UIPopoverController* _accountDetailPopover;
}

@property(nonatomic,assign) id<CustomerInfoButtonCellDelegate> actionDelegate;
@property(nonatomic,retain) IBOutlet UILabel* infoTitle;
@property(nonatomic,retain) IBOutlet UILabel* infoValue;
@property(nonatomic,retain) IBOutlet UIButton* actionBtn;
@property(nonatomic,retain) NSMutableDictionary* cellData;
//@property(nonatomic,retain) UIPopoverController* accountDetailPopover;

- (IBAction)showAccountBalanceDetail;
- (void)configCellWithData:(NSMutableDictionary*)aCustDict;

@end
