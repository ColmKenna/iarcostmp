//
//  CustomerIarcosInvoiceDetailsCellFactory.h
//  iArcos
//
//  Created by David Kilmartin on 16/12/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderDetailBaseTableCell.h"

@interface CustomerIarcosInvoiceDetailsCellFactory : NSObject {
    NSString* _readLabelTableCellId;
    NSString* _drillDownTableCellId;
}

@property(nonatomic, retain) NSString* readLabelTableCellId;
@property(nonatomic, retain) NSString* drillDownTableCellId;

+(id)factory;
- (OrderDetailBaseTableCell*)createOrderDetailBaseTableCellWithData:(NSMutableDictionary*)aData;
- (OrderDetailBaseTableCell*)createOrderDetailReadLabelTableCell;
- (OrderDetailBaseTableCell*)createOrderDetailDrillDownTableCell;
- (NSString*)identifierWithData:(NSMutableDictionary*)aData;

@end
