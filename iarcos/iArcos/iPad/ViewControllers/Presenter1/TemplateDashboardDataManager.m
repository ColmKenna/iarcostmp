//
//  TemplateDashboardDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 04/12/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import "TemplateDashboardDataManager.h"
#import "GlobalSharedClass.h"

@implementation TemplateDashboardDataManager
@synthesize todayTitle = _todayTitle;
@synthesize issuesTitle = _issuesTitle;
@synthesize newsTitle = _newsTitle;
@synthesize stockoutsTitle = _stockoutsTitle;
@synthesize vanStocksTitle = _vanStocksTitle;
@synthesize promotionTitle = _promotionTitle;
@synthesize statsTitle = _statsTitle;
@synthesize commentsTitle = _commentsTitle;
@synthesize segmentItemList = _segmentItemList;

- (instancetype)init{
    self = [super init];
    if (self) {
        self.todayTitle = @"TODAY";
        self.issuesTitle = [[GlobalSharedClass shared].issuesText uppercaseString];
        NSString* definedIssuesText = [ArcosUtils retrieveDefinedIssuesText];
        if (![definedIssuesText isEqualToString:@""]) {
            self.issuesTitle = [definedIssuesText uppercaseString];
        }
        self.newsTitle = @"NEWS";
        self.stockoutsTitle = @"STOCK OUTS";
        self.vanStocksTitle = @"VAN STOCKS";
        self.promotionTitle = @"PROMOTION";
        self.statsTitle = @"STATS";
        self.commentsTitle = @"COMMENTS";
        self.segmentItemList = [NSMutableArray arrayWithObjects:self.todayTitle, self.issuesTitle, self.newsTitle, self.stockoutsTitle, self.vanStocksTitle, self.promotionTitle, self.commentsTitle, nil];
    }
    
    return self;
}

- (void)dealloc {
    self.todayTitle = nil;
    self.issuesTitle = nil;
    self.newsTitle = nil;
    self.stockoutsTitle = nil;
    self.vanStocksTitle = nil;
    self.promotionTitle = nil;
    self.statsTitle = nil;
    self.commentsTitle = nil;
    self.segmentItemList = nil;
    
    [super dealloc];
}

- (int)retrieveIndexByTitle:(NSString*)title {
    int itemIndex = 0;
    for (int i = 0; i < [self.segmentItemList count]; i++) {
        if ([title isEqualToString:[self.segmentItemList objectAtIndex:i]]) {
            itemIndex = i;
        }
    }
    return itemIndex;
}



@end
