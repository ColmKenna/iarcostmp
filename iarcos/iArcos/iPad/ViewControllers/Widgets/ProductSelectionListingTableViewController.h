//
//  ProductSelectionListingTableViewController.h
//  iArcos
//
//  Created by Richard on 13/04/2021.
//  Copyright © 2021 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductSelectionListingDataManager.h"
#import "ProductSelectionListingTableViewCell.h"

@protocol ProductSelectionListingDelegate <NSObject>
- (void)didDismissProductSelectionPopover;
- (void)didPressProductSaveButtonSelectionListing:(NSMutableArray*)aProductList;
- (void)didPressProductAllButton;
- (void)didShowErrorMsg:(NSString*)anErrorMsg;
@end

@interface ProductSelectionListingTableViewController : UITableViewController <UISearchBarDelegate> {
    id<ProductSelectionListingDelegate> _actionDelegate;
    ProductSelectionListingDataManager* _productSelectionListingDataManager;
//    NSMutableArray* _originalObjectList;
    NSMutableArray* _myObjectList;
    NSMutableArray* _tableData;//will be storing data that will be displayed in table
    NSMutableArray* _sortKeys;
    NSMutableDictionary* _objectSections;
    BOOL _needIndexView;
    UISearchBar* _mySearchBar;
}

@property(nonatomic, assign) id<ProductSelectionListingDelegate> actionDelegate;
@property(nonatomic, retain) ProductSelectionListingDataManager* productSelectionListingDataManager;
//@property(nonatomic,retain) NSMutableArray* originalObjectList;
@property(nonatomic,retain) NSMutableArray* myObjectList;
@property(nonatomic,retain) NSMutableArray* tableData;
@property(nonatomic,retain) NSMutableArray* sortKeys;
@property(nonatomic,retain) NSMutableDictionary* objectSections;
@property(nonatomic,assign) BOOL needIndexView;
@property(nonatomic,retain) IBOutlet UISearchBar* mySearchBar;

- (void)resetProduct:(NSMutableArray*)aProductList;

@end


