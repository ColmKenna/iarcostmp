//
//  CustomerIarcosInvoiceDetailsDataManager.h
//  iArcos
//
//  Created by David Kilmartin on 16/12/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosCoreData.h"

@interface CustomerIarcosInvoiceDetailsDataManager : NSObject {
    NSNumber* _invoiceIUR;
    ArcosGenericClass* _replyResult;
    NSMutableArray* _sectionTitleList;
    NSMutableDictionary* _groupedDataDict;
    NSString* _invoiceDetailsTitle;
    NSMutableArray* _orderlineDictList;
    NSString* _orderHeaderIUR;
    NSString* _orderNumber;
}

@property(nonatomic, retain) NSNumber* invoiceIUR;
@property(nonatomic, retain) ArcosGenericClass* replyResult;
@property(nonatomic, retain) NSMutableArray* sectionTitleList;
@property(nonatomic, retain) NSMutableDictionary* groupedDataDict;
@property(nonatomic, retain) NSString* invoiceDetailsTitle;
@property(nonatomic, retain) NSMutableArray* orderlineDictList;
@property (nonatomic,retain) NSString* orderHeaderIUR;
@property (nonatomic,retain) NSString* orderNumber;

- (void)loadInvoiceDetailsData:(ArcosGenericClass*)aReplyResult;
- (void)createInvoiceDetailsSectionData;
- (NSMutableDictionary*)createReadLabelCellDataWithCellKey:(NSString*)aCellKey fieldNameLabel:(NSString*)aFieldNameLabel fieldData:(NSString*)aFieldData;
- (void)createDrillDownSectionDataWithSectionTitle:(NSString*)aSectionTitle orderHeaderType:(NSNumber*)anOrderHeaderType;
- (NSMutableDictionary*)createDrillDownCellDataWithFieldNameLabel:(NSString*)aFieldNameLabel orderHeaderType:(NSNumber*)anOrderHeaderType;
- (NSMutableDictionary*)createOrderNumberCellDataWithFieldNameLabel:(NSString*)aFieldNameLabel fieldData:(NSString*)aFieldData;
- (NSMutableDictionary*)cellDataWithIndexPath:(NSIndexPath*)anIndexPath;
- (void)createOrderlinesData;

@end
