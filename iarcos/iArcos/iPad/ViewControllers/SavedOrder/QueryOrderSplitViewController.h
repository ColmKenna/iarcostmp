//
//  QueryOrderSplitViewController.h
//  Arcos
//
//  Created by David Kilmartin on 19/05/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailViewController.h"
#import "SplitDividerUILabel.h"
#import "QueryOrderMasterTableViewController.h"
#import "QueryOrderDetailTableViewController.h"


@interface QueryOrderSplitViewController : OrderDetailViewController<SlideAcrossViewAnimationDelegate> {
    SplitDividerUILabel* _splitDividerLabel;
    QueryOrderMasterTableViewController* _queryOrderMasterTableViewController;
    QueryOrderDetailTableViewController* _queryOrderDetailTableViewController;
    float _masterWidth;
    float _dividerWidth;
    
    UINavigationController* _masterNavigationController;
    UINavigationController* _detailNavigationController;
    QueryOrderSource _queryOrderSource;
    id<SlideAcrossViewAnimationDelegate> _animateDelegate;
}

@property(nonatomic, retain) SplitDividerUILabel* splitDividerLabel;
@property(nonatomic, retain) QueryOrderMasterTableViewController* queryOrderMasterTableViewController;
@property(nonatomic, retain) QueryOrderDetailTableViewController* queryOrderDetailTableViewController;
@property(nonatomic, assign) float masterWidth;
@property(nonatomic, assign) float dividerWidth;
@property(nonatomic, retain) UINavigationController* masterNavigationController;
@property(nonatomic, retain) UINavigationController* detailNavigationController;
@property(nonatomic, assign) QueryOrderSource queryOrderSource;
@property(nonatomic, assign) id<SlideAcrossViewAnimationDelegate> animateDelegate;

@end
