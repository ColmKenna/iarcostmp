//
//  CallGenericServices.h
//  Arcos
//
//  Created by David Kilmartin on 02/12/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosService.h"
#import "MBProgressHUD.h"
#import "ArcosUtils.h"
@class ConnectivityCheck;
#import "ArcosMeetingWithDetailsUpload.h"

@protocol GetDataGenericDelegate <NSObject>

@optional
-(void)setGetDataResult:(ArcosGenericReturnObject*) result;
-(void)setGetSecondDataResult:(ArcosGenericReturnObject*) result;
-(void)setGetRecordResult:(ArcosGenericReturnObject*) result;
-(void)setGetGraphResult:(ArcosReportModel*) result;
-(void)setUpdateRecordResult:(ArcosGenericReturnObject*) result;
-(void)setCreateRecordResult:(ArcosGenericClass*) result;
-(void)setCreateMultipleRecordsResult:(NSMutableArray*) result;
//-(void)setGetCustomerDataResult:(ArcosGenericReturnObject*) result;
@end



@interface CallGenericServices : NSObject {
    id<GetDataGenericDelegate> delegate;
    MBProgressHUD* _HUD;
    UIView* currentView;
    BOOL showingLoading;
    ArcosService* _arcosService;
    BOOL isNotRecursion;
    ConnectivityCheck* _connectivityCheck;
}

@property(nonatomic, assign) BOOL showingLoading;
@property(nonatomic, assign) id<GetDataGenericDelegate> delegate;
@property(nonatomic, retain) MBProgressHUD* HUD;
@property(nonatomic, retain) UIView* currentView;
@property(nonatomic, retain) ArcosService* arcosService;
@property(nonatomic, assign) BOOL isNotRecursion;
@property(nonatomic, retain) ConnectivityCheck* connectivityCheck;

-(id)initWithView:(UIView *)view;
-(void)refreshHUDViewFrame:(UIView *)view;

-(BOOL)startCallService;
-(id)handleResultErrorProcess:(id)result;

-(void)getData:(NSString*) sqlTextString;
-(void)resultBackFromGetDataService:(id)result;

-(void)getSecondData:(NSString*) sqlTextString;
-(void)resultBackFromGetSecondDataService:(id)result;

-(void)getRecord:(NSString*) tableName iur:(int)aIur;
-(void)resultBackFromGetRecordService:(id)result;

-(void)getGraph:(NSString*) reportString iur:(int)aIur;
-(void)resultBackFromGetGraphService:(id)result;

-(void)updateRecord:(NSString*)tableName iur:(int)iur fieldName:(NSString*)fieldName newContent:(NSString*)newContent;
-(void)resultBackFromUpdateRecordService:(id)result;

-(void)createRecord:(NSString*)tableName fields:(ArcosCreateRecordObject*)aFields;
-(void)resultBackFromCreateRecordService:(id)result;

-(void)createMultipleRecords:(NSString*)tableName records:(NSMutableArray*) records;
-(void)resultBackFromCreateMultipleRecordsService:(id)result;

-(void)genericGetCustomerData:(int)aLocationIUR startDate:(NSDate*)aStartDate endDate:(NSDate*)anEndDate type:(NSString*)aType level:(int)aLevel action:(SEL)anAction target:(id)aTarget;
-(void)genericGetData:(NSString*) sqlTextString action:(SEL)anAction target:(id)aTarget;
-(void)genericGetReportMainWithEmployeeiur: (int) employeeiur reportiur: (int) reportiur startDate: (NSDate*) startDate endDate: (NSDate*) endDate type: (NSString*) type tablename: (NSString*) tablename iur: (int) iur action:(SEL)anAction target:(id)aTarget;
-(void)genericGetReportSubWithEmployeeiur: (int) employeeiur reportiur: (int) reportiur startDate: (NSDate*) startDate endDate: (NSDate*) endDate type: (NSString*) type leveliur: (int) leveliur buy: (BOOL) buy tablename: (NSString*) tablename iur: (int) iur action:(SEL)anAction target:(id)aTarget;
-(void)genericCreateRecord:(NSString*)tableName fields:(ArcosCreateRecordObject*)aFields action:(SEL)anAction target:(id)aTarget;
-(void)genericDeleteRecord:(NSString*)tableName iur: (int) iur action:(SEL)anAction target:(id)aTarget;
-(void)genericGetStockistWithEmployeeiur: (int) employeeiur longtitude: (double) longtitude latitude: (double) latitude distance: (double) distance areacode: (NSString*) areacode areaiur: (int) areaiur level: (int) level levelcode: (NSString*) levelcode AsOfDate: (NSDate*) AsOfDate action:(SEL)anAction target:(id)aTarget;
-(void)genericGetFromResourcesWithFileName:(NSString*)aFileName action:(SEL)anAction target:(id)aTarget;
-(void)updateConnectivityRegisterValidation:(BOOL)aFlag;
-(void)genericGetRecord:(NSString*) tableName iur:(int)aIur action:(SEL)anAction target:(id)aTarget;
-(void)genericUpdateRecord:(NSString*)tableName iur:(int)iur fieldName:(NSString*)fieldName newContent:(NSString*)newContent action:(SEL)anAction target:(id)aTarget;
-(void)genericNotBuy:(int)aLocationIUR Level:(int)aLevel LevelCode:(NSString*)aLevelCode filterLevel:(int)aFilterLevel action:(SEL)anAction target:(id)aTarget;
-(void)genericProductSalesPerLocationSummary:(int)aLocationiur productiur: (int)aProductiur action:(SEL)anAction target:(id)aTarget;
-(void)genericGetSurveySummaryByLocation:(int)aLocationiur action:(SEL)anAction target:(id)aTarget;
-(void)genericGetSurveryDetailsByLocation:(int)aLocationiur contactiur:(int)aContactiur surveyiur:(int)aSurveyiur responseDate:(NSDate*)aResponseDate action:(SEL)anAction target:(id)aTarget;
- (void)genericGet_Resource_FilenamesByLocation:(int)aLocationIUR locationCode:(NSString*)aLocationCode action:(SEL)anAction target:(id)aTarget;
- (void)genericGetTargetByEmployee:(int)anEmployeeIUR action:(SEL)anAction target:(id)aTarget;
- (void)genericUpdateMeetingByMeetingBO:(ArcosMeetingWithDetailsDownload*)aMeetingToUpdate action:(SEL)anAction target:(id)aTarget;
- (void)genericGetMeetingWithIUR:(NSNumber*)anIUR action:(SEL)anAction target:(id)aTarget;
- (void)genericUploadFileNewWithContents:(NSData*)aContents fileName:(NSString*)aFileName description:(NSString*)aDescription tableIUR:(NSString*)aTableIUR tableName:(NSString*)aTableName employeeiur:(int)anEmployeeiur locationiur:(int)aLocationiur dateAttached:(NSDate*)aDateAttached action:(SEL)anAction target:(id)aTarget;
- (void)genericProcessDashboardQueryWithDashboardiur:(int)aDashboardiur Employeeiur:(int)anEmployeeiur Locationiur:(int)aLocationiur action:(SEL)anAction target:(id)aTarget;
- (void)genericGetAttachmentWithIUR:(int)anIUR action:(SEL)anAction target:(id)aTarget;
- (void)genericReporterOptionsWithAction:(SEL)anAction target:(id)aTarget;
- (void)genericFileExistsInResourcesWithFileName:(NSString*)aFileName action:(SEL)anAction target:(id)aTarget;

@end
