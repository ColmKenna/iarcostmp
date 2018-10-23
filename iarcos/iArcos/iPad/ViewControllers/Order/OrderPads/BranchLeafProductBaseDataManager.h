//
//  BranchLeafProductBaseDataManager.h
//  Arcos
//
//  Created by David Kilmartin on 22/08/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FormRowsTableViewController.h"
#import "BranchLeafMiscUtils.h"
#import "LeafSmallTemplateViewController.h"

@interface BranchLeafProductBaseDataManager : NSObject {
    BranchLeafMiscUtils* _branchLeafMiscUtils;
    LeafSmallTemplateViewController* _leafSmallTemplateViewController;
}

@property(nonatomic, retain) BranchLeafMiscUtils* branchLeafMiscUtils;

@property(nonatomic, retain) LeafSmallTemplateViewController* leafSmallTemplateViewController;

- (id)showProductTableViewController:(NSString*)aBranchLxCodeContent branchLxCode:(NSString*)aBranchLxCode leafLxCodeContent:(NSString*)anLeafLxCodeContent leafLxCode:(NSString*)anLeafLxCode;

@end
