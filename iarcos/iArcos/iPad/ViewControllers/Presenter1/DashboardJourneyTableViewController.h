//
//  DashboardJourneyTableViewController.h
//  iArcos
//
//  Created by David Kilmartin on 03/12/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerJourneyDataManager.h"
#import "DashboardJourneyTableViewCell.h"
#import "DashboardJourneyHeaderView.h"
@class ArcosRootViewController;

@interface DashboardJourneyTableViewController : UITableViewController {
    CustomerJourneyDataManager* _customerJourneyDataManager;
    DashboardJourneyHeaderView* _myHeaderView;
    ArcosRootViewController* _arcosRootViewController;
}

@property(nonatomic, retain) CustomerJourneyDataManager* customerJourneyDataManager;
@property(nonatomic, retain) IBOutlet DashboardJourneyHeaderView* myHeaderView;
@property(nonatomic, retain) ArcosRootViewController* arcosRootViewController;

@end
