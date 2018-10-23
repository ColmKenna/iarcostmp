//
//  PresenterBridgeGridViewController.h
//  iArcos
//
//  Created by David Kilmartin on 31/07/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PresenterViewController.h"
#import "PresenterBridgeGridDataManager.h"
#import "MainPresenterTableViewCell.h"

@interface PresenterBridgeGridViewController : PresenterViewController <MainPresenterTableViewCellDelegate> {
    PresenterBridgeGridDataManager* _presenterBridgeGridDataManager;
    UITableView* _myTableView;
}

@property(nonatomic, retain) PresenterBridgeGridDataManager* presenterBridgeGridDataManager;
@property(nonatomic, retain) IBOutlet UITableView* myTableView;

@end
