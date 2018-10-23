//
//  TemplateDashboardDataManager.h
//  iArcos
//
//  Created by David Kilmartin on 04/12/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosConfigDataManager.h"
#import "ArcosSystemCodesUtils.h"

@interface TemplateDashboardDataManager : NSObject {
    NSString* _todayTitle;
    NSString* _issuesTitle;
    NSString* _newsTitle;
    NSString* _stockoutsTitle;
    NSString* _vanStocksTitle;
    NSString* _promotionTitle;
    NSString* _statsTitle;
    NSString* _commentsTitle;
    NSMutableArray* _segmentItemList;
}

@property(nonatomic, retain) NSString* todayTitle;
@property(nonatomic, retain) NSString* issuesTitle;
@property(nonatomic, retain) NSString* newsTitle;
@property(nonatomic, retain) NSString* stockoutsTitle;
@property(nonatomic, retain) NSString* vanStocksTitle;
@property(nonatomic, retain) NSString* promotionTitle;
@property(nonatomic, retain) NSString* statsTitle;
@property(nonatomic, retain) NSString* commentsTitle;
@property(nonatomic, retain) NSMutableArray* segmentItemList;

- (int)retrieveIndexByTitle:(NSString*)title;


@end
