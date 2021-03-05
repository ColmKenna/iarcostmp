//
//  SavedIarcosOrderDetailTableCellFactory.h
//  iArcos
//
//  Created by David Kilmartin on 05/11/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderDetailBaseTableCell.h"

@interface SavedIarcosOrderDetailTableCellFactory : NSObject {
    NSString* _dateTableCellId;
    NSString* _readLabelTableCellId;
    NSString* _writeLabelTableCellId;
    NSString* _textFieldTableCellId;
    NSString* _textViewTableCellId;
    NSString* _drillDownTableCellId;
    NSString* _numberTextFieldTableCellId;
    NSString* _dateHourMinTableCellId;
    NSString* _iArcosPrintTableCellId;
    NSString* _deliveryInstructions1TableCellId;
    NSString* _formTypeLabelTableCellId;
    NSString* _invoiceRefTableCellId;
}

@property(nonatomic, retain) NSString* dateTableCellId;
@property(nonatomic, retain) NSString* readLabelTableCellId;
@property(nonatomic, retain) NSString* writeLabelTableCellId;
@property(nonatomic, retain) NSString* textFieldTableCellId;
@property(nonatomic, retain) NSString* textViewTableCellId;
@property(nonatomic, retain) NSString* drillDownTableCellId;
@property(nonatomic, retain) NSString* numberTextFieldTableCellId;
@property(nonatomic, retain) NSString* dateHourMinTableCellId;
@property(nonatomic, retain) NSString* iArcosPrintTableCellId;
@property(nonatomic, retain) NSString* deliveryInstructions1TableCellId;
@property(nonatomic, retain) NSString* formTypeLabelTableCellId;
@property(nonatomic, retain) NSString* invoiceRefTableCellId;

+(id)factory;
- (OrderDetailBaseTableCell*)createOrderDetailBaseTableCellWithData:(NSMutableDictionary*)aData;
-(OrderDetailBaseTableCell*)createOrderDetailDateTableCell;
-(OrderDetailBaseTableCell*)createOrderDetailReadLabelTableCell;
-(OrderDetailBaseTableCell*)createOrderDetailWriteLabelTableCell;
-(OrderDetailBaseTableCell*)createOrderDetailTextFieldTableCell;
-(OrderDetailBaseTableCell*)createOrderDetailTextViewTableCell;
-(OrderDetailBaseTableCell*)createOrderDetailDrillDownTableCell;
-(OrderDetailBaseTableCell*)createOrderDetailNumberTextFieldTableCell;
-(OrderDetailBaseTableCell*)createOrderDetailDateHourMinTableCell;
-(OrderDetailBaseTableCell*)createOrderDetailIArcosPrintTableCell;
-(OrderDetailBaseTableCell*)createOrderDetailDeliveryInstructions1TableCell;
- (OrderDetailBaseTableCell*)createOrderDetailFormTypeLabelTableCell;
- (OrderDetailBaseTableCell*)createOrderDetailInvoiceRefTableCell;
-(NSString*)identifierWithData:(NSMutableDictionary*)aData;

@end
