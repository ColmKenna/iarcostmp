//
//  ProductPredictiveSearchDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 24/11/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import "ProductPredictiveSearchDataManager.h"

@implementation ProductPredictiveSearchDataManager
@synthesize target = _target;
@synthesize textDidBeginEditingSelector = _textDidBeginEditingSelector;
@synthesize textDidEndEditingSelector = _textDidEndEditingSelector;
@synthesize textDidChangeSelector = _textDidChangeSelector;
@synthesize searchButtonClickedSelector = _searchButtonClickedSelector;
@synthesize cancelButtonClickedSelector = _cancelButtonClickedSelector;

- (id)initWithTarget:(id)aTarget{
    self = [super init];
    if (self != nil) {
        self.target = aTarget;
        self.textDidBeginEditingSelector = NSSelectorFromString(@"predictiveSearchBarTextDidBeginEditing");
        self.textDidEndEditingSelector = NSSelectorFromString(@"predictiveSearchBarTextDidEndEditing");
        self.textDidChangeSelector = NSSelectorFromString(@"predictiveSearchBarTextDidChange:");
        self.searchButtonClickedSelector = NSSelectorFromString(@"predictiveSearchBarSearchButtonClicked:");
        self.cancelButtonClickedSelector = NSSelectorFromString(@"predictiveSearchBarCancelButtonClicked");
    }
    return self;
}

- (void)dealloc {    
    [super dealloc];
}

#pragma mark FormRowSearchDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self.target performSelector:self.textDidBeginEditingSelector];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [self.target performSelector:self.textDidEndEditingSelector];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self.target performSelector:self.textDidChangeSelector withObject:searchBar.text];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.target performSelector:self.searchButtonClickedSelector withObject:searchBar.text];    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    [self.target performSelector:self.cancelButtonClickedSelector];
    
}

@end
