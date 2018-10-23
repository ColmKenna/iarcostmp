//
//  LargeSmallImageFormRowsSlideViewController.h
//  Arcos
//
//  Created by David Kilmartin on 13/06/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LargeSmallImageFormRowsDataManager.h"
#import "OrderFormNavigationControllerBackButtonDelegate.h"
#import "SmallImageL5FormRowsSlideViewController.h"
#import "FormRowsTableViewController.h"

@interface LargeSmallImageFormRowsSlideViewController : UIViewController <UIScrollViewDelegate,LargeImageSlideViewItemDelegate, SmallImageSlideViewItemDelegate> {
    UIScrollView* _myScrollView;
    LargeSmallImageFormRowsDataManager* _largeSmallImageFormRowsDataManager;
    id<OrderFormNavigationControllerBackButtonDelegate> _backButtonDelegate;
    BOOL _isSlideUpViewShowing;
    SmallImageL5FormRowsSlideViewController* _smallImageL5FormRowsSlideViewController;
    float _slideUpViewHeight;
    BOOL _isNotFirstLoaded;
}

@property(nonatomic, retain) IBOutlet UIScrollView* myScrollView;
@property(nonatomic, retain) LargeSmallImageFormRowsDataManager* largeSmallImageFormRowsDataManager;
@property(nonatomic, retain) id<OrderFormNavigationControllerBackButtonDelegate> backButtonDelegate;
@property(nonatomic, assign) BOOL isSlideUpViewShowing;
@property(nonatomic, retain) SmallImageL5FormRowsSlideViewController* smallImageL5FormRowsSlideViewController;
@property(nonatomic, assign) float slideUpViewHeight;
@property (nonatomic, assign) BOOL isNotFirstLoaded;


@end
