//
//  OrderDetailDataManager.h
//  Arcos
//
//  Created by David Kilmartin on 21/02/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosCoreData.h"
#import "OrderDetailOrderDataManager.h"
#import "OrderDetailCallDataManager.h"

@interface OrderDetailDataManager : NSObject {
    OrderDetailBaseDataManager* _orderDetailBaseDataManager;
    NSNumber* _orderNumber;
    NSMutableDictionary* _savedOrderDetailCellData;
    NSMutableDictionary* _orderHeader;
    NSMutableArray* _sectionTitleList;
    NSMutableDictionary* _groupedDataDict;
    NSMutableArray* _actionTableDataDictList;
    BOOL _locationSwitchedFlag;
}

@property(nonatomic, retain) OrderDetailBaseDataManager* orderDetailBaseDataManager;
@property(nonatomic, retain) NSNumber* orderNumber;
@property(nonatomic, retain) NSMutableDictionary* savedOrderDetailCellData;
@property(nonatomic, retain) NSMutableDictionary* orderHeader;
@property(nonatomic, retain) NSMutableArray* sectionTitleList;
@property(nonatomic, retain) NSMutableDictionary* groupedDataDict;
@property(nonatomic, retain) NSMutableArray* actionTableDataDictList;
@property(nonatomic, assign) BOOL locationSwitchedFlag;

- (void)loadSavedOrderDetailCellData:(NSMutableDictionary*)aCellData;
- (NSMutableDictionary*)cellDataWithIndexPath:(NSIndexPath*)anIndexPath;
- (void)inputFinishedWithData:(id)data forIndexpath:(NSIndexPath*)theIndexpath;
- (BOOL)saveTheOrderHeader;
- (NSMutableArray*)createActionTableDataDictList:(NSMutableDictionary*)aCellData;
- (void)locationInputFinishedWithData:(id)data forIndexpath:(NSIndexPath *)theIndexpath;

@end
