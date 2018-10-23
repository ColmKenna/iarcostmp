//
//  ReporterExcelQLPreviewController.h
//  Arcos
//
//  Created by David Kilmartin on 19/04/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "ArcosQLPreviewController.h"
#import "ReporterPdfQLPreviewController.h"
#import "ReporterFileManager.h"
#import "ArcosSystemCodesUtils.h"

@interface ReporterExcelQLPreviewController : ArcosQLPreviewController<QLPreviewControllerDataSource> {
    UIBarButtonItem* _downloadPdfButton;
    ReporterFileManager* _reporterFileManager;
}

@property(nonatomic,retain) UIBarButtonItem* downloadPdfButton;
@property (nonatomic,retain) ReporterFileManager* reporterFileManager;

- (void)drillDownToPDFView;

@end
