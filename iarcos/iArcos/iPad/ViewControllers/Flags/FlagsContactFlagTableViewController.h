//
//  FlagsContactFlagTableViewController.h
//  iArcos
//
//  Created by Richard on 16/10/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelViewDelegate.h"
#import "FlagsContactFlagTableViewCell.h"
#import "CallGenericServices.h"
#import "ArcosCoreData.h"
#import "FlagsContactFlagTableViewControllerDelegate.h"
#import "FlagsContactFlagDataManager.h"

@interface FlagsContactFlagTableViewController : UITableViewController <GenericTextInputTableViewCellDelegate>{
    id<ModelViewDelegate> _actionDelegate;
    id<FlagsContactFlagTableViewControllerDelegate> _refreshDelegate;
    CallGenericServices* _callGenericServices;
    FlagsContactFlagDataManager* _flagsContactFlagDataManager;
}

@property(nonatomic, assign) id<ModelViewDelegate> actionDelegate;
@property(nonatomic, assign) id<FlagsContactFlagTableViewControllerDelegate> refreshDelegate;
@property(nonatomic, retain) CallGenericServices* callGenericServices;
@property(nonatomic, retain) FlagsContactFlagDataManager* flagsContactFlagDataManager;

@end


