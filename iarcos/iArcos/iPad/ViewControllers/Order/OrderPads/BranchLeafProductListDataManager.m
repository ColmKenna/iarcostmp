//
//  BranchLeafProductListDataManager.m
//  Arcos
//
//  Created by David Kilmartin on 22/08/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "BranchLeafProductListDataManager.h"

@implementation BranchLeafProductListDataManager

- (FormRowsTableViewController*)showProductTableViewController:(NSString*)aBranchLxCodeContent branchLxCode:(NSString*)aBranchLxCode leafLxCodeContent:(NSString*)anLeafLxCodeContent leafLxCode:(NSString*)anLeafLxCode {    
    NSMutableArray* unsortFormRows = [self.branchLeafMiscUtils getFormRowList:aBranchLxCodeContent branchLxCode:aBranchLxCode leafLxCodeContent:anLeafLxCodeContent leafLxCode:anLeafLxCode];
    
    FormRowsTableViewController* formRowsView = [[[FormRowsTableViewController alloc] initWithNibName:@"FormRowsTableViewController" bundle:nil] autorelease];
    formRowsView.isShowingSearchBar = YES;
    formRowsView.dividerIUR = [NSNumber numberWithInt:-2];
    formRowsView.unsortedFormrows = unsortFormRows;
    [formRowsView syncUnsortedFormRowsWithOriginal];
    
    return formRowsView;
}

@end
