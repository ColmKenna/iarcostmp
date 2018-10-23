//
//  FormRowsWrapperViewController.h
//  iArcos
//
//  Created by David Kilmartin on 13/06/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomisePartialPresentViewControllerDelegate.h"
#import "FormRowsTableViewController.h"

@interface FormRowsWrapperViewController : UIViewController <UIGestureRecognizerDelegate, FormRowsTableViewControllerDelegate>{
    id<CustomisePartialPresentViewControllerDelegate> _myDelegate;
    id<FormRowsTableViewControllerDelegate> _actionDelegate;
    UIView* _customiseTemplateView;
    UINavigationController* _globalNavigationController;
    FormRowsTableViewController* _formRowsTableViewController;
    NSDictionary* _layoutDict;
}

@property(nonatomic, assign) id<CustomisePartialPresentViewControllerDelegate> myDelegate;
@property(nonatomic, assign) id<FormRowsTableViewControllerDelegate> actionDelegate;
@property(nonatomic, retain) IBOutlet UIView* customiseTemplateView;
@property(nonatomic, retain) UINavigationController* globalNavigationController;
@property(nonatomic, retain) FormRowsTableViewController* formRowsTableViewController;
@property(nonatomic, retain) NSDictionary* layoutDict;

@end
