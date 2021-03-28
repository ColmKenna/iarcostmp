//
//  CustomerGDPRDataManager.h
//  iArcos
//
//  Created by David Kilmartin on 03/05/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosArrayOfCallTran.h"

@interface CustomerGDPRDataManager : NSObject {
    NSMutableArray* _displayList;
    NSNumber* _locationIUR;
    NSString* _locationName;
    NSString* _locationAddress;
    NSMutableDictionary* _contactDict;
    NSMutableDictionary* _orderHeader;
    NSString* _configErrorMsg;
    ArcosArrayOfCallTran* _callTranList;
    NSNumber* _detailIUR;
    NSNumber* _score;
    NSString* _tooltip;
}

@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) NSNumber* locationIUR;
@property(nonatomic, retain) NSString* locationName;
@property(nonatomic, retain) NSString* locationAddress;
@property(nonatomic, retain) NSMutableDictionary* contactDict;
@property(nonatomic, retain) NSMutableDictionary* orderHeader;
@property(nonatomic, retain) NSString* configErrorMsg;
@property(nonatomic, retain) ArcosArrayOfCallTran* callTranList;
@property(nonatomic, retain) NSNumber* detailIUR;
@property(nonatomic, retain) NSNumber* score;
@property(nonatomic, retain) NSString* tooltip;

- (BOOL)enableSignatureAmendment;
- (BOOL)tickSelectedCondition;
- (NSNumber*)tickSelectedIUR;
- (BOOL)contactSelectedCondition;

@end
