//
//  OrderEntryInputDataManager.h
//  iArcos
//
//  Created by Apple on 10/03/2020.
//  Copyright © 2020 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosCoreData.h"

@interface OrderEntryInputDataManager : NSObject {
    NSString* _bonKey;
    NSString* _focKey;
    NSString* _instKey;
    NSString* _testKey;
    NSMutableDictionary* _columnDescDataDict;
    NSMutableArray* _qtyList;
    NSMutableArray* _bonList;
}

@property(nonatomic, retain) NSString* bonKey;
@property(nonatomic, retain) NSString* focKey;
@property(nonatomic, retain) NSString* instKey;
@property(nonatomic, retain) NSString* testKey;
@property(nonatomic, retain) NSMutableDictionary* columnDescDataDict;
@property(nonatomic, retain) NSMutableArray* qtyList;
@property(nonatomic, retain) NSMutableArray* bonList;

- (void)retrieveColumnDescriptionInfo;


@end


