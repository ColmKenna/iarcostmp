//
//  OrderMasterViewController.h
//  Arcos
//
//  Created by David Kilmartin on 11/07/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubstitutableDetailViewController.h"
#import "OrderDetailViewController.h"
#import "PreviousOrderDetailViewController.h"
#import "SavedOrderDetailViewController.h"
#import "PlaceOrderDetailViewController.h"
#import "OrderFormTableViewController.h"
#import "FormRowsTableViewController.h"

@interface OrderMasterViewController : UITableViewController<UISplitViewControllerDelegate,UIActionSheetDelegate> {
    //OrderDetailViewController* myOrderDetailViewController;
    
    UISplitViewController *splitViewController;
    
    UIPopoverController *popoverController;    
    UIBarButtonItem *rootPopoverButtonItem;
    
    NSArray* tableRows;
    IBOutlet UIView* headerView;
    
    //header view outlet
    IBOutlet UILabel* locationName;
    IBOutlet UILabel* locationAddress;
    IBOutlet UILabel* locationPhone;
    
    //detail view ref
    UITableViewController* detailView;
}
//@property(nonatomic,retain) OrderDetailViewController* myOrderDetailViewController;

@property (nonatomic, assign) IBOutlet UISplitViewController *splitViewController;

@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) UIBarButtonItem *rootPopoverButtonItem;

@property (nonatomic, retain) IBOutlet UIView* headerView;

//header view outlet
@property (nonatomic, retain) IBOutlet UILabel* locationName;
@property (nonatomic, retain) IBOutlet UILabel* locationAddress;
@property (nonatomic, retain) IBOutlet UILabel* locationPhone;

//detail view ref
@property (nonatomic, retain) UITableViewController* detailView;

- (IBAction)allOnHeaderViewPressed:(id)sender;
@end
