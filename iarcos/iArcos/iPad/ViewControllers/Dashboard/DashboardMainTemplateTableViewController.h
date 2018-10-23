//
//  DashboardMainTemplateTableViewController.h
//  iArcos
//
//  Created by David Kilmartin on 11/04/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DashboardMainTemplateDataManager.h"
#import "DashboardMainTemplateTableViewCell.h"
#import "TwoBarViewController.h"
#import "DashboardPdfViewController.h"
#import "DashboardGenericTableViewController.h"

@interface DashboardMainTemplateTableViewController : UITableViewController <DashboardMainTemplateTableViewCellDelegate>{
    DashboardMainTemplateDataManager* _dashboardMainTemplateDataManager;
}

@property(nonatomic, retain) DashboardMainTemplateDataManager* dashboardMainTemplateDataManager;

@end
