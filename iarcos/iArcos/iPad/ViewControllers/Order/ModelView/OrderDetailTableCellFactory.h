//
//  OrderDetailTableCellFactory.h
//  Arcos
//
//  Created by David Kilmartin on 21/02/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderDetailBaseTableCell.h"

@interface OrderDetailTableCellFactory : NSObject {
    NSString* _dateTableCellId;
    NSString* _readLabelTableCellId;
    NSString* _writeLabelTableCellId;
    NSString* _textFieldTableCellId;
    NSString* _textViewTableCellId;
    NSString* _drillDownTableCellId;
    NSString* _numberTextFieldTableCellId;
    NSString* _dateHourMinTableCellId;
    NSString* _printTableCellId;
    NSString* _deliveryInstructions1TableCellId;
    NSString* _formTypeLabelTableCellId;
}

@property(nonatomic, retain) NSString* dateTableCellId;
@property(nonatomic, retain) NSString* readLabelTableCellId;
@property(nonatomic, retain) NSString* writeLabelTableCellId;
@property(nonatomic, retain) NSString* textFieldTableCellId;
@property(nonatomic, retain) NSString* textViewTableCellId;
@property(nonatomic, retain) NSString* drillDownTableCellId;
@property(nonatomic, retain) NSString* numberTextFieldTableCellId;
@property(nonatomic, retain) NSString* dateHourMinTableCellId;
@property(nonatomic, retain) NSString* printTableCellId;
@property(nonatomic, retain) NSString* deliveryInstructions1TableCellId;
@property(nonatomic, retain) NSString* formTypeLabelTableCellId;

+(id)factory;
- (OrderDetailBaseTableCell*)createOrderDetailBaseTableCellWithData:(NSMutableDictionary*)aData;
-(OrderDetailBaseTableCell*)createOrderDetailDateTableCell;
-(OrderDetailBaseTableCell*)createOrderDetailReadLabelTableCell;
-(OrderDetailBaseTableCell*)createOrderDetailWriteLabelTableCell;
-(OrderDetailBaseTableCell*)createOrderDetailTextFieldTableCell;
-(OrderDetailBaseTableCell*)createOrderDetailTextViewTableCell;
-(OrderDetailBaseTableCell*)createOrderDetailDrillDownTableCell;
-(OrderDetailBaseTableCell*)createOrderDetailPrintTableCell;
-(OrderDetailBaseTableCell*)createOrderDetailNumberTextFieldTableCell;
-(OrderDetailBaseTableCell*)createOrderDetailDateHourMinTableCell;
-(OrderDetailBaseTableCell*)createOrderDetailDeliveryInstructions1TableCell;
- (OrderDetailBaseTableCell*)createOrderDetailFormTypeLabelTableCell;
-(NSString*)identifierWithData:(NSMutableDictionary*)aData;

@end
