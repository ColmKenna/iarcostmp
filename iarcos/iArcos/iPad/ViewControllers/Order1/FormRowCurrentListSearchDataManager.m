//
//  FormRowCurrentListSearchDataManager.m
//  Arcos
//
//  Created by David Kilmartin on 09/11/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "FormRowCurrentListSearchDataManager.h"

@implementation FormRowCurrentListSearchDataManager
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
        self.textDidBeginEditingSelector = NSSelectorFromString(@"currentListSearchBarTextDidBeginEditing");
        self.textDidEndEditingSelector = NSSelectorFromString(@"currentListSearchBarTextDidEndEditing");
        self.textDidChangeSelector = NSSelectorFromString(@"currentListSearchTextDidChange:");
        self.searchButtonClickedSelector = NSSelectorFromString(@"currentListSearchBarSearchButtonClicked:");
        self.cancelButtonClickedSelector = NSSelectorFromString(@"currentListSearchBarCancelButtonClicked");
    }
    return self;
}

- (void)dealloc {    
    [super dealloc];
}

#pragma mark FormRowSearchDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
//    searchBar.showsCancelButton = YES;
//    SEL textDidBeginEditingSelector = NSSelectorFromString(@"currentListSearchBarTextDidBeginEditing");
    [self.target performSelector:self.textDidBeginEditingSelector];
//    [self.target performSelector:@selector(currentListSearchBarTextDidBeginEditing)];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
//    searchBar.showsCancelButton = NO;
//    SEL textDidEndEditingSelector = NSSelectorFromString(@"currentListSearchBarTextDidEndEditing");
    [self.target performSelector:self.textDidEndEditingSelector];
//    [self.target performSelector:@selector(currentListSearchBarTextDidEndEditing)];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
//    NSLog(@"searchBar textDidChange: %@", searchText);
//    SEL textDidChangeSelector = NSSelectorFromString(@"currentListSearchTextDidChange:");
    [self.target performSelector:self.textDidChangeSelector withObject:searchBar.text];
//    [self.target performSelector:@selector(currentListSearchTextDidChange:) withObject:searchBar.text];
//    [searchBar becomeFirstResponder];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
//    [searchBar resignFirstResponder];
//    SEL searchButtonClickedSelector = NSSelectorFromString(@"currentListSearchBarSearchButtonClicked:");
    [self.target performSelector:self.searchButtonClickedSelector withObject:searchBar.text];
//    [self.target performSelector:@selector(currentListSearchBarSearchButtonClicked:) withObject:searchBar.text];    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {    
//    SEL cancelButtonClickedSelector = NSSelectorFromString(@"currentListSearchBarCancelButtonClicked");
    [self.target performSelector:self.cancelButtonClickedSelector];
//    [self.target performSelector:@selector(currentListSearchBarCancelButtonClicked)];
//    [searchBar resignFirstResponder];
    
}

@end
