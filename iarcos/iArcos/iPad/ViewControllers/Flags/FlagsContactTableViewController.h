//
//  FlagsContactTableViewController.h
//  iArcos
//
//  Created by Richard on 05/10/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlagsContactTableViewControllerDelegate.h"
#import "ArcosCoreData.h"
#import "FlagsContactDataManager.h"

@interface FlagsContactTableViewController : UITableViewController {
    id<FlagsContactTableViewControllerDelegate> _actionDelegate;
    NSMutableArray* _originalContactList;
    NSMutableArray* _myContactList;
    NSMutableArray* _tableData;//will be storing data that will be displayed in table
    NSMutableArray* _searchedData;//will be storing data matching with the search string
    NSMutableArray* _customerNames;
    NSMutableArray* _sortKeys;
    NSMutableDictionary* _customerSections;
    BOOL _needIndexView;
    UISearchBar* _mySearchBar;
    FlagsContactDataManager* _flagsContactDataManager;
}

@property(nonatomic,assign) id<FlagsContactTableViewControllerDelegate> actionDelegate;
@property(nonatomic,retain) NSMutableArray* originalContactList;
@property(nonatomic,retain) NSMutableArray* myContactList;
@property(nonatomic,retain) NSMutableArray* tableData;
@property(nonatomic,retain) NSMutableArray* searchedData;
@property(nonatomic,retain) NSMutableArray* customerNames;
@property(nonatomic,retain) NSMutableArray* sortKeys;
@property(nonatomic,retain) NSMutableDictionary* customerSections;
@property(nonatomic,assign) BOOL needIndexView;
@property(nonatomic,retain) IBOutlet UISearchBar* mySearchBar;
@property(nonatomic,retain) FlagsContactDataManager* flagsContactDataManager;

- (void)resetContact:(NSMutableArray*)aContactList;
- (void)refreshContactList;

@end


