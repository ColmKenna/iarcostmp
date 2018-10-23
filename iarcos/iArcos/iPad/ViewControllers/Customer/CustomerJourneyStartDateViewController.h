//
//  CustomerJourneyStartDateViewController.h
//  Arcos
//
//  Created by David Kilmartin on 06/06/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CallGenericServices.h"
#import "ArcosCoreData.h"
#import "CustomerJourneyStartDateDataManager.h"
#import "CustomerJourneyStartDateTableCell.h"

@protocol CustomerJourneyStartDateDelegate <NSObject>

- (void)dismissJourneyStartDatePopoverController;
- (void)refreshParentContentForJourneyStartDate;

@end

@interface CustomerJourneyStartDateViewController : UIViewController<GetDataGenericDelegate, UITableViewDelegate, UITableViewDataSource, CustomerJourneyStartDateTableCellDelegate> {
    UITableView* _myTableView;
    UINavigationItem* _myNavigationItem;
    UIBarButtonItem* _saveButton;
    CallGenericServices* _callGenericServices;
    UIBarButtonItem* _updateButton;
    id<CustomerJourneyStartDateDelegate> _delegate;
    CustomerJourneyStartDateDataManager* _customerJourneyStartDateDataManager;
}

@property (nonatomic, retain) IBOutlet UITableView* myTableView;
@property (nonatomic, retain) IBOutlet UINavigationItem* myNavigationItem;
@property (nonatomic, retain) UIBarButtonItem* saveButton;
@property (nonatomic, retain) CallGenericServices* callGenericServices;
@property (nonatomic, retain) UIBarButtonItem* updateButton;
@property (nonatomic, assign) id<CustomerJourneyStartDateDelegate> delegate;
@property (nonatomic, retain) CustomerJourneyStartDateDataManager* customerJourneyStartDateDataManager;

@end
