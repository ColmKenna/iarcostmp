//
//  LocalNewItemsWebServiceProcessor.h
//  iArcos
//
//  Created by David Kilmartin on 20/04/2016.
//  Copyright (c) 2016 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocalNewItemsUpdateCenterDelegate.h"
#import "ArcosService.h"
#import "UploadProcessCenter.h"

@interface LocalNewItemsWebServiceProcessor : NSObject <UploadWebServiceProcessorDelegate> {
    id<LocalNewItemsUpdateCenterDelegate> _updateCenterDelegate;
    ArcosService* _arcosService;
    BOOL _isProcessingFinished;
    UploadProcessCenter* _uploadProcessCenter;
    NSMutableArray* _locationCompetitor2List;
    int _locationCompetitor2RowPointer;
    NSMutableArray* _contactCP20List;
    int _contactCP20RowPointer;
    NSMutableArray* _responseObjectList;
    int _responsePageIndex;
    int _responseTotalPage;
}

@property(nonatomic, assign) id<LocalNewItemsUpdateCenterDelegate> updateCenterDelegate;
@property(nonatomic, retain) ArcosService* arcosService;
@property(nonatomic, assign) BOOL isProcessingFinished;
@property(nonatomic, retain) UploadProcessCenter* uploadProcessCenter;
@property(nonatomic, retain) NSMutableArray* locationCompetitor2List;
@property(nonatomic, assign) int locationCompetitor2RowPointer;
@property(nonatomic, retain) NSMutableArray* contactCP20List;
@property(nonatomic, assign) int contactCP20RowPointer;
@property(nonatomic, retain) NSMutableArray* responseObjectList;
@property(nonatomic, assign) int responsePageIndex;
@property(nonatomic, assign) int responseTotalPage;

- (void)updateLocationToServer;
- (void)updateResponseToServer;
- (void)uploadCollectedToServer;
- (void)updateLocationCompetitor2ToServer;
- (void)updateContactCP20ToServer;
- (NSMutableArray*)locationArray;
- (NSMutableArray*)responseArray;
- (NSMutableArray*)retrieveLocationCompetitor2List;
- (NSMutableArray*)retrieveContactCP20List;

@end
