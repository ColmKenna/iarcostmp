//
//  CustomerCalendarListTableViewController.h
//  iArcos
//
//  Created by Richard on 04/04/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerBaseDetailViewController.h"
#import "MBProgressHUD.h"
#import "CustomerCalendarListDataManager.h"
#import "ArcosConstantsDataManager.h"
#import "CustomerCalendarListTableViewCell.h"
#import "CustomerInfoTableViewController.h"
#import "CustomerCalendarListHeaderView.h"

@interface CustomerCalendarListTableViewController : CustomerBaseDetailViewController <CheckLocationIURTemplateDelegate, GenericRefreshParentContentDelegate>{
    MBProgressHUD* _HUD;
    CustomerCalendarListDataManager* _customerCalendarListDataManager;
    UISegmentedControl* _mySegmentedControl;
    CheckLocationIURTemplateProcessor* _checkLocationIURTemplateProcessor;
    CustomerCalendarListHeaderView* _customerCalendarListHeaderView;
}

@property(nonatomic,retain) MBProgressHUD* HUD;
@property(nonatomic,retain) CustomerCalendarListDataManager* customerCalendarListDataManager;
@property(nonatomic,retain) UISegmentedControl* mySegmentedControl;
@property (nonatomic, retain) CheckLocationIURTemplateProcessor* checkLocationIURTemplateProcessor;
@property (nonatomic, retain) IBOutlet CustomerCalendarListHeaderView* customerCalendarListHeaderView;

@end

