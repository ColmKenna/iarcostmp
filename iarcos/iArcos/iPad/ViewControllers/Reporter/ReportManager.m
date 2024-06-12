//
//  ReportManager.m
//  Arcos
//
//  Created by David Kilmartin on 27/04/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "ReportManager.h"
#import "ArcosService.h"
#import "SettingManager.h"
#import "ArcosRootViewController.h"

@interface ReportManager (Private)
-(void) GenerateReportWithCode:(NSNumber*)code;
-(void) FillTheDataDictionary:(CXMLDocument*)doc;
@end

@implementation ReportManager
@synthesize ReportCode;
@synthesize ReportDocument;
@synthesize Options;
@synthesize MainData;
@synthesize AllData;
@synthesize delegate;
@synthesize xmlFileName = _xmlFileName;
@synthesize arcosRootViewController = _arcosRootViewController;
//@synthesize csvFileName = _csvFileName;

-(id)init{
    self=[super init];
    if (self!=nil) {
        self.Options=[NSMutableArray array];
        self.MainData=[NSMutableArray array];
        self.AllData=[NSMutableDictionary dictionary];
        self.arcosRootViewController = (ArcosRootViewController*)[ArcosUtils getRootView];
    }
    return self;
}
+(id)Manager{
    return [[[self alloc]init]autorelease];
}

-(void) GenerateReportWithCode:(NSNumber*)code{
    
}

-(void)ReportDocumentWithName:(NSString*)name{
//    NSString* path=[NSString stringWithFormat:@"%@%@",[SettingManager downloadServer],name];
    self.xmlFileName = name;
    NSString* path = [self createReportFilePath:name];
//    NSLog(@"report xml path---%@",path);
    if ([ArcosSystemCodesUtils webServiceResourceExistence]) {
        NSLog(@"wsr xml");
        ArcosService* service = [ArcosService serviceWithUsername:@"u1103395_Support" andPassword:@"Strata411325"];
        [service GetFromResources:self action:@selector(wsrXmlBackFromService:) FileNAme:name];
    } else {
//        NSLog(@"normal xml");
        NSURL* url=[NSURL URLWithString:path];
        self.ReportDocument = [[[CXMLDocument alloc] initWithContentsOfURL:url options:0 error:nil] autorelease];
        
        [self.delegate reportXMLDocumentGenerated:self.ReportDocument];
    }
}

-(void)wsrXmlBackFromService:(id)result {
    id newResult = [ArcosSystemCodesUtils handleResultErrorProcess:result];
    if (newResult == nil) {
        [self.delegate reportDocumentGeneratedWithErrorOccured];
        return;
    }
    NSString* xmlFilePath = [NSString stringWithFormat:@"%@/%@", [FileCommon reporterPath],self.xmlFileName];
    [FileCommon removeFileAtPath:xmlFilePath];
//    NSLog(@"xmlFilePath: %@", xmlFilePath);
    BOOL fileCreatedFlag = [ArcosSystemCodesUtils convertBase64ToPhysicalFile:newResult filePath:xmlFilePath];
    if (!fileCreatedFlag) {
        [self.delegate reportDocumentGeneratedWithErrorOccured];
        return;
    }
//    ArcosGetFromResourcesResult* arcosGetFromResourcesResult = (ArcosGetFromResourcesResult*)newResult;
//    if (arcosGetFromResourcesResult.ErrorModel.Code > 0) {
//        [arcosGetFromResourcesResult.FileContents writeToFile:xmlFilePath atomically:YES];
//    } else {
//        [ArcosUtils showDialogBox:arcosGetFromResourcesResult.ErrorModel.Message title:@"" delegate:nil target:self.arcosRootViewController tag:0 handler:nil];
//    }
    NSURL* url=[NSURL fileURLWithPath:xmlFilePath];
    self.ReportDocument = [[[CXMLDocument alloc] initWithContentsOfURL:url options:0 error:nil] autorelease];
//    NSLog(@"abc");
    [self.delegate reportXMLDocumentGenerated:self.ReportDocument];
}

-(void) FillTheDataDictionary:(CXMLDocument*)doc{
    NSArray* Main=[doc nodesForXPath:@"//Main" error:nil];
    NSArray* Sub=[doc nodesForXPath:@"//Sub" error:nil];
    
    //@autoreleasepool {

        //filling main data
        for (CXMLElement* element in Main) {
            NSMutableDictionary* elementDict=[NSMutableDictionary dictionary];
            for (int i=0; i<element.childCount; i++) {
                
                if (![[element childAtIndex:i].name isEqualToString:@"text"]&&[[element childAtIndex:i]stringValue]!=nil) {
//                    NSLog(@"child name:%@  %d  child value:%@  %d",[element childAtIndex:i].name,[[element childAtIndex:i].name length],[[element childAtIndex:i]stringValue],[[[element childAtIndex:i]stringValue]length]);
                    
                    [elementDict setObject:[[element childAtIndex:i]stringValue] forKey:[element childAtIndex:i].name];
                }
                
            }
            [self.MainData addObject:elementDict];
        }

    

        //filling sub total
        for (CXMLElement* element in Sub) {
            NSMutableDictionary* elementDict=[NSMutableDictionary dictionary];
            for (int i=0; i<element.childCount; i++) {
                
                if (![[element childAtIndex:i].name isEqualToString:@"text"]) {
//                    NSLog(@"child name:%@  %d  child value:%@  %d",[element childAtIndex:i].name,[[element childAtIndex:i].name length],[[element childAtIndex:i]stringValue],[[[element childAtIndex:i]stringValue]length]);
                    
                    [elementDict setObject:[[element childAtIndex:i]stringValue] forKey:[element childAtIndex:i].name];
                }
                
            }
            [self.Options addObject:elementDict];
        }
    //}
    
}

#pragma mark service call
-(void)runXMLReportWithIUR:(NSNumber*)rIUR withEmployeeIUR:(NSNumber*)eIUR withStartDate:(NSDate*)sDate withEndDate:(NSDate*)eDate tableName:(NSString*)aTableName selectedIUR:(NSNumber*)aSelectedIUR extraParams:(NSString*)anExtraParams {
    ArcosService* service=[ArcosService serviceWithUsername:@"u1103395_Support" andPassword:@"Strata411325"];
//    ArcosLevel5Spec* arcosLevel5Spec = [self createLevel5Spec:rIUR withEmployeeIUR:eIUR withStartDate:sDate withEndDate:eDate];
//    [service RunLevel5:self action:@selector(reportXMLBack:) spec:arcosLevel5Spec];
    NSLog(@"XMLReport: %@ %@", aTableName, aSelectedIUR);
    [service RunReport:self action:@selector(reportXMLBack:) ReportIUR:[rIUR intValue] startDate:sDate endDate:eDate EmployeeIUR:[eIUR intValue] tablename:aTableName tableiur:[aSelectedIUR intValue] extraParams:anExtraParams];
}

-(void)runExcelReportWithIUR:(NSNumber*)rIUR withEmployeeIUR:(NSNumber*)eIUR withStartDate:(NSDate*)sDate withEndDate:(NSDate*)eDate tableName:(NSString*)aTableName selectedIUR:(NSNumber*)aSelectedIUR extraParams:(NSString*)anExtraParams {
    ArcosService* service=[ArcosService serviceWithUsername:@"u1103395_Support" andPassword:@"Strata411325"];
    ArcosLevel5Spec* arcosLevel5Spec = [self createLevel5Spec:rIUR withEmployeeIUR:eIUR withStartDate:sDate withEndDate:eDate];
    NSLog(@"ExcelReport: %@ %@", aTableName, aSelectedIUR);
    [service RunLevel5:self action:@selector(reportExcelBack:) spec:arcosLevel5Spec tablename:aTableName iur:[aSelectedIUR intValue] extraFilters:anExtraParams];
//    [service RunReport:self action:@selector(reportExcelBack:) ReportIUR:[rIUR intValue] startDate:sDate endDate:eDate EmpoloyeeIUR:[eIUR intValue]];
}

-(ArcosLevel5Spec*)createLevel5Spec:(NSNumber*)rIUR withEmployeeIUR:(NSNumber*)eIUR withStartDate:(NSDate*)sDate withEndDate:(NSDate*)eDate {
    ArcosLevel5Spec* arcosLevel5Spec = [[[ArcosLevel5Spec alloc] init] autorelease];
    arcosLevel5Spec.Iur = [rIUR intValue];    
    arcosLevel5Spec.Employeeiur = [eIUR intValue];
    arcosLevel5Spec.StartDate = sDate;
    arcosLevel5Spec.EndDate = eDate;
    arcosLevel5Spec.FileName = [rIUR stringValue];
    return arcosLevel5Spec;
}

-(NSString*)createReportFilePath:(NSString*)fileName {
    NSString* serviceAddress = [SettingManager serviceAddress];
    NSRange range;
    NSString* filePath = @"";
    @try {
        range = [serviceAddress rangeOfString:@"/" options:NSBackwardsSearch];
        filePath = [NSString stringWithFormat:@"%@/Resources/%@", [serviceAddress substringToIndex:range.location], fileName];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", [exception reason]);
    }    
    return filePath;
}

-(NSString*)createPdfReportFileName:(NSString*)fileName {
    NSRange range;
    NSString* pdfReportFileName = @"";
    @try {
        range = [fileName rangeOfString:@"." options:NSBackwardsSearch];
        pdfReportFileName = [NSString stringWithFormat:@"%@.pdf", [fileName substringToIndex:range.location]];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", [exception reason]);
    }    
    return pdfReportFileName;
}

-(void)reportXMLBack:(id)result{
    [GlobalSharedClass shared].serviceTimeoutInterval = [GlobalSharedClass shared].defaultServiceTimeoutInterval;
    if (result!=nil) {
        if ([result isKindOfClass:[NSError class]]) {
            NSError* anError=(NSError*)result;
            NSLog(@"An error come back from service %@",[anError description]);
            [self.delegate reportDocumentGeneratedWithError:[anError description]];
            
        } else if([result isKindOfClass:[SoapFault class]]){
            SoapFault* anFault=(SoapFault*) result;
            NSLog(@"An error come back from service %@",[anFault faultString]);
            [self.delegate reportDocumentGeneratedWithError:[anFault faultString]];
            
        }else  {
            NSLog(@"object back from run report %@",result);
            [self ReportDocumentWithName:result];
        }
        
    }else{
        NSLog(@"A null come back from service");
        [self.delegate reportDocumentGeneratedWithError:@"A null come back from service"];
    }
}
-(void)reportExcelBack:(id)result{
    [GlobalSharedClass shared].serviceTimeoutInterval = [GlobalSharedClass shared].defaultServiceTimeoutInterval;
    if (result!=nil) {
        if ([result isKindOfClass:[NSError class]]) {
            NSError* anError=(NSError*)result;
            NSLog(@"An error come back from service %@",[anError description]);
            [self.delegate reportDocumentGeneratedWithError:[anError description]];
            
        } else if([result isKindOfClass:[SoapFault class]]){
            SoapFault* anFault=(SoapFault*) result;
            NSLog(@"An error come back from service %@",[anFault faultString]);
            [self.delegate reportDocumentGeneratedWithError:[anFault faultString]];
            
        }else  {
            NSLog(@"object back from run report %@",result);
//            NSString* path=[NSString stringWithFormat:@"%@%@",[SettingManager downloadServer],result];
//            NSString* pdfReportFileName = [self createPdfReportFileName:result];
            NSString* pdfReportFileName = @"";
//            NSLog(@"pdfReportFileName: %@", result);
            NSString* path = [self createReportFilePath:result];
//            NSString* pdfPath = [self createReportFilePath:pdfReportFileName];
            NSString* pdfPath = @"";
            [self.delegate reportExcelDocumentGeneratedWithServerFilePath:path fileName:result pdfServerFilePath:pdfPath pdfFileName:pdfReportFileName];
//            [self.delegate reportExcelDocumentGenerated:path];
        }
        
    }else{
        NSLog(@"A null come back from service");
        [self.delegate reportDocumentGeneratedWithError:@"A null come back from service"];
    }
}

-(void)dealloc{
    if(self.ReportCode!=nil){ self.ReportCode=nil; }
        
    
    if(self.ReportDocument!=nil){ self.ReportDocument=nil; }
        
    
    if(self.Options!=nil){ self.Options=nil; }
        
    
    if(self.MainData!=nil){ self.MainData=nil; }
        
    
    if(self.AllData!=nil){ self.AllData=nil; }
        
//    if(self.delegate!=nil){
//        self.delegate=nil;
//    }
    if (self.xmlFileName != nil) { self.xmlFileName = nil; }
//    self.csvFileName = nil;
    
    [super dealloc];
}
@end
