//
//  CustomerTyvLyModalViewController.h
//  Arcos
//
//  Created by David Kilmartin on 15/12/2011.
//  Copyright (c) 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CallGenericServices.h"
#import "ArcosUtils.h"
#import "CustomerTyvLyTableCell.h"
#import "ConnectivityCheck.h"
#import "SlideAcrossViewAnimationDelegate.h"
#import "ArcosConfigDataManager.h"
#import "CustomerTyvLyDataManager.h"

@interface CustomerTyvLyModalViewController : UITableViewController <GetDataGenericDelegate>{
    id<SlideAcrossViewAnimationDelegate> _animateDelegate;
    IBOutlet UIView* tableHeader;
    IBOutlet UIView* tableHeader2;    
    IBOutlet UITableView* tableListView;
//    NSMutableArray* displayList;
    NSNumber* locationIUR;
//    UIActivityIndicatorView* activityIndicator;
    CallGenericServices* callGenericServices;
    int columnQty;
    //connectivity check
    ConnectivityCheck* connectivityCheck;
    CustomerTyvLyDataManager* _customerTyvLyDataManager;
}

@property (nonatomic, assign) id<SlideAcrossViewAnimationDelegate> animateDelegate;
@property (nonatomic, retain) IBOutlet UIView* tableHeader;
@property (nonatomic, retain) IBOutlet UIView* tableHeader2;
@property (nonatomic,retain)  IBOutlet UITableView* tableListView;
//@property (nonatomic,retain)  NSMutableArray* displayList;
@property (nonatomic,retain)  NSNumber* locationIUR;
@property (nonatomic, assign) int columnQty;
@property (nonatomic,retain) CustomerTyvLyDataManager* customerTyvLyDataManager;

- (UITableViewCell *)initColumn15TableViewCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
