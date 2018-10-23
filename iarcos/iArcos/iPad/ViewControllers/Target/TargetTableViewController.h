//
//  TargetTableViewController.h
//  iArcos
//
//  Created by David Kilmartin on 30/08/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TargetDataManager.h"
#import "TargetTableViewCell.h"
#import "CallGenericServices.h"
#import "SettingManager.h"
#import "TargetTableCellFactory.h"

@interface TargetTableViewController : UITableViewController {
    TargetDataManager* _targetDataManager;
    CallGenericServices* _callGenericServices;
    TargetTableCellFactory* _tableCellFactory;
}

@property(nonatomic, retain) TargetDataManager* targetDataManager;
@property(nonatomic, retain) CallGenericServices* callGenericServices;
@property(nonatomic, retain) TargetTableCellFactory* tableCellFactory;

@end
