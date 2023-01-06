//
//  MainPresenterTableViewController.h
//  iArcos
//
//  Created by David Kilmartin on 29/03/2016.
//  Copyright (c) 2016 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainPresenterDataManager.h"
#import "MainPresenterTableViewCell.h"
#import "NewPresenterViewController.h"

@interface MainPresenterTableViewController : UITableViewController <MainPresenterTableViewCellDelegate>{
    PresenterRequestSource _parentMainPresenterRequestSource;
    MainPresenterDataManager* _mainPresenterDataManager;
    BOOL _isNotFirstLoaded;
    UILabel* _custNameHeaderLabel;
    UILabel* _custAddrHeaderLabel;
}

@property(nonatomic,assign) PresenterRequestSource parentMainPresenterRequestSource;
@property(nonatomic, retain) MainPresenterDataManager* mainPresenterDataManager;
@property(nonatomic,assign) BOOL isNotFirstLoaded;
@property(nonatomic, retain) UILabel* custNameHeaderLabel;
@property(nonatomic, retain) UILabel* custAddrHeaderLabel;

- (UIViewController*)retrieveNewPresenterViewControllerResult:(NSDictionary*)mainPresenterCellDict;

@end
