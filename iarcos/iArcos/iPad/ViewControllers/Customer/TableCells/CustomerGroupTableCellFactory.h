//
//  CustomerGroupTableCellFactory.h
//  iArcos
//
//  Created by David Kilmartin on 14/06/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomerGroupBaseTableViewCell.h"

@interface CustomerGroupTableCellFactory : NSObject {
    NSString* _contactTableCellId;
    NSString* _accessTimesTableCellId;
    NSString* _notSeenTableCellId;
    NSString* _buyingGroupTableCellId;
}

@property(nonatomic, retain) NSString* contactTableCellId;
@property(nonatomic, retain) NSString* accessTimesTableCellId;
@property(nonatomic, retain) NSString* notSeenTableCellId;
@property(nonatomic, retain) NSString* buyingGroupTableCellId;

+ (instancetype)factory;
- (NSString*)identifierWithData:(NSMutableDictionary*)aData;
- (CustomerGroupBaseTableViewCell*)createCustomerGroupBaseTableViewCellWithData:(NSMutableDictionary*)aData;

@end
