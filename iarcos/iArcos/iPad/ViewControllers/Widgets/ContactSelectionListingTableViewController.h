//
//  ContactSelectionListingTableViewController.h
//  iArcos
//
//  Created by David Kilmartin on 25/01/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerGroupDataManager.h"
#import "CustomerSelectionListingTableViewController.h"

@protocol ContactSelectionListingTableViewControllerDelegate <NSObject>
- (void)didDismissContactSelectionPopover;
- (void)didSelectContactSelectionListing:(NSMutableArray*)aContactList;
@end

@interface ContactSelectionListingTableViewController : UITableViewController <UISearchBarDelegate, CustomerSelectionListingDelegate>{
    id<ContactSelectionListingTableViewControllerDelegate> _actionDelegate;
    NSMutableArray* _originalContactList;
    NSMutableArray* _myContactList;
    NSMutableArray* _tableData;//will be storing data that will be displayed in table
    NSMutableArray* _searchedData;//will be storing data matching with the search string
    NSMutableArray* _customerNames;
    NSMutableArray* _sortKeys;
    NSMutableDictionary* _customerSections;
    BOOL _needIndexView;
    UISearchBar* _mySearchBar;
    UIBarButtonItem* _locationButton;
}

@property(nonatomic,assign) id<ContactSelectionListingTableViewControllerDelegate> actionDelegate;
@property(nonatomic,retain) NSMutableArray* originalContactList;
@property(nonatomic,retain) NSMutableArray* myContactList;
//@property(nonatomic,retain) NSMutableArray* myCustomers;
@property(nonatomic,retain) NSMutableArray* tableData;
@property(nonatomic,retain) NSMutableArray* searchedData;
@property(nonatomic,retain) NSMutableArray* customerNames;
@property(nonatomic,retain) NSMutableArray* sortKeys;
@property(nonatomic,retain) NSMutableDictionary* customerSections;
@property(nonatomic,assign) BOOL needIndexView;
@property(nonatomic,retain) IBOutlet UISearchBar* mySearchBar;
@property(nonatomic,retain) UIBarButtonItem* locationButton;

- (void)resetContact:(NSMutableArray*)aContactList;

@end

