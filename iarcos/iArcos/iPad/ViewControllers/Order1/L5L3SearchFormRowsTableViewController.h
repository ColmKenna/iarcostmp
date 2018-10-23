//
//  L5L3SearchFormRowsTableViewController.h
//  Arcos
//
//  Created by David Kilmartin on 21/11/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "L5L3SearchDataManager.h"
#import "ImageFormRowsTableCell.h"
#import "OrderSharedClass.h"
#import "FormRowsTableViewController.h"
#import "L3SearchDataManager.h"

@interface L5L3SearchFormRowsTableViewController : UITableViewController<ImageFormRowsDelegate> {
    NSString* _l3DescrDetailCode;
    L5L3SearchDataManager* _l5L3SearchDataManager;
    UISearchBar* _mySearchBar;
    L3SearchDataManager* _l3SearchDataManager;
    BOOL _isNotFirstLoaded;
}

@property(nonatomic, retain) NSString* l3DescrDetailCode;
@property(nonatomic, retain) L5L3SearchDataManager* l5L3SearchDataManager;
@property(nonatomic, retain) IBOutlet UISearchBar* mySearchBar;
@property(nonatomic, retain) L3SearchDataManager* l3SearchDataManager;
@property(nonatomic, assign) BOOL isNotFirstLoaded;

- (NSMutableDictionary*)createFormRowWithProduct:(NSMutableDictionary*) product;
- (void)reloadTableViewData;
- (void)scrollBehindSearchSection;

@end
