//
//  LargeImageFormRowsSlideViewController.h
//  Arcos
//
//  Created by David Kilmartin on 11/06/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LargeImageFormRowsDataManager.h"
#import "OrderFormNavigationControllerBackButtonDelegate.h"
#import "LargeImageL5FormRowsSlideViewController.h"
#import "FormRowsTableViewController.h"

@interface LargeImageFormRowsSlideViewController : UIViewController<UIScrollViewDelegate, LargeImageSlideViewItemDelegate> {
    UIScrollView* _myScrollView;
    LargeImageFormRowsDataManager* _largeImageFormRowsDataManager;
    id<OrderFormNavigationControllerBackButtonDelegate> _backButtonDelegate;
}

@property(nonatomic, retain) IBOutlet UIScrollView* myScrollView;
@property(nonatomic, retain) LargeImageFormRowsDataManager* largeImageFormRowsDataManager;
@property(nonatomic, retain) id<OrderFormNavigationControllerBackButtonDelegate> backButtonDelegate;

@end
