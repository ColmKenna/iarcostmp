//
//  SavedOrderMasterDataManager.m
//  Arcos
//
//  Created by David Kilmartin on 19/05/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "SavedOrderMasterDataManager.h"
#import "ArcosConfigDataManager.h"
#import "GlobalSharedClass.h"

@implementation SavedOrderMasterDataManager
@synthesize sectionTitleList = _sectionTitleList;
@synthesize groupDataDict = _groupDataDict;
@synthesize orderSectionTitle = _orderSectionTitle;
@synthesize querySectionTitle = _querySectionTitle;

- (id)init{
    self = [super init];
    if (self != nil) {
        self.orderSectionTitle = @"Orders/Calls";
        self.querySectionTitle = [GlobalSharedClass shared].issuesText;//@"Queries"
        NSString* definedIssuesText = [ArcosUtils retrieveDefinedIssuesText];
        if (![definedIssuesText isEqualToString:@""]) {
            self.querySectionTitle = definedIssuesText;
        }
    }
    return self;
}

- (void)dealloc{
    self.sectionTitleList = nil;
    self.groupDataDict = nil;
    self.orderSectionTitle = nil;
    self.querySectionTitle = nil;
    
    [super dealloc];
}

- (void)createDataToDisplay {
    self.groupDataDict = [NSMutableDictionary dictionaryWithCapacity:2];
    BOOL taskFlag = [[ArcosConfigDataManager sharedArcosConfigDataManager] recordTasksFlag];
    self.sectionTitleList = [NSMutableArray arrayWithObjects:self.orderSectionTitle, nil];
    
    NSMutableArray* orderSectionContentList = [NSMutableArray arrayWithObjects:@"All",@"Today",@"This Week",@"This Month",@"This Year",@"MAT",@"Pending Only", nil];
    
    [self.groupDataDict setObject:orderSectionContentList forKey:self.orderSectionTitle];
    if (taskFlag) {
        NSMutableArray* queryContentList = [NSMutableArray arrayWithObjects:@"All",@"Today",@"This Week",@"This Month",@"This Year",@"MAT",@"Outstanding", nil];
        [self.sectionTitleList addObject:self.querySectionTitle];
        [self.groupDataDict setObject:queryContentList forKey:self.querySectionTitle];
    }
}

@end
