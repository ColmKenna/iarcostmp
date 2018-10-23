//
//  OrderlinesIarcosTableCellFactory.h
//  iArcos
//
//  Created by David Kilmartin on 10/11/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderlinesIarcosBaseTableViewCell.h"

@interface OrderlinesIarcosTableCellFactory : NSObject {
    NSString* _qtyTableCellId;
    NSString* _qtyBonusTableCellId;
    NSString* _qtyDiscTableCellId;
    NSString* _splitQtyTableCellId;
    NSString* _splitQtyBonusTableCellId;
    NSString* _blankTableCellId;
}

@property(nonatomic, retain) NSString* qtyTableCellId;
@property(nonatomic, retain) NSString* qtyBonusTableCellId;
@property(nonatomic, retain) NSString* qtyDiscTableCellId;
@property(nonatomic, retain) NSString* splitQtyTableCellId;
@property(nonatomic, retain) NSString* splitQtyBonusTableCellId;
@property(nonatomic, retain) NSString* blankTableCellId;

- (OrderlinesIarcosBaseTableViewCell*)createOrderlinesIarcosBaseTableViewCellWithData:(NSMutableDictionary*)aData;
-(NSString*)identifierWithData:(NSMutableDictionary*)aData;

@end
