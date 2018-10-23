//
//  ActivateTemplateViewController.h
//  Arcos
//
//  Created by David Kilmartin on 22/04/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PresentViewControllerDelegate.h"
#import "ActivateLocalViewController.h"
#import "ActivateEnterpriseViewController.h"

@interface ActivateTemplateViewController : UIViewController <PresentViewControllerDelegate, ActivateLocalActionDelegate, ActivateEnterpriseActionDelegate> {
    id<PresentViewControllerDelegate> _presentDelegate;
    UIScrollView* _baseScrollContentView;
    UITableView* _baseTableContentView;
    BOOL _isNotFirstLoaded;
    UINavigationController* _globalNavigationController;
    ActivateLocalViewController* _activateLocalViewController;
    ActivateEnterpriseViewController* _activateEnterpriseViewController;
}

@property(nonatomic, assign) id<PresentViewControllerDelegate> presentDelegate;
@property(nonatomic, retain) IBOutlet UIScrollView* baseScrollContentView;
@property(nonatomic, retain) IBOutlet UITableView* baseTableContentView;
@property(nonatomic, assign) BOOL isNotFirstLoaded;
@property(nonatomic, retain) UINavigationController* globalNavigationController;
@property(nonatomic, retain) ActivateLocalViewController* activateLocalViewController;
@property(nonatomic, retain) ActivateEnterpriseViewController* activateEnterpriseViewController;

@end
