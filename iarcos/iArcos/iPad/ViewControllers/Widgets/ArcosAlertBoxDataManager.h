//
//  ArcosAlertBoxDataManager.h
//  iArcos
//
//  Created by Richard on 21/06/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosCoreData.h"

@interface ArcosAlertBoxDataManager : NSObject {
    NSString* _qtyKey;
    NSString* _bonKey;
    NSString* _focKey;
    NSString* _instKey;
    NSString* _testKey;
    NSMutableDictionary* _columnDescDataDict;
}

@property(nonatomic, retain) NSString* qtyKey;
@property(nonatomic, retain) NSString* bonKey;
@property(nonatomic, retain) NSString* focKey;
@property(nonatomic, retain) NSString* instKey;
@property(nonatomic, retain) NSString* testKey;
@property(nonatomic, retain) NSMutableDictionary* columnDescDataDict;

- (void)retrieveColumnDescriptionInfo;

@end

