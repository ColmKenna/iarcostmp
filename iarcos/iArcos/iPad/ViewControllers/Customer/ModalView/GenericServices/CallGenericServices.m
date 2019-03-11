//
//  CallGenericServices.m
//  Arcos
//
//  Created by David Kilmartin on 02/12/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "CallGenericServices.h"
#import "ConnectivityCheck.h"


@implementation CallGenericServices
@synthesize delegate;
@synthesize HUD = _HUD;
@synthesize currentView;
@synthesize showingLoading;
@synthesize arcosService = _arcosService;
@synthesize isNotRecursion;
@synthesize connectivityCheck = _connectivityCheck;
//@synthesize recordDelegate;

-(id)initWithView:(UIView *)view{
    self=[super init];
    if (self!=nil) {
        self.currentView = view;
        self.showingLoading = YES;
        self.HUD = [[[MBProgressHUD alloc] initWithView:self.currentView] autorelease];
        self.HUD.dimBackground = YES;
        self.arcosService = [ArcosService serviceWithUsername:@"u1103395_Support" andPassword:@"Strata411325"];
        self.isNotRecursion = YES;
        self.connectivityCheck = [[[ConnectivityCheck alloc] init] autorelease];
    }
    return self;
}

-(void)refreshHUDViewFrame:(UIView *)view {
    self.HUD.frame = view.bounds;
}

-(BOOL)startCallService {
    [self.currentView addSubview:self.HUD];
    if (self.showingLoading && self.HUD.alpha < 1.0f) {
        BOOL isConnected = [self.connectivityCheck syncStart];
//        NSLog(@"isConnected %d", isConnected);
        if (!isConnected) {            
            [ArcosUtils showMsg:-1 message:self.connectivityCheck.errorString delegate:nil];
            return NO;            
        }
        self.HUD.labelText = @"Loading";    
        [self.HUD show:YES];
    }
    return YES;
}

-(id)handleResultErrorProcess:(id)result {
    if (self.showingLoading && self.isNotRecursion) {
        [self.HUD hide:YES];
    }    
    NSString *message;
    UIAlertView *v;
    if ([result isKindOfClass:[NSError class]]) {
        NSError* anError = (NSError*)result;
        message = [anError localizedDescription];
//        NSLog(@"NSError class %@", message);
        v = [[UIAlertView alloc] initWithTitle: @"Error !" message: message delegate: nil cancelButtonTitle: @"OK" otherButtonTitles: nil, nil];
        [v show];
        [v release];
        [self.HUD hide:YES];
        return nil;
    } else if ([result isKindOfClass:[SoapFault class]]) {
//        NSLog(@"SoapFault class2");
        SoapFault* anSoapFault = (SoapFault*)result;
        message = [anSoapFault faultString];
        v = [[UIAlertView alloc] initWithTitle: @"Error !" message: message delegate: nil cancelButtonTitle: @"OK" otherButtonTitles: nil, nil];
        [v show];
        [v release];
        [self.HUD hide:YES];
        return nil;
    }
//    NSLog(@"GetServiceData %@", result);    
    return result;
}

#pragma getData
-(void)getData:(NSString*) sqlTextString {    
    if (![self startCallService]) {
        return;
    }   
    [self.arcosService GetData:self action:@selector(resultBackFromGetDataService:) stateMent:sqlTextString];
    //Start an activity indicator here
    /*
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //Call your function or whatever work that needs to be done
        //Code in this part is run on a background thread
        NSLog(@"123");
        if (![self startCallService]) {
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            
            //Stop your activity indicator or anything else with the GUI
            //Code here is run on the main thread
            NSLog(@"45");
            [self.arcosService GetData:self action:@selector(resultBackFromGetDataService:) stateMent:sqlTextString];
        });
    });
    */
}

-(void)resultBackFromGetDataService:(id)result {
//    NSLog(@"GetDataService Call back from service");    
    if(result != nil) {
        result = [self handleResultErrorProcess:result];
        if (result != nil) {
            ArcosGenericReturnObject* replyResult = (ArcosGenericReturnObject*)result;
            [self.delegate setGetDataResult:replyResult];
        } else {
            [self.delegate setGetDataResult:result];
        }        
    } else {
        [self.delegate setGetDataResult:result];
    }    
}

#pragma getSecondData
-(void)getSecondData:(NSString*) sqlTextString {    
    if (![self startCallService]) {
        return;
    }   
    [self.arcosService GetData:self action:@selector(resultBackFromGetSecondDataService:) stateMent:sqlTextString];    
}

-(void)resultBackFromGetSecondDataService:(id)result {
//    NSLog(@"GetSecondDataResult Call back from service");    
    if(result != nil) {
        result = [self handleResultErrorProcess:result];
        if (result != nil) {
            ArcosGenericReturnObject* replyResult = (ArcosGenericReturnObject*)result;
            [self.delegate setGetSecondDataResult:replyResult];
        } else {
            [self.delegate setGetSecondDataResult:result];
        }        
    } else {
        [self.delegate setGetSecondDataResult:result];
    }    
}

#pragma getRecord
-(void)getRecord:(NSString*) tableName iur:(int)aIur {
    if (![self startCallService]) {
        return;
    }
    [self.arcosService GetRecord:self action:@selector(resultBackFromGetRecordService:) TableName:tableName iur:aIur];

}

-(void)resultBackFromGetRecordService:(id)result {
//    NSLog(@"GetRecordService Call back from service");    
    if(result != nil) {
        result = [self handleResultErrorProcess:result];
        if (result != nil) {
            ArcosGenericReturnObject* replyResult = (ArcosGenericReturnObject*)result;
            [self.delegate setGetRecordResult:replyResult];
        } else {
            [self.delegate setGetRecordResult:result];
        }        
    } else{
        [self.delegate setGetRecordResult:result];
    }
}

#pragma getGraph
-(void)getGraph:(NSString*) reportString iur:(int)aIur {
    if (![self startCallService]) {
        return;
    }
    [self.arcosService GetGraph:self action:@selector(resultBackFromGetGraphService:) iur:aIur reportString:reportString];
}

-(void)resultBackFromGetGraphService:(id)result {
//    NSLog(@"GetGraphService Call back from service");
    if (result != nil) {
        result = [self handleResultErrorProcess:result];
        if (result != nil) {
            ArcosReportModel* replyResult = (ArcosReportModel*)result;
            [self.delegate setGetGraphResult:replyResult];
        } else {
            [self.delegate setGetGraphResult:result];
        }
    } else {
        [self.delegate setGetGraphResult:result];
    }
}

#pragma UpdateRecord
-(void)updateRecord:(NSString*)tableName iur:(int)iur fieldName:(NSString*)fieldName newContent:(NSString*)newContent {
    if (![self startCallService]) {
        return;
    }
    [self.arcosService UpdateRecord:self action:@selector(resultBackFromUpdateRecordService:) TableName:tableName iur:iur FieldName:fieldName NewContent:newContent];
}

-(void)resultBackFromUpdateRecordService:(id)result {
//    NSLog(@"UpdateRecordService Call back from service");    
    if(result != nil) {
        result = [self handleResultErrorProcess:result];
        if (result != nil) {
            ArcosGenericReturnObject* replyResult = (ArcosGenericReturnObject*)result;
            [self.delegate setUpdateRecordResult:replyResult];
        } else {
            [self.delegate setUpdateRecordResult:result];
        }        
    } else{
        [self.delegate setUpdateRecordResult:result];
    }
}

#pragma CreateRecord
-(void)createRecord:(NSString*)tableName fields:(ArcosCreateRecordObject*)aFields {
    if (![self startCallService]) {
        return;
    }
    [self.arcosService CreateRecord:self action:@selector(resultBackFromCreateRecordService:) TableName:tableName Fields:aFields];
}

-(void)resultBackFromCreateRecordService:(id)result {
//    NSLog(@"CreateRecordService Call back from service");
//    [HUD hide:YES];
    if(result != nil) {
        result = [self handleResultErrorProcess:result];
        if (result != nil) {
            ArcosGenericClass* replyResult = (ArcosGenericClass*)result;
            [self.delegate setCreateRecordResult:replyResult];
        } else {
            [self.delegate setCreateRecordResult:result];
        }        
    } else{
        [self.delegate setCreateRecordResult:result];
    }
}

#pragma CreateMultipleRecords
-(void)createMultipleRecords:(NSString*)tableName records:(NSMutableArray*) records {
    if (![self startCallService]) {
        return;
    }
    [self.arcosService CreateMultipleRecords:self action:@selector(resultBackFromCreateMultipleRecordsService:) TableName:tableName records:records];
}

-(void)resultBackFromCreateMultipleRecordsService:(id)result {
    if(result != nil) {
        result = [self handleResultErrorProcess:result];
        if (result != nil) {
            NSMutableArray* replyResult = (NSMutableArray*)result;
            [self.delegate setCreateMultipleRecordsResult:replyResult];
        } else {
            [self.delegate setCreateMultipleRecordsResult:result];
        }        
    } else{
        [self.delegate setCreateMultipleRecordsResult:result];
    }
}

#pragma GetCustomerData
-(void)genericGetCustomerData:(int)aLocationIUR startDate:(NSDate*)aStartDate endDate:(NSDate*)anEndDate type:(NSString*)aType level:(int)aLevel action:(SEL)anAction target:(id)aTarget{
    if (![self startCallService]) {
        return;
    }
    [self.arcosService GetCustomerData:aTarget action:anAction Locationiur:aLocationIUR startDate:aStartDate endDate:(NSDate *)anEndDate Type:aType level:aLevel];
}
#pragma GetData
-(void)genericGetData:(NSString*) sqlTextString action:(SEL)anAction target:(id)aTarget {
    if (![self startCallService]) {
        return;
    }
    [self.arcosService GetData:aTarget action:anAction stateMent:sqlTextString];
}
-(void)genericGetReportMainWithEmployeeiur: (int) employeeiur reportiur: (int) reportiur startDate: (NSDate*) startDate endDate: (NSDate*) endDate type: (NSString*) type tablename: (NSString*) tablename iur: (int) iur action:(SEL)anAction target:(id)aTarget {
    if (![self startCallService]) {
        return;
    }
    [self.arcosService GetReportMain:aTarget action:anAction employeeiur:employeeiur reportiur:reportiur startDate:startDate endDate:endDate type:type tablename:tablename iur:iur];
}
-(void)genericGetReportSubWithEmployeeiur: (int) employeeiur reportiur: (int) reportiur startDate: (NSDate*) startDate endDate: (NSDate*) endDate type: (NSString*) type leveliur: (int) leveliur buy: (BOOL) buy tablename: (NSString*) tablename iur: (int) iur action:(SEL)anAction target:(id)aTarget {
    if (![self startCallService]) {
        return;
    }
    [self.arcosService GetReportSub:aTarget action:anAction employeeiur:employeeiur reportiur:reportiur startDate:startDate endDate:endDate type:type leveliur:leveliur buy:buy tablename:tablename iur:iur];
}
-(void)genericCreateRecord:(NSString*)tableName fields:(ArcosCreateRecordObject*)aFields action:(SEL)anAction target:(id)aTarget {
    if (![self startCallService]) {
        return;
    }
    [self.arcosService CreateRecord:aTarget action:anAction TableName:tableName Fields:aFields];
}

-(void)genericDeleteRecord:(NSString*)tableName iur: (int) iur action:(SEL)anAction target:(id)aTarget {
    if (![self startCallService]) {
        return;
    }
    [self.arcosService DeleteRecord:aTarget action:anAction TableName:tableName iur:iur];
}

-(void)genericGetStockistWithEmployeeiur: (int) employeeiur longtitude: (double) longtitude latitude: (double) latitude distance: (double) distance areacode: (NSString*) areacode areaiur: (int) areaiur level: (int) level levelcode: (NSString*) levelcode AsOfDate: (NSDate*) AsOfDate action:(SEL)anAction target:(id)aTarget{
    if (![self startCallService]) {
        return;
    }
    [self.arcosService GetStockist:aTarget action:anAction employeeiur:employeeiur longtitude:longtitude latitude:latitude distance:distance areacode:areacode areaiur:areaiur level:level levelcode:levelcode AsOfDate:AsOfDate];
}

-(void)genericGetFromResourcesWithFileName:(NSString*)aFileName action:(SEL)anAction target:(id)aTarget {
    if (![self startCallService]) {
        return;
    }
    [self.arcosService GetFromResources:aTarget action:anAction FileNAme:aFileName];
}

-(void)updateConnectivityRegisterValidation:(BOOL)aFlag {
    self.connectivityCheck.isRegisterValidation = aFlag;
}

-(void)genericGetRecord:(NSString*) tableName iur:(int)aIur action:(SEL)anAction target:(id)aTarget {
    if (![self startCallService]) {
        return;
    }
    [self.arcosService GetRecord:aTarget action:anAction TableName:tableName iur:aIur];
}

-(void)genericUpdateRecord:(NSString*)tableName iur:(int)iur fieldName:(NSString*)fieldName newContent:(NSString*)newContent action:(SEL)anAction target:(id)aTarget {
    if (![self startCallService]) {
        return;
    }
    [self.arcosService UpdateRecord:aTarget action:anAction TableName:tableName iur:iur FieldName:fieldName NewContent:newContent];
}

-(void)genericNotBuy:(int)aLocationIUR Level:(int)aLevel LevelCode:(NSString*)aLevelCode filterLevel:(int)aFilterLevel action:(SEL)anAction target:(id)aTarget {
    if (![self startCallService]) {
        return;
    }
    [self.arcosService NotBuy:aTarget action:anAction LocationIUR:aLocationIUR Level:aLevel LevelCode:aLevelCode filterLevel:aFilterLevel];
}

-(void)genericProductSalesPerLocationSummary:(int)aLocationiur productiur: (int)aProductiur action:(SEL)anAction target:(id)aTarget {
    if (![self startCallService]) {
        return;
    }
    [self.arcosService ProductSalesPerLocationSummary:aTarget action:anAction locationiur:aLocationiur productiur:aProductiur];
}

-(void)genericGetSurveySummaryByLocation:(int)aLocationiur action:(SEL)anAction target:(id)aTarget {
    if (![self startCallService]) {
        return;
    }
    [self.arcosService GetSurverySummaryByLocation:aTarget action:anAction locaioniur:aLocationiur];
}

-(void)genericGetSurveryDetailsByLocation:(int)aLocationiur contactiur:(int)aContactiur surveyiur:(int)aSurveyiur responseDate:(NSDate*)aResponseDate action:(SEL)anAction target:(id)aTarget {
    if (![self startCallService]) {
        return;
    }
    [self.arcosService GetSurveryDetailsByLocation:aTarget action:anAction locationiur:aLocationiur contactiur:aContactiur surveyiur:aSurveyiur responseDate:aResponseDate];
}

- (void)genericGet_Resource_FilenamesByLocation:(int)aLocationIUR locationCode:(NSString*)aLocationCode action:(SEL)anAction target:(id)aTarget {
    if (![self startCallService]) {
        return;
    }
    [self.arcosService Get_Resource_Filenames:aTarget action:anAction LocationIUR:aLocationIUR LocationCode:aLocationCode];
}

- (void)genericGetTargetByEmployee:(int)anEmployeeIUR action:(SEL)anAction target:(id)aTarget {
    if (![self startCallService]) {
        return;
    }
    [self.arcosService GetTargetByEmployee:aTarget action:anAction EmployeeIUR:anEmployeeIUR];
}

- (void)genericUpdateMeetingByMeetingBO:(ArcosMeetingWithDetails*)aMeetingToUpdate action:(SEL)anAction target:(id)aTarget {
    if (![self startCallService]) {
        return;
    }
    [self.arcosService UpdateMeeting:aTarget action:anAction meetingToUpdate:aMeetingToUpdate];
}

- (void)genericGetMeetingWithIUR:(NSNumber*)anIUR action:(SEL)anAction target:(id)aTarget {
    if (![self startCallService]) {
        return;
    }
    [self.arcosService GetMeeting:aTarget action:anAction meetingiur:[anIUR intValue]];
}

-(void)dealloc{
//    if (self.delegate != nil) { self.delegate = nil; }
    [self.HUD removeFromSuperview];
    if (self.currentView != nil) { self.currentView = nil;}
    if (self.HUD != nil) { self.HUD = nil; }  
    if (self.arcosService != nil) { self.arcosService = nil; }
    if (self.connectivityCheck != nil) {
        self.connectivityCheck = nil;
    }
    
    [super dealloc];
}



@end
