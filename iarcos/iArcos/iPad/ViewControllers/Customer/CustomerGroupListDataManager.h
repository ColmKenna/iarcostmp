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
}

@property(nonatomic, retain) NSString* masterLocationTitle;

@property(nonatomic, retain) NSString* buyingGroupTitle;
@property(nonatomic, retain) NSString* buyingGroupDescrTypeCode;

- (void)filterWithBuyingGroupCondition:(NSMutableDictionary*)aBuyingGroupDict resultList:(NSMutableArray*)aResultList;

@end
