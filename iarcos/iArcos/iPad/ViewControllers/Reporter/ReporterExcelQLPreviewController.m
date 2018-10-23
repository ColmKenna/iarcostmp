//
//  ReporterExcelQLPreviewController.m
//  Arcos
//
//  Created by David Kilmartin on 19/04/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "ReporterExcelQLPreviewController.h"

@implementation ReporterExcelQLPreviewController
@synthesize downloadPdfButton = _downloadPdfButton;
@synthesize reporterFileManager = _reporterFileManager;

- (void)dealloc {
    if (self.downloadPdfButton != nil) { self.downloadPdfButton = nil; }
    if (self.reporterFileManager != nil) { self.reporterFileManager = nil; }
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.downloadPdfButton = [[[UIBarButtonItem alloc] initWithTitle:@"DownloadPdfFile" style:UIBarButtonItemStylePlain target:self action:@selector(pdfButtonPressed:)] autorelease];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.navigationItem.rightBarButtonItem, self.emailButton, self.previewButton, self.downloadPdfButton,nil];
}

- (void)pdfButtonPressed:(id)sender {
    if ([ArcosSystemCodesUtils webServiceResourceExistence]) {
        NSLog(@"wsr pdf");
        ArcosService* service = [ArcosService serviceWithUsername:@"u1103395_Support" andPassword:@"Strata411325"];
        [service GetFromResources:self action:@selector(wsrPdfBackFromService:) FileNAme:self.reporterFileManager.pdfFileName];
    } else {
        BOOL pdfDownloadFlag = [self.arcosPreviewDelegate downloadPdfFileDelegate];
        if (pdfDownloadFlag) {
            ReporterPdfQLPreviewController* reporterPdfQLPreviewController = [[ReporterPdfQLPreviewController alloc] init];
            reporterPdfQLPreviewController.dataSource = self;
            reporterPdfQLPreviewController.delegate = self;
            [self.navigationController pushViewController:reporterPdfQLPreviewController animated:YES];
            [reporterPdfQLPreviewController release];
        }
    }
}

- (void)wsrPdfBackFromService:(id)result {
    result = [ArcosSystemCodesUtils handleResultErrorProcess:result];
    if (result == nil) {
        return;
    }
    NSString* pdfFilePath = [NSString stringWithFormat:@"%@/%@", [FileCommon reporterPath],self.reporterFileManager.pdfFileName];
    [FileCommon removeFileAtPath:pdfFilePath];
    BOOL isSuccessful = [ArcosSystemCodesUtils convertBase64ToPhysicalFile:result filePath:pdfFilePath];
    if (isSuccessful) {
        [self drillDownToPDFView];
    }
}

- (void)drillDownToPDFView {
    ReporterPdfQLPreviewController* reporterPdfQLPreviewController = [[ReporterPdfQLPreviewController alloc] init];
    reporterPdfQLPreviewController.dataSource = self;
    reporterPdfQLPreviewController.delegate = self;
    [self.navigationController pushViewController:reporterPdfQLPreviewController animated:YES];
    [reporterPdfQLPreviewController release];
}

#pragma mark Preview Controller
- (NSInteger) numberOfPreviewItemsInPreviewController: (QLPreviewController *) controller 
{
	return [self.reporterFileManager.previewPdfDocumentList count];
}

- (id <QLPreviewItem>)previewController: (QLPreviewController *)controller previewItemAtIndex:(NSInteger)index 
{        
    NSString* tmpFileName = [self.reporterFileManager.previewPdfDocumentList objectAtIndex:index];
    NSString* filePath = [NSString stringWithFormat:@"%@/%@", [FileCommon pathWithFolder:self.reporterFileManager.reporterFolderName], tmpFileName];
    ArcosQLPreviewItem* arcosQLPreviewItem = [[[ArcosQLPreviewItem alloc] init] autorelease];
    arcosQLPreviewItem.myItemURL = [NSURL fileURLWithPath:filePath];
    arcosQLPreviewItem.myItemTitle = [NSString stringWithFormat:@"%@", self.reporterFileManager.reportTitle];
    return arcosQLPreviewItem;    
}

@end
