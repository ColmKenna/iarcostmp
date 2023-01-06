//
//  ReporterXmlExcelViewController.m
//  iArcos
//
//  Created by Richard on 30/11/2022.
//  Copyright © 2022 Strata IT Limited. All rights reserved.
//

#import "ReporterXmlExcelViewController.h"

@interface ReporterXmlExcelViewController ()

@end

@implementation ReporterXmlExcelViewController
@synthesize myWebView = _myWebView;
@synthesize fileName = _fileName;
@synthesize filePath = _filePath;
@synthesize reportTitle = _reportTitle;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.myWebView.scalesPageToFit = YES;
    NSURL* fileURL = [NSURL fileURLWithPath:self.filePath];
    if ([FileCommon fileExistAtPath:self.filePath]) {
        [self.myWebView loadRequest:[NSURLRequest requestWithURL:fileURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60]];
    }
}

- (void)dealloc {
    self.myWebView = nil;
    self.fileName = nil;
    self.filePath = nil;
    self.reportTitle = nil;
    
    [super dealloc];
}

- (void)processRawData:(CXMLDocument*)aReportDocument fileName:(NSString*)aFileName {
    self.reportTitle = [NSString stringWithFormat:@"%@", aFileName];
    self.fileName = [NSString stringWithFormat:@"%@.csv", aFileName];
    self.filePath = [NSString stringWithFormat:@"%@/%@", [FileCommon reporterPath], self.fileName];
    NSMutableString* reportContent = [NSMutableString string];
    NSArray* mainNodeList = [aReportDocument nodesForXPath:@"//Main" error:nil];
    for (int i = 0; i < [mainNodeList count]; i++) {
        CXMLElement* reportElement = [mainNodeList objectAtIndex:i];
        if (i == 0) {
            for (int j = 0; j < reportElement.childCount; j++) {
                NSString* nodeName = [reportElement childAtIndex:j].name;
                if (![nodeName isEqualToString:@"text"]) {
                    [reportContent appendString:[ArcosUtils convertNilToEmpty:nodeName]];
                    [reportContent appendString:[GlobalSharedClass shared].commaDelimiter];
                }
            }
            [reportContent appendString:[GlobalSharedClass shared].rowDelimiter];
        }
        for (int k = 0; k < reportElement.childCount; k++) {
            NSString* nodeName = [reportElement childAtIndex:k].name;
            if (![nodeName isEqualToString:@"text"]) {
                [reportContent appendString:[ArcosUtils trim:[ArcosUtils convertNilToEmpty:[[reportElement childAtIndex:k] stringValue]]]];
                [reportContent appendString:[GlobalSharedClass shared].commaDelimiter];
            }
        }
        [reportContent appendString:[GlobalSharedClass shared].rowDelimiter];
    }
    [reportContent writeToFile:self.filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

@end
