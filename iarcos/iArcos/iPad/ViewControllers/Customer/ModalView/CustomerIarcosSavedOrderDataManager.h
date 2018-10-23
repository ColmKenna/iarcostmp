//
//  CustomerIarcosSavedOrderDataManager.h
//  iArcos
//
//  Created by David Kilmartin on 03/11/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosCoreData.h"
#import "ArcosConfigDataManager.h"

@interface CustomerIarcosSavedOrderDataManager : NSObject {
    NSMutableArray* _displayList;
    NSNumber* _locationIUR;
    NSMutableDictionary* _currentSelectedOrderHeader;
    NSIndexPath* _sendingIndexPath;
    NSNumber* _sendingOrderNumber;
    BOOL _sendingSuccessFlag;
    NSMutableArray* _remoteTableDataDictList;
    NSNumber* _currentNumberOflines;
}

@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) NSNumber* locationIUR;
@property(nonatomic, retain) NSMutableDictionary* currentSelectedOrderHeader;
@property(nonatomic, retain) NSIndexPath* sendingIndexPath;
@property(nonatomic, retain) NSNumber* sendingOrderNumber;
@property(nonatomic, assign) BOOL sendingSuccessFlag;
@property(nonatomic, retain) NSMutableArray* remoteTableDataDictList;
@property(nonatomic, retain) NSNumber* currentNumberOflines;

- (id)initWithLocationIUR:(NSNumber*)aLocationIUR;
- (void)orderListingWithLocationIUR:(NSNumber*)aLocationIUR locationDefaultContactIUR:(NSNumber*)aLocationDefaultContactIUR;
- (NSMutableArray*)createTableDataDictList;
- (void)processRemoteOrderRawData:(NSMutableArray*)aDataList;
- (void)processRemoteCallRawData:(NSMutableArray*)aDataList;
- (void)normaliseData;

@end
