//
//  CustomerGroupListDataManager.h
//  iArcos
//
//  Created by David Kilmartin on 12/05/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "CustomerGroupDataManager.h"

@interface CustomerGroupListDataManager : CustomerGroupDataManager {
    NSString* _masterLocationTitle;
    
    NSString* _buyingGroupTitle;
    NSString* _buyingGroupDescrTypeCode;
    NSString* _locationStatusDescrTypeCode;
    NSString* _creditStatusDescrTypeCode;
    NSString* _locationStatusTitle;
    NSString* _creditStatusTitle;
}

@property(nonatomic, retain) NSString* masterLocationTitle;

@property(nonatomic, retain) NSString* buyingGroupTitle;
@property(nonatomic, retain) NSString* buyingGroupDescrTypeCode;
@property(nonatomic, retain) NSString* locationStatusDescrTypeCode;
@property(nonatomic, retain) NSString* creditStatusDescrTypeCode;
@property(nonatomic, retain) NSString* locationStatusTitle;
@property(nonatomic, retain) NSString* creditStatusTitle;

- (void)filterWithBuyingGroupCondition:(NSMutableDictionary*)aBuyingGroupDict resultList:(NSMutableArray*)aResultList;
- (NSMutableDictionary*)createLocationStatusDict;
- (NSMutableDictionary*)createCreditStatusDict;


@end
