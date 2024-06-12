//
//  ReporterCsvViewController.h
//  iArcos
//
//  Created by Richard on 10/06/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideAcrossViewAnimationDelegate.h"
#import "ArcosUtils.h"
#import "ReporterCsvDataManager.h"
#import "GenericUITableTableCell.h"
#import "LeftRightInsetUILabel.h"
#import "ReporterCsvDetailTableViewController.h"
#import "ArcosCustomiseAnimation.h"

@interface ReporterCsvViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ArcosCustomiseAnimationDelegate, SlideAcrossViewAnimationDelegate>{
    id<SlideAcrossViewAnimationDelegate> _animateDelegate;
    UIScrollView* _customiseScrollView;
    UIViewController* _myRootViewController;
    ReporterCsvDataManager* _reporterCsvDataManager;
    UIView* _customiseTableHeaderView;
    UITableView* _customiseTableView;
    UINavigationController* _globalNavigationController;
    ArcosCustomiseAnimation* _arcosCustomiseAnimation;
}

@property(nonatomic, assign) id<SlideAcrossViewAnimationDelegate> animateDelegate;
@property(nonatomic, retain) IBOutlet UIScrollView* customiseScrollView;
@property(nonatomic, retain) UIViewController* myRootViewController;
@property(nonatomic, retain) ReporterCsvDataManager* reporterCsvDataManager;
@property(nonatomic, retain) UIView* customiseTableHeaderView;
@property(nonatomic, retain) UITableView* customiseTableView;
@property(nonatomic, retain) UINavigationController* globalNavigationController;
@property(nonatomic, retain) ArcosCustomiseAnimation* arcosCustomiseAnimation;

@end


