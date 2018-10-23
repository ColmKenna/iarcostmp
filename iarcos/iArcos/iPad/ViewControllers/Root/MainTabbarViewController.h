//
//  MainTabbarViewController.h
//  Arcos
//
//  Created by David Kilmartin on 20/06/2011.
//  Copyright 2011  Strata IT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerViewController.h"
#import "ActivateLocalViewController.h"
#import "ActivateTemplateViewController.h"

@interface MainTabbarViewController : UITabBarController<PresentViewControllerDelegate> {
    
    IBOutlet CustomerViewController* myCustomerViewController;
    BOOL _isNotFirstLoaded;
    UINavigationController* _auxNavigationController;
}
@property (nonatomic,retain)     IBOutlet CustomerViewController* myCustomerViewController;
@property(nonatomic, assign) BOOL isNotFirstLoaded;
@property (nonatomic,retain) UINavigationController* auxNavigationController;


@end
