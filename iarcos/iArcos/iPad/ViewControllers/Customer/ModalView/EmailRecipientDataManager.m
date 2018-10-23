//
//  EmailRecipientDataManager.m
//  Arcos
//
//  Created by David Kilmartin on 15/02/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "EmailRecipientDataManager.h"

@implementation EmailRecipientDataManager
@synthesize emailRecipientBaseDataManager = _emailRecipientBaseDataManager;
@synthesize requestSource = _requestSource;
@synthesize locationIUR = _locationIUR;
@synthesize displayList = _displayList;
@synthesize groupedDataDict = _groupedDataDict;
@synthesize sectionTypeList = _sectionTypeList;
@synthesize wholesalerDict = _wholesalerDict;
@synthesize currentRecipientDict = _currentRecipientDict;

- (id)initWithLocationIUR:(NSNumber*)aLocationIUR requestSource:(EmailRequestSource)aRequestSource {
    self = [super init];
    if (self != nil) {        
        self.requestSource = aRequestSource;
        self.locationIUR = aLocationIUR;
        switch (aRequestSource) {
            case EmailRequestSourcePhoto: {
//                NSLog(@"initWithLocationIUR0");
                self.emailRecipientBaseDataManager = [[[EmailRecipientPhotoDataManager alloc] init] autorelease];
            }                
                break;
            case EmailRequestSourceOrder: {
//                NSLog(@"initWithLocationIUR1");
                self.emailRecipientBaseDataManager = [[[EmailRecipientOrderDataManager alloc] init] autorelease];
            }
                break;
            case EmailRequestSourceCall: {
//                NSLog(@"initWithLocationIUR2");
                self.emailRecipientBaseDataManager = [[[EmailRecipientCallDataManager alloc] init] autorelease];
            }
                break;
            case EmailRequestSourceReporter: {
                self.emailRecipientBaseDataManager = [[[EmailRecipientReporterDataManager alloc] init] autorelease];
            }
                break;
            case EmailRequestSourcePresenter: {
                self.emailRecipientBaseDataManager = [[[EmailRecipientPresenterDataManager alloc] init] autorelease];
            }
                break;
            case EmailRequestSourceAccountOverview: {
                self.emailRecipientBaseDataManager = [[[EmailRecipientAccountOverviewDataManager alloc] init] autorelease];
            }
                break;
            case EmailRequestSourceEmployee: {
                self.emailRecipientBaseDataManager = [[[EmailRecipientEmployeeDataManager alloc] init] autorelease];
            }
                break;
            default: {
//                NSLog(@"initWithLocationIUR3");
                self.emailRecipientBaseDataManager = [[[EmailRecipientPhotoDataManager alloc] init] autorelease];
            }
                break;
        }
        self.displayList = [NSMutableArray array];
        self.groupedDataDict = [NSMutableDictionary dictionary];
        self.sectionTypeList = [NSMutableArray array];
        self.emailRecipientBaseDataManager.locationIUR = self.locationIUR;
        self.emailRecipientBaseDataManager.displayList = self.displayList;
        self.emailRecipientBaseDataManager.groupedDataDict = self.groupedDataDict;
        self.emailRecipientBaseDataManager.sectionTypeList = self.sectionTypeList;
    }
    return self;
}


- (void)dealloc {
    if (self.emailRecipientBaseDataManager != nil) { self.emailRecipientBaseDataManager = nil; }
    if (self.locationIUR != nil) { self.locationIUR = nil; }
    if (self.displayList != nil) { self.displayList = nil; }
    if (self.groupedDataDict != nil) { self.groupedDataDict = nil; }
    if (self.sectionTypeList != nil) { self.sectionTypeList = nil; }
    if (self.wholesalerDict != nil) { self.wholesalerDict = nil; }
    if (self.currentRecipientDict != nil) { self.currentRecipientDict = nil; }
    
    
    [super dealloc];
}

@end
