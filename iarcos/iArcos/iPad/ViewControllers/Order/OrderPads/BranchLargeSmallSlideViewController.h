//
//  BranchLargeSmallSlideViewController.h
//  Arcos
//
//  Created by David Kilmartin on 14/08/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BranchLargeSmallDataManager.h"
#import "LargeImageSlideViewItemController.h"
#import "LeafSmallTemplateViewController.h"
#import "OrderFormNavigationControllerBackButtonDelegate.h"
#import "BranchLeafProductGridViewController.h"

@interface BranchLargeSmallSlideViewController : UIViewController<UIScrollViewDelegate, LargeImageSlideViewItemDelegate, LeafSmallTemplateViewItemDelegate, BranchLeafProductNavigationTitleDelegate> {
    UIScrollView* _myScrollView;
    BranchLargeSmallDataManager* _branchLargeSmallDataManager;
    NSString* _formType;
    BOOL _isSlideUpViewShowing;
    LeafSmallTemplateViewController* _leafSmallTemplateViewController;
    float _slideUpViewHeight;
    id<OrderFormNavigationControllerBackButtonDelegate> _backButtonDelegate;
    BOOL _isNotFirstLoaded;
    id<BranchLeafProductNavigationTitleDelegate> _navigationTitleDelegate;
}

@property(nonatomic, retain) IBOutlet UIScrollView* myScrollView;
@property(nonatomic, retain) BranchLargeSmallDataManager* branchLargeSmallDataManager;
@property(nonatomic, retain) NSString* formType;
@property(nonatomic, assign) BOOL isSlideUpViewShowing;
@property(nonatomic, retain) LeafSmallTemplateViewController* leafSmallTemplateViewController;
@property(nonatomic, assign) float slideUpViewHeight;
@property(nonatomic, assign) id<OrderFormNavigationControllerBackButtonDelegate> backButtonDelegate;
@property (nonatomic, assign) BOOL isNotFirstLoaded;
@property (nonatomic, assign) id<BranchLeafProductNavigationTitleDelegate> navigationTitleDelegate;

@end
