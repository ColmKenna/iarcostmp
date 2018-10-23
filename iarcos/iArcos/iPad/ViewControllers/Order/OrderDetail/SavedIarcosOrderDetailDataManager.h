//
//  SavedIarcosOrderDetailDataManager.h
//  iArcos
//
//  Created by David Kilmartin on 05/11/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosCoreData.h"
#import "SavedIarcosOrderDetailOrderDataManager.h"
#import "SavedIarcosOrderDetailCallDataManager.h"
#import "SavedIarcosOrderDetailRemoteOrderDataManager.h"
#import "SavedIarcosOrderDetailRemoteCallDataManager.h"

@interface SavedIarcosOrderDetailDataManager : NSObject {
    NSNumber* _orderNumber;
    NSMutableDictionary* _orderHeader;
    NSMutableArray* _sectionTitleList;
    NSMutableDictionary* _groupedDataDict;
    SavedIarcosOrderDetailBaseDataManager* _savedIarcosOrderDetailBaseDataManager;
    BOOL _isContactDetailsShowed;
    BOOL _isOrderDetailsShowed;
    BOOL _isMemoDetailsShowed;
    NSMutableArray* _actionTableDataDictList;
}

@property(nonatomic, retain) NSNumber* orderNumber;
@property(nonatomic, retain) NSMutableDictionary* orderHeader;
@property(nonatomic, retain) NSMutableArray* sectionTitleList;
@property(nonatomic, retain) NSMutableDictionary* groupedDataDict;
@property(nonatomic, retain) SavedIarcosOrderDetailBaseDataManager* savedIarcosOrderDetailBaseDataManager;
@property(nonatomic, assign) BOOL isContactDetailsShowed;
@property(nonatomic, assign) BOOL isOrderDetailsShowed;
@property(nonatomic, assign) BOOL isMemoDetailsShowed;
@property(nonatomic, retain) NSMutableArray* actionTableDataDictList;

- (void)loadSavedOrderDetailCellData:(NSMutableDictionary*)aCellData;
- (NSMutableDictionary*)cellDataWithIndexPath:(NSIndexPath*)anIndexPath;
- (void)inputFinishedWithData:(id)data forIndexpath:(NSIndexPath*)theIndexpath;
- (BOOL)saveTheOrderHeader;
- (void)processRemoteOrderDetailRawData:(ArcosGenericClass*)arcosGenericClass cellDict:(NSMutableDictionary*)aCellDict;
- (void)processRemoteCallDetailRawData:(ArcosGenericClass*)arcosGenericClass cellDict:(NSMutableDictionary*)aCellDict;
- (NSMutableArray*)createActionTableDataDictList:(NSMutableDictionary*)aCellData;

@end
