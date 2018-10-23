//
//  OrderHeaderTotalSetTargetViewController.h
//  Arcos
//
//  Created by David Kilmartin on 14/05/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingManager.h"
#import "SettingTableCellFactory.h"
#import "OrderHeaderTotalSetTargetDelegate.h"
#import "ArcosUtils.h"
#import "ExtendedSettingManager.h"

@interface OrderHeaderTotalSetTargetViewController : UIViewController <UITableViewDelegate,UITableViewDataSource, SettingTableViewCellDelegate, UIAlertViewDelegate> {
    id<OrderHeaderTotalSetTargetDelegate> _delegate;
    NSMutableArray* _displayList;
    UITableView* _targetTableView;
    UINavigationItem* tableNavigationItem;
    SettingManager* settingManager;
    NSArray* settingGroups;
    SettingTableCellFactory* cellFactory;
    UIBarButtonItem* saveButton;
    ExtendedSettingManager* _extendedSettingManager;
    /*
    struct {
        unsigned int disabled:1;
        unsigned int tracking:1;
        unsigned int touchInside:1;
        unsigned int touchDragged:1;
        unsigned int requiresDisplayOnTracking:1;
        unsigned int highlighted:1;
        unsigned int dontHighlightOnTouchDown:1;
        unsigned int delayActions:1;
        unsigned int allowActionsToQueue:1;
        unsigned int pendingUnhighlight:1;
        unsigned int selected:1;
        unsigned int verticalAlignment:2;
        unsigned int horizontalAlignment:2;
    } _testTargetFlags;
    */
}

@property (nonatomic, assign) id<OrderHeaderTotalSetTargetDelegate> delegate;
@property (nonatomic, retain) NSMutableArray* displayList;
@property (nonatomic, retain) IBOutlet UITableView* targetTableView;
@property (nonatomic, retain) IBOutlet UINavigationItem* tableNavigationItem;

@property(nonatomic,retain) SettingManager* settingManager;
@property(nonatomic,retain) NSArray* settingGroups;
@property(nonatomic,retain) SettingTableCellFactory* cellFactory;
@property(nonatomic,retain) UIBarButtonItem* saveButton;
@property(nonatomic,retain) ExtendedSettingManager* extendedSettingManager;

@end
