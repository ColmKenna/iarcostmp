//
//  CustomerNewsTaskWrapperViewController.h
//  Arcos
//
//  Created by David Kilmartin on 23/09/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerNewsTaskTableViewController.h"

@interface CustomerNewsTaskWrapperViewController : UIViewController <CustomisePresentViewControllerDelegate> {
    id<CustomisePresentViewControllerDelegate> _myDelegate;
    UIView*  _customiseContentView;
    UIScrollView* _customiseScrollContentView;
    UINavigationController* _globalNavigationController;
    
}

@property(nonatomic, assign) id<CustomisePresentViewControllerDelegate> myDelegate;
@property(nonatomic, retain) IBOutlet UIView* customiseContentView;
@property(nonatomic, retain) IBOutlet UIScrollView* customiseScrollContentView;
@property(nonatomic, retain) UINavigationController* globalNavigationController;

@end
