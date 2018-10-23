//
//  LargeSmallL3SearchFormRowSlideViewController.h
//  Arcos
//
//  Created by David Kilmartin on 09/07/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LargeSmallL3SearchFormRowDataManager.h"
#import "FormRowsTableViewController.h"
#import "OrderFormNavigationControllerBackButtonDelegate.h"
#import "SmallL5L3SearchFormRowSlideViewController.h"
#import "FormRowsTableViewController.h"

@interface LargeSmallL3SearchFormRowSlideViewController : UIViewController<LargeImageSlideViewItemDelegate, SmallImageSlideViewItemDelegate> {
    UIScrollView* _myScrollView;
    LargeSmallL3SearchFormRowDataManager* _largeSmallL3SearchFormRowDataManager;
    id<OrderFormNavigationControllerBackButtonDelegate> _backButtonDelegate;
    BOOL _isSlideUpViewShowing;
    SmallL5L3SearchFormRowSlideViewController* _smallL5L3SearchFormRowSlideViewController;
    float _slideUpViewHeight;
    BOOL _isNotFirstLoaded;
}

@property(nonatomic, retain) IBOutlet UIScrollView* myScrollView;
@property(nonatomic, retain) LargeSmallL3SearchFormRowDataManager* largeSmallL3SearchFormRowDataManager;
@property(nonatomic, retain) id<OrderFormNavigationControllerBackButtonDelegate> backButtonDelegate;
@property(nonatomic, assign) BOOL isSlideUpViewShowing;
@property(nonatomic, retain) SmallL5L3SearchFormRowSlideViewController* smallL5L3SearchFormRowSlideViewController;
@property(nonatomic, assign) float slideUpViewHeight;
@property (nonatomic, assign) BOOL isNotFirstLoaded;

@end
