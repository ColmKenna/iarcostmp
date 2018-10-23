//
//  LargeSmallFormDetailSlideViewController.h
//  Arcos
//
//  Created by David Kilmartin on 19/07/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LargeSmallFormDetailDataManager.h"
#import "OrderFormNavigationControllerBackButtonDelegate.h"
#import "SmallFormDetailDividerSlideViewController.h"
#import "FormRowsTableViewController.h"
#import "GlobalSharedClass.h"

@interface LargeSmallFormDetailSlideViewController : UIViewController <UIScrollViewDelegate,LargeImageSlideViewItemDelegate, SmallImageSlideViewItemDelegate>{
    UIScrollView* _myScrollView;
    LargeSmallFormDetailDataManager* _largeSmallFormDetailDataManager;
    NSNumber* _formIUR;
    id<OrderFormNavigationControllerBackButtonDelegate> _backButtonDelegate;
    BOOL _isSlideUpViewShowing;
    SmallFormDetailDividerSlideViewController* _smallFormDetailDividerSlideViewController;
    float _slideUpViewHeight;
    BOOL _isNotFirstLoaded;
}

@property(nonatomic, retain) IBOutlet UIScrollView* myScrollView;
@property(nonatomic, retain) LargeSmallFormDetailDataManager* largeSmallFormDetailDataManager;
@property(nonatomic, retain) NSNumber* formIUR;
@property(nonatomic, retain) id<OrderFormNavigationControllerBackButtonDelegate> backButtonDelegate;
@property(nonatomic, assign) BOOL isSlideUpViewShowing;
@property(nonatomic, retain) SmallFormDetailDividerSlideViewController* smallFormDetailDividerSlideViewController;
@property(nonatomic, assign) float slideUpViewHeight;
@property (nonatomic, assign) BOOL isNotFirstLoaded;

@end
