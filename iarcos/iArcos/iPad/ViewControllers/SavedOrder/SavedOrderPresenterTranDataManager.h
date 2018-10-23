//
//  SavedOrderPresenterTranDataManager.h
//  iArcos
//
//  Created by David Kilmartin on 22/01/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosCoreData.h"

@interface SavedOrderPresenterTranDataManager : NSObject {
    NSMutableArray* _sortedKeyList;
    NSMutableDictionary* _ptranListDict;
    NSMutableDictionary* _callOrderHeaderDict;
    NSString* _ptDetailLevelIUR;
    NSNumber* _employeeIUR;
}

@property(nonatomic, retain) NSMutableArray* sortedKeyList;
@property(nonatomic, retain) NSMutableDictionary* ptranListDict;
@property(nonatomic, retain) NSMutableDictionary* callOrderHeaderDict;
@property(nonatomic, retain) NSString* ptDetailLevelIUR;
@property(nonatomic, retain) NSNumber* employeeIUR;

- (void)processPresenterTransaction;

@end
