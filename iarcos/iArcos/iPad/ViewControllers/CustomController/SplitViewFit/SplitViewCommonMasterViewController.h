//
//  SplitViewCommonMasterViewController.h
//  Arcos
//
//  Created by David Kilmartin on 19/08/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubstitutableDetailViewController.h"
//#import "MGSplitViewController.h"

@interface SplitViewCommonMasterViewController : UIViewController<UISplitViewControllerDelegate> {
    UISplitViewController *splitViewController;
    
//    UIPopoverController *popoverController;
    UIBarButtonItem *rootPopoverButtonItem;
}
@property (nonatomic, assign) IBOutlet UISplitViewController *splitViewController;

//@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) UIBarButtonItem *rootPopoverButtonItem;
@end
