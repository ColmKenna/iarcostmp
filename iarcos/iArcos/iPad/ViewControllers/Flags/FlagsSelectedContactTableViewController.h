//
//  FlagsSelectedContactTableViewController.h
//  iArcos
//
//  Created by Richard on 05/10/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlagsSelectedContactDataManager.h"
#import "ArcosUtils.h"
#import "FlagsSelectedContactTableViewControllerDelegate.h"

@interface FlagsSelectedContactTableViewController : UITableViewController {
    id<FlagsSelectedContactTableViewControllerDelegate> _actionDelegate;
    FlagsSelectedContactDataManager* _flagsSelectedContactDataManager;
}

@property(nonatomic,assign) id<FlagsSelectedContactTableViewControllerDelegate> actionDelegate;
@property(nonatomic,retain) FlagsSelectedContactDataManager* flagsSelectedContactDataManager;

- (void)resetSelectedContact:(NSMutableArray*)aContactList;

@end

