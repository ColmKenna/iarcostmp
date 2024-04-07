//
//  ArcosCalendarEventEntryDetailTemplateViewController.h
//  iArcos
//
//  Created by Richard on 31/01/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModalPresentViewControllerDelegate.h"
#import "GlobalSharedClass.h"
#import "ArcosUtils.h"
#import "ArcosCalendarEventEntryDetailTableViewController.h"
#import "MBProgressHUD.h"
#import "ArcosCalendarEventEntryDetailTemplateViewControllerDelegate.h"
#import "ArcosCalendarEventEntryDetailListingDataManager.h"

@interface ArcosCalendarEventEntryDetailTemplateViewController : UIViewController <ArcosCalendarEventEntryDetailTableViewControllerDelegate, ArcosCalendarEventEntryDetailListingDataManagerDelegate>{
    UIView* _mainTemplateView;
    UINavigationBar* _mainNavigationBar;
    UIView* _eventTemplateView;
    UIView* _listingTemplateView;
    id<ArcosCalendarEventEntryDetailTemplateViewControllerDelegate> _actionDelegate;
    id<ModalPresentViewControllerDelegate> _presentDelegate;
    UINavigationBar* _eventNavigationBar;
    UITableView* _eventTableView;
    ArcosCalendarEventEntryDetailTableViewController* _arcosCalendarEventEntryDetailTableViewController;
    MBProgressHUD* _HUD;
    UINavigationBar* _listingNavigationBar;
    UITableView* _listingTableView;
    ArcosCalendarEventEntryDetailListingDataManager* _arcosCalendarEventEntryDetailListingDataManager;
    UILabel* _listingTitleLabel;
}

@property(nonatomic, retain) IBOutlet UIView* mainTemplateView;
@property(nonatomic, retain) IBOutlet UINavigationBar* mainNavigationBar;
@property(nonatomic, retain) IBOutlet UIView* eventTemplateView;
@property(nonatomic, retain) IBOutlet UIView* listingTemplateView;
@property(nonatomic, assign) id<ArcosCalendarEventEntryDetailTemplateViewControllerDelegate> actionDelegate;
@property(nonatomic, assign) id<ModalPresentViewControllerDelegate> presentDelegate;
@property(nonatomic, retain) IBOutlet UINavigationBar* eventNavigationBar;
@property(nonatomic, retain) IBOutlet UITableView* eventTableView;
@property(nonatomic, retain) ArcosCalendarEventEntryDetailTableViewController* arcosCalendarEventEntryDetailTableViewController;
@property(nonatomic, retain) MBProgressHUD* HUD;
@property(nonatomic, retain) IBOutlet UINavigationBar* listingNavigationBar;
@property(nonatomic, retain) IBOutlet UITableView* listingTableView;
@property(nonatomic, retain) ArcosCalendarEventEntryDetailListingDataManager* arcosCalendarEventEntryDetailListingDataManager;
@property(nonatomic, retain) IBOutlet UILabel* listingTitleLabel;

@end


