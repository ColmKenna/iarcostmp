//
//  DashboardGenericTableViewController.h
//  iArcos
//
//  Created by David Kilmartin on 15/05/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DashboardGenericDataManager.h"
#import "DashboardGenericTableViewCell.h"

@interface DashboardGenericTableViewController : UITableViewController {
    DashboardGenericDataManager* _dashboardGenericDataManager;
}

@property(nonatomic, retain) DashboardGenericDataManager* dashboardGenericDataManager;

@end
