//
//  ArcosCalendarTableViewController.h
//  iArcos
//
//  Created by Richard on 15/03/2022.
//  Copyright © 2022 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArcosCalendarTableDataManager.h"
#import "ArcosCalendarTableViewCell.h"
#import "ArcosCalendarTableHeaderView.h"
@class ArcosRootViewController;
#import "MBProgressHUD.h"

@interface ArcosCalendarTableViewController : UITableViewController {
    ArcosCalendarTableDataManager* _arcosCalendarTableDataManager;
    ArcosCalendarTableHeaderView* _arcosCalendarTableHeaderView;
    ArcosRootViewController* _arcosRootViewController;
    MBProgressHUD* _HUD;
}

@property(nonatomic, retain) ArcosCalendarTableDataManager* arcosCalendarTableDataManager;
@property(nonatomic, retain) IBOutlet ArcosCalendarTableHeaderView* arcosCalendarTableHeaderView;
@property(nonatomic, retain) ArcosRootViewController* arcosRootViewController;
@property(nonatomic, retain) MBProgressHUD* HUD;

@end


