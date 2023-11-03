//
//  FlagsLocationTableViewController.h
//  iArcos
//
//  Created by Richard on 05/10/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArcosCoreData.h"
#import "FlagsLocationTableViewControllerDelegate.h"
#import "FlagsLocationDataManager.h"

@interface FlagsLocationTableViewController : UITableViewController {
    NSMutableArray* myCustomers;
    NSMutableArray* customerNames;
    
    NSMutableArray* sortKeys;
    NSMutableDictionary* _customerSections;
    
    IBOutlet UISearchBar* mySearchBar;
    NSMutableArray *tableData;//will be storing data that will be displayed in table
    NSMutableArray *searchedData;//will be storing data matching with the search string
    BOOL searching;
    BOOL letUserSelectRow;
    BOOL needIndexView;
                
    id<FlagsLocationTableViewControllerDelegate> _selectionDelegate;
    NSMutableDictionary* _allLocationRecordDict;
    BOOL _viewHasBeenAppearedFlag;
    BOOL _hideAllButtonFlag;
    NSNumber* _showLocationCode;
    FlagsLocationDataManager* _flagsLocationDataManager;
}

@property (nonatomic, retain) IBOutlet UISearchBar *mySearchBar;

@property(nonatomic,retain) NSMutableArray* myCustomers;
@property(nonatomic,retain) NSMutableArray* customerNames;
@property(nonatomic,retain) NSMutableArray* sortKeys;
@property(nonatomic,retain) NSMutableDictionary* customerSections;
@property(nonatomic,retain) NSMutableArray *searchedData;
@property (nonatomic, assign) id<FlagsLocationTableViewControllerDelegate> selectionDelegate;
@property (nonatomic, retain) NSMutableDictionary* allLocationRecordDict;
@property (nonatomic, assign) BOOL viewHasBeenAppearedFlag;
@property (nonatomic, assign) BOOL hideAllButtonFlag;
@property (nonatomic, retain) NSNumber* showLocationCode;
@property (nonatomic, retain) FlagsLocationDataManager* flagsLocationDataManager;

-(void)resetCustomer:(NSMutableArray*)customers;
-(void)resetList:(NSMutableArray*)aList;
-(void)sortCustomers:(NSMutableArray*)customers;
-(NSMutableDictionary*)objectFromName:(NSString*)name;
-(NSMutableArray*)objectsFromName:(NSString*)name;
- (void)scrollBehindSearchSection;
- (void)refreshLocationList;

@end


