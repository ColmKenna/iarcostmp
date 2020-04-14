//
//  UtilitiesConfigurationTableViewController.h
//  iArcos
//
//  Created by David Kilmartin on 23/04/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UtilitiesDetailViewController.h"
#import "UtilitiesConfigurationTableCell.h"
#import "UtilitiesConfigurationDataManager.h"
#import "UtilitiesMailViewController.h"
#import "UtilitiesConfigurationTableViewControllerDelegate.h"

@interface UtilitiesConfigurationTableViewController : UtilitiesDetailViewController <GenericTextViewInputTableCellDelegate, CustomisePresentViewControllerDelegate> {
    id<UtilitiesConfigurationTableViewControllerDelegate> _saveDelegate;
    UtilitiesConfigurationDataManager* _utilitiesConfigurationDataManager;
    UINavigationController* _globalNavigationController;
    UIViewController* _rootView;
}

@property(nonatomic, assign) id<UtilitiesConfigurationTableViewControllerDelegate> saveDelegate;
@property(nonatomic, retain) UtilitiesConfigurationDataManager* utilitiesConfigurationDataManager;
@property(nonatomic, retain) UINavigationController* globalNavigationController;
@property (nonatomic, retain) UIViewController* rootView;

@end
