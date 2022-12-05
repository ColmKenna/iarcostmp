//
//  ReporterXmlExcelViewController.h
//  iArcos
//
//  Created by Richard on 30/11/2022.
//  Copyright © 2022 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileCommon.h"
#import "CXMLDocument.h"
#import "CXMLElement.h"
#import "GlobalSharedClass.h"
#import "ArcosUtils.h"

@interface ReporterXmlExcelViewController : UIViewController {
    UIWebView* _myWebView;
    NSString* _fileName;
    NSString* _filePath;
    
}

@property(nonatomic,retain) IBOutlet UIWebView* myWebView;
@property(nonatomic,retain) NSString* fileName;
@property(nonatomic,retain) NSString* filePath;

- (void)processRawData:(CXMLDocument*)aReportDocument fileName:(NSString*)aFileName;

@end


