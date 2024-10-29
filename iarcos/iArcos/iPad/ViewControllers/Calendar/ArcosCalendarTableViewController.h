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
#import "ArcosCalendarEventEntryDetailTableViewController.h"
#import "ArcosService.h"
#import "ArcosCalendarEventEntryDetailTemplateViewController.h"
#import "CustomerJourneyDataManager.h"

@interface ArcosCalendarTableViewController : UITableViewController <ArcosCalendarTableViewCellDelegate, ModalPresentViewControllerDelegate, ArcosCalendarEventEntryDetailTemplateViewControllerDelegate, ArcosCalendarCellBaseTableViewDataManagerDelegate>{
    ArcosCalendarTableDataManager* _arcosCalendarTableDataManager;
    ArcosCalendarTableHeaderView* _arcosCalendarTableHeaderView;
    ArcosRootViewController* _arcosRootViewController;
    MBProgressHUD* _HUD;
    ArcosService* _arcosService;
    CustomerJourneyDataManager* _customerJourneyDataManager;
    UINavigationController* _globalNavigationController;
    UtilitiesMailDataManager* _utilitiesMailDataManager;
}

@property(nonatomic, retain) ArcosCalendarTableDataManager* arcosCalendarTableDataManager;
@property(nonatomic, retain) IBOutlet ArcosCalendarTableHeaderView* arcosCalendarTableHeaderView;
@property(nonatomic, retain) ArcosRootViewController* arcosRootViewController;
@property(nonatomic, retain) MBProgressHUD* HUD;
@property(nonatomic, retain) ArcosService* arcosService;
@property(nonatomic, retain) CustomerJourneyDataManager* customerJourneyDataManager;
@property(nonatomic, retain) UINavigationController* globalNavigationController;
@property(nonatomic, retain) UtilitiesMailDataManager* utilitiesMailDataManager;

@end


