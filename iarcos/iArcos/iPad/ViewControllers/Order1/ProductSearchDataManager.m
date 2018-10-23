//
//  ProductSearchDataManager.m
//  Arcos
//
//  Created by David Kilmartin on 08/11/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "ProductSearchDataManager.h"

@implementation ProductSearchDataManager
@synthesize displayList = _displayList;
@synthesize target = _target;
@synthesize searchButtonClickedSelector = _searchButtonClickedSelector;

- (id)initWithTarget:(id)aTarget{
    self = [super init];
    if (self != nil) {
        self.target = aTarget;
        self.searchButtonClickedSelector = NSSelectorFromString(@"resetTableViewDataSourceWithSearchText:");
    }
    return self;
}

- (void)dealloc {
    if (self.displayList != nil) { self.displayList = nil; }     
    
    
    [super dealloc];
}

- (void)createSearchFormDetailData {
    ArcosFormDetailBO* arcosFormDetailBO = [[[ArcosFormDetailBO alloc] init] autorelease];
    arcosFormDetailBO.iur = 14;
    arcosFormDetailBO.Details = @"Search";
    arcosFormDetailBO.DefaultDeliverDate = [NSDate date];    
    arcosFormDetailBO.Active = YES;
    arcosFormDetailBO.FormType = 104;
    arcosFormDetailBO.Type = @"104";
    arcosFormDetailBO.PrintDeliveryDocket = NO;
    arcosFormDetailBO.ShowSeperators = YES;
    [[ArcosCoreData sharedArcosCoreData] loadFormDetailsWithSoapOB:arcosFormDetailBO];
}

//- (NSMutableArray*)productWithDescriptionKeyword:(NSString*)aKeyword {
//    NSMutableArray* products = [[ArcosCoreData sharedArcosCoreData] productWithDescriptionKeyword:aKeyword];
//    if (products == nil) {
//        self.displayList = [NSMutableArray array];
//    } else {
//        self.displayList = [NSMutableArray arrayWithCapacity:[products count]];
//        for (NSMutableDictionary* aProduct in products) {//loop products
//            NSMutableDictionary* formRow = [ProductFormRowConverter createFormRowWithProduct:aProduct];
//            //sync the row with current cart
//            formRow = [[OrderSharedClass sharedOrderSharedClass]syncRowWithCurrentCart:formRow];
//            [self.displayList addObject:formRow];
//        }
//    }    
//    return self.displayList;
//}

#pragma mark FormRowSearchDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = YES;
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = NO;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
//    [self productWithDescriptionKeyword:[NSString stringWithFormat:@"%@", searchBar.text]];
//    [self.target performSelector:self.searchButtonClickedSelector withObject:self.displayList];
    [self.target performSelector:self.searchButtonClickedSelector withObject:searchBar.text];
//    [self.target performSelector:@selector(resetFormRowTableViewDataSource:) withObject:self.displayList];    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    [searchBar resignFirstResponder];
    searchBar.text = @"";
}

- (void)createActiveProduct {
    [[ArcosCoreData sharedArcosCoreData] createActiveProduct];
}

@end
