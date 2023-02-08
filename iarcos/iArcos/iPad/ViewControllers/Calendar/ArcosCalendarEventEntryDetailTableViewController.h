//
//  ArcosCalendarEventEntryDetailTableViewController.h
//  iArcos
//
//  Created by Richard on 12/05/2022.
//  Copyright © 2022 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArcosCalendarEventEntryDetailDataManager.h"
#import "ArcosCalendarEventEntryDetailTableViewCellFactory.h"
#import "ArcosUtils.h"
#import "ModalPresentViewControllerDelegate.h"
#import "GlobalSharedClass.h"
#import "ArcosConstantsDataManager.h"
#import "MBProgressHUD.h"
#import "ArcosCalendarEventEntryDetailTableViewControllerDelegate.h"

@interface ArcosCalendarEventEntryDetailTableViewController : UITableViewController <ArcosCalendarEventEntryDetailBaseTableViewCellDelegate>{
    id<ArcosCalendarEventEntryDetailTableViewControllerDelegate> _actionDelegate;
    id<ModalPresentViewControllerDelegate> _presentDelegate;
    ArcosCalendarEventEntryDetailDataManager* _arcosCalendarEventEntryDetailDataManager;
    ArcosCalendarEventEntryDetailTableViewCellFactory* _tableCellFactory;
    MBProgressHUD* _HUD;
}

@property(nonatomic, assign) id<ArcosCalendarEventEntryDetailTableViewControllerDelegate> actionDelegate;
@property(nonatomic, assign) id<ModalPresentViewControllerDelegate> presentDelegate;
@property(nonatomic, retain) ArcosCalendarEventEntryDetailDataManager* arcosCalendarEventEntryDetailDataManager;
@property(nonatomic, retain) ArcosCalendarEventEntryDetailTableViewCellFactory* tableCellFactory;
@property(nonatomic, retain) MBProgressHUD* HUD;

@end


