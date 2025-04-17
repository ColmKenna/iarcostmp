//
//  RootViewController.h
//  iArcos
//
//  Created by David Kilmartin on 07/05/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplitDividerUILabel.h"
#import "CustomerMasterViewController.h"

@interface ArcosRootViewController : UIViewController< CustomerMasterViewControllerDelegate, SubMenuTableViewControllerDelegate,PresentViewControllerDelegate> {
    SplitDividerUILabel* _dividerLabel;
    float _masterWidth;
    BOOL _isMasterViewNotShowing;
    float _dividerWidth;
    CustomerMasterViewController* _customerMasterViewController;
    UINavigationController* _masterNavigationController;
    UIViewController* _selectedRightViewController;
    BOOL _isNotFirstLoaded;
}

@property(nonatomic, retain) SplitDividerUILabel* dividerLabel;
@property(nonatomic, assign) float masterWidth;
@property(nonatomic, assign) BOOL isMasterViewNotShowing;
@property(nonatomic, assign) float dividerWidth;
@property(nonatomic, retain) CustomerMasterViewController* customerMasterViewController;
@property(nonatomic, retain) UINavigationController* masterNavigationController;
@property(nonatomic, assign) UIViewController* selectedRightViewController;
@property(nonatomic, assign) BOOL isNotFirstLoaded;

- (void)GoBack;
@end
