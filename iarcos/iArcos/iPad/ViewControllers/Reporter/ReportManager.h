//
//  ReportManager.h
//  Arcos
//
//  Created by David Kilmartin on 27/04/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TouchXML.h"
#import "ArcosService.h"
#import "ArcosSystemCodesUtils.h"

@protocol ReportManagerDelegate 

-(void)reportXMLDocumentGenerated:(CXMLDocument*)doc;
-(void)reportExcelDocumentGenerated:(NSString*)doc;
-(void)reportDocumentGeneratedWithError:(NSString*)error;
-(void)reportExcelDocumentGeneratedWithServerFilePath:(NSString*)aServerFilePath fileName:(NSString*)aFileName pdfServerFilePath:(NSString*)aPdfServerFilePath pdfFileName:(NSString*)aPdfFileName;
@end

@interface ReportManager : NSObject{
    NSNumber* ReportCode;
    CXMLDocument* ReportDocument;
    NSMutableArray* Options;
    NSMutableArray* MainData;
    NSMutableDictionary* AllData;
    
    id<ReportManagerDelegate> delegate;
    NSString* _xmlFileName;
}
@property(nonatomic,retain) NSNumber* ReportCode;
@property(nonatomic,retain) CXMLDocument* ReportDocument;
@property(nonatomic,retain) NSMutableArray* Options;
@property(nonatomic,retain) NSMutableArray* MainData;
@property(nonatomic,retain) NSMutableDictionary* AllData;
@property(nonatomic,assign) id<ReportManagerDelegate> delegate;
@property(nonatomic,retain) NSString* xmlFileName;

+(id)Manager;

-(void)ReportDocumentWithName:(NSString*)name;
-(void)runXMLReportWithIUR:(NSNumber*)rIUR withEmployeeIUR:(NSNumber*)eIUR withStartDate:(NSDate*)sDate withEndDate:(NSDate*)eDate tableName:(NSString*)aTableName selectedIUR:(NSNumber*)aSelectedIUR extraParams:(NSString*)anExtraParams;
-(void)runExcelReportWithIUR:(NSNumber*)rIUR withEmployeeIUR:(NSNumber*)eIUR withStartDate:(NSDate*)sDate withEndDate:(NSDate*)eDate tableName:(NSString*)aTableName selectedIUR:(NSNumber*)aSelectedIUR extraParams:(NSString*)anExtraParams;
-(ArcosLevel5Spec*)createLevel5Spec:(NSNumber*)rIUR withEmployeeIUR:(NSNumber*)eIUR withStartDate:(NSDate*)sDate withEndDate:(NSDate*)eDate;
-(NSString*)createReportFilePath:(NSString*)fileName;
-(NSString*)createPdfReportFileName:(NSString*)fileName;
@end
