//
//  CustomerSelectionListingTableViewController.h
//  Arcos
//
//  Created by David Kilmartin on 08/08/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArcosCoreData.h"
@protocol CustomerSelectionListingDelegate <NSObject>
@optional
- (void)didDismissSelectionPopover;
- (void)didSelectCustomerSelectionListingRecord:(NSMutableDictionary*)aCustDict;
- (void)allButtonPressed:(NSMutableDictionary*)aCustDict;
@end

@interface CustomerSelectionListingTableViewController : UITableViewController<UISearchBarDelegate> {
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
                
    id<CustomerSelectionListingDelegate> _selectionDelegate;
    NSMutableDictionary* _allLocationRecordDict;
    BOOL _isNotFirstLoaded;
    BOOL _isNotShowingAllButton;
    NSNumber* _showLocationCode;
}
@property (nonatomic, retain) IBOutlet UISearchBar *mySearchBar;

@property(nonatomic,retain) NSMutableArray* myCustomers;
@property(nonatomic,retain) NSMutableArray* customerNames;
@property(nonatomic,retain) NSMutableArray* sortKeys;
@property(nonatomic,retain) NSMutableDictionary* customerSections;
@property(nonatomic,retain) NSMutableArray *searchedData;
@property (nonatomic, assign) id<CustomerSelectionListingDelegate> selectionDelegate;
@property (nonatomic, retain) NSMutableDictionary* allLocationRecordDict;
@property (nonatomic, assign) BOOL isNotFirstLoaded;
@property (nonatomic, assign) BOOL isNotShowingAllButton;
@property (nonatomic, retain) NSNumber* showLocationCode;

-(void)resetCustomer:(NSMutableArray*)customers;
-(void)resetList:(NSMutableArray*)aList;
-(void)sortCustomers:(NSMutableArray*)customers;
-(NSMutableDictionary*)objectFromName:(NSString*)name;
-(NSMutableArray*)objectsFromName:(NSString*)name;
- (void)scrollBehindSearchSection;

@end
