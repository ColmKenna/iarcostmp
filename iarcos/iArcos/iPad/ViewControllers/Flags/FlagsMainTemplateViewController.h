//
//  FlagsMainTemplateViewController.h
//  iArcos
//
//  Created by Richard on 05/10/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlagsLocationTableViewController.h"
#import "FlagsContactTableViewController.h"
#import "FlagsSelectedContactTableViewController.h"
#import "FlagsMainTemplateDataManager.h"
#import "MBProgressHUD.h"

@interface FlagsMainTemplateViewController : UIViewController <FlagsLocationTableViewControllerDelegate, FlagsContactTableViewControllerDelegate, FlagsSelectedContactTableViewControllerDelegate>{
    UIView* _locationViewHolder;
    UIView* _contactViewHolder;
    UILabel* _separatorFromContactViewHolder;
    UIView* _selectedContactViewHolder;
    UILabel* _separatorFromSelectedContactViewHolder;
    
    FlagsLocationTableViewController* _flagsLocationTableViewController;
    UINavigationController* _flagsLocationNavigationController;
    FlagsContactTableViewController* _flagsContactTableViewController;
    UINavigationController* _flagsContactNavigationController;
    FlagsSelectedContactTableViewController* _flagsSelectedContactTableViewController;
    UINavigationController* _flagsSelectedContactNavigationController;
    NSDictionary* _layoutDict;
    FlagsMainTemplateDataManager* _flagsMainTemplateDataManager;
    MBProgressHUD* _HUD;
}

@property(nonatomic, retain) IBOutlet UIView* locationViewHolder;
@property(nonatomic, retain) IBOutlet UIView* contactViewHolder;
@property(nonatomic, retain) IBOutlet UILabel* separatorFromContactViewHolder;
@property(nonatomic, retain) IBOutlet UIView* selectedContactViewHolder;
@property(nonatomic, retain) IBOutlet UILabel* separatorFromSelectedContactViewHolder;
@property(nonatomic, retain) FlagsLocationTableViewController* flagsLocationTableViewController;
@property(nonatomic, retain) UINavigationController* flagsLocationNavigationController;
@property(nonatomic, retain) FlagsContactTableViewController* flagsContactTableViewController;
@property(nonatomic, retain) UINavigationController* flagsContactNavigationController;
@property(nonatomic, retain) FlagsSelectedContactTableViewController* flagsSelectedContactTableViewController;
@property(nonatomic, retain) UINavigationController* flagsSelectedContactNavigationController;
@property(nonatomic, retain) NSDictionary* layoutDict;
@property(nonatomic, retain) FlagsMainTemplateDataManager* flagsMainTemplateDataManager;
@property(nonatomic, retain) MBProgressHUD* HUD;

@end

