//
//  SavedOrderMasterDataManager.h
//  Arcos
//
//  Created by David Kilmartin on 19/05/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SavedOrderMasterDataManager : NSObject {
    NSMutableArray* _sectionTitleList;
    NSMutableDictionary* _groupDataDict;
    NSString* _orderSectionTitle;
    NSString* _querySectionTitle;
}

@property(nonatomic, retain) NSMutableArray* sectionTitleList;
@property(nonatomic, retain) NSMutableDictionary* groupDataDict;
@property(nonatomic, retain) NSString* orderSectionTitle;
@property(nonatomic, retain) NSString* querySectionTitle;

- (void)createDataToDisplay;

@end
