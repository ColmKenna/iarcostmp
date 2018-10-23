//
//  L3SearchFormRowsTableViewController.h
//  Arcos
//
//  Created by David Kilmartin on 21/11/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "L3SearchDataManager.h"
#import "ImageFormRowsTableCell.h"
#import "L5L3SearchFormRowsTableViewController.h"
#import "BranchLeafProductGridViewController.h"
#import "OrderFormNavigationControllerBackButtonDelegate.h"

@interface L3SearchFormRowsTableViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, ImageFormRowsDelegate,UISearchBarDelegate, BranchLeafProductNavigationTitleDelegate> {
    UISearchBar* _mySearchBar;
    UITableView* _myTableView;
    L3SearchDataManager* _l3SearchDataManager;
    NSString* _formType;
    BOOL _isNotFirstLoaded;
    id<OrderFormNavigationControllerBackButtonDelegate> _backButtonDelegate;
    id<BranchLeafProductNavigationTitleDelegate> _navigationTitleDelegate;
}

@property(nonatomic, retain) IBOutlet UISearchBar* mySearchBar;
@property(nonatomic, retain) IBOutlet UITableView* myTableView;
@property(nonatomic, retain) L3SearchDataManager* l3SearchDataManager;
@property(nonatomic, retain) NSString* formType;
@property (nonatomic, assign) BOOL isNotFirstLoaded;
@property (nonatomic, assign) id<OrderFormNavigationControllerBackButtonDelegate> backButtonDelegate;
@property (nonatomic, assign) id<BranchLeafProductNavigationTitleDelegate> navigationTitleDelegate;

- (void)reloadTableViewData;
@end
