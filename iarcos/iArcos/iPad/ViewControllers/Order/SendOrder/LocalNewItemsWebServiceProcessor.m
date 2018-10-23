//
//  LocalNewItemsWebServiceProcessor.m
//  iArcos
//
//  Created by David Kilmartin on 20/04/2016.
//  Copyright (c) 2016 Strata IT Limited. All rights reserved.
//

#import "LocalNewItemsWebServiceProcessor.h"
#import "SettingManager.h"
#import "ArcosCoreData.h"
#import "ArcosLocationBO.h"
@interface LocalNewItemsWebServiceProcessor()
- (BOOL)errorCheck:(id)result;
- (void)submitLocationCompetitor2List;
- (void)submitContactCP20List;
@end

@implementation LocalNewItemsWebServiceProcessor
@synthesize updateCenterDelegate = _updateCenterDelegate;
@synthesize arcosService = _arcosService;
@synthesize isProcessingFinished = _isProcessingFinished;
@synthesize uploadProcessCenter = _uploadProcessCenter;
@synthesize locationCompetitor2List = _locationCompetitor2List;
@synthesize contactCP20List = _contactCP20List;
@synthesize contactCP20RowPointer = _contactCP20RowPointer;
@synthesize responseObjectList = _responseObjectList;
@synthesize responsePageIndex = _responsePageIndex;
@synthesize responseTotalPage = _responseTotalPage;

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.arcosService = [ArcosService service];
        self.isProcessingFinished = YES;
        self.uploadProcessCenter = [[[UploadProcessCenter alloc] init] autorelease];
        self.uploadProcessCenter.myDelegate = self;
    }
    return self;
}

- (void)dealloc {
    self.arcosService = nil;
    self.uploadProcessCenter = nil;
    self.locationCompetitor2List = nil;
    self.contactCP20List = nil;
    self.responseObjectList = nil;
    
    [super dealloc];
}

- (void)updateLocationToServer {
    if (self.isProcessingFinished) {
        self.isProcessingFinished = NO;
        NSMutableArray* resultArray = [self locationArray];
        if ([resultArray count] <= 0) {
            self.isProcessingFinished = YES;
            return;
        }
        [self.updateCenterDelegate startLocalNewItemsSending:@"Coordinates"];
        [self.arcosService UpdateLocationsLongtitudeLatitude:self action:@selector(locationUpdateResult:) CompanyIUR:[[SettingManager companyIUR]intValue] EmployeeIUR:[[SettingManager employeeIUR]intValue]  Locations:resultArray];
        
    }
}

- (void)updateResponseToServer {
    if (self.isProcessingFinished) {
        self.isProcessingFinished = NO;
//        NSMutableArray* resultArray = [self responseArray];
        self.responsePageIndex = 0;
        self.responseTotalPage = [self retrieveTotalPage:[ArcosUtils convertNSUIntegerToUnsignedInt:[self.responseObjectList count]] pageSize:[GlobalSharedClass shared].responsePageSize];
        if ([self.responseObjectList count] <= 0) {
            self.isProcessingFinished = YES;
            return;
        }
        [self.updateCenterDelegate startLocalNewItemsSending:@"Survey Responses"];
        [self submitResponseList];
        
    }
}

- (void)submitResponseList {
    int auxLocation = self.responsePageIndex * [GlobalSharedClass shared].responsePageSize;
    int auxLength = (self.responsePageIndex < (self.responseTotalPage - 1)) ? [GlobalSharedClass shared].responsePageSize : ([ArcosUtils convertNSUIntegerToUnsignedInt:[self.responseObjectList count]] - auxLocation);
    NSRange responseRange = NSMakeRange(auxLocation, auxLength);
    
    NSArray* tmpResponseArray = [self.responseObjectList subarrayWithRange:responseRange];
    NSMutableArray* responseArray = [NSMutableArray arrayWithArray:tmpResponseArray];
    [self.arcosService UpdateResponses:self action:@selector(responseUpdateResult:) CompanyIUR:[[SettingManager companyIUR]intValue] EmployeeIUR:[[SettingManager employeeIUR]intValue] Responses:responseArray];
}

- (void)uploadCollectedToServer {
    if (self.isProcessingFinished) {
        self.isProcessingFinished = NO;
        [self.updateCenterDelegate startLocalNewItemsSending:@"Photos"];
        [self.uploadProcessCenter.selectorList removeAllObjects];
        [self.uploadProcessCenter pushSelector:@selector(uploadPartialPhoto) name:[GlobalSharedClass shared].collectedSelectorName];
        [self.uploadProcessCenter startPerformSelectorList];
    }
}

- (void)updateLocationCompetitor2ToServer {
    if (self.isProcessingFinished) {
        self.isProcessingFinished = NO;
        self.locationCompetitor2List = [self retrieveLocationCompetitor2List];
        self.locationCompetitor2RowPointer = 0;
        if ([self.locationCompetitor2List count] <= 0) {
            self.isProcessingFinished = YES;
            return;
        }
        [self.updateCenterDelegate startLocalNewItemsSending:@"Location Access Times"];
        [self submitLocationCompetitor2List];
    }
}

- (void)updateContactCP20ToServer {
    if (self.isProcessingFinished) {
        self.isProcessingFinished = NO;
        self.contactCP20List = [self retrieveContactCP20List];
        self.contactCP20RowPointer = 0;
        if ([self.contactCP20List count] <= 0) {
            self.isProcessingFinished = YES;
            return;
        }
        [self.updateCenterDelegate startLocalNewItemsSending:@"Contact Access Times"];
        [self submitContactCP20List];
    }
}

- (void)submitLocationCompetitor2List {
    Location* aLocation = [self.locationCompetitor2List objectAtIndex:self.locationCompetitor2RowPointer];
    [self.arcosService UpdateRecord:self action:@selector(locationCompetitor2UpdateRecordResult:) TableName:@"Location" iur:[aLocation.LocationIUR intValue] FieldName:@"AccessTimes" NewContent:aLocation.accessTimes];
}

- (void)submitContactCP20List {
    Contact* aContact = [self.contactCP20List objectAtIndex:self.contactCP20RowPointer];
    [self.arcosService UpdateRecord:self action:@selector(contactCP20UpdateRecordResult:) TableName:@"Contact" iur:[aContact.IUR intValue] FieldName:@"AccessTimes" NewContent:aContact.accessTimes];
}

- (void)locationCompetitor2UpdateRecordResult:(id)result {
    if (![self errorCheck:result]) {
        Location* aLocation = [self.locationCompetitor2List objectAtIndex:self.locationCompetitor2RowPointer];
        [[ArcosCoreData sharedArcosCoreData]updateLocationWithFieldName:@"Competitor2" withActualContent:[NSNumber numberWithInt:0] withLocationIUR:aLocation.LocationIUR];
        self.locationCompetitor2RowPointer++;
        if (self.locationCompetitor2RowPointer == [self.locationCompetitor2List count]) {
            self.isProcessingFinished = YES;
            return;
        }
        [self submitLocationCompetitor2List];
    } else {
        self.isProcessingFinished = YES;
    }
}

- (void)contactCP20UpdateRecordResult:(id)result {
    if (![self errorCheck:result]) {
        Contact* aContact = [self.contactCP20List objectAtIndex:self.contactCP20RowPointer];
        [[ArcosCoreData sharedArcosCoreData]updateContactWithFieldName:@"cP20" withActualContent:[NSNumber numberWithInt:0] withContactIUR:aContact.IUR];
        self.contactCP20RowPointer++;
        if (self.contactCP20RowPointer == [self.contactCP20List count]) {
            self.isProcessingFinished = YES;
            return;
        }
        [self submitContactCP20List];
    } else {
        self.isProcessingFinished = YES;
    }
}

-(void)locationUpdateResult:(id)result{
    if (![self errorCheck:result]) {
        ArcosArrayOfLocationLongtitideLatitudeUpdateObject* objects=(ArcosArrayOfLocationLongtitideLatitudeUpdateObject*)result;
        for (ArcosLocationLongtitideLatitudeUpdateObject* object in objects) {
            [[ArcosCoreData sharedArcosCoreData]updateLocationWithFieldName:@"Competitor1" withActualContent:[NSNumber numberWithInt:0] withLocationIUR:[NSNumber numberWithInt:object.Iur]];
        }
    }
    self.isProcessingFinished = YES;
}

- (void)responseUpdateResult:(id)result{
    if (![result isKindOfClass:[NSError class]] && ![result isKindOfClass:[SoapFault class]]) {
        ArcosArrayOfResponseBO* responses=(ArcosArrayOfResponseBO*)result;
        for (ArcosResponseBO* object in responses) {
            [[ArcosCoreData sharedArcosCoreData]updateResponseWithBO:object];
        }
        self.responsePageIndex++;
        if (self.responsePageIndex >= self.responseTotalPage) {
            self.responseObjectList = nil;
            self.isProcessingFinished = YES;
            return;
        }
        [self submitResponseList];
    } else {
        [self handleResultErrorProcessWithoutReturn:result];
        self.responseObjectList = nil;
        self.isProcessingFinished = YES;
    }    
}

- (void)handleResultErrorProcessWithoutReturn:(id)result {
    NSString* errorMsg = [GlobalSharedClass shared].unassignedText;
    if ([result isKindOfClass:[NSError class]]) {
        NSError* anError = (NSError*)result;
        errorMsg = [anError localizedDescription];        
        [self.updateCenterDelegate errorOccurredLocalNewItemsSending:errorMsg];
    } else if ([result isKindOfClass:[SoapFault class]]) {        
        SoapFault* anSoapFault = (SoapFault*)result;
        errorMsg = [anSoapFault faultString];
        [self.updateCenterDelegate errorOccurredLocalNewItemsSending:errorMsg];
    } else {
        [self.updateCenterDelegate errorOccurredLocalNewItemsSending:errorMsg];
    }
}

- (int)retrieveTotalPage:(int)aTotalCount pageSize:(int)aPageSize {
    float tmpTotalPage = aTotalCount * 1.0f / aPageSize;
    int totalPages = (int)ceilf(tmpTotalPage);
    return totalPages;
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
//    NSMutableArray* returnArray=[NSMutableArray array];
    self.responseObjectList = [NSMutableArray arrayWithCapacity:[responses count]];
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
//        [returnArray addObject:responseBO];
        [self.responseObjectList addObject:responseBO];
        [responseBO release];
    }
    return self.responseObjectList;
}

- (NSMutableArray*)retrieveLocationCompetitor2List {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"Competitor2 = %@", [NSNumber numberWithInt:99]];
    NSMutableArray* objectArray = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"Location" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
    return objectArray;
}

- (NSMutableArray*)retrieveContactCP20List {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"cP20 = %@", [NSNumber numberWithInt:99]];
    NSMutableArray* objectArray = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"Contact" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
    return objectArray;
}

- (BOOL)errorCheck:(id)result{
    if ([result isKindOfClass:[NSError class]]) {
        NSError* anError = (NSError*)result;
        NSLog(@"An error come back from service %@",[anError localizedDescription]);
        
    } else if ([result isKindOfClass:[SoapFault class]]){
        SoapFault* fault=(SoapFault*)result;
        NSLog(@"An fault come back from service %@",[fault faultString]);
    } else {
        return NO;
    }
    return YES;
}

#pragma mark UploadWebServiceProcessorDelegate
- (void)uploadBranchProcessInitiation {
    
}
- (void)uploadBranchProcessCompleted {
    self.isProcessingFinished = YES;
}
- (void)uploadProcessStarted {
    
}
- (void)uploadProcessWithText:(NSString *)aText {
    
}
- (void)uploadProgressViewWithValue:(float)aProgressValue {
    
}
- (void)uploadProcessFinished:(NSString *)aSelectorName sectionTitle:(NSString *)aSectionTitle overallNumber:(int)anOverallNumber {
    
}
- (void)uploadProcessWithErrorMsg:(NSString *)anErrorMsg {
    self.isProcessingFinished = YES;
}


@end
