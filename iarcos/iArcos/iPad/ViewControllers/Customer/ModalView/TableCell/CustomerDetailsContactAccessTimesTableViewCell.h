//
//  CustomerDetailsContactAccessTimesTableViewCell.h
//  iArcos
//
//  Created by David Kilmartin on 30/09/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArcosCoreData.h"
#import "CustomerInfoAccessTimesCalendarTableViewController.h"

@interface CustomerDetailsContactAccessTimesTableViewCell : UITableViewCell <GenericSelectionCancelDelegate, CustomerInfoAccessTimesCalendarTableViewControllerDelegate, UIPopoverControllerDelegate>{
    id<CustomerInfoAccessTimesCalendarTableViewControllerDelegate> _actionDelegate;
    UILabel* _infoTitle;
    UILabel* _infoValue;
    UIButton* _actionBtn;
    NSMutableDictionary* _cellData;
    UIPopoverController* _accessTimesCalendarPopover;
    NSString* _typeCode;
}

@property(nonatomic, assign) id<CustomerInfoAccessTimesCalendarTableViewControllerDelegate> actionDelegate;
@property(nonatomic, retain) IBOutlet UILabel* infoTitle;
@property(nonatomic, retain) IBOutlet UILabel* infoValue;
@property(nonatomic, retain) IBOutlet UIButton* actionBtn;
@property(nonatomic, retain) NSMutableDictionary* cellData;
@property(nonatomic, retain) UIPopoverController* accessTimesCalendarPopover;
@property(nonatomic, retain) NSString* typeCode;

- (void)configCellWithData:(NSMutableDictionary*)aCustDict code:(NSString*)aCode;
- (IBAction)showAccessTimesCalendar;

@end
