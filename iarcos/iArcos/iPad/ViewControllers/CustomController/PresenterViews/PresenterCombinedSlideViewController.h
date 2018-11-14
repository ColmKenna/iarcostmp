//
//  PresenterCombinedSlideViewController.h
//  iArcos
//
//  Created by David Kilmartin on 27/11/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PresenterViewController.h"
#import "PresenterCombinedSlideViewPdfItemController.h"
#import "PresenterCombinedSlideViewVideoItemController.h"
#import "LeafSmallTemplateViewController.h"
@class ArcosRootViewController;
#import "EmailOneButtonAddressSelectDataManager.h"
#import "EmailAllButtonAddressSelectDataManager.h"

@interface PresenterCombinedSlideViewController : PresenterViewController <PresenterCombinedSlideViewItemDelegate,LeafSmallTemplateViewItemDelegate>{
    UIScrollView* _scrollView;
    int _currentPage;
    int _previousPage;
    NSMutableArray* _viewItemControllerList;
    float _slideUpViewHeight;
    BOOL _isSlideUpViewShowing;
    LeafSmallTemplateViewController* _leafSmallTemplateViewController;
    ArcosRootViewController* _arcosRootViewController;
    UIBarButtonItem* _emailAllBarButton;
    
}

@property (nonatomic, retain) IBOutlet UIScrollView* scrollView;
@property (nonatomic, assign) int currentPage;
@property (nonatomic, assign) int previousPage;
@property (nonatomic, retain) NSMutableArray* viewItemControllerList;
@property (nonatomic, assign) float slideUpViewHeight;
@property (nonatomic, assign) BOOL isSlideUpViewShowing;
@property(nonatomic, retain) LeafSmallTemplateViewController* leafSmallTemplateViewController;
@property(nonatomic, retain) ArcosRootViewController* arcosRootViewController;
@property(nonatomic, retain) UIBarButtonItem* emailAllBarButton;

@end
