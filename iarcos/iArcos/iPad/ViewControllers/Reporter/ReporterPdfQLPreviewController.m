//
//  ReporterPdfQLPreviewController.m
//  Arcos
//
//  Created by David Kilmartin on 19/04/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "ReporterPdfQLPreviewController.h"

@implementation ReporterPdfQLPreviewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.navigationItem.rightBarButtonItem, self.emailButton, self.previewButton,nil];
}

@end
