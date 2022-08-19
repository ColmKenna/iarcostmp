//
//  WebServiceSharedClass.h
//  Arcos
//
//  Created by David Kilmartin on 11/07/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "SynthesizeSingleton.h"
#import "ArcosCoreData.h"
#import "PaginatedUpdateCenter.h"
#import "PaginatedRequestObjectProvider.h"
#import "ResourcesUpdateCenter.h"
#import "SaveRecordUpdateCenter.h"
#import "ArcosConfigDataManager.h"
#import "SaveRecordLocationProductMATUpdateCenter.h"
#import "SaveRecordDescrDetailUpdateCenter.h"
#import "SaveRecordLocLocLinkUpdateCenter.h"
#import "BatchedUpdateCenter.h"
#import "WebServiceSharedDataManager.h"
#import "RemoveRecordUpdateCenter.h"
@protocol WebServiceSharedClassDelegate
-(void)StartGettingData;
-(void)GotData:(NSUInteger)dataCount;
-(void)UpdateData;
-(void)CommitData;
-(void)LoadingData:(int)currentDataCount;
-(void)FinishLoadingData:(NSUInteger)anOverallNumber;
-(void)ErrorOccured:(NSString*)errorDesc;
-(void)ProgressViewWithValue:(float)aProgressValue;
-(void)ProgressViewWithValueWithoutAnimation:(float)aProgressValue;
-(void)ResourceStatusTextWithValue:(NSString*)aValue;
- (void)GotFailWithErrorResourcesFileDelegate:(NSError *)anError;
- (void)GotErrorWithResourcesFile:(NSError *)anError;
@end

@interface WebServiceSharedClass : NSObject <PaginatedUpdateCenterDelegate,ResourcesUpdateCenterDelegate,SaveRecordUpdateCenterDelegate,BatchedUpdateCenterDelegate, RemoveRecordProcessorDelegate> {
    ArcosService* service;
    BOOL isLoadingFinished;
    
    //delegate
    id<WebServiceSharedClassDelegate>delegate;
    PaginatedUpdateCenter* _paginatedUpdateCenter;
    BOOL _isPaginatedLoadingFinished;
    PaginatedRequestObjectProvider* _paginatedRequestObjectProvider;
    ResourcesUpdateCenter* _resourcesUpdateCenter;
    NSString* _auxFileName;
    SaveRecordBaseUpdateCenter* _saveRecordUpdateCenter;
    NSString* _rowDelimiter;
    NSString* _serverFaultMsg;
    BatchedUpdateCenter* _batchedUpdateCenter;
    BOOL _isBatchedLoadingFinished;
    WebServiceSharedDataManager* _webServiceSharedDataManager;
    RemoveRecordUpdateCenter* _removeRecordUpdateCenter;
}
+ (WebServiceSharedClass *)sharedWebServiceSharedClass;
//-(id)init;

@property(nonatomic,retain)     ArcosService* service;
@property(nonatomic,assign)     BOOL isLoadingFinished;
@property(nonatomic,assign)    id<WebServiceSharedClassDelegate>delegate;
@property(nonatomic,retain) PaginatedUpdateCenter* paginatedUpdateCenter;
@property(nonatomic,assign) BOOL isPaginatedLoadingFinished;
@property(nonatomic,retain) PaginatedRequestObjectProvider* paginatedRequestObjectProvider;
@property(nonatomic,retain) ResourcesUpdateCenter* resourcesUpdateCenter;
@property(nonatomic,retain) NSString* auxFileName;
@property(nonatomic,retain) SaveRecordBaseUpdateCenter* saveRecordUpdateCenter;
@property(nonatomic,retain) NSString* rowDelimiter;
@property(nonatomic,retain) NSString* serverFaultMsg;
@property(nonatomic,retain) BatchedUpdateCenter* batchedUpdateCenter;
@property(nonatomic,assign) BOOL isBatchedLoadingFinished;
@property(nonatomic,retain) WebServiceSharedDataManager* webServiceSharedDataManager;
@property(nonatomic,retain) RemoveRecordUpdateCenter* removeRecordUpdateCenter;

-(BOOL)paginatedLoadingActionFlag;
-(BOOL)batchedLoadingActionFlag;
-(void)loadPaginatedProductsToDB:(NSNumber*)aPageNumber;
-(void)loadProductsToDB;
-(void)loadPriceToDB;
-(void)loadPaginatedLocationsToDB:(NSNumber*)aPageNumber;
-(void)loadPackageToDB;
-(void)loadLocationsToDB;
-(void)loadPaginatedLocLocLinkToDB:(NSNumber*)aPageNumber;
-(void)loadLocLocLinkToDB;
-(void)loadLocationProductMATToDB;
-(void)loadPaginatedDescrDetailsToDB:(NSNumber*)aPageNumber;
-(void)loadDescrDetailsToDB;
-(void)loadFormDetailsToDB;
-(void)loadPaginatedFormRowsToDB:(NSNumber*)aPageNumber;
-(void)loadFormRowsToDB;
-(void)loadWholeSalersToDB;
-(void)loadDescriptionTypeToDB;
-(void)loadPaginatedContactsToDB:(NSNumber*)aPageNumber;
-(void)loadContactToDB;
-(void)loadPaginatedConLocLinkToDB:(NSNumber*)aPageNumber;
-(void)loadConLocLinkToDB;
-(void)loadPresenterToDB;
-(void)loadPaginatedImageToDB:(NSNumber*)aPageNumber;
-(void)loadImageToDB;
-(void)loadEmployeeToDB;
-(void)loadConfigToDB;
//-(void)loadOrderToDB;
//-(void)loadOrderToDB:(NSDate*)aStartDate endDate:(NSDate*)aEndDate;
-(void)loadOrderToDB:(NSMutableDictionary*)aDataDict;
//-(void)loadCallToDB:(NSDate*)aStartDate endDate:(NSDate*)aEndDate;
-(void)loadCallToDB:(NSMutableDictionary*)aDataDict;
-(void)loadResponseToDB:(NSDate*)aStartDate endDate:(NSDate*)aEndDate;
-(void)loadSurveyToDB;
-(void)loadJourneyToDB;
-(void)loadResourcesToFolder;
-(void)loadPaginatedWSRToFolder:(NSString*)aFileName;

-(void)loadingProgress:(NSNumber*)value;

-(NSNumber*)companyIUR;
-(NSNumber*)employeeIUR;
-(id)handleResultErrorProcess:(id)result;
-(void)handleResultErrorProcessWithoutReturn:(id)result;
-(void)handlePaginatedResultErrorProcess;

@end
