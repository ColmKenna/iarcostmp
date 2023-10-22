//
//  FlagsContactFlagWrapperViewController.h
//  iArcos
//
//  Created by Richard on 16/10/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlagsContactFlagTableViewController.h"

@interface FlagsContactFlagWrapperViewController : UIViewController <ModelViewDelegate, FlagsContactFlagTableViewControllerDelegate>{
    id<ModelViewDelegate> _actionDelegate;
    id<FlagsContactFlagTableViewControllerDelegate> _refreshDelegate;
    UIView* _contactFlagViewHolder;
    FlagsContactFlagTableViewController* _flagsContactFlagTableViewController;
    UINavigationController* _flagsContactFlagNavigationController;
    NSDictionary* _layoutDict;
    
}

@property(nonatomic, assign) id<ModelViewDelegate> actionDelegate;
@property(nonatomic, assign) id<FlagsContactFlagTableViewControllerDelegate> refreshDelegate;
@property(nonatomic, retain) IBOutlet UIView* contactFlagViewHolder;
@property(nonatomic, retain) FlagsContactFlagTableViewController* flagsContactFlagTableViewController;
@property(nonatomic, retain) UINavigationController* flagsContactFlagNavigationController;
@property(nonatomic, retain) NSDictionary* layoutDict;

@end


