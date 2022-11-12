//
//  WebServiceSharedClass.m
//  Arcos
//
//  Created by David Kilmartin on 11/07/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "WebServiceSharedClass.h"
#import "SettingManager.h"
@interface WebServiceSharedClass ()
- (void)genericGenerateDataAsCsvBackFromService:(id)result action:(SEL)anAction;
- (void)genericWSRBackFromService:(id)result className:(NSString*)aClassName;
@end

@implementation WebServiceSharedClass
//SYNTHESIZE_SINGLETON_FOR_CLASS(WebServiceSharedClass);
@synthesize service;
@synthesize isLoadingFinished;
@synthesize delegate;
@synthesize paginatedUpdateCenter = _paginatedUpdateCenter;
@synthesize isPaginatedLoadingFinished = _isPaginatedLoadingFinished;
@synthesize paginatedRequestObjectProvider = _paginatedRequestObjectProvider;
@synthesize resourcesUpdateCenter = _resourcesUpdateCenter;
@synthesize auxFileName = _auxFileName;
@synthesize saveRecordUpdateCenter = _saveRecordUpdateCenter;
@synthesize rowDelimiter = _rowDelimiter;
@synthesize serverFaultMsg = _serverFaultMsg;
@synthesize batchedUpdateCenter = _batchedUpdateCenter;
@synthesize isBatchedLoadingFinished = _isBatchedLoadingFinished;
@synthesize webServiceSharedDataManager = _webServiceSharedDataManager;
@synthesize removeRecordUpdateCenter = _removeRecordUpdateCenter;

-(id)init{
    self=[super init];
    if (self!=nil) {
        //make a service instance
        //self.service=[ArcosService serviceWithUsername:@"u1103395_Support" andPassword:@"Strata411325"];
        self.isLoadingFinished=YES;
        self.isPaginatedLoadingFinished = YES;
        self.isBatchedLoadingFinished = YES;
        self.paginatedRequestObjectProvider = [[[PaginatedRequestObjectProvider alloc] init] autorelease];
        self.rowDelimiter = @"\r\n";
        self.serverFaultMsg = @"server fault";
        self.webServiceSharedDataManager = [[[WebServiceSharedDataManager alloc] init] autorelease];
    }
    
    return self;
}
+ (WebServiceSharedClass *)sharedWebServiceSharedClass{
    WebServiceSharedClass* se=[[[self alloc]init]autorelease];
    se.service=[ArcosService serviceWithUsername:@"u1103395_Support" andPassword:@"Strata411325"];
    return se;
}
//data loading functions
-(BOOL)paginatedLoadingActionFlag {
    return self.isPaginatedLoadingFinished;
}
-(BOOL)batchedLoadingActionFlag {
    return self.isBatchedLoadingFinished;
}

-(void)loadPaginatedProductsToDB:(NSNumber*)aPageNumber {    
    if (self.isPaginatedLoadingFinished) {        
//        PaginatedRequestObject* productRequestObject = [self.paginatedRequestObjectProvider productRequestObject];
//        [self.service GetPagedProductDetailsView:self action:@selector(paginatedProductsBackFromService:) SelectStateMent:productRequestObject.selectStateMent fromStatement:productRequestObject.fromStatement OrderBy:productRequestObject.orderBy pagenumber:[aPageNumber intValue] pagesize:[GlobalSharedClass shared].pageSize];
        NSMutableDictionary* productDataDict = [self.paginatedRequestObjectProvider getUpdateCenterDataDict:[GlobalSharedClass shared].productSelectorName];
        NSNumber* downloadMode = [productDataDict objectForKey:@"DownloadMode"];
        NSNumber* isDownloaded = [productDataDict objectForKey:@"IsDownloaded"];
        SettingManager* sm = [SettingManager setting];
        NSString* keypath = [NSString stringWithFormat:@"CompanySetting.%@",@"Download"];
        NSMutableDictionary* activeOnly = [sm getSettingForKeypath:keypath atIndex:3];
        NSNumber* active = [activeOnly objectForKey:@"Value"];
        NSMutableDictionary* empolyee = [sm getSettingForKeypath:@"PersonalSetting.Personal" atIndex:0];
        NSNumber* empolyeeIUR = [empolyee objectForKey:@"Value"];
        if ([downloadMode intValue] == 1 && [isDownloaded boolValue]) {//1:Partial
            NSDate* downloadDate = [productDataDict objectForKey:@"DownloadDate"];
            if ([[ArcosConfigDataManager sharedArcosConfigDataManager] allowDownloadByEmployeeFlag]) {
                [self.service GetAllActiveProductsRestrictedByEmployeePaged:self action:@selector(paginatedProductsBackFromService:) employeeiur:[empolyeeIUR intValue] activeOnly:[active boolValue] StartDate:downloadDate pagenumber:[aPageNumber intValue] pagesize:[GlobalSharedClass shared].pageSize];
            } else {
                [self.service GetAllActiveProductsPaged:self action:@selector(paginatedProductsBackFromService:) activeOnly:[active boolValue] StartDate:downloadDate pagenumber:[aPageNumber intValue] pagesize:[GlobalSharedClass shared].pageSize];
            }
        } else {
            if ([[ArcosConfigDataManager sharedArcosConfigDataManager] allowDownloadByEmployeeFlag]) {
                [self.service GetAllActiveProductsRestrictedByEmployeePaged:self action:@selector(paginatedProductsBackFromService:) employeeiur:[empolyeeIUR intValue] activeOnly:[active boolValue] StartDate:[ArcosUtils dateFromString:@"01/12/1999" format:[GlobalSharedClass shared].dateFormat] pagenumber:[aPageNumber intValue] pagesize:[GlobalSharedClass shared].pageSize];
            } else {
                [self.service GetAllActiveProductsPaged:self action:@selector(paginatedProductsBackFromService:) activeOnly:[active boolValue] StartDate:[ArcosUtils dateFromString:@"01/12/1999" format:[GlobalSharedClass shared].dateFormat] pagenumber:[aPageNumber intValue] pagesize:[GlobalSharedClass shared].pageSize];
            }
        }
    }
    self.isPaginatedLoadingFinished = NO;
}

-(void)loadProductsToDB{
    if (self.isLoadingFinished) {
//        PaginatedRequestObject* productRequestObject = [self.paginatedRequestObjectProvider productRequestObject];
        NSMutableDictionary* productDataDict = [self.paginatedRequestObjectProvider getUpdateCenterDataDict:[GlobalSharedClass shared].productSelectorName];
        NSNumber* downloadMode = [productDataDict objectForKey:@"DownloadMode"];
        NSNumber* isDownloaded = [productDataDict objectForKey:@"IsDownloaded"];
        SettingManager* sm = [SettingManager setting];
        NSString* keypath = [NSString stringWithFormat:@"CompanySetting.%@",@"Download"];
        NSMutableDictionary* activeOnly = [sm getSettingForKeypath:keypath atIndex:3];
        NSNumber* active = [activeOnly objectForKey:@"Value"];
        NSMutableDictionary* empolyee = [sm getSettingForKeypath:@"PersonalSetting.Personal" atIndex:0];
        NSNumber* empolyeeIUR = [empolyee objectForKey:@"Value"];
        if ([[ArcosConfigDataManager sharedArcosConfigDataManager] downloadDataByCSVFlag]) {
//            NSString* sqlStatement = [NSString stringWithFormat:@"%@ %@ %@", productRequestObject.selectStateMent, productRequestObject.fromStatement, productRequestObject.orderBy];
//            [self.service GenerateDataAsCsv:self action:@selector(generateDataAsCsvBackFromService:) stateMent:sqlStatement];
            if ([downloadMode intValue] == 1 && [isDownloaded boolValue]) {//1:Partial
                NSDate* downloadDate = [productDataDict objectForKey:@"DownloadDate"];
                if ([[ArcosConfigDataManager sharedArcosConfigDataManager] allowDownloadByEmployeeFlag]) {
                    [self.service GenerateProductDataRestrictedByEmployeeAsCsv:self action:@selector(generateDataAsCsvBackFromService:) Employeeiur:[empolyeeIUR intValue] activeOnly:[active boolValue] StartDate:downloadDate];
                } else {
                    [self.service GenerateProductDataAsCsv:self action:@selector(generateDataAsCsvBackFromService:) activeOnly:[active boolValue] StartDate:downloadDate];
                }
            } else {
                if ([[ArcosConfigDataManager sharedArcosConfigDataManager] allowDownloadByEmployeeFlag]) {
                    [self.service GenerateProductDataRestrictedByEmployeeAsCsv:self action:@selector(generateDataAsCsvBackFromService:) Employeeiur:[empolyeeIUR intValue] activeOnly:[active boolValue] StartDate:[ArcosUtils dateFromString:@"01/12/1999" format:[GlobalSharedClass shared].dateFormat]];
                } else {
                    [self.service GenerateProductDataAsCsv:self action:@selector(generateDataAsCsvBackFromService:) activeOnly:[active boolValue] StartDate:[ArcosUtils dateFromString:@"01/12/1999" format:[GlobalSharedClass shared].dateFormat]];
                }
            }
        } else {
//            [self.service GetPagedProductDetailsView:self action:@selector(productsBackFromService:) SelectStateMent:productRequestObject.selectStateMent fromStatement:productRequestObject.fromStatement OrderBy:productRequestObject.orderBy pagenumber:1 pagesize:[GlobalSharedClass shared].pageSize];
            if ([downloadMode intValue] == 1 && [isDownloaded boolValue]) {//1:Partial
                NSDate* downloadDate = [productDataDict objectForKey:@"DownloadDate"];
                if ([[ArcosConfigDataManager sharedArcosConfigDataManager] allowDownloadByEmployeeFlag]) {
                    [self.service GetAllActiveProductsRestrictedByEmployeePaged:self action:@selector(productsBackFromService:) employeeiur:[empolyeeIUR intValue] activeOnly:[active boolValue] StartDate:downloadDate pagenumber:1 pagesize:[GlobalSharedClass shared].pageSize];
                } else {
                    [self.service GetAllActiveProductsPaged:self action:@selector(productsBackFromService:) activeOnly:[active boolValue] StartDate:downloadDate pagenumber:1 pagesize:[GlobalSharedClass shared].pageSize];
                }
            } else {
                if ([[ArcosConfigDataManager sharedArcosConfigDataManager] allowDownloadByEmployeeFlag]) {
                    [self.service GetAllActiveProductsRestrictedByEmployeePaged:self action:@selector(productsBackFromService:) employeeiur:[empolyeeIUR intValue] activeOnly:[active boolValue] StartDate:[ArcosUtils dateFromString:@"01/12/1999" format:[GlobalSharedClass shared].dateFormat] pagenumber:1 pagesize:[GlobalSharedClass shared].pageSize];
                } else {
                    [self.service GetAllActiveProductsPaged:self action:@selector(productsBackFromService:) activeOnly:[active boolValue] StartDate:[ArcosUtils dateFromString:@"01/12/1999" format:[GlobalSharedClass shared].dateFormat] pagenumber:1 pagesize:[GlobalSharedClass shared].pageSize];
                }
            }
        }
        [self.delegate StartGettingData];
    }
    self.isLoadingFinished=NO;
}

-(void)loadPriceToDB {
    if (self.isLoadingFinished) {
        NSLog(@"loadPriceToDB");
        PaginatedRequestObject* priceRequestObject = [self.paginatedRequestObjectProvider priceRequestObject];
        NSString* sqlStatement = [NSString stringWithFormat:@"%@ %@ %@", priceRequestObject.selectStateMent, priceRequestObject.fromStatement, priceRequestObject.orderBy];
        [self.service GenerateDataAsCsv:self action:@selector(priceGenerateDataAsCsvBackFromService:) stateMent:sqlStatement];
        [self.delegate StartGettingData];
    }
    self.isLoadingFinished = NO;
}

-(void)loadPaginatedLocationsToDB:(NSNumber*)aPageNumber {
    if (self.isPaginatedLoadingFinished) {
        PaginatedRequestObject* locationRequestObject = [self.paginatedRequestObjectProvider locationRequestObject];
        [self.service GetPagedProductDetailsView:self action:@selector(paginatedLocationsBackFromService:) SelectStateMent:locationRequestObject.selectStateMent fromStatement:locationRequestObject.fromStatement OrderBy:locationRequestObject.orderBy pagenumber:[aPageNumber intValue] pagesize:[GlobalSharedClass shared].pageSize];
    }
    self.isPaginatedLoadingFinished = NO;
}

-(void)loadPackageToDB {
    if (self.isLoadingFinished) {
        NSMutableArray* locationList = [[ArcosCoreData sharedArcosCoreData] retrieveLocationWithPredicate:nil];
        NSString* locationIurList = @"";
        int locationListLength = [ArcosUtils convertNSUIntegerToUnsignedInt:[locationList count]];
        if (locationListLength == 0) {
            self.isLoadingFinished = YES;
            return;
        }
        for (int i = 0; i < locationListLength; i++) {
            NSDictionary* locationDict = [locationList objectAtIndex:i];
            if (i == 0) {
                locationIurList = [NSString stringWithFormat:@"%@", [locationDict objectForKey:@"LocationIUR"]];
            } else {
                locationIurList = [NSString stringWithFormat:@"%@,%@", locationIurList, [locationDict objectForKey:@"LocationIUR"]];
            }
        }
        if ([locationIurList isEqualToString:@""]) {
            locationIurList = @"-999";
        }
        PaginatedRequestObject* packageRequestObject = [self.paginatedRequestObjectProvider packageRequestObject:locationIurList];
        NSString* sqlStatement = [NSString stringWithFormat:@"%@ %@ %@", packageRequestObject.selectStateMent, packageRequestObject.fromStatement, packageRequestObject.orderBy];
        [self.service GenerateDataAsCsv:self action:@selector(packageGenerateDataAsCsvBackFromService:) stateMent:[ArcosUtils wrapStringByCDATA:sqlStatement]];
        [self.delegate StartGettingData];
    }
    self.isLoadingFinished = NO;
}

-(void)loadLocationsToDB{
    if (self.isLoadingFinished){
        PaginatedRequestObject* locationRequestObject = [self.paginatedRequestObjectProvider locationRequestObject];
        if ([[ArcosConfigDataManager sharedArcosConfigDataManager] downloadDataByCSVFlag]) {
            NSString* sqlStatement = [NSString stringWithFormat:@"%@ %@ %@", locationRequestObject.selectStateMent, locationRequestObject.fromStatement, locationRequestObject.orderBy];
            [self.service GenerateDataAsCsv:self action:@selector(locationGenerateDataAsCsvBackFromService:) stateMent:sqlStatement];
        } else {
            [self.service GetPagedProductDetailsView:self action:@selector(locationsBackFromService:) SelectStateMent:locationRequestObject.selectStateMent fromStatement:locationRequestObject.fromStatement OrderBy:locationRequestObject.orderBy pagenumber:1 pagesize:[GlobalSharedClass shared].pageSize];
        }
        [self.delegate StartGettingData];
    }
    self.isLoadingFinished=NO;
}

-(void)loadPaginatedLocLocLinkToDB:(NSNumber*)aPageNumber {
    if (self.isPaginatedLoadingFinished) {
        PaginatedRequestObject* locLocLinkRequestObject = [self.paginatedRequestObjectProvider locLocLinkRequestObject];
        [self.service GetPagedProductDetailsView:self action:@selector(paginatedLocLocLinkBackFromService:) SelectStateMent:locLocLinkRequestObject.selectStateMent fromStatement:locLocLinkRequestObject.fromStatement OrderBy:locLocLinkRequestObject.orderBy pagenumber:[aPageNumber intValue] pagesize:[GlobalSharedClass shared].pageSize];
    }
    self.isPaginatedLoadingFinished = NO;
}

-(void)loadLocLocLinkToDB {
    if (self.isLoadingFinished){
        PaginatedRequestObject* locLocLinkRequestObject = [self.paginatedRequestObjectProvider locLocLinkRequestObject];
        if ([[ArcosConfigDataManager sharedArcosConfigDataManager] downloadDataByCSVFlag]) {
            NSString* sqlStatement = [NSString stringWithFormat:@"%@ %@ %@", locLocLinkRequestObject.selectStateMent, locLocLinkRequestObject.fromStatement, locLocLinkRequestObject.orderBy];
            [self.service GenerateDataAsCsv:self action:@selector(locLocLinkGenerateDataAsCsvBackFromService:) stateMent:sqlStatement];
        } else {
            [self.service GetPagedProductDetailsView:self action:@selector(locLocLinkBackFromService:) SelectStateMent:locLocLinkRequestObject.selectStateMent fromStatement:locLocLinkRequestObject.fromStatement OrderBy:locLocLinkRequestObject.orderBy pagenumber:1 pagesize:[GlobalSharedClass shared].pageSize];
        }
        [self.delegate StartGettingData];
    }
    self.isLoadingFinished=NO;
}

-(void)loadLocationProductMATToDB {
    if (self.isLoadingFinished){
        PaginatedRequestObject* locationProductMATRequestObject = [self.paginatedRequestObjectProvider locationProductMATRequestObject];
        NSString* sqlStatement = [NSString stringWithFormat:@"%@ %@ %@", locationProductMATRequestObject.selectStateMent, locationProductMATRequestObject.fromStatement, locationProductMATRequestObject.orderBy];
        [self.service GenerateDataAsCsv:self action:@selector(locationProductMATGenerateDataAsCsvBackFromService:) stateMent:sqlStatement];
        
        [self.delegate StartGettingData];
    }
    self.isLoadingFinished=NO;
}

-(void)loadPaginatedDescrDetailsToDB:(NSNumber*)aPageNumber {    
    if (self.isPaginatedLoadingFinished) {        
        PaginatedRequestObject* descrDetailsRequestObject = [self.paginatedRequestObjectProvider descrDetailsRequestObject];        
        [self.service GetPagedProductDetailsView:self action:@selector(paginatedDescrDetailsBackFromService:) SelectStateMent:descrDetailsRequestObject.selectStateMent fromStatement:descrDetailsRequestObject.fromStatement OrderBy:descrDetailsRequestObject.orderBy pagenumber:[aPageNumber intValue] pagesize:[GlobalSharedClass shared].pageSize];
    }
    self.isPaginatedLoadingFinished = NO;
}

-(void)loadDescrDetailsToDB{
    if (self.isLoadingFinished){
        PaginatedRequestObject* descrDetailRequestObject = [self.paginatedRequestObjectProvider descrDetailsRequestObject];
        if ([[ArcosConfigDataManager sharedArcosConfigDataManager] downloadDataByCSVFlag]) {
            NSString* sqlStatement = [NSString stringWithFormat:@"%@ %@ %@", descrDetailRequestObject.selectStateMent, descrDetailRequestObject.fromStatement, descrDetailRequestObject.orderBy];
            [self.service GenerateDataAsCsv:self action:@selector(descrDetailGenerateDataAsCsvBackFromService:) stateMent:sqlStatement];
        } else {
            [self.service GetPagedProductDetailsView:self action:@selector(descriptionsBackFromService:) SelectStateMent:descrDetailRequestObject.selectStateMent fromStatement:descrDetailRequestObject.fromStatement OrderBy:descrDetailRequestObject.orderBy pagenumber:1 pagesize:[GlobalSharedClass shared].pageSize];
        }
        
        [self.delegate StartGettingData];
    }
    self.isLoadingFinished=NO;

}

-(void)loadFormDetailsToDB{
    SettingManager* sm=[SettingManager setting];
    NSString* keypath=[NSString stringWithFormat:@"CompanySetting.%@",@"Download"];
    NSMutableDictionary* activeOnly=[sm getSettingForKeypath:keypath atIndex:4];
    NSNumber* active=[activeOnly objectForKey:@"Value"];
    
    if (self.isLoadingFinished){
        if ([[ArcosConfigDataManager sharedArcosConfigDataManager] allowDownloadByEmployeeFlag]) {
            int employeeIur = [[SettingManager employeeIUR] intValue];
            [self.service GetAllFormDetailsByEmployee:self action:@selector(formDetailsBackFromService:) CompanyIUR:[[self companyIUR] intValue] EmployeeIUR:employeeIur Active:[active boolValue]];
        } else {
            [self.service GetAllFormDetails:self action:@selector(formDetailsBackFromService:) CompanyIUR:[[self companyIUR] intValue] Active:[active boolValue]];
        }
        [self.delegate StartGettingData];
    }
    self.isLoadingFinished=NO;

}

-(void)loadPaginatedFormRowsToDB:(NSNumber*)aPageNumber {
    if (self.isPaginatedLoadingFinished) {
        PaginatedRequestObject* formRowRequestObject = [self.paginatedRequestObjectProvider formRowRequestObject];
        [self.service GetPagedProductDetailsView:self action:@selector(paginatedFormRowsBackFromService:) SelectStateMent:formRowRequestObject.selectStateMent fromStatement:formRowRequestObject.fromStatement OrderBy:formRowRequestObject.orderBy pagenumber:[aPageNumber intValue] pagesize:[GlobalSharedClass shared].pageSize];
    }
    self.isPaginatedLoadingFinished = NO;
}
-(void)loadFormRowsToDB{
    
    if (self.isLoadingFinished){
        /*
         SettingManager* sm=[SettingManager setting];
         NSString* keypath=[NSString stringWithFormat:@"CompanySetting.%@",@"Download"];
         NSMutableDictionary* activeOnly=[sm getSettingForKeypath:keypath atIndex:4];
         NSNumber* active=[activeOnly objectForKey:@"Value"];
         
        [self.service GetAllFormRows:self action:@selector(testFormRowsBackFromService:) CompanyIUR:[[self companyIUR] intValue] Active:[active boolValue]];
        */
        PaginatedRequestObject* formRowRequestObject = [self.paginatedRequestObjectProvider formRowRequestObject];
        [self.service GetPagedProductDetailsView:self action:@selector(formRowsBackFromService:) SelectStateMent:formRowRequestObject.selectStateMent fromStatement:formRowRequestObject.fromStatement OrderBy:formRowRequestObject.orderBy pagenumber:1 pagesize:[GlobalSharedClass shared].pageSize];        
         
        [self.delegate StartGettingData];
    }
    self.isLoadingFinished=NO;

}
-(void)loadWholeSalersToDB{
    
}

-(void)loadDescriptionTypeToDB{
    if (self.isLoadingFinished){
        [self.service GetAllDescrTypes:self  action:@selector(descrTypeBackFromService:) CompanyIUR:[[self companyIUR] intValue]];
        [self.delegate StartGettingData];
    }
    self.isLoadingFinished=NO;

}

-(void)loadPaginatedContactsToDB:(NSNumber*)aPageNumber {
    if (self.isPaginatedLoadingFinished) {        
        PaginatedRequestObject* contactRequestObject = [self.paginatedRequestObjectProvider contactRequestObject];        
        [self.service GetPagedProductDetailsView:self action:@selector(paginatedContactsBackFromService:) SelectStateMent:contactRequestObject.selectStateMent fromStatement:contactRequestObject.fromStatement OrderBy:contactRequestObject.orderBy pagenumber:[aPageNumber intValue] pagesize:[GlobalSharedClass shared].pageSize];
    }
    self.isPaginatedLoadingFinished = NO;
}

-(void)loadContactToDB{
    /*
    SettingManager* sm=[SettingManager setting];
    NSString* keypath=[NSString stringWithFormat:@"CompanySetting.%@",@"Download"];
    NSMutableDictionary* ownContactOnly=[sm getSettingForKeypath:keypath atIndex:1];
    NSNumber* ownContact=[ownContactOnly objectForKey:@"Value"];
    NSMutableDictionary* empolyee=[sm getSettingForKeypath:@"PersonalSetting.Personal" atIndex:0];
    NSNumber* empolyeeIUR=[empolyee objectForKey:@"Value"];
    int anIUR=0;
    if ([ownContact boolValue]) {
        anIUR=[empolyeeIUR intValue];
    }
    */
    if (self.isLoadingFinished){
//        [self.service GetAllContacts:self action:@selector(contactsBackFromService:) CompanyIUR:[[self companyIUR] intValue] EmployeeIUR:anIUR active:YES];
        PaginatedRequestObject* contactRequestObject = [self.paginatedRequestObjectProvider contactRequestObject];
        [self.service GetPagedProductDetailsView:self action:@selector(contactsBackFromService:) SelectStateMent:contactRequestObject.selectStateMent fromStatement:contactRequestObject.fromStatement OrderBy:contactRequestObject.orderBy pagenumber:1 pagesize:[GlobalSharedClass shared].pageSize];
        [self.delegate StartGettingData];
    }
    self.isLoadingFinished=NO;

}

-(void)loadPaginatedConLocLinkToDB:(NSNumber*)aPageNumber {
    if (self.isPaginatedLoadingFinished) {        
        PaginatedRequestObject* conLocLinkRequestObject = [self.paginatedRequestObjectProvider conLocLinkRequestObject];   
        [self.service GetPagedProductDetailsView:self action:@selector(paginatedConLocLinkBackFromService:) SelectStateMent:conLocLinkRequestObject.selectStateMent fromStatement:conLocLinkRequestObject.fromStatement OrderBy:conLocLinkRequestObject.orderBy pagenumber:[aPageNumber intValue] pagesize:[GlobalSharedClass shared].pageSize];
    }
    self.isPaginatedLoadingFinished = NO;
}

-(void)loadConLocLinkToDB{
    /*
    SettingManager* sm=[SettingManager setting];
    NSString* keypath=[NSString stringWithFormat:@"CompanySetting.%@",@"Download"];
    NSMutableDictionary* ownContactOnly=[sm getSettingForKeypath:keypath atIndex:1];
    NSNumber* ownContact=[ownContactOnly objectForKey:@"Value"];
    NSMutableDictionary* empolyee=[sm getSettingForKeypath:@"PersonalSetting.Personal" atIndex:0];
    NSNumber* empolyeeIUR=[empolyee objectForKey:@"Value"];
    int anIUR=0;
    if ([ownContact boolValue]) {
        anIUR=[empolyeeIUR intValue];
    }
    */
    if (self.isLoadingFinished){
//        [self.service GetAllConLocLinks:self action:@selector(conLocLinksBackFromService:) CompanyIUR:[[self companyIUR] intValue] EmployeeIUR:anIUR Active:YES];
        PaginatedRequestObject* conLocLinkRequestObject = [self.paginatedRequestObjectProvider conLocLinkRequestObject];        
        [self.service GetPagedProductDetailsView:self action:@selector(conLocLinksBackFromService:) SelectStateMent:conLocLinkRequestObject.selectStateMent fromStatement:conLocLinkRequestObject.fromStatement OrderBy:conLocLinkRequestObject.orderBy pagenumber:1 pagesize:[GlobalSharedClass shared].pageSize];
        [self.delegate StartGettingData];
    }
    self.isLoadingFinished=NO;


}
-(void)loadPresenterToDB{
    
    if (self.isLoadingFinished){
        if ([[ArcosConfigDataManager sharedArcosConfigDataManager] allowDownloadByEmployeeFlag]) {
            int employeeIur = [[SettingManager employeeIUR] intValue];
            [self.service GetAllPresentersForEmployee: self action:@selector(presenterBackFromService:) CompanyIUR:[[self companyIUR] intValue] Employeeiur:employeeIur Active:YES];
        } else {
            [self.service GetAllPresenters: self action:@selector(presenterBackFromService:) CompanyIUR:[[self companyIUR] intValue] Active:YES];
        }
        [self.delegate StartGettingData];
    }
    self.isLoadingFinished=NO;

}

-(void)loadPaginatedImageToDB:(NSNumber*)aPageNumber {
    if (self.isPaginatedLoadingFinished) {        
        PaginatedRequestObject* imageRequestObject = [self.paginatedRequestObjectProvider imageRequestObject];        
        [self.service GetPagedProductDetailsView:self action:@selector(paginatedImageBackFromService:) SelectStateMent:imageRequestObject.selectStateMent fromStatement:imageRequestObject.fromStatement OrderBy:imageRequestObject.orderBy pagenumber:[aPageNumber intValue] pagesize:[GlobalSharedClass shared].imagePageSize];
    }
    self.isPaginatedLoadingFinished = NO;
}

-(void)loadImageToDB{
    if (self.isLoadingFinished){
//        [self.service GetAllImages:self action:@selector(imageBackFromService:) CompanyIUR:[[self companyIUR] intValue]];
        PaginatedRequestObject* imageRequestObject = [self.paginatedRequestObjectProvider imageRequestObject];
        [self.service GetPagedProductDetailsView:self action:@selector(imageBackFromService:) SelectStateMent:imageRequestObject.selectStateMent fromStatement:imageRequestObject.fromStatement OrderBy:imageRequestObject.orderBy pagenumber:1 pagesize:[GlobalSharedClass shared].imagePageSize];
        [self.delegate StartGettingData];
    }
    self.isLoadingFinished=NO;

}
-(void)loadEmployeeToDB{
    SettingManager* sm=[SettingManager setting];
    NSMutableDictionary* empolyee=[sm getSettingForKeypath:@"PersonalSetting.Personal" atIndex:0];
    NSNumber* empolyeeIUR=[empolyee objectForKey:@"Value"];
    int anIUR=0;
    anIUR=[empolyeeIUR intValue];
    
    if (self.isLoadingFinished){
        [self.service GetAllEmployees:self action:@selector(employeeBackFromService:) CompanyIUR: [[self companyIUR] intValue]EmployeeIUR:anIUR];
        [self.delegate StartGettingData];
    }
    self.isLoadingFinished=NO;
}
-(void)loadConfigToDB{
    if (self.isLoadingFinished){
        [self.service GetCurrentConfig:self action:@selector(configBackFromService:)];
        [self.delegate StartGettingData];
    }
    self.isLoadingFinished=NO;
}
-(void)loadOrderToDB:(NSMutableDictionary*)aDataDict {
    NSDate* aStartDate = [aDataDict objectForKey:@"StartDate"];
    NSDate* aEndDate = [aDataDict objectForKey:@"EndDate"];
    NSNumber* aDownloadMode = [aDataDict objectForKey:@"DownloadMode"];
    SettingManager* sm=[SettingManager setting];
    NSMutableDictionary* empolyee=[sm getSettingForKeypath:@"PersonalSetting.Personal" atIndex:0];
    NSNumber* empolyeeIUR=[empolyee objectForKey:@"Value"];
    int anIUR=0;
    anIUR=[empolyeeIUR intValue];
    if ([aDownloadMode intValue] == 1) {
        anIUR = anIUR * -1;
    }
    //start and end date
    /**
    NSString* dateString=@"2011-10-01";
    NSDateFormatter* formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [formatter dateFromString:dateString];  
    [formatter release];
    */
    
    if (self.isLoadingFinished){

        [self.service GetAllOrderHeadersBetweenDateRangesOrLocationAndEmplyee:self action:@selector(orderBackFromService:) CompanyIUR:0 EmployeeIUR:anIUR StartDate:aStartDate EndDate:aEndDate locationIUR:0 emplyeeiur:0];
         [self.delegate StartGettingData];
    }
    self.isLoadingFinished=NO;
}

-(void)loadCallToDB:(NSMutableDictionary*)aDataDict {
    NSDate* aStartDate = [aDataDict objectForKey:@"StartDate"];
    NSDate* aEndDate = [aDataDict objectForKey:@"EndDate"];
    NSNumber* aDownloadMode = [aDataDict objectForKey:@"DownloadMode"];
    SettingManager* sm=[SettingManager setting];
    NSMutableDictionary* empolyee=[sm getSettingForKeypath:@"PersonalSetting.Personal" atIndex:0];
    NSNumber* empolyeeIUR=[empolyee objectForKey:@"Value"];
    int anIUR=0;
    anIUR=[empolyeeIUR intValue];
    if ([aDownloadMode intValue] == 1) {
        anIUR = anIUR * -1;
    }
//    int employeeIur = [[SettingManager employeeIUR] intValue];
    if (self.isLoadingFinished){
        [self.service GetAllCallsBetweenDates:self action:@selector(callBackFromService:) employeeiur:anIUR startDate:aStartDate endDate:aEndDate];
        [self.delegate StartGettingData];
    }
    self.isLoadingFinished = NO;
}
-(void)loadResponseToDB:(NSDate*)aStartDate endDate:(NSDate*)aEndDate {
    int employeeIur = [[SettingManager employeeIUR] intValue];
    if (self.isLoadingFinished){
        [self.service GetResponseByEmployee:self action:@selector(responseBackFromService:) employeeiur:employeeIur beginresponsedate:aStartDate endresponsedate:aEndDate];
        [self.delegate StartGettingData];
    }
    self.isLoadingFinished = NO;
}

-(void)loadSurveyToDB {
    if (self.isLoadingFinished) {
        if ([[ArcosConfigDataManager sharedArcosConfigDataManager] allowDownloadByEmployeeFlag]) {
            int employeeIur = [[SettingManager employeeIUR] intValue];
            [self.service GetAllSurveysByEmployeeiur:self action:@selector(surveyBackFromService:) CompanyIUR:[[self companyIUR] intValue] Employeeiur:employeeIur];
        } else {
            [self.service GetAllSurveys:self action:@selector(surveyBackFromService:) CompanyIUR:[[self companyIUR] intValue]];
        }
        [self.delegate StartGettingData];
    }
    self.isLoadingFinished = NO;
}
-(void)loadJourneyToDB {
    if (self.isLoadingFinished) {
        [self.service GetAllJourneys:self action:@selector(journeyBackFromService:) CompanyIUR:[[self companyIUR] intValue] EmployeeIUR:[[self employeeIUR] intValue]];
        [self.delegate StartGettingData];
    }
    self.isLoadingFinished = NO;
}
-(void)loadResourcesToFolder {
    if (self.isLoadingFinished) {        
        self.isLoadingFinished = NO;
        [self.delegate StartGettingData];
        if (self.resourcesUpdateCenter != nil) {
            self.resourcesUpdateCenter = nil;
        }
        self.resourcesUpdateCenter = [[[ResourcesUpdateCenter alloc] initWithTarget:self action:@selector(loadPaginatedWSRToFolder:) loadingAction:@selector(paginatedLoadingActionFlag)] autorelease];
        self.resourcesUpdateCenter.resourcesUpdateDelegate = self;
        [self.resourcesUpdateCenter checkFileIntegrity];        
    }
}
- (void)checkFileMD5Completed {
    SettingManager* sm = [SettingManager setting];
    NSMutableDictionary* presenterPwdDict = [sm getSettingForKeypath:@"CompanySetting.Connection" atIndex:8];
    NSString* presenterPwd = [[presenterPwdDict objectForKey:@"Value"] uppercaseString];
    //    NSLog(@"presenterPwd:%@", presenterPwd);
    NSRange aWSRRange = [presenterPwd rangeOfString:@"[WSR]"];
//    NSLog(@"abc: %@", self.resourcesUpdateCenter.needDownloadFileList);
    if (aWSRRange.location != NSNotFound) {
        if ([self.resourcesUpdateCenter.needDownloadFileList count] == 0) {
            self.isLoadingFinished = YES;
            [self.delegate FinishLoadingData:0];
        } else {
            [self.resourcesUpdateCenter runWSRTask];
        }
    } else {
        if ([self.resourcesUpdateCenter.needDownloadFileList count] == 0) {
            self.isLoadingFinished = YES;
            [self.delegate FinishLoadingData:0];
        } else {
            [self.resourcesUpdateCenter runTask];
        }
    }
}
-(void)loadPaginatedWSRToFolder:(NSString*)aFileName {
    if (self.isPaginatedLoadingFinished) {
        [self.service GetFromResources:self action:@selector(paginatedWSRBackFromService:) FileNAme:aFileName];
    }
    self.isPaginatedLoadingFinished = NO;
}

-(void)paginatedWSRBackFromService:(id)result {
    if ([result isKindOfClass:[SoapFault class]]) {
//        SoapFault* aSoapFault = (SoapFault*)result;
//        [ArcosUtils showMsg:[aSoapFault faultString] delegate:nil];
        [ArcosUtils showMsg:[NSString stringWithFormat:@"%@ is not available in Resources folder.", self.resourcesUpdateCenter.currentFileName] delegate:nil];
    } else if ([result isKindOfClass:[NSError class]]) {
        NSError* anError = (NSError*)result;
        [ArcosUtils showMsg:[anError localizedDescription] delegate:nil];
    } else {
        @try {
            NSData* myNSData = [[[NSData alloc] initWithBase64EncodedString:result options:0] autorelease];
            NSString* filePath = [NSString stringWithFormat:@"%@/%@", [FileCommon presenterPath], self.resourcesUpdateCenter.currentFileName];
            BOOL saveFileFlag = [myNSData writeToFile:filePath atomically:YES];
            if (saveFileFlag) {
                self.resourcesUpdateCenter.sucessfulFileCount++;
            }
        }
        @catch (NSException *exception) {
            [ArcosUtils showMsg:[exception reason] delegate:nil];
        }
    }
    self.isPaginatedLoadingFinished = YES;
}

-(NSNumber*)companyIUR{
    return [SettingManager companyIUR];
}
-(NSNumber*)employeeIUR{
    return [SettingManager employeeIUR];
}
#pragma marks call backs
//service call back
-(void)resultBackFromService:(id)result{
    if (result!=nil) {
        if (![result isKindOfClass:[NSError class]] && ![result isKindOfClass:[SoapFault class]]) {
            SoapArray* objects=(SoapArray*)result;
            //NSLog(@"%d objects came back for sevice",[objects count]);
            
            for (SoapObject* anObject in objects) {
                NSLog(@"Object %@",anObject);
            }          
            
        }else{
            /**
            NSError* anError=(NSError*)result;
            NSLog(@"An error come back from service %@",[anError description]);
             */
            [self handleResultErrorProcessWithoutReturn:result];
        }
        
    }else{
        [self.delegate ErrorOccured:self.serverFaultMsg];
    }
    self.isLoadingFinished=YES;

}

-(void)paginatedProductsBackFromService:(id)result {
    if (result!=nil) {
        if (![result isKindOfClass:[NSError class]] && ![result isKindOfClass:[SoapFault class]]) {
            //objects back
            ArcosGenericObjectWithImage* xmlResult=(ArcosGenericObjectWithImage*)result;
            if (xmlResult.ErrorModel.Code > 0) {
                ArcosArrayOfGenericReturnObjectWithImage* objects = (ArcosArrayOfGenericReturnObjectWithImage*)xmlResult.ArrayOfData;
                for (ArcosGenericReturnObjectWithImage* anObject in objects) {
                    [[ArcosCoreData sharedArcosCoreData]LoadProductWithSoapOB:anObject];                  
                }
                [self.delegate ProgressViewWithValue:[self.paginatedUpdateCenter progressValue]];
            } else if (xmlResult.ErrorModel.Code <= 0) {
                [self.paginatedUpdateCenter stopTask];
                [self.delegate ErrorOccured:xmlResult.ErrorModel.Message];
            }            
        }else{
            [self handlePaginatedResultErrorProcess];
            [self handleResultErrorProcessWithoutReturn:result];
        }        
    }else{
        [self handlePaginatedResultErrorProcess];
        [self.delegate ErrorOccured:self.serverFaultMsg];
    }
    self.isPaginatedLoadingFinished=YES;    
}

-(void)productsBackFromService:(id)result{
    if (result!=nil) {
        if (![result isKindOfClass:[NSError class]] && ![result isKindOfClass:[SoapFault class]]) {
            //objects back
            ArcosGenericObjectWithImage* xmlResult=(ArcosGenericObjectWithImage*)result;
            if (xmlResult.ErrorModel.Code >= 0) {
                //NSLog(@"%d objects came back for products",[objects count]);
                
//                [self.delegate GotData:xmlResult.ErrorModel.Code];
                /*
                 if (xmlResult.ErrorModel.Code>0) {
                 // Remove current Contents first
                 //NSLog(@"remove old data");
                 [[ArcosCoreData sharedArcosCoreData] clearTableWithName:@"Product"];
                 }
                 */
//                int currentObjectIndex=0;
                NSMutableDictionary* productDataDict = [self.paginatedRequestObjectProvider getUpdateCenterDataDict:[GlobalSharedClass shared].productSelectorName];
                if ([[productDataDict objectForKey:@"DownloadMode"] intValue] == 0) {
                    [[ArcosCoreData sharedArcosCoreData] clearTableWithName:@"Product"];
                }
                ArcosArrayOfGenericReturnObjectWithImage* objects = (ArcosArrayOfGenericReturnObjectWithImage*)xmlResult.ArrayOfData;
                for (ArcosGenericReturnObjectWithImage* anObject in objects) {//load objects                    
                    [[ArcosCoreData sharedArcosCoreData]LoadProductWithSoapOB:anObject];
//                    currentObjectIndex++;
//                    [self.delegate LoadingData:currentObjectIndex];
                    //NSLog(@"loading data---%d",currentObjectIndex);
                    
                }
                if (xmlResult.OverallNumber > xmlResult.ErrorModel.Code) {
                    self.paginatedUpdateCenter = [[[PaginatedUpdateCenter alloc] initWithTarget:self action:@selector(loadPaginatedProductsToDB:) loadingAction:@selector(paginatedLoadingActionFlag) overallNumber:xmlResult.OverallNumber pageSize:[GlobalSharedClass shared].pageSize] autorelease];
                    self.paginatedUpdateCenter.paginatedDelegate = self;
                    [self.delegate ProgressViewWithValue:1.0f / [self.paginatedUpdateCenter totalPage]];
                    [self.paginatedUpdateCenter runTask];
                } else {
                    self.isLoadingFinished=YES;
                    [self.delegate FinishLoadingData:xmlResult.OverallNumber];
                }                
                //finish load objects
            } else if (xmlResult.ErrorModel.Code < 0) {
                [self.delegate ErrorOccured:xmlResult.ErrorModel.Message];
            }
            
        }else{
            /**
            NSError* anError=(NSError*)result;
            NSLog(@"An error come back from service %@",[anError description]);
            [self.delegate ErrorOccured:[anError description]];
             */
            [self handleResultErrorProcessWithoutReturn:result];
        }
        
    }else{
        [self.delegate ErrorOccured:self.serverFaultMsg];
    }
//    self.isLoadingFinished=YES;
//    [self.delegate FinishLoadingData];
    //NSLog(@"finish loading data");

}

-(void)paginatedLocationsBackFromService:(id)result {
    if (result!=nil) {
        if (![result isKindOfClass:[NSError class]] && ![result isKindOfClass:[SoapFault class]]) {
            //objects back
            ArcosGenericObjectWithImage* xmlResult=(ArcosGenericObjectWithImage*)result;
            if (xmlResult.ErrorModel.Code > 0) {
                ArcosArrayOfGenericReturnObjectWithImage* objects = (ArcosArrayOfGenericReturnObjectWithImage*)xmlResult.ArrayOfData;
                for (ArcosGenericReturnObjectWithImage* anObject in objects) {
                    [[ArcosCoreData sharedArcosCoreData]LoadLocationWithSoapOB:anObject];                  
                }
                [self.delegate ProgressViewWithValue:[self.paginatedUpdateCenter progressValue]];
            } else if (xmlResult.ErrorModel.Code <= 0) {
                [self.paginatedUpdateCenter stopTask];
                [self.delegate ErrorOccured:xmlResult.ErrorModel.Message];
            }            
        }else{
            [self handlePaginatedResultErrorProcess];
            [self handleResultErrorProcessWithoutReturn:result];
        }        
    }else{
        [self handlePaginatedResultErrorProcess];
        [self.delegate ErrorOccured:self.serverFaultMsg];
    }
    self.isPaginatedLoadingFinished=YES;    
}
-(void)locationsBackFromService:(id)result{
    if (result!=nil) {
        if (![result isKindOfClass:[NSError class]] && ![result isKindOfClass:[SoapFault class]]) {
            ArcosGenericObjectWithImage* xmlResult=(ArcosGenericObjectWithImage*)result;
            if (xmlResult.ErrorModel.Code >= 0) {
                NSMutableDictionary* locationDataDict = [self.paginatedRequestObjectProvider getUpdateCenterDataDict:[GlobalSharedClass shared].locationSelectorName];
                NSNumber* downloadMode = [locationDataDict objectForKey:@"DownloadMode"];
                if ([downloadMode intValue] == 0) {//full
                    [[ArcosCoreData sharedArcosCoreData] clearTableWithName:@"Location"];
                }
                ArcosArrayOfGenericReturnObjectWithImage* objects = (ArcosArrayOfGenericReturnObjectWithImage*)xmlResult.ArrayOfData;
                for (ArcosGenericReturnObjectWithImage* anObject in objects) {//load objects                    
                    [[ArcosCoreData sharedArcosCoreData]LoadLocationWithSoapOB:anObject];                    
                }
                if (xmlResult.OverallNumber > xmlResult.ErrorModel.Code) {
                    self.paginatedUpdateCenter = [[[PaginatedUpdateCenter alloc] initWithTarget:self action:@selector(loadPaginatedLocationsToDB:) loadingAction:@selector(paginatedLoadingActionFlag) overallNumber:xmlResult.OverallNumber pageSize:[GlobalSharedClass shared].pageSize] autorelease];
                    self.paginatedUpdateCenter.paginatedDelegate = self;
                    [self.delegate ProgressViewWithValue:1.0f / [self.paginatedUpdateCenter totalPage]];
                    [self.paginatedUpdateCenter runTask];
                } else {
                    NSMutableDictionary* locationDataDict = [self.paginatedRequestObjectProvider getUpdateCenterDataDict:[GlobalSharedClass shared].locationSelectorName];
                    [self.webServiceSharedDataManager resetLocationList];
                    if ([[locationDataDict objectForKey:@"DownloadMode"] intValue] == 0) {
//                        NSMutableArray* locationIURList = [self.webServiceSharedDataManager retrieveAllLocationIUR];            
//                        [self.webServiceSharedDataManager removeAllSentOrderHeaderWithLocationIURList:locationIURList];
//                        [self.webServiceSharedDataManager removeLocationProductMATWithLocationIURList:locationIURList];
                        self.removeRecordUpdateCenter = [[[RemoveRecordUpdateCenter alloc] initWithCompletedSelector:@selector(removeRecordCompletedWithOnePageDownload)] autorelease];
                        self.removeRecordUpdateCenter.completedOverallNumber = xmlResult.OverallNumber;
                        self.removeRecordUpdateCenter.removeDelegate = self;
                        [self.removeRecordUpdateCenter buildProcessSelectorList];
                        [self.removeRecordUpdateCenter startPerformSelectorList];
                        return;
                    }
                    
                    self.isLoadingFinished=YES;
                    [self.delegate FinishLoadingData:xmlResult.OverallNumber];
                }
            } else if(xmlResult.ErrorModel.Code < 0) {
                [self.delegate ErrorOccured:xmlResult.ErrorModel.Message];
            }
        }else{
            [self handleResultErrorProcessWithoutReturn:result];
        }
    }else{
        [self.delegate ErrorOccured:self.serverFaultMsg];
    }
}

- (void)removeRecordCompletedWithOnePageDownload {
    self.isLoadingFinished=YES;
    [self.delegate FinishLoadingData:self.removeRecordUpdateCenter.completedOverallNumber];
}

-(void)paginatedLocLocLinkBackFromService:(id)result {
    if (result!=nil) {
        if (![result isKindOfClass:[NSError class]] && ![result isKindOfClass:[SoapFault class]]) {
            //objects back
            ArcosGenericObjectWithImage* xmlResult=(ArcosGenericObjectWithImage*)result;
            if (xmlResult.ErrorModel.Code > 0) {
                ArcosArrayOfGenericReturnObjectWithImage* objects = (ArcosArrayOfGenericReturnObjectWithImage*)xmlResult.ArrayOfData;
                for (ArcosGenericReturnObjectWithImage* anObject in objects) {
                    [[ArcosCoreData sharedArcosCoreData]loadLocLocLinkWithSoapOB:anObject];
                }
                [self.delegate ProgressViewWithValue:[self.paginatedUpdateCenter progressValue]];
            } else if (xmlResult.ErrorModel.Code <= 0) {
                [self.paginatedUpdateCenter stopTask];
                [self.delegate ErrorOccured:xmlResult.ErrorModel.Message];
            }
        }else{
            [self handlePaginatedResultErrorProcess];
            [self handleResultErrorProcessWithoutReturn:result];
        }
    }else{
        [self handlePaginatedResultErrorProcess];
        [self.delegate ErrorOccured:self.serverFaultMsg];
    }
    self.isPaginatedLoadingFinished=YES;
}

-(void)locLocLinkBackFromService:(id)result {
    if (result!=nil) {
        if (![result isKindOfClass:[NSError class]] && ![result isKindOfClass:[SoapFault class]]) {
            ArcosGenericObjectWithImage* xmlResult=(ArcosGenericObjectWithImage*)result;
            if (xmlResult.ErrorModel.Code >= 0) {
                NSMutableDictionary* locLocLinkDataDict = [self.paginatedRequestObjectProvider getUpdateCenterDataDict:[GlobalSharedClass shared].locLocLinkSelectorName];
                NSNumber* downloadMode = [locLocLinkDataDict objectForKey:@"DownloadMode"];
                if ([downloadMode intValue] == 0) {//full
                    [[ArcosCoreData sharedArcosCoreData] clearTableWithName:@"LocLocLink"];
                }
                ArcosArrayOfGenericReturnObjectWithImage* objects = (ArcosArrayOfGenericReturnObjectWithImage*)xmlResult.ArrayOfData;
                for (ArcosGenericReturnObjectWithImage* anObject in objects) {//load objects
                    [[ArcosCoreData sharedArcosCoreData]loadLocLocLinkWithSoapOB:anObject];
                }
                if (xmlResult.OverallNumber > xmlResult.ErrorModel.Code) {
                    self.paginatedUpdateCenter = [[[PaginatedUpdateCenter alloc] initWithTarget:self action:@selector(loadPaginatedLocLocLinkToDB:) loadingAction:@selector(paginatedLoadingActionFlag) overallNumber:xmlResult.OverallNumber pageSize:[GlobalSharedClass shared].pageSize] autorelease];
                    self.paginatedUpdateCenter.paginatedDelegate = self;
                    [self.delegate ProgressViewWithValue:1.0f / [self.paginatedUpdateCenter totalPage]];
                    [self.paginatedUpdateCenter runTask];
                } else {
                    self.isLoadingFinished=YES;
                    [self.delegate FinishLoadingData:xmlResult.OverallNumber];
                }
            } else if(xmlResult.ErrorModel.Code < 0) {
                [self.delegate ErrorOccured:xmlResult.ErrorModel.Message];
            }
        }else{
            [self handleResultErrorProcessWithoutReturn:result];
        }
    }else{
        [self.delegate ErrorOccured:self.serverFaultMsg];
    }
}

-(void)paginatedDescrDetailsBackFromService:(id)result {
    @try {
        if (result!=nil) {
            if (![result isKindOfClass:[NSError class]] && ![result isKindOfClass:[SoapFault class]]) {
                ArcosGenericObjectWithImage* xmlResult=(ArcosGenericObjectWithImage*)result;
                if (xmlResult.ErrorModel.Code > 0) {
                    ArcosArrayOfGenericReturnObjectWithImage* objects = (ArcosArrayOfGenericReturnObjectWithImage*)xmlResult.ArrayOfData;
                    for (ArcosGenericReturnObjectWithImage* anObject in objects) {
                        [[ArcosCoreData sharedArcosCoreData]LoadDescriptionWithSoapOB:anObject];                  
                    }
                    [self.delegate ProgressViewWithValue:[self.paginatedUpdateCenter progressValue]];
                } else if (xmlResult.ErrorModel.Code <= 0) {
                    [self.paginatedUpdateCenter stopTask];
                    [self.delegate ErrorOccured:xmlResult.ErrorModel.Message];
                }            
            }else{
                [self handlePaginatedResultErrorProcess];
                [self handleResultErrorProcessWithoutReturn:result];
            }        
        }else{
            [self handlePaginatedResultErrorProcess];
            [self.delegate ErrorOccured:self.serverFaultMsg];
        }
        self.isPaginatedLoadingFinished=YES;
    }
    @catch (NSException *exception) {
        [self.delegate ErrorOccured:exception.reason];
    }
        
}
-(void)descriptionsBackFromService:(id)result{
    @try {
        if (result!=nil) {
            if (![result isKindOfClass:[NSError class]] && ![result isKindOfClass:[SoapFault class]]) {
                ArcosGenericObjectWithImage* xmlResult=(ArcosGenericObjectWithImage*)result;
                if (xmlResult.ErrorModel.Code >= 0) {
                    NSMutableDictionary* descrDetailDataDict = [self.paginatedRequestObjectProvider getUpdateCenterDataDict:[GlobalSharedClass shared].descrDetailSelectorName];
                    if ([[descrDetailDataDict objectForKey:@"DownloadMode"] intValue] == 0) {
                        [[ArcosCoreData sharedArcosCoreData] clearTableWithName:@"DescrDetail"];
                    }
                    ArcosArrayOfGenericReturnObjectWithImage* objects = (ArcosArrayOfGenericReturnObjectWithImage*)xmlResult.ArrayOfData;
                    for (ArcosGenericReturnObjectWithImage* anObject in objects) {//load objects                    
                        [[ArcosCoreData sharedArcosCoreData]LoadDescriptionWithSoapOB:anObject];                    
                    }
                    if (xmlResult.OverallNumber > xmlResult.ErrorModel.Code) {
                        self.paginatedUpdateCenter = [[[PaginatedUpdateCenter alloc] initWithTarget:self action:@selector(loadPaginatedDescrDetailsToDB:) loadingAction:@selector(paginatedLoadingActionFlag) overallNumber:xmlResult.OverallNumber pageSize:[GlobalSharedClass shared].pageSize] autorelease];
                        self.paginatedUpdateCenter.paginatedDelegate = self;
                        [self.delegate ProgressViewWithValue:1.0f / [self.paginatedUpdateCenter totalPage]];
                        [self.paginatedUpdateCenter runTask];
                    } else {
                        self.isLoadingFinished=YES;
                        [self.delegate FinishLoadingData:xmlResult.OverallNumber];
                    }
                } else if (xmlResult.ErrorModel.Code < 0) {
                    [self.delegate ErrorOccured:xmlResult.ErrorModel.Message];
                }
            }else{
                [self handleResultErrorProcessWithoutReturn:result];
            }        
        }else{
            [self.delegate ErrorOccured:self.serverFaultMsg];
        }
    }
    @catch (NSException *exception) {
        [self.delegate ErrorOccured:exception.reason];
    }    
}

-(void)formDetailsBackFromService:(id)result{
    if (result!=nil) {
        if (![result isKindOfClass:[NSError class]] && ![result isKindOfClass:[SoapFault class]]) {
            ArcosArrayOfFormDetailBO* objects=(ArcosArrayOfFormDetailBO*)result;
            //NSLog(@"%d objects came back",[objects count]);
            
            [self.delegate GotData:[objects count]];
//            if ([objects count]>0) {
//                // Remove current Contents first
//                //NSLog(@"remove old data");
//                
//            }
            [[ArcosCoreData sharedArcosCoreData] clearTableWithName:@"FormDetail"];
            int currentObjectIndex=0;
            
            for (ArcosFormDetailBO* anObject in objects) {
                //NSLog(@"Object %@",anObject);
                [[ArcosCoreData sharedArcosCoreData]loadFormDetailsWithSoapOB:anObject];
                
                currentObjectIndex++;
                [self.delegate LoadingData:currentObjectIndex];
                //NSLog(@"loading data---%d",currentObjectIndex);
            }          
            self.isLoadingFinished=YES;
            [self.delegate FinishLoadingData:[objects count]];
        }else{
            /**
            NSError* anError=(NSError*)result;
            NSLog(@"An error come back from service %@",[anError description]);
            [self.delegate ErrorOccured:[anError description]];
             */
            [self handleResultErrorProcessWithoutReturn:result];
        }
        
    }else{
        [self.delegate ErrorOccured:self.serverFaultMsg];
    }
//    self.isLoadingFinished=YES;
//    [self.delegate FinishLoadingData];
    //NSLog(@"finish loading data");
}


-(void)paginatedFormRowsBackFromService:(id)result{
    if (result!=nil) {
        if (![result isKindOfClass:[NSError class]] && ![result isKindOfClass:[SoapFault class]]) {
            //objects back
            ArcosGenericObjectWithImage* xmlResult=(ArcosGenericObjectWithImage*)result;
            if (xmlResult.ErrorModel.Code > 0) {
                ArcosArrayOfGenericReturnObjectWithImage* objects = (ArcosArrayOfGenericReturnObjectWithImage*)xmlResult.ArrayOfData;
                for (ArcosGenericReturnObjectWithImage* anObject in objects) {
                    [[ArcosCoreData sharedArcosCoreData]loadFormRowWithSoapOB:anObject];                  
                }
                [self.delegate ProgressViewWithValue:[self.paginatedUpdateCenter progressValue]];
            } else if (xmlResult.ErrorModel.Code <= 0) {
                [self.paginatedUpdateCenter stopTask];
                [self.delegate ErrorOccured:xmlResult.ErrorModel.Message];
            }            
        }else{
            [self handlePaginatedResultErrorProcess];
            [self handleResultErrorProcessWithoutReturn:result];
        }        
    }else{
        [self handlePaginatedResultErrorProcess];
        [self.delegate ErrorOccured:self.serverFaultMsg];
    }
    self.isPaginatedLoadingFinished=YES;
}
-(void)formRowsBackFromService:(id)result{
    if (result!=nil) {
        if (![result isKindOfClass:[NSError class]] && ![result isKindOfClass:[SoapFault class]]) {
            ArcosGenericObjectWithImage* xmlResult=(ArcosGenericObjectWithImage*)result;
            if (xmlResult.ErrorModel.Code >= 0) {
                NSMutableDictionary* formRowDataDict = [self.paginatedRequestObjectProvider getUpdateCenterDataDict:[GlobalSharedClass shared].formRowSelectorName];
                NSNumber* downloadMode = [formRowDataDict objectForKey:@"DownloadMode"];
                if ([downloadMode intValue] == 0) {//full
                    [[ArcosCoreData sharedArcosCoreData] clearTableWithName:@"FormRow"];
                }
                ArcosArrayOfGenericReturnObjectWithImage* objects = (ArcosArrayOfGenericReturnObjectWithImage*)xmlResult.ArrayOfData;
                for (ArcosGenericReturnObjectWithImage* anObject in objects) {//load objects                    
                    [[ArcosCoreData sharedArcosCoreData]loadFormRowWithSoapOB:anObject];                    
                }
                if (xmlResult.OverallNumber > xmlResult.ErrorModel.Code) {
                    self.paginatedUpdateCenter = [[[PaginatedUpdateCenter alloc] initWithTarget:self action:@selector(loadPaginatedFormRowsToDB:) loadingAction:@selector(paginatedLoadingActionFlag) overallNumber:xmlResult.OverallNumber pageSize:[GlobalSharedClass shared].pageSize] autorelease];
                    self.paginatedUpdateCenter.paginatedDelegate = self;
                    [self.delegate ProgressViewWithValue:1.0f / [self.paginatedUpdateCenter totalPage]];
                    [self.paginatedUpdateCenter runTask];
                } else {
                    self.isLoadingFinished=YES;
                    [self.delegate FinishLoadingData:xmlResult.OverallNumber];
                }
            } else if(xmlResult.ErrorModel.Code < 0) {
                [self.delegate ErrorOccured:xmlResult.ErrorModel.Message];
            }
            /*
            ArcosArrayOfFormRowBO* objects=(ArcosArrayOfFormRowBO*)result;
            //NSLog(@"%d objects came back for form row",[objects count]);
            
            [self.delegate GotData:[objects count]];
            if ([objects count]>0) {
                // Remove current Contents first
                //NSLog(@"remove old data");
                [[ArcosCoreData sharedArcosCoreData] clearTableWithName:@"FormRow"];
            }
            int currentObjectIndex=0;
            
            for (ArcosFormRowBO* anObject in objects) {
                //NSLog(@"Object %@",anObject);
                [[ArcosCoreData sharedArcosCoreData]loadFormRowWithSoapOB:anObject];
                
                currentObjectIndex++;
                [self.delegate LoadingData:currentObjectIndex];
                //NSLog(@"loading data---%d",currentObjectIndex);
            }          
            self.isLoadingFinished=YES;
            [self.delegate FinishLoadingData:[objects count]];
             */
        }else{
            /**
            NSError* anError=(NSError*)result;
            NSLog(@"An error come back from service %@",[anError description]);
            [self.delegate ErrorOccured:[anError description]];
             */
            [self handleResultErrorProcessWithoutReturn:result];
        }
        
    }else{
        [self.delegate ErrorOccured:self.serverFaultMsg];
    }
//    self.isLoadingFinished=YES;
//    [self.delegate FinishLoadingData];
    //NSLog(@"finish loading data");
}

-(void)contactsBackFromService:(id)result{
    if (result!=nil) {
        if (![result isKindOfClass:[NSError class]] && ![result isKindOfClass:[SoapFault class]]) {
            ArcosGenericObjectWithImage* xmlResult=(ArcosGenericObjectWithImage*)result;
            if (xmlResult.ErrorModel.Code >= 0) {                
                NSMutableDictionary* contactDataDict = [self.paginatedRequestObjectProvider getUpdateCenterDataDict:[GlobalSharedClass shared].contactSelectorName];
                if ([[contactDataDict objectForKey:@"DownloadMode"] intValue] == 0) {
                    [[ArcosCoreData sharedArcosCoreData] clearTableWithName:@"Contact"];
                }
                ArcosArrayOfGenericReturnObjectWithImage* objects = (ArcosArrayOfGenericReturnObjectWithImage*)xmlResult.ArrayOfData;
                for (ArcosGenericReturnObjectWithImage* anObject in objects) {//load objects                    
                    [[ArcosCoreData sharedArcosCoreData]loadContactWithSoapOB:anObject];                    
                }
                if (xmlResult.OverallNumber > xmlResult.ErrorModel.Code) {
                    self.paginatedUpdateCenter = [[[PaginatedUpdateCenter alloc] initWithTarget:self action:@selector(loadPaginatedContactsToDB:) loadingAction:@selector(paginatedLoadingActionFlag) overallNumber:xmlResult.OverallNumber pageSize:[GlobalSharedClass shared].pageSize] autorelease];
                    self.paginatedUpdateCenter.paginatedDelegate = self;
                    [self.delegate ProgressViewWithValue:1.0f / [self.paginatedUpdateCenter totalPage]];
                    [self.paginatedUpdateCenter runTask];
                } else {
                    self.isLoadingFinished=YES;
                    [self.delegate FinishLoadingData:xmlResult.OverallNumber];
                }
            } else if(xmlResult.ErrorModel.Code < 0) {
                [self.delegate ErrorOccured:xmlResult.ErrorModel.Message];
            }
            /*
            ArcosArrayOfContactBO* objects=(ArcosArrayOfContactBO*)result;
            //NSLog(@"%d objects came back for contact",[objects count]);
            
            [self.delegate GotData:[objects count]];
            if ([objects count]>0) {
                // Remove current Contents first
                //NSLog(@"remove old data");
                [[ArcosCoreData sharedArcosCoreData] clearTableWithName:@"Contact"];
            }
            int currentObjectIndex=0;
            
            for (ArcosContactBO* anObject in objects) {
                //NSLog(@"Object %@",anObject);
                [[ArcosCoreData sharedArcosCoreData]loadContactWithSoapOB:anObject];
                
                currentObjectIndex++;
                [self.delegate LoadingData:currentObjectIndex];
                //NSLog(@"loading data---%d",currentObjectIndex);
            }          
            */
        }else{
            /**
            NSError* anError=(NSError*)result;
            NSLog(@"An error come back from service %@",[anError description]);
            [self.delegate ErrorOccured:[anError description]];
             */
            [self handleResultErrorProcessWithoutReturn:result];
        }
        
    }else{
        [self.delegate ErrorOccured:self.serverFaultMsg];
    }
//    self.isLoadingFinished=YES;
//    [self.delegate FinishLoadingData];
    //NSLog(@"finish loading data");
}

-(void)paginatedContactsBackFromService:(id)result{
    if (result!=nil) {
        if (![result isKindOfClass:[NSError class]] && ![result isKindOfClass:[SoapFault class]]) {
            //objects back
            ArcosGenericObjectWithImage* xmlResult=(ArcosGenericObjectWithImage*)result;
            if (xmlResult.ErrorModel.Code > 0) {
                ArcosArrayOfGenericReturnObjectWithImage* objects = (ArcosArrayOfGenericReturnObjectWithImage*)xmlResult.ArrayOfData;
                for (ArcosGenericReturnObjectWithImage* anObject in objects) {
                    [[ArcosCoreData sharedArcosCoreData]loadContactWithSoapOB:anObject];                  
                }
                [self.delegate ProgressViewWithValue:[self.paginatedUpdateCenter progressValue]];
            } else if (xmlResult.ErrorModel.Code <= 0) {
                [self.paginatedUpdateCenter stopTask];
                [self.delegate ErrorOccured:xmlResult.ErrorModel.Message];
            }            
        }else{
            [self handlePaginatedResultErrorProcess];
            [self handleResultErrorProcessWithoutReturn:result];
        }        
    }else{
        [self handlePaginatedResultErrorProcess];
        [self.delegate ErrorOccured:self.serverFaultMsg];
    }
    self.isPaginatedLoadingFinished=YES;
}

-(void)descrTypeBackFromService:(id)result{
    if (result!=nil) {
        if (![result isKindOfClass:[NSError class]] && ![result isKindOfClass:[SoapFault class]]) {
            ArcosArrayOfDescrTypeBO* objects=(ArcosArrayOfDescrTypeBO*)result;
            //NSLog(@"%d objects came back for description type",[objects count]);
            
            [self.delegate GotData:[objects count]];
            if ([objects count]>0) {
                // Remove current Contents first
                //NSLog(@"remove old data");
                
            }
            [[ArcosCoreData sharedArcosCoreData] clearTableWithName:@"DescrType"];
            
            int currentObjectIndex=0;
            
            for (ArcosDescrTypeBO* anObject in objects) {
                //NSLog(@"Object %@",anObject);
                [[ArcosCoreData sharedArcosCoreData]loadDescriptionTypeWithSoapOB:anObject];
                
                currentObjectIndex++;
                [self.delegate LoadingData:currentObjectIndex];
                //NSLog(@"loading data---%d",currentObjectIndex);
            }          
            self.isLoadingFinished=YES;
            [self.delegate FinishLoadingData:[objects count]];
        }else{
            /**
            NSError* anError=(NSError*)result;
            NSLog(@"An error come back from service %@",[anError description]);
            [self.delegate ErrorOccured:[anError description]];
             */
            [self handleResultErrorProcessWithoutReturn:result];
        }
        
    }else{
        [self.delegate ErrorOccured:self.serverFaultMsg];
    }
//    self.isLoadingFinished=YES;
//    [self.delegate FinishLoadingData];
    //NSLog(@"finish loading data");
} 

-(void)paginatedConLocLinkBackFromService:(id)result {
    if (result!=nil) {
        if (![result isKindOfClass:[NSError class]] && ![result isKindOfClass:[SoapFault class]]) {
            //objects back
            ArcosGenericObjectWithImage* xmlResult=(ArcosGenericObjectWithImage*)result;
            if (xmlResult.ErrorModel.Code > 0) {
                ArcosArrayOfGenericReturnObjectWithImage* objects = (ArcosArrayOfGenericReturnObjectWithImage*)xmlResult.ArrayOfData;
                for (ArcosGenericReturnObjectWithImage* anObject in objects) {
                    [[ArcosCoreData sharedArcosCoreData]loadConLocLinkWithSoapOB:anObject];                  
                }
                [self.delegate ProgressViewWithValue:[self.paginatedUpdateCenter progressValue]];
            } else if (xmlResult.ErrorModel.Code <= 0) {
                [self.paginatedUpdateCenter stopTask];
                [self.delegate ErrorOccured:xmlResult.ErrorModel.Message];
            }            
        }else{
            [self handlePaginatedResultErrorProcess];
            [self handleResultErrorProcessWithoutReturn:result];
        }        
    }else{
        [self handlePaginatedResultErrorProcess];
        [self.delegate ErrorOccured:self.serverFaultMsg];
    }
    self.isPaginatedLoadingFinished=YES;
}

-(void)conLocLinksBackFromService:(id)result{
    if (result!=nil) {
        if (![result isKindOfClass:[NSError class]] && ![result isKindOfClass:[SoapFault class]]) {
            ArcosGenericObjectWithImage* xmlResult=(ArcosGenericObjectWithImage*)result;
            if (xmlResult.ErrorModel.Code >= 0) {                
//                self.isLoadingFinished=YES;
//                [self.delegate ErrorOccured:xmlResult.ErrorModel.Message];
//                [self.delegate FinishLoadingData];
//                return;
                NSMutableDictionary* conLocLinkDataDict = [self.paginatedRequestObjectProvider getUpdateCenterDataDict:[GlobalSharedClass shared].conLocLinkSelectorName];
                if ([[conLocLinkDataDict objectForKey:@"DownloadMode"] intValue] == 0) {
                    [[ArcosCoreData sharedArcosCoreData] clearTableWithName:@"ConLocLink"];
                }
                ArcosArrayOfGenericReturnObjectWithImage* objects = (ArcosArrayOfGenericReturnObjectWithImage*)xmlResult.ArrayOfData;
                for (ArcosGenericReturnObjectWithImage* anObject in objects) {//load objects                    
                    [[ArcosCoreData sharedArcosCoreData]loadConLocLinkWithSoapOB:anObject];                    
                }
                if (xmlResult.OverallNumber > xmlResult.ErrorModel.Code) {
                    self.paginatedUpdateCenter = [[[PaginatedUpdateCenter alloc] initWithTarget:self action:@selector(loadPaginatedConLocLinkToDB:) loadingAction:@selector(paginatedLoadingActionFlag) overallNumber:xmlResult.OverallNumber pageSize:[GlobalSharedClass shared].pageSize] autorelease];
                    self.paginatedUpdateCenter.paginatedDelegate = self;
                    [self.delegate ProgressViewWithValue:1.0f / [self.paginatedUpdateCenter totalPage]];
                    [self.paginatedUpdateCenter runTask];
                } else {
                    self.isLoadingFinished=YES;
                    [self.delegate FinishLoadingData:xmlResult.OverallNumber];
                }
            } else if(xmlResult.ErrorModel.Code < 0) {
                [self.delegate ErrorOccured:xmlResult.ErrorModel.Message];
            }
            /*
            ArcosArrayOfConLocLinkBO* objects=(ArcosArrayOfConLocLinkBO*)result;
            //NSLog(@"%d objects came back for presenter",[objects count]);
            
            [self.delegate GotData:[objects count]];
            if ([objects count]>0) {
                // Remove current Contents first
                //NSLog(@"remove old data");
                [[ArcosCoreData sharedArcosCoreData] clearTableWithName:@"ConLocLink"];
            }
            int currentObjectIndex=0;
            
            for (ArcosConLocLinkBO* anObject in objects) {
                //NSLog(@"Object %@",anObject);
                [[ArcosCoreData sharedArcosCoreData]loadConLocLinkWithSoapOB:anObject];
                
                currentObjectIndex++;
                [self.delegate LoadingData:currentObjectIndex];
                //NSLog(@"loading data---%d",currentObjectIndex);
            }          
            */
        }else{
            /**
            NSError* anError=(NSError*)result;
            NSLog(@"An error come back from service %@",[anError description]);
            [self.delegate ErrorOccured:[anError description]];
             */
            [self handleResultErrorProcessWithoutReturn:result];
        }
        
    }else{
        [self.delegate ErrorOccured:self.serverFaultMsg];
    }
//    self.isLoadingFinished=YES;
//    [self.delegate FinishLoadingData];
    //NSLog(@"finish loading data");

}
-(void)presenterBackFromService:(id)result{
    if (result!=nil) {
        if (![result isKindOfClass:[NSError class]] && ![result isKindOfClass:[SoapFault class]]) {
            ArcosArrayOfPresenter* objects=(ArcosArrayOfPresenter*)result;
            //NSLog(@"%d objects came back for conloc link",[objects count]);
            
            [self.delegate GotData:[objects count]];
            if ([objects count]>0) {
                // Remove current Contents first
                //NSLog(@"remove old data");
                
            }
            [[ArcosCoreData sharedArcosCoreData] clearTableWithName:@"Presenter"];
            int currentObjectIndex=0;
            
            for (ArcosPresenter* anObject in objects) {
                //NSLog(@"Object %@",anObject);
                [[ArcosCoreData sharedArcosCoreData]loadPresenterWithSoapOB:anObject];
                
                currentObjectIndex++;
                [self.delegate LoadingData:currentObjectIndex];
                //NSLog(@"loading data---%d",currentObjectIndex);
            }          
            self.isLoadingFinished=YES;
            [self.delegate FinishLoadingData:[objects count]];
        }else{
            /**
            NSError* anError=(NSError*)result;
            NSLog(@"An error come back from service %@",[anError description]);
            [self.delegate ErrorOccured:[anError description]];
             */
            [self handleResultErrorProcessWithoutReturn:result];
        }
        
    }else{
        [self.delegate ErrorOccured:self.serverFaultMsg];
    }
//    self.isLoadingFinished=YES;
//    [self.delegate FinishLoadingData];
    //NSLog(@"finish loading data");
    
}
-(void)paginatedImageBackFromService:(id)result{
    if (result!=nil) {
        if (![result isKindOfClass:[NSError class]] && ![result isKindOfClass:[SoapFault class]]) {
            //objects back
            ArcosGenericObjectWithImage* xmlResult=(ArcosGenericObjectWithImage*)result;
            if (xmlResult.ErrorModel.Code > 0) {
                ArcosArrayOfGenericReturnObjectWithImage* objects = (ArcosArrayOfGenericReturnObjectWithImage*)xmlResult.ArrayOfData;
                for (ArcosGenericReturnObjectWithImage* anObject in objects) {
                    [[ArcosCoreData sharedArcosCoreData]loadImageWithSoapOB:anObject];                  
                }
                [self.delegate ProgressViewWithValue:[self.paginatedUpdateCenter progressValue]];
            } else if (xmlResult.ErrorModel.Code <= 0) {
                [self.paginatedUpdateCenter stopTask];
                [self.delegate ErrorOccured:xmlResult.ErrorModel.Message];
            }            
        }else{
            [self handlePaginatedResultErrorProcess];
            [self handleResultErrorProcessWithoutReturn:result];
        }        
    }else{
        [self handlePaginatedResultErrorProcess];
        [self.delegate ErrorOccured:self.serverFaultMsg];
    }
    self.isPaginatedLoadingFinished=YES;
}

-(void)imageBackFromService:(id)result{
    if (result!=nil) {
        if (![result isKindOfClass:[NSError class]] && ![result isKindOfClass:[SoapFault class]]) {
            ArcosGenericObjectWithImage* xmlResult=(ArcosGenericObjectWithImage*)result;
            if (xmlResult.ErrorModel.Code >= 0) {                
                
                ArcosArrayOfGenericReturnObjectWithImage* objects = (ArcosArrayOfGenericReturnObjectWithImage*)xmlResult.ArrayOfData;
                for (ArcosGenericReturnObjectWithImage* anObject in objects) {//load objects                    
                    [[ArcosCoreData sharedArcosCoreData]loadImageWithSoapOB:anObject];                    
                }
                if (xmlResult.OverallNumber > xmlResult.ErrorModel.Code) {
                    self.paginatedUpdateCenter = [[[PaginatedUpdateCenter alloc] initWithTarget:self action:@selector(loadPaginatedImageToDB:) loadingAction:@selector(paginatedLoadingActionFlag) overallNumber:xmlResult.OverallNumber pageSize:[GlobalSharedClass shared].imagePageSize] autorelease];
                    self.paginatedUpdateCenter.paginatedDelegate = self;
                    [self.delegate ProgressViewWithValue:1.0f / [self.paginatedUpdateCenter totalPage]];
                    [self.paginatedUpdateCenter runTask];
                } else {
                    self.isLoadingFinished=YES;
                    [self.delegate FinishLoadingData:xmlResult.OverallNumber];
                }
            } else if(xmlResult.ErrorModel.Code < 0) {
                [self.delegate ErrorOccured:xmlResult.ErrorModel.Message];
            }
            /*
            ArcosArrayOfImageBO* objects=(ArcosArrayOfImageBO*)result;
            //NSLog(@"%d objects came back for conloc link",[objects count]);
            
            [self.delegate GotData:[objects count]];
            if ([objects count]>0) {
                // Remove current Contents first
                //NSLog(@"remove old data");
                [[ArcosCoreData sharedArcosCoreData] clearTableWithName:@"Image"];
            }
            int currentObjectIndex=0;
            
            for (ArcosImageBO* anObject in objects) {
                //NSLog(@"Object %@",anObject);
                [[ArcosCoreData sharedArcosCoreData]loadImagerWithSoapOB:anObject];
                
                currentObjectIndex++;
                [self.delegate LoadingData:currentObjectIndex];
                //NSLog(@"loading data---%d",currentObjectIndex);
            }          
            */
        }else{
            /**
            NSError* anError=(NSError*)result;
            NSLog(@"An error come back from service %@",[anError description]);
            [self.delegate ErrorOccured:[anError description]];
             */
            [self handleResultErrorProcessWithoutReturn:result];
        }
        
    }else{
        [self.delegate ErrorOccured:self.serverFaultMsg];
    }
//    self.isLoadingFinished=YES;
//    [self.delegate FinishLoadingData];
    //NSLog(@"finish loading data");
    
}
-(void)employeeBackFromService:(id)result{
    if (result!=nil) {
        if (![result isKindOfClass:[NSError class]] && ![result isKindOfClass:[SoapFault class]]) {
            ArcosArrayOfEmployeeBO* objects=(ArcosArrayOfEmployeeBO*)result;
//            NSLog(@"%d objects came back for employee",[objects count]);
            
            [self.delegate GotData:[objects count]];
            if ([objects count]>0) {
                // Remove current Contents first
                //NSLog(@"remove old data");
                
            }
            [[ArcosCoreData sharedArcosCoreData] clearTableWithName:@"Employee"];
            int currentObjectIndex=0;
            
            for (ArcosEmployeeBO* anObject in objects) {
                //NSLog(@"employee Object %@",anObject);
                [[ArcosCoreData sharedArcosCoreData]loadEmployeeWithSoapOB:anObject];
                
                currentObjectIndex++;
                [self.delegate LoadingData:currentObjectIndex];
                //NSLog(@"loading data---%d",currentObjectIndex);
            }          
            self.isLoadingFinished=YES;
            [self.delegate FinishLoadingData:[objects count]];
        }else{
            /**
            NSError* anError=(NSError*)result;
            NSLog(@"An error come back from service %@",[anError description]);
            [self.delegate ErrorOccured:[anError description]];
            */
            [self handleResultErrorProcessWithoutReturn:result];
        }
        
    }else{
        [self.delegate ErrorOccured:self.serverFaultMsg];
    }
//    self.isLoadingFinished=YES;
//    [self.delegate FinishLoadingData];
}

-(void)generateDataAsCsvBackFromService:(id)result {
    [self genericGenerateDataAsCsvBackFromService:result action:@selector(productWSRBackFromService:)];
}

-(void)productWSRBackFromService:(id)result {
    if (result != nil) {
        result = [self handleResultErrorProcess:result];
        if (result != nil) {
            @try {
                NSData* myNSData = [[NSData alloc] initWithBase64EncodedString:result options:0];
                NSString* filePath = [NSString stringWithFormat:@"%@/%@", [FileCommon documentsPath], self.auxFileName];
                [myNSData writeToFile:filePath atomically:YES];
                [myNSData release];
                NSString* fileContents = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
                NSArray* rowList = [fileContents componentsSeparatedByString:self.rowDelimiter];
                [fileContents release];
                [FileCommon removeFileAtPath:filePath];
//                if ([rowList count] > 2) {
//                    
//                }
                NSMutableDictionary* productDataDict = [self.paginatedRequestObjectProvider getUpdateCenterDataDict:[GlobalSharedClass shared].productSelectorName];
                if ([[productDataDict objectForKey:@"DownloadMode"] intValue] == 0) {
                    [[ArcosCoreData sharedArcosCoreData] clearTableWithName:@"Product"];
                }
                self.batchedUpdateCenter = [[[BatchedUpdateCenter alloc] initBatchedWithTarget:self action:@selector(loadProductBatchedUpdateCenter:) loadingAction:@selector(batchedLoadingActionFlag) recordList:rowList pageSize:[GlobalSharedClass shared].batchedSize] autorelease];
                self.batchedUpdateCenter.batchedDelegate = self;
                [self.batchedUpdateCenter runTask];
            }
            @catch (NSException *exception) {
                [self.delegate ErrorOccured:[exception reason]];
            }
        }
    } else {
        [self.delegate ErrorOccured:self.serverFaultMsg];
    }
//    [self genericWSRBackFromService:result className:@"SaveRecordUpdateCenter"];
}

- (void)loadProductBatchedUpdateCenter:(NSNumber*)pageNumber {
    if (self.isBatchedLoadingFinished) {
        self.saveRecordUpdateCenter = [[[SaveRecordUpdateCenter alloc] initWithRecordList:self.batchedUpdateCenter.recordList batchedNumber:[pageNumber intValue] batchedSize:[GlobalSharedClass shared].batchedSize] autorelease];
        self.saveRecordUpdateCenter.saveRecordDelegate = self;
        [self.delegate UpdateData];
        [self.saveRecordUpdateCenter runTask];
    }
    self.isBatchedLoadingFinished = NO;
}

-(void)locationProductMATGenerateDataAsCsvBackFromService:(id)result {
    [self genericGenerateDataAsCsvBackFromService:result action:@selector(locationProductMATWSRBackFromService:)];
}

-(void)locationProductMATWSRBackFromService:(id)result {
    if (result != nil) {
        result = [self handleResultErrorProcess:result];
        if (result != nil) {
            @try {
                NSData* myNSData = [[NSData alloc] initWithBase64EncodedString:result options:0];
                NSString* filePath = [NSString stringWithFormat:@"%@/%@", [FileCommon documentsPath], self.auxFileName];
                [myNSData writeToFile:filePath atomically:YES];
                [myNSData release];
                NSString* fileContents = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
                NSArray* rowList = [fileContents componentsSeparatedByString:self.rowDelimiter];
                [fileContents release];
                [FileCommon removeFileAtPath:filePath];
                self.batchedUpdateCenter = [[[BatchedUpdateCenter alloc] initBatchedWithTarget:self action:@selector(loadLocationProductMATBatchedUpdateCenter:) loadingAction:@selector(batchedLoadingActionFlag) recordList:rowList pageSize:[GlobalSharedClass shared].batchedSize] autorelease];
                self.batchedUpdateCenter.levelIUR = [GlobalSharedClass shared].currentTimeStamp;
                self.batchedUpdateCenter.batchedDelegate = self;
                [self.batchedUpdateCenter runTask];
            }
            @catch (NSException *exception) {
                [self.delegate ErrorOccured:[exception reason]];
            }
        }
    } else {
        [self.delegate ErrorOccured:self.serverFaultMsg];
    }
//    [self genericWSRBackFromService:result className:@"SaveRecordLocationProductMATUpdateCenter"];
}

- (void)loadLocationProductMATBatchedUpdateCenter:(NSNumber*)pageNumber {
    if (self.isBatchedLoadingFinished) {
        self.saveRecordUpdateCenter = [[[SaveRecordLocationProductMATUpdateCenter alloc] initWithRecordList:self.batchedUpdateCenter.recordList batchedNumber:[pageNumber intValue] batchedSize:[GlobalSharedClass shared].batchedSize] autorelease];
        self.saveRecordUpdateCenter.saveRecordDelegate = self;
        self.saveRecordUpdateCenter.levelIUR = self.batchedUpdateCenter.levelIUR;
        [self.delegate UpdateData];
        [self.saveRecordUpdateCenter runTask];
    }
    self.isBatchedLoadingFinished = NO;
}

-(void)descrDetailGenerateDataAsCsvBackFromService:(id)result {
    [self genericGenerateDataAsCsvBackFromService:result action:@selector(descrDetailWSRBackFromService:)];
}

-(void)descrDetailWSRBackFromService:(id)result {
    [self genericWSRBackFromService:result className:@"SaveRecordDescrDetailUpdateCenter"];
}

-(void)locLocLinkGenerateDataAsCsvBackFromService:(id)result {
    [self genericGenerateDataAsCsvBackFromService:result action:@selector(locLocLinkWSRBackFromService:)];
}

-(void)locLocLinkWSRBackFromService:(id)result {
    [self genericWSRBackFromService:result className:@"SaveRecordLocLocLinkUpdateCenter"];
}

- (void)priceGenerateDataAsCsvBackFromService:(id)result {
    [self genericGenerateDataAsCsvBackFromService:result action:@selector(priceWSRBackFromService:)];
}

-(void)packageGenerateDataAsCsvBackFromService:(id)result {
    [self genericGenerateDataAsCsvBackFromService:result action:@selector(packageWSRBackFromService:)];
}

-(void)locationGenerateDataAsCsvBackFromService:(id)result {
    [self genericGenerateDataAsCsvBackFromService:result action:@selector(locationWSRBackFromService:)];
}

- (void)priceWSRBackFromService:(id)result {
    [self genericWSRBackFromService:result className:@"SaveRecordPriceUpdateCenter"];
}

-(void)packageWSRBackFromService:(id)result {
    [self genericWSRBackFromService:result className:@"SaveRecordPackageUpdateCenter"];
}

-(void)locationWSRBackFromService:(id)result {
    [self genericWSRBackFromService:result className:@"SaveRecordLocationUpdateCenter"];
}

- (void)genericGenerateDataAsCsvBackFromService:(id)result action:(SEL)anAction {
    if (result != nil) {
        result = [self handleResultErrorProcess:result];
        if (result != nil) {
            ArcosGenericClass* arcosGenericClass = (ArcosGenericClass*)result;
            NSNumber* recordNumber = [ArcosUtils convertStringToNumber:[ArcosUtils convertNilToEmpty:arcosGenericClass.Field1]];
            if ([recordNumber intValue] > 0) {
                self.auxFileName = [ArcosUtils convertToString:arcosGenericClass.Field2];
                [self.service GetFromResources:self action:anAction FileNAme:self.auxFileName];
            } else {
                self.isLoadingFinished = YES;
                [self.delegate FinishLoadingData:0];
            }
        }
    } else {
        [self.delegate ErrorOccured:self.serverFaultMsg];
    }
}
- (void)genericWSRBackFromService:(id)result className:(NSString*)aClassName {
    if (result != nil) {
        result = [self handleResultErrorProcess:result];
        if (result != nil) {
            @try {
                NSData* myNSData = [[NSData alloc] initWithBase64EncodedString:result options:0];
                NSString* filePath = [NSString stringWithFormat:@"%@/%@", [FileCommon documentsPath], self.auxFileName];
                [myNSData writeToFile:filePath atomically:YES];
                [myNSData release];
                NSString* fileContents = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
                NSArray* rowList = [fileContents componentsSeparatedByString:self.rowDelimiter];
                [fileContents release];
                [FileCommon removeFileAtPath:filePath];
                if ([aClassName isEqualToString:@"SaveRecordDescrDetailUpdateCenter"]) {
                    NSMutableDictionary* descrDetailDataDict = [self.paginatedRequestObjectProvider getUpdateCenterDataDict:[GlobalSharedClass shared].descrDetailSelectorName];
                    if ([[descrDetailDataDict objectForKey:@"DownloadMode"] intValue] == 0) {
                        [[ArcosCoreData sharedArcosCoreData] clearTableWithName:@"DescrDetail"];
                    }
                }
                if ([aClassName isEqualToString:@"SaveRecordPackageUpdateCenter"]) {
                    NSMutableDictionary* locationDataDict = [self.paginatedRequestObjectProvider getUpdateCenterDataDict:[GlobalSharedClass shared].packageSelectorName];
                    if ([[locationDataDict objectForKey:@"DownloadMode"] intValue] == 0) {
                        [[ArcosCoreData sharedArcosCoreData] clearTableWithName:@"Package"];
                    }
                }
                if ([aClassName isEqualToString:@"SaveRecordLocationUpdateCenter"]) {
                    NSMutableDictionary* locationDataDict = [self.paginatedRequestObjectProvider getUpdateCenterDataDict:[GlobalSharedClass shared].locationSelectorName];
                    if ([[locationDataDict objectForKey:@"DownloadMode"] intValue] == 0) {
                        [[ArcosCoreData sharedArcosCoreData] clearTableWithName:@"Location"];
                    }
                }
                if ([aClassName isEqualToString:@"SaveRecordLocLocLinkUpdateCenter"]) {
                    NSMutableDictionary* locLocLinkDataDict = [self.paginatedRequestObjectProvider getUpdateCenterDataDict:[GlobalSharedClass shared].locLocLinkSelectorName];
                    if ([[locLocLinkDataDict objectForKey:@"DownloadMode"] intValue] == 0) {
                        [[ArcosCoreData sharedArcosCoreData] clearTableWithName:@"LocLocLink"];
                    }
                }
                if ([aClassName isEqualToString:@"SaveRecordPriceUpdateCenter"]) {
                    NSMutableDictionary* priceDataDict = [self.paginatedRequestObjectProvider getUpdateCenterDataDict:[GlobalSharedClass shared].priceSelectorName];
                    if ([[priceDataDict objectForKey:@"DownloadMode"] intValue] == 0) {
                        [[ArcosCoreData sharedArcosCoreData] clearTableWithName:@"Price"];
                        [[ArcosCoreData sharedArcosCoreData] clearTableWithName:@"Promotion"];
                    }
                }                
                self.saveRecordUpdateCenter = [[[NSClassFromString(aClassName) alloc] initWithRecordList:rowList] autorelease];
                self.saveRecordUpdateCenter.auxClassName = aClassName;
                self.saveRecordUpdateCenter.saveRecordDelegate = self;
                [self.delegate UpdateData];
                [self.saveRecordUpdateCenter runTask];
            }
            @catch (NSException *exception) {
                [self.delegate ErrorOccured:[exception reason]];
            }
        }
    } else {
        [self.delegate ErrorOccured:self.serverFaultMsg];
    }
}

-(void)configBackFromService:(id)result{
    if (result!=nil) {
        if (![result isKindOfClass:[NSError class]] && ![result isKindOfClass:[SoapFault class]]) {
            ArcosConfig* object=(ArcosConfig*)result;
//            NSLog(@"object come back for config-->%@",object);
            
            if (object!=nil ) {
                // Remove current Contents first
                //NSLog(@"remove old data");
                [[ArcosCoreData sharedArcosCoreData] clearTableWithName:@"Config"];
                [[ArcosCoreData sharedArcosCoreData]loadConfigWithSoapOB:object];
                
            }
            self.isLoadingFinished=YES;
            [self.delegate FinishLoadingData:1];
        }else{
            /**
            NSError* anError=(NSError*)result;
            NSLog(@"An error come back from service %@",[anError description]);
            [self.delegate ErrorOccured:[anError description]];
            */
            [self handleResultErrorProcessWithoutReturn:result];
        }
        
    }else{
        [self.delegate ErrorOccured:self.serverFaultMsg];
    }
//    self.isLoadingFinished=YES;
//    [self.delegate FinishLoadingData];
}
-(void)orderBackFromService:(id)result{
    if (result!=nil) {
        if (![result isKindOfClass:[NSError class]] && ![result isKindOfClass:[SoapFault class]]) {
            ArcosArrayOfOrderHeaderBO* objects=(ArcosArrayOfOrderHeaderBO*)result;
//            NSLog(@"%d objects came back for orderheader",[objects count]);
            
            [self.delegate GotData:[objects count]];
            /**
            if ([objects count]>0) {
                // Remove current Contents first
                //NSLog(@"remove old data");
                [[ArcosCoreData sharedArcosCoreData] clearTableWithName:@"OrderHeader"];
                [[ArcosCoreData sharedArcosCoreData] clearTableWithName:@"OrderLine"];
                
            }
            */
            int currentObjectIndex=0;
            
            for (ArcosOrderHeaderBO* anObject in objects) {
//                NSLog(@"employee Object %@",anObject);
                //[[ArcosCoreData sharedArcosCoreData]loadOrderHeaderWithSoapOB:anObject];
//                NSNumber* numberOfOrder = [[ArcosCoreData sharedArcosCoreData] orderWithOrderNumber:anObject.OrderNumber];
//                NSLog(@"number of order is %@", numberOfOrder);
//                if ([numberOfOrder intValue] == 0) {
////                    NSLog(@"inner branch order number is: %d", anObject.OrderNumber);
//                    
//                }               
                [[ArcosCoreData sharedArcosCoreData]loadOrderWithSoapOB:anObject];
                currentObjectIndex++;
                [self.delegate LoadingData:currentObjectIndex];
                //NSLog(@"loading data---%d",currentObjectIndex);
            }
            self.isLoadingFinished=YES;
            [self.delegate FinishLoadingData:[objects count]];
        }else{
            /**
            NSError* anError=(NSError*)result;
            NSLog(@"An error come back from service %@",[anError description]);
            [self.delegate ErrorOccured:[anError description]];
            */
            [self handleResultErrorProcessWithoutReturn:result];
        }
        
    }else{
        [self.delegate ErrorOccured:self.serverFaultMsg];
    }
//    self.isLoadingFinished=YES;
//    [self.delegate FinishLoadingData];
    
}

-(void)callBackFromService:(id)result{
    if (result!=nil) {
        if (![result isKindOfClass:[NSError class]] && ![result isKindOfClass:[SoapFault class]]) {
            ArcosArrayOfCallBO* objects = (ArcosArrayOfCallBO*)result;            
//            NSLog(@"%d objects came back for call orderheader",[objects count]);
            
            [self.delegate GotData:[objects count]];
            
            int currentObjectIndex=0;
            for (ArcosCallBO* anObject in objects) {
                NSNumber* locationIUR = [NSNumber numberWithInt:anObject.LocationIUR];
                NSNumber* contactIUR = [NSNumber numberWithInt:anObject.ContactIUR];
                NSDate* beginDate = [ArcosUtils beginOfDay:anObject.CallDate];
                NSDate* endDate = [ArcosUtils endOfDayWithMaxTime:anObject.CallDate];
                NSPredicate* predicate = [NSPredicate predicateWithFormat:@"LocationIUR = %d and ContactIUR = %d and (OrderDate >= %@) and (OrderDate <= %@)",[locationIUR intValue], [contactIUR intValue], beginDate, endDate];
                NSMutableArray* objectsArray = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"OrderHeader" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
                if ([objectsArray count] == 0) {
                    [[ArcosCoreData sharedArcosCoreData]loadCallWithSoapOB:anObject];
                } else {
                    if ([anObject.CallTrans count] > 0) {
                        BOOL sameCallExistFlag = NO;
                        for (NSDictionary* tmpDict in objectsArray) {
                            if ([[tmpDict objectForKey:@"NumberOflines"] intValue] == 0) {
                                sameCallExistFlag = YES;
                                break;
                            }
                        }
                        if (!sameCallExistFlag) {
                            [[ArcosCoreData sharedArcosCoreData]loadCallWithSoapOB:anObject];
                        }
                    }
                }
                
                currentObjectIndex++;
                [self.delegate LoadingData:currentObjectIndex];
            }
            self.isLoadingFinished=YES;
            [self.delegate FinishLoadingData:[objects count]];
        }else{
            [self handleResultErrorProcessWithoutReturn:result];
        }        
    }else{
        [self.delegate ErrorOccured:self.serverFaultMsg];
    }    
}
-(void)responseBackFromService:(id)result{
    if (result!=nil) {
        if (![result isKindOfClass:[NSError class]] && ![result isKindOfClass:[SoapFault class]]) {
            ArcosArrayOfResponseBO* objects = (ArcosArrayOfResponseBO*)result;
            [self.delegate GotData:[objects count]];
            
            int currentObjectIndex=0;
            for (ArcosResponseBO* anObject in objects) {
                [[ArcosCoreData sharedArcosCoreData] loadResponseWithSoapOB:anObject];
                
                currentObjectIndex++;
                [self.delegate LoadingData:currentObjectIndex];
            }
            self.isLoadingFinished=YES;
            [self.delegate FinishLoadingData:[objects count]];
        }else{
            [self handleResultErrorProcessWithoutReturn:result];
        }
    }else{
        [self.delegate ErrorOccured:self.serverFaultMsg];
    }
}
-(void)surveyBackFromService:(id)result{
    if (result != nil) {
        result = [self handleResultErrorProcess:result];
        if (result != nil) {
            ArcosArrayOfSurveyBO* arcosArrayOfSurveyBO = (ArcosArrayOfSurveyBO*)result;
            [self.delegate GotData:[arcosArrayOfSurveyBO count]];
            if ([arcosArrayOfSurveyBO count] > 0) {
                                                                    
            }
            [[ArcosCoreData sharedArcosCoreData] clearTableWithName:@"Survey"];
            [[ArcosCoreData sharedArcosCoreData] clearTableWithName:@"Question"];
            
            int currentObjectIndex = 0;
            for (ArcosSurveyBO* arcosSurveyBO in arcosArrayOfSurveyBO) {
                [[ArcosCoreData sharedArcosCoreData] loadSurveyWithSoapOB:arcosSurveyBO];
                currentObjectIndex++;
                [self.delegate LoadingData:currentObjectIndex];
            }
            self.isLoadingFinished = YES;
            [self.delegate FinishLoadingData:[arcosArrayOfSurveyBO count]];
        }
    } else {
        [self.delegate ErrorOccured:self.serverFaultMsg];
    }
//    self.isLoadingFinished = YES;
//    [self.delegate FinishLoadingData];
}
-(void)journeyBackFromService:(id)result{
    if (result != nil) {
        result = [self handleResultErrorProcess:result];
        if (result != nil) {            
            ArcosArrayOfJourneyBO* arcosArrayOfJourneyBO = (ArcosArrayOfJourneyBO*)result;
            [self.delegate GotData:[arcosArrayOfJourneyBO count]];
            if ([arcosArrayOfJourneyBO count] > 0) {
                                                                
            }
            [[ArcosCoreData sharedArcosCoreData] clearTableWithName:@"Journey"];
            
            int currentObjectIndex = 0;
            for (ArcosJourneyBO* arcosJourneyBO in arcosArrayOfJourneyBO) {
                [[ArcosCoreData sharedArcosCoreData] loadJourneyWithSoapOB:arcosJourneyBO];
                currentObjectIndex++;
                [self.delegate LoadingData:currentObjectIndex];
            }
            self.isLoadingFinished = YES;
            [self.delegate FinishLoadingData:[arcosArrayOfJourneyBO count]];
        }
    } else {
        [self.delegate ErrorOccured:self.serverFaultMsg];
    }
//    self.isLoadingFinished = YES;
//    [self.delegate FinishLoadingData];
}
-(id)handleResultErrorProcess:(id)result {
    NSString* errorMsg;
    if ([result isKindOfClass:[NSError class]]) {
        NSError* anError = (NSError*)result;
        errorMsg = [anError localizedDescription];        
        [self.delegate ErrorOccured:errorMsg];
        return nil;
    } else if ([result isKindOfClass:[SoapFault class]]) {        
        SoapFault* anSoapFault = (SoapFault*)result;
        errorMsg = [anSoapFault faultString];
        [self.delegate ErrorOccured:errorMsg];
        return nil;
    }
    return result;
}

-(void)handleResultErrorProcessWithoutReturn:(id)result {
    NSString* errorMsg;
    if ([result isKindOfClass:[NSError class]]) {
        NSError* anError = (NSError*)result;
        errorMsg = [anError localizedDescription];        
        [self.delegate ErrorOccured:errorMsg];
    } else if ([result isKindOfClass:[SoapFault class]]) {        
        SoapFault* anSoapFault = (SoapFault*)result;
        errorMsg = [anSoapFault faultString];
        [self.delegate ErrorOccured:errorMsg];
    } else {
        [self.delegate ErrorOccured:self.serverFaultMsg];
    }
}

-(void)loadingProgress:(NSNumber*)value{
    [self.delegate LoadingData:[value intValue] ];

}

#pragma mark PaginatedUpdateCenterDelegate
-(void)paginatedUpdateCompleted:(int)anOverallNumber {
    if ([NSStringFromSelector(self.paginatedUpdateCenter.action) isEqualToString:@"loadPaginatedLocationsToDB:"]) {
        NSMutableDictionary* locationDataDict = [self.paginatedRequestObjectProvider getUpdateCenterDataDict:[GlobalSharedClass shared].locationSelectorName];
        [self.webServiceSharedDataManager resetLocationList];
        if ([[locationDataDict objectForKey:@"DownloadMode"] intValue] == 0) {
//            NSMutableArray* locationIURList = [self.webServiceSharedDataManager retrieveAllLocationIUR];            
//            [self.webServiceSharedDataManager removeAllSentOrderHeaderWithLocationIURList:locationIURList];
//            [self.webServiceSharedDataManager removeLocationProductMATWithLocationIURList:locationIURList];
            self.removeRecordUpdateCenter = [[[RemoveRecordUpdateCenter alloc] initWithCompletedSelector:@selector(removeRecordCompletedWithPaginationDownload)] autorelease];
            self.removeRecordUpdateCenter.completedOverallNumber = anOverallNumber;
            self.removeRecordUpdateCenter.removeDelegate = self;
            [self.removeRecordUpdateCenter buildProcessSelectorList];
            [self.removeRecordUpdateCenter startPerformSelectorList];
            return;
        }        
    }
    self.isLoadingFinished = YES;
    [self.delegate FinishLoadingData:anOverallNumber];
}

- (void)removeRecordCompletedWithPaginationDownload {
    self.isLoadingFinished = YES;
    [self.delegate FinishLoadingData:self.removeRecordUpdateCenter.completedOverallNumber];
}
#pragma mark ResourcesUpdateCenterDelegate
-(void)resourcesUpdateCompleted:(int)anOverallFileCount {
    self.isLoadingFinished = YES;
    [self.delegate FinishLoadingData:anOverallFileCount];
}

- (void)updateResourcesProgressBar:(float)aValue {
    [self.delegate ProgressViewWithValue:aValue];
}

- (void)ResourceStatusTextWithValue:(NSString*)aValue {
    [self.delegate ResourceStatusTextWithValue:aValue];
}

- (void)didFailWithErrorResourcesFileDelegate:(NSError *)anError {
    [self.delegate GotFailWithErrorResourcesFileDelegate:anError];
}

- (void)errorWithResourcesFile:(NSError *)anError {
    [self.delegate GotErrorWithResourcesFile:anError];
}

-(void)handlePaginatedResultErrorProcess {
    if (self.paginatedUpdateCenter != nil) {
        [self.paginatedUpdateCenter stopTask];
    }
}
#pragma mark SaveRecordUpdateCenterDelegate
- (void)saveRecordUpdateCompleted:(int)aRecordCount {
    if ([self.saveRecordUpdateCenter.auxClassName isEqualToString:@"SaveRecordLocationUpdateCenter"]) {
        NSMutableDictionary* locationDataDict = [self.paginatedRequestObjectProvider getUpdateCenterDataDict:[GlobalSharedClass shared].locationSelectorName];
        [self.webServiceSharedDataManager resetLocationList];
        if ([[locationDataDict objectForKey:@"DownloadMode"] intValue] == 0) {
//            NSMutableArray* locationIURList = [self.webServiceSharedDataManager retrieveAllLocationIUR];            
//            [self.webServiceSharedDataManager removeAllSentOrderHeaderWithLocationIURList:locationIURList];
//            [self.webServiceSharedDataManager removeLocationProductMATWithLocationIURList:locationIURList];
            self.removeRecordUpdateCenter = [[[RemoveRecordUpdateCenter alloc] initWithCompletedSelector:@selector(removeRecordCompletedWithCsvDownload)] autorelease];
            self.removeRecordUpdateCenter.removeDelegate = self;
            [self.removeRecordUpdateCenter buildProcessSelectorList];
            [self.removeRecordUpdateCenter startPerformSelectorList];
            return;
        }        
    }
    [self.service DeleteFromResources:self action:@selector(deleteResourcesBackFromService:) FileNAme:self.auxFileName];
}

- (void)removeRecordCompletedWithCsvDownload {
    [self.service DeleteFromResources:self action:@selector(deleteResourcesBackFromService:) FileNAme:self.auxFileName];
}

- (void)updateSaveRecordProgressBar:(float)aValue {
    [self.delegate ProgressViewWithValue:aValue];
    self.saveRecordUpdateCenter.isSaveRecordLoadingFinished = YES;
}

-(void)CommitData {
    [self.delegate CommitData];
}

- (void)batchedSaveRecordUpdateCompleted:(int)aRecordCount {
    [self.batchedUpdateCenter accumulateActiveRecordCount:aRecordCount];
    self.isBatchedLoadingFinished = YES;
}

#pragma mark BatchedUpdateCenterDelegate
- (void)batchedUpdateCompleted:(int)anOverallNumber {
    if ([NSStringFromSelector(self.batchedUpdateCenter.action) isEqualToString:@"loadLocationProductMATBatchedUpdateCenter:"]) {
        NSMutableDictionary* locationProductMATDataDict = [self.paginatedRequestObjectProvider getUpdateCenterDataDict:[GlobalSharedClass shared].locationProductMATSelectorName];
        if ([[locationProductMATDataDict objectForKey:@"DownloadMode"] intValue] == 0) {
            NSLog(@"enter mat");
            [self.webServiceSharedDataManager removeLocationProductMATWithLevelIUR:self.batchedUpdateCenter.levelIUR];
        }
    }
    [self.service DeleteFromResources:self action:@selector(batchedDeleteResourcesBackFromService:) FileNAme:self.auxFileName];
}

- (void)batchedDeleteResourcesBackFromService:(id)result {
    self.isLoadingFinished = YES;
    [self.delegate FinishLoadingData:self.batchedUpdateCenter.activeRecordBatchedCount];
    self.batchedUpdateCenter.batchedDelegate = nil;
    self.batchedUpdateCenter = nil;
}

- (void)deleteResourcesBackFromService:(id)result {
    self.isLoadingFinished = YES;    
    [self.delegate FinishLoadingData:self.saveRecordUpdateCenter.activeRecordCount];
    self.saveRecordUpdateCenter.saveRecordDelegate = nil;
    self.saveRecordUpdateCenter = nil;
}
#pragma mark RemoveRecordProcessorDelegate
- (void)updateRemoveRecordProgressBar:(float)aValue {
    [self.delegate ProgressViewWithValue:aValue];
}

- (void)updateRemoveRecordProgressBarWithoutAnimation:(float)aValue {
    [self.delegate ProgressViewWithValueWithoutAnimation:aValue];
}

- (void)updateRemoveStatusTextWithValue:(NSString*)aValue {
    [self.delegate ResourceStatusTextWithValue:aValue];
}

- (void)removeRecordProcessCompleted {
    
}

- (void)didFinishRemoveRecordUpdateCenter {
    [self performSelector:self.removeRecordUpdateCenter.completedSelector];
}

#pragma mark test
-(void)testFormRowsBackFromService:(id)result {
    NSLog(@"testFormRowsBackFromService finish.");
}

-(void)dealloc{
    if (self.service != nil) { self.service = nil; }
    if (self.paginatedUpdateCenter != nil) { self.paginatedUpdateCenter = nil; }
    if (self.paginatedRequestObjectProvider != nil) { self.paginatedRequestObjectProvider = nil; }
    if (self.resourcesUpdateCenter != nil) { self.resourcesUpdateCenter = nil; }
    self.auxFileName = nil;
    self.saveRecordUpdateCenter.saveRecordDelegate = nil;
    self.saveRecordUpdateCenter = nil;
    self.rowDelimiter = nil;
    self.serverFaultMsg = nil;
    self.batchedUpdateCenter.batchedDelegate = nil;
    self.batchedUpdateCenter = nil;
    self.webServiceSharedDataManager = nil;
    self.removeRecordUpdateCenter = nil;
    
    [super dealloc];
}
@end
