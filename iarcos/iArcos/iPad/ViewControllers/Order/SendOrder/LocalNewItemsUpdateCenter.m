//
//  LocalNewItemsUpdateCenter.m
//  Arcos
//
//  Created by David Kilmartin on 16/03/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "LocalNewItemsUpdateCenter.h"
#import "SettingManager.h"
#import "ArcosCoreData.h"
#import "ArcosLocationBO.h"
@implementation LocalNewItemsUpdateCenter
@synthesize localItemsDelegate = _localItemsDelegate;
//@synthesize arcosService = _arcosService;
@synthesize itemsWebServiceProcessor = _itemsWebServiceProcessor;
@synthesize selectorList = _selectorList;
@synthesize currentSelectorDict = _currentSelectorDict;
@synthesize selectorListCount = _selectorListCount;
@synthesize isBusy = _isBusy;
@synthesize performTimer = _performTimer;

- (instancetype)init {
    self = [super init];
    if (self != nil) {
//        self.arcosService = [ArcosService serviceWithUsername:@"u1103395_Support" andPassword:@"Strata411325"];
        self.itemsWebServiceProcessor = [[[LocalNewItemsWebServiceProcessor alloc] init] autorelease];
        self.itemsWebServiceProcessor.updateCenterDelegate = self;
        self.selectorList = [NSMutableArray array];
        self.isBusy = NO;
    }
    return self;
}

- (void)dealloc {
//    self.arcosService = nil;
    self.itemsWebServiceProcessor = nil;
    self.selectorList = nil;
    self.currentSelectorDict = nil;
    self.performTimer = nil;
    
    [super dealloc];
}
/*
-(void)updateAll{
    [self updateLocationToServer];
}

-(void)updateLocationToServer{
    NSMutableArray* resultArray=[self locationArray];
    if ([resultArray count]<=0) {
        [self updateRespondToServer];
        return;
    }
    
    [self.arcosService UpdateLocationsLongtitudeLatitude:self action:@selector(locationUpdateResult:) CompanyIUR:[[SettingManager companyIUR]intValue] EmployeeIUR:[[SettingManager employeeIUR]intValue]  Locations:resultArray];
}
-(void)updateRespondToServer{
    NSMutableArray* resultArray=[self responseArray];
    if ([resultArray count]<=0) {
        [self.localItemsDelegate didFinishLocalNewItemsSending];
        return;
    }
    
    [self.arcosService UpdateResponses:self action:@selector(responseUpdateResult:) CompanyIUR:[[SettingManager companyIUR]intValue] EmployeeIUR:[[SettingManager employeeIUR]intValue] Responses:resultArray];
}
- (void)uploadPhotosToServer {
    
}

-(NSMutableArray*)locationArray{
    NSArray* locations=[[ArcosCoreData sharedArcosCoreData]allLocationWithNewGeo];
    NSMutableArray* returnArray=[NSMutableArray array];
    
    for (Location* aLocation in locations) {
        ArcosLocationLongtitideLatitudeUpdateObject* locationBO=[[ArcosLocationLongtitideLatitudeUpdateObject alloc]init];
        locationBO.Iur=[aLocation.LocationIUR intValue];
        locationBO.Latitude=[NSDecimalNumber decimalNumberWithDecimal:[aLocation.Latitude decimalValue]]; 
        locationBO.Longitude=[NSDecimalNumber decimalNumberWithDecimal:[aLocation.Longitude decimalValue]];
        
        [returnArray addObject:locationBO];
        [locationBO release];
    }
    
    return returnArray;
}
-(NSMutableArray*)responseArray{
    NSArray* responses=[[ArcosCoreData sharedArcosCoreData]allNewResponse];
    NSMutableArray* returnArray=[NSMutableArray array];
    
    for (Response* aResponse in responses) {
        ArcosResponseBO* responseBO=[[ArcosResponseBO alloc]init];
        responseBO.Answer=[ArcosUtils wrapStringByCDATA:aResponse.Answer];
        responseBO.Calliur=[aResponse.CallIUR intValue];
        responseBO.Contactiur=[aResponse.ContactIUR intValue];
        responseBO.Iur=[aResponse.IUR intValue];
        responseBO.Locationiur=[aResponse.LocationIUR intValue];
        responseBO.Questioniur=[aResponse.QuestionIUR intValue];
        responseBO.Responseint=[aResponse.ResponseInt intValue];
        responseBO.ResponseDate=aResponse.ResponseDate;
        responseBO.Surveyiur=[aResponse.SurveyIUR intValue];
        [returnArray addObject:responseBO];
        [responseBO release];
    }
    return returnArray;
}

-(void)locationUpdateResult:(id)result{
    if (![self errorCheck:result]) {
        ArcosArrayOfLocationLongtitideLatitudeUpdateObject* objects=(ArcosArrayOfLocationLongtitideLatitudeUpdateObject*)result;
        for (ArcosLocationLongtitideLatitudeUpdateObject* object in objects) {
            [[ArcosCoreData sharedArcosCoreData]updateLocationWithFieldName:@"Competitor1" withActualContent:[NSNumber numberWithInt:0] withLocationIUR:[NSNumber numberWithInt:object.Iur]];
        }
    }
    [self updateRespondToServer];
}
-(void)responseUpdateResult:(id)result{
    if (![self errorCheck:result]) {
        ArcosArrayOfResponseBO* responses=(ArcosArrayOfResponseBO*)result;
        for (ArcosResponseBO* object in responses) {
            [[ArcosCoreData sharedArcosCoreData]updateResponseWithBO:object];
        }
    }
    [self.localItemsDelegate didFinishLocalNewItemsSending];
}

-(BOOL)errorCheck:(id)result{
    if (result!=nil) {
        if ([result isKindOfClass:[NSError class]]) {
            NSError* anError=(NSError*)result;
            NSLog(@"An error come back from service %@",[anError localizedDescription]);

        }else if([result isKindOfClass:[SoapFault class]]){
            SoapFault* fault=(SoapFault*)result;
            NSLog(@"An fault come back from service %@",[fault faultString]);
        }else {
            return NO;
        }
        
    }else{
        NSLog(@"An nil come back from service");
    }
    return YES;
}
*/

- (void)pushSelector:(SEL)aSelector name:(NSString*)aName {
    NSDictionary* tmpSelDict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSValue valueWithPointer:aSelector], aName, nil] forKeys:[NSArray arrayWithObjects:@"selector", @"name", nil]];
    [self.selectorList addObject:tmpSelDict];
}

- (NSDictionary*)popSelector {
    if ([self.selectorList count] > 0) {
        NSDictionary* tmpDict = [[[self.selectorList lastObject] retain] autorelease];
        if (tmpDict) {
            [self.selectorList removeLastObject];
        } else {
            return nil;
        }
        
        self.currentSelectorDict = tmpDict;
        return tmpDict;
    }
    return nil;
}

- (void)stopTask {
    [self.performTimer invalidate];
    self.performTimer = nil;
    [self.selectorList removeAllObjects];
    self.isBusy = NO;
    self.itemsWebServiceProcessor.isProcessingFinished = YES;
    [GlobalSharedClass shared].serviceTimeoutInterval = 60.0;
}

- (void)startPerformSelectorList {
    if ([self.selectorList count] <= 0 || self.isBusy) return;
    
    //set the service time out interval
    [GlobalSharedClass shared].serviceTimeoutInterval = 600.0;
    
    self.selectorListCount = [ArcosUtils convertNSUIntegerToUnsignedInt:[self.selectorList count]];
    self.isBusy = YES;
//    [self.myDelegate uploadBranchProcessInitiation];
    self.performTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkSelectorStack) userInfo:nil repeats:YES];
}

- (void)checkSelectorStack {
    if (!self.itemsWebServiceProcessor.isProcessingFinished) return;
    if ([self.selectorList count] <= 0) {
        [self.performTimer invalidate];
        self.performTimer = nil;
        [self.localItemsDelegate didFinishLocalNewItemsSending];
        self.isBusy = NO;
        
        //set the service time out interval back to default
        [GlobalSharedClass shared].serviceTimeoutInterval = 60.0;
    } else {
        NSDictionary* topSelectorDict = [self popSelector];
        if (topSelectorDict == nil) return;
        SEL topSelector = [[topSelectorDict objectForKey:@"selector"] pointerValue];
        [self.itemsWebServiceProcessor performSelector:topSelector];
    }
}

- (void)buildProcessSelectorList {
    [self.selectorList removeAllObjects];
    if ([[self.itemsWebServiceProcessor retrieveContactCP20List] count] > 0) {
        [self pushSelector:@selector(updateContactCP20ToServer) name:@"ContactCP20"];
    }
    if ([[self.itemsWebServiceProcessor retrieveLocationCompetitor2List] count] > 0) {
        [self pushSelector:@selector(updateLocationCompetitor2ToServer) name:@"LocationCompetitor2"];
    }
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] uploadPhotoAfterSendingOrderFlag]) {
        NSMutableArray* collectedDictList = [self.itemsWebServiceProcessor.uploadProcessCenter.webServiceProcessor.photoFileInfoProvider retrievePartialPhotoInfo];
        if ([collectedDictList count] > 0) {
            [self pushSelector:@selector(uploadCollectedToServer) name:[GlobalSharedClass shared].collectedSelectorName];
        }
    }
    if ([[self.itemsWebServiceProcessor responseArray] count] > 0) {
        [self pushSelector:@selector(updateResponseToServer) name:[GlobalSharedClass shared].responseSelectorName];
    }
    if ([[self.itemsWebServiceProcessor locationArray] count] > 0) {
        [self pushSelector:@selector(updateLocationToServer) name:[GlobalSharedClass shared].locationSelectorName];
    }
}

#pragma mark LocalNewItemsUpdateCenterDelegate
- (void)didFinishLocalNewItemsSending {
    
}

- (void)startLocalNewItemsSending:(NSString*)anItemName {
    [self.localItemsDelegate startLocalNewItemsSending:anItemName];
}

- (void)errorOccurredLocalNewItemsSending:(NSString*)anErrorMsg {
    [self stopTask];
    [self.localItemsDelegate errorOccurredLocalNewItemsSending:anErrorMsg];
    [self.localItemsDelegate didFinishLocalNewItemsSending];
}

@end
