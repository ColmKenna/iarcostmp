//
//  ActivateLocalDataManager.m
//  Arcos
//
//  Created by David Kilmartin on 22/04/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "ActivateLocalDataManager.h"

@implementation ActivateLocalDataManager
@synthesize updateDelegate = _updateDelegate;
@synthesize mainTimer = _mainTimer;
@synthesize isMainLoadingFinished = _isMainLoadingFinished;
@synthesize subTimer = _subTimer;
@synthesize isSubLoadingFinished = _isSubLoadingFinished;
@synthesize subFileList = _subFileList;
@synthesize subIndexList = _subIndexList;
@synthesize subFileCount = _subFileCount;
@synthesize timeLength = _timeLength;
@synthesize halfTimeLength = _halfTimeLength;
@synthesize selectorList = _selectorList;
@synthesize currentSelectorName = _currentSelectorName;
@synthesize presenterFileList = _presenterFileList;
@synthesize totalSelectorLength = _totalSelectorLength;
@synthesize isFree = _isFree;

- (id)init{
    self = [super init];
    if (self != nil) {
        self.isMainLoadingFinished = YES;
        self.isSubLoadingFinished = YES;
        self.selectorList = [NSMutableArray array];
        self.timeLength = 1.0;
        self.halfTimeLength = 0.5;
        self.isFree = YES;
    }
    return self;
}

- (void)dealloc {
    self.mainTimer = nil;
    self.subTimer = nil;
    self.subFileList = nil;
    self.subIndexList = nil;
    self.selectorList = nil;
    self.currentSelectorName = nil;
    self.presenterFileList = nil;
    
    [super dealloc];
}

- (void)buildSelectorDataList {
    self.selectorList = [NSMutableArray array];
    [self pushSelector:@selector(importLocationData) withName:[GlobalSharedClass shared].locationSelectorName];
    [self pushSelector:@selector(importProductData) withName:[GlobalSharedClass shared].productSelectorName];
    [self pushSelector:@selector(importDescrTypeData) withName:[GlobalSharedClass shared].descrTypeSelectorName];
    [self pushSelector:@selector(importDescrDetailData) withName:[GlobalSharedClass shared].descrDetailSelectorName];
    [self pushSelector:@selector(importResourceData) withName:[GlobalSharedClass shared].resourcesSelectorName];
    [self pushSelector:@selector(importPresenterData) withName:[GlobalSharedClass shared].presenterSelectorName];
    [self pushSelector:@selector(importImageData) withName:[GlobalSharedClass shared].imageSelectorName];
    [self pushSelector:@selector(importConLocLinkData) withName:[GlobalSharedClass shared].conLocLinkSelectorName];
    [self pushSelector:@selector(importContactData) withName:[GlobalSharedClass shared].contactSelectorName];
    [self pushSelector:@selector(importFormRowData) withName:[GlobalSharedClass shared].formRowSelectorName];
    [self pushSelector:@selector(importFormDetailData) withName:[GlobalSharedClass shared].formDetailSelectorName];
    [self pushSelector:@selector(importEmployeeData) withName:[GlobalSharedClass shared].employeeSelectorName];
    [self pushSelector:@selector(importConfigData) withName:[GlobalSharedClass shared].configSelectorName];
    [self pushSelector:@selector(importOrderData) withName:[GlobalSharedClass shared].orderHeaderSelectorName];
    [self pushSelector:@selector(importCallData) withName:[GlobalSharedClass shared].callOrderHeaderSelectorName];
    [self pushSelector:@selector(importSurveyData) withName:[GlobalSharedClass shared].surveySelectorName];    
    [self pushSelector:@selector(importJourneyData) withName:[GlobalSharedClass shared].journeySelectorName];
    self.totalSelectorLength = [self.selectorList count];
}

- (void)pushSelector:(SEL)aSelector withName:(NSString*)aName {
    NSDictionary* aSelDict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSValue valueWithPointer:aSelector], aName,nil] forKeys:[NSArray arrayWithObjects:@"selector",@"name", nil]];
    [self.selectorList addObject:aSelDict];
}

- (SEL)popSelector {
    if ([self.selectorList count] > 0) {
        NSDictionary* tempDict = [[[self.selectorList lastObject]retain]autorelease];
        if (tempDict) {
            [self.selectorList removeLastObject];
        }else{
            return nil;
        }
        
        SEL selector= [[tempDict objectForKey:@"selector"] pointerValue];
        self.currentSelectorName = [tempDict objectForKey:@"name"];
        
        return selector;
    }
    return nil;
}

- (NSMutableDictionary*)createDataWithSelectorName:(NSString*)aSelectorName {
    NSMutableArray* fileList = [NSMutableArray array];
    int i = 0;
    while (YES) {
        NSString* fileName = [NSString stringWithFormat:@"%@%d",aSelectorName,i];
        NSString* filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"xml"];
        if ([FileCommon fileExistAtPath:filePath]) {
            [fileList insertObject:fileName atIndex:0];
            i++;
        } else {
            break;
        }
    }
    NSUInteger fileCount = [fileList count];
    NSMutableArray* indexList = [NSMutableArray arrayWithCapacity:[fileList count]];
    for (NSUInteger i = fileCount; i > 0 ; i--) {
        [indexList addObject:[NSNumber numberWithUnsignedInteger:i]];
    }
    NSMutableDictionary* cellDataDict = [NSMutableDictionary dictionaryWithCapacity:3];
    [cellDataDict setObject:fileList forKey:@"FileList"];
    [cellDataDict setObject:indexList forKey:@"IndexList"];
    [cellDataDict setObject:[NSNumber numberWithUnsignedInteger:fileCount] forKey:@"FileCount"];
    self.subFileList = fileList;
    self.subIndexList = indexList;
    self.subFileCount = fileCount;
    return cellDataDict;
}

- (void)importAllData {
    if (!self.isFree) return;
    self.isFree = NO;
    [self buildSelectorDataList];
    self.mainTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkAllData) userInfo:nil repeats:YES];
}

- (void)checkAllData {
    if (!self.isMainLoadingFinished) return;
    if ([self.selectorList count] <= 0) {
        [self.mainTimer invalidate];
        self.mainTimer = nil;
        [self.updateDelegate mainLoadingComplete];
        self.isFree = YES;
    } else {
        SEL aSelector = [self popSelector];
        if (aSelector != nil) {
            [self performSelector:aSelector];
        }
    }
}

#pragma mark Survey
- (void)importSurveyData {
    if (!self.isMainLoadingFinished) return;
    self.isMainLoadingFinished = NO;
    [self createDataWithSelectorName:[GlobalSharedClass shared].surveySelectorName];
    self.subTimer = [NSTimer scheduledTimerWithTimeInterval:self.timeLength target:self selector:@selector(checkSurveyDataCenter) userInfo:nil repeats:YES];
    [self.updateDelegate startImportData:[GlobalSharedClass shared].surveySelectorName];
}

- (void)checkSurveyDataCenter {
    if (!self.isSubLoadingFinished) return;
    if ([self.subFileList count] <= 0) {
        [self.subTimer invalidate];
        self.subTimer = nil;
        [self.updateDelegate completeLoadingData:[GlobalSharedClass shared].surveySelectorName];
        [self updateTableProgressView];
        self.isMainLoadingFinished = YES;
    } else {
        [self processSurveyDataCenter];
    }
}

- (void)processSurveyDataCenter {
    if (!self.isSubLoadingFinished) return;
    self.isSubLoadingFinished = NO;
    NSString* fileName = [[[self.subFileList lastObject] retain] autorelease];
    float progressValue = [[self.subIndexList lastObject] floatValue] / self.subFileCount;
    [self.subIndexList removeLastObject];
    [self.subFileList removeLastObject];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        id result = [ArcosXMLParser doXMLParse:fileName deserializeTo:[[ArcosArrayOfSurveyBO alloc] autorelease]];
        ArcosArrayOfSurveyBO* arcosArrayOfSurveyBO = (ArcosArrayOfSurveyBO*)result;
        for (ArcosSurveyBO* arcosSurveyBO in arcosArrayOfSurveyBO) {
            [[ArcosCoreData sharedArcosCoreData] loadSurveyWithSoapOB:arcosSurveyBO];
        }
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [self.updateDelegate activateProgressViewWithValue:progressValue animated:YES];
            self.isSubLoadingFinished = YES;
        });
    });
}

#pragma mark Config
- (void)importConfigData {
    if (!self.isMainLoadingFinished) return;
    self.isMainLoadingFinished = NO;
    [self createDataWithSelectorName:[GlobalSharedClass shared].configSelectorName];
    self.subTimer = [NSTimer scheduledTimerWithTimeInterval:self.timeLength target:self selector:@selector(checkConfigDataCenter) userInfo:nil repeats:YES];
    [self.updateDelegate startImportData:[GlobalSharedClass shared].configSelectorName];
    
}

- (void)checkConfigDataCenter {
    if (!self.isSubLoadingFinished) return;
    if ([self.subFileList count] <= 0) {
        [self.subTimer invalidate];
        self.subTimer = nil;
        [self.updateDelegate completeLoadingData:[GlobalSharedClass shared].configSelectorName];
        [self updateTableProgressView];
        self.isMainLoadingFinished = YES;
    } else {
        [self processConfigDataCenter];
    }
}

- (void)processConfigDataCenter {
    if (!self.isSubLoadingFinished) return;
    self.isSubLoadingFinished = NO;
    NSString* fileName = [[[self.subFileList lastObject] retain] autorelease];
    float progressValue = [[self.subIndexList lastObject] floatValue] / self.subFileCount;
    [self.subIndexList removeLastObject];
    [self.subFileList removeLastObject];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        id result = [ArcosXMLParser doXMLParse:fileName deserializeTo:[[ArcosConfig alloc] autorelease]];
        ArcosConfig* arcosConfig = (ArcosConfig*)result;
        [[ActivateAppStatusManager appStatusInstance] saveDemoAppStatus];
        [[ArcosCoreData sharedArcosCoreData]loadConfigWithSoapOB:arcosConfig];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [self.updateDelegate activateProgressViewWithValue:progressValue animated:YES];
            self.isSubLoadingFinished = YES;
        });
    });
}

#pragma mark Location
- (void)importLocationData {
    if (!self.isMainLoadingFinished) return;
    self.isMainLoadingFinished = NO;
    [self createDataWithSelectorName:[GlobalSharedClass shared].locationSelectorName];
    self.subTimer = [NSTimer scheduledTimerWithTimeInterval:self.timeLength target:self selector:@selector(checkLocationDataCenter) userInfo:nil repeats:YES];
    [self.updateDelegate startImportData:[GlobalSharedClass shared].locationSelectorName];
    
}

- (void)checkLocationDataCenter {
    if (!self.isSubLoadingFinished) return;
    if ([self.subFileList count] <= 0) {
        [self.subTimer invalidate];
        self.subTimer = nil;
        [self.updateDelegate completeLoadingData:[GlobalSharedClass shared].locationSelectorName];
        [self updateTableProgressView];
        self.isMainLoadingFinished = YES;
    } else {
        [self processLocationDataCenter];
    }
}

- (void)processLocationDataCenter {
    if (!self.isSubLoadingFinished) return;
    self.isSubLoadingFinished = NO;
    NSString* fileName = [[[self.subFileList lastObject] retain] autorelease];
    float progressValue = [[self.subIndexList lastObject] floatValue] / self.subFileCount;
    [self.subIndexList removeLastObject];
    [self.subFileList removeLastObject];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ArcosGenericObjectWithImage* xmlResult = [ArcosXMLParser doXMLParse:fileName deserializeTo:[[ArcosGenericObjectWithImage alloc] autorelease]];
        
        if (xmlResult.ErrorModel.Code >= 0) {
            ArcosArrayOfGenericReturnObjectWithImage* objects = (ArcosArrayOfGenericReturnObjectWithImage*)xmlResult.ArrayOfData;
            for (ArcosGenericReturnObjectWithImage* anObject in objects) {//load objects
                [[ArcosCoreData sharedArcosCoreData]LoadLocationWithSoapOB:anObject];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [self.updateDelegate activateProgressViewWithValue:progressValue animated:YES];
            self.isSubLoadingFinished = YES;
        });
    });
}

#pragma mark DescrDetail
- (void)importDescrDetailData {
    if (!self.isMainLoadingFinished) return;
    self.isMainLoadingFinished = NO;
    [self createDataWithSelectorName:[GlobalSharedClass shared].descrDetailSelectorName];
    self.subTimer = [NSTimer scheduledTimerWithTimeInterval:self.timeLength target:self selector:@selector(checkDescrDetailDataCenter) userInfo:nil repeats:YES];
    [self.updateDelegate startImportData:[GlobalSharedClass shared].descrDetailSelectorName];
}

- (void)checkDescrDetailDataCenter {
    if (!self.isSubLoadingFinished) return;
    if ([self.subFileList count] <= 0) {
        [self.subTimer invalidate];
        self.subTimer = nil;
        [self.updateDelegate completeLoadingData:[GlobalSharedClass shared].descrDetailSelectorName];
        [self updateTableProgressView];
        self.isMainLoadingFinished = YES;
    } else {
        [self processDescrDetailDataCenter];
    }
}

- (void)processDescrDetailDataCenter {
    if (!self.isSubLoadingFinished) return;
    self.isSubLoadingFinished = NO;
    NSString* fileName = [[[self.subFileList lastObject] retain] autorelease];
    float progressValue = [[self.subIndexList lastObject] floatValue] / self.subFileCount;
    [self.subIndexList removeLastObject];
    [self.subFileList removeLastObject];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ArcosGenericObjectWithImage* xmlResult = [ArcosXMLParser doXMLParse:fileName deserializeTo:[[ArcosGenericObjectWithImage alloc] autorelease]];
        
        if (xmlResult.ErrorModel.Code >= 0) {
            ArcosArrayOfGenericReturnObjectWithImage* objects = (ArcosArrayOfGenericReturnObjectWithImage*)xmlResult.ArrayOfData;
            for (ArcosGenericReturnObjectWithImage* anObject in objects) {//load objects
                [[ArcosCoreData sharedArcosCoreData]LoadDescriptionWithSoapOB:anObject];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [self.updateDelegate activateProgressViewWithValue:progressValue animated:YES];
            self.isSubLoadingFinished = YES;
        });
    });
}

#pragma mark DescrType
- (void)importDescrTypeData {
    if (!self.isMainLoadingFinished) return;
    self.isMainLoadingFinished = NO;
    [self createDataWithSelectorName:[GlobalSharedClass shared].descrTypeSelectorName];
    self.subTimer = [NSTimer scheduledTimerWithTimeInterval:self.timeLength target:self selector:@selector(checkDescrTypeDataCenter) userInfo:nil repeats:YES];
    [self.updateDelegate startImportData:[GlobalSharedClass shared].descrTypeSelectorName];
}

- (void)checkDescrTypeDataCenter {
    if (!self.isSubLoadingFinished) return;
    if ([self.subFileList count] <= 0) {
        [self.subTimer invalidate];
        self.subTimer = nil;
        [self.updateDelegate completeLoadingData:[GlobalSharedClass shared].descrTypeSelectorName];
        [self updateTableProgressView];
        self.isMainLoadingFinished = YES;
    } else {
        [self processDescrTypeDataCenter];
    }
}

- (void)processDescrTypeDataCenter {
    if (!self.isSubLoadingFinished) return;
    self.isSubLoadingFinished = NO;
    NSString* fileName = [[[self.subFileList lastObject] retain] autorelease];
    float progressValue = [[self.subIndexList lastObject] floatValue] / self.subFileCount;
    [self.subIndexList removeLastObject];
    [self.subFileList removeLastObject];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ArcosArrayOfDescrTypeBO* objects = [ArcosXMLParser doXMLParse:fileName deserializeTo:[[ArcosArrayOfDescrTypeBO alloc] autorelease]];
        
        for (ArcosDescrTypeBO* anObject in objects) {
            [[ArcosCoreData sharedArcosCoreData]loadDescriptionTypeWithSoapOB:anObject];
        }
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [self.updateDelegate activateProgressViewWithValue:progressValue animated:YES];
            self.isSubLoadingFinished = YES;
        });
    });
}

#pragma mark Image
- (void)importImageData {
    if (!self.isMainLoadingFinished) return;
    self.isMainLoadingFinished = NO;
    [self createDataWithSelectorName:[GlobalSharedClass shared].imageSelectorName];
    self.subTimer = [NSTimer scheduledTimerWithTimeInterval:self.halfTimeLength target:self selector:@selector(checkImageDataCenter) userInfo:nil repeats:YES];
    [self.updateDelegate startImportData:[GlobalSharedClass shared].imageSelectorName];
}

- (void)checkImageDataCenter {
    if (!self.isSubLoadingFinished) return;
    if ([self.subFileList count] <= 0) {
        [self.subTimer invalidate];
        self.subTimer = nil;
        [self.updateDelegate completeLoadingData:[GlobalSharedClass shared].imageSelectorName];
        [self updateTableProgressView];
        self.isMainLoadingFinished = YES;
    } else {
        [self processImageDataCenter];
    }
}

- (void)processImageDataCenter {
    if (!self.isSubLoadingFinished) return;
    self.isSubLoadingFinished = NO;
    NSString* fileName = [[[self.subFileList lastObject] retain] autorelease];
    float progressValue = [[self.subIndexList lastObject] floatValue] / self.subFileCount;
    [self.subIndexList removeLastObject];
    [self.subFileList removeLastObject];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ArcosGenericObjectWithImage* xmlResult = [ArcosXMLParser doXMLParse:fileName deserializeTo:[[ArcosGenericObjectWithImage alloc] autorelease]];
        
        if (xmlResult.ErrorModel.Code >= 0) {
            ArcosArrayOfGenericReturnObjectWithImage* objects = (ArcosArrayOfGenericReturnObjectWithImage*)xmlResult.ArrayOfData;
            for (ArcosGenericReturnObjectWithImage* anObject in objects) {//load objects
                [[ArcosCoreData sharedArcosCoreData]loadImageWithSoapOB:anObject];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [self.updateDelegate activateProgressViewWithValue:progressValue animated:YES];
            self.isSubLoadingFinished = YES;
        });
    });
}

#pragma mark Employee
- (void)importEmployeeData {
    if (!self.isMainLoadingFinished) return;
    self.isMainLoadingFinished = NO;
    [self createDataWithSelectorName:[GlobalSharedClass shared].employeeSelectorName];
    self.subTimer = [NSTimer scheduledTimerWithTimeInterval:self.timeLength target:self selector:@selector(checkEmployeeDataCenter) userInfo:nil repeats:YES];
    [self.updateDelegate startImportData:[GlobalSharedClass shared].employeeSelectorName];
}

- (void)checkEmployeeDataCenter {
    if (!self.isSubLoadingFinished) return;
    if ([self.subFileList count] <= 0) {
        [self.subTimer invalidate];
        self.subTimer = nil;
        [self.updateDelegate completeLoadingData:[GlobalSharedClass shared].employeeSelectorName];
        [self updateTableProgressView];
        self.isMainLoadingFinished = YES;
    } else {
        [self processEmployeeDataCenter];
    }
}

- (void)processEmployeeDataCenter {
    if (!self.isSubLoadingFinished) return;
    self.isSubLoadingFinished = NO;
    NSString* fileName = [[[self.subFileList lastObject] retain] autorelease];
    float progressValue = [[self.subIndexList lastObject] floatValue] / self.subFileCount;
    [self.subIndexList removeLastObject];
    [self.subFileList removeLastObject];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ArcosArrayOfEmployeeBO* objects = [ArcosXMLParser doXMLParse:fileName deserializeTo:[[ArcosArrayOfEmployeeBO alloc] autorelease]];
        
        for (ArcosEmployeeBO* anObject in objects) {
            [[ArcosCoreData sharedArcosCoreData]loadEmployeeWithSoapOB:anObject];
        }
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [self.updateDelegate activateProgressViewWithValue:progressValue animated:YES];
            self.isSubLoadingFinished = YES;
        });
    });
}

#pragma mark FormDetail
- (void)importFormDetailData {
    if (!self.isMainLoadingFinished) return;
    self.isMainLoadingFinished = NO;
    [self createDataWithSelectorName:[GlobalSharedClass shared].formDetailSelectorName];
    self.subTimer = [NSTimer scheduledTimerWithTimeInterval:self.timeLength target:self selector:@selector(checkFormDetailDataCenter) userInfo:nil repeats:YES];
    [self.updateDelegate startImportData:[GlobalSharedClass shared].formDetailSelectorName];
}

- (void)checkFormDetailDataCenter {
    if (!self.isSubLoadingFinished) return;
    if ([self.subFileList count] <= 0) {
        [self.subTimer invalidate];
        self.subTimer = nil;
        [self.updateDelegate completeLoadingData:[GlobalSharedClass shared].formDetailSelectorName];
        [self updateTableProgressView];
        self.isMainLoadingFinished = YES;
    } else {
        [self processFormDetailDataCenter];
    }
}

- (void)processFormDetailDataCenter {
    if (!self.isSubLoadingFinished) return;
    self.isSubLoadingFinished = NO;
    NSString* fileName = [[[self.subFileList lastObject] retain] autorelease];
    float progressValue = [[self.subIndexList lastObject] floatValue] / self.subFileCount;
    [self.subIndexList removeLastObject];
    [self.subFileList removeLastObject];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ArcosArrayOfFormDetailBO* objects = [ArcosXMLParser doXMLParse:fileName deserializeTo:[[ArcosArrayOfFormDetailBO alloc] autorelease]];
        
        for (ArcosFormDetailBO* anObject in objects) {
            [[ArcosCoreData sharedArcosCoreData]loadFormDetailsWithSoapOB:anObject];
        }
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [self.updateDelegate activateProgressViewWithValue:progressValue animated:YES];
            self.isSubLoadingFinished = YES;
        });
    });
}

#pragma mark FormRow
- (void)importFormRowData {
    if (!self.isMainLoadingFinished) return;
    self.isMainLoadingFinished = NO;
    [self createDataWithSelectorName:[GlobalSharedClass shared].formRowSelectorName];
    self.subTimer = [NSTimer scheduledTimerWithTimeInterval:self.timeLength target:self selector:@selector(checkFormRowDataCenter) userInfo:nil repeats:YES];
    [self.updateDelegate startImportData:[GlobalSharedClass shared].formRowSelectorName];
}

- (void)checkFormRowDataCenter {
    if (!self.isSubLoadingFinished) return;
    if ([self.subFileList count] <= 0) {
        [self.subTimer invalidate];
        self.subTimer = nil;
        [self.updateDelegate completeLoadingData:[GlobalSharedClass shared].formRowSelectorName];
        [self updateTableProgressView];
        self.isMainLoadingFinished = YES;
    } else {
        [self processFormRowDataCenter];
    }
}

- (void)processFormRowDataCenter {
    if (!self.isSubLoadingFinished) return;
    self.isSubLoadingFinished = NO;
    NSString* fileName = [[[self.subFileList lastObject] retain] autorelease];
    float progressValue = [[self.subIndexList lastObject] floatValue] / self.subFileCount;
    [self.subIndexList removeLastObject];
    [self.subFileList removeLastObject];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ArcosGenericObjectWithImage* xmlResult = [ArcosXMLParser doXMLParse:fileName deserializeTo:[[ArcosGenericObjectWithImage alloc] autorelease]];
        
        if (xmlResult.ErrorModel.Code >= 0) {
            ArcosArrayOfGenericReturnObjectWithImage* objects = (ArcosArrayOfGenericReturnObjectWithImage*)xmlResult.ArrayOfData;
            for (ArcosGenericReturnObjectWithImage* anObject in objects) {//load objects
                [[ArcosCoreData sharedArcosCoreData]loadFormRowWithSoapOB:anObject];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [self.updateDelegate activateProgressViewWithValue:progressValue animated:YES];
            self.isSubLoadingFinished = YES;
        });
    });
}

#pragma mark Contact
- (void)importContactData {
    if (!self.isMainLoadingFinished) return;
    self.isMainLoadingFinished = NO;
    [self createDataWithSelectorName:[GlobalSharedClass shared].contactSelectorName];
    self.subTimer = [NSTimer scheduledTimerWithTimeInterval:self.timeLength target:self selector:@selector(checkContactDataCenter) userInfo:nil repeats:YES];
    [self.updateDelegate startImportData:[GlobalSharedClass shared].contactSelectorName];
}

- (void)checkContactDataCenter {
    if (!self.isSubLoadingFinished) return;
    if ([self.subFileList count] <= 0) {
        [self.subTimer invalidate];
        self.subTimer = nil;
        [self.updateDelegate completeLoadingData:[GlobalSharedClass shared].contactSelectorName];
        [self updateTableProgressView];
        self.isMainLoadingFinished = YES;
    } else {
        [self processContactDataCenter];
    }
}

- (void)processContactDataCenter {
    if (!self.isSubLoadingFinished) return;
    self.isSubLoadingFinished = NO;
    NSString* fileName = [[[self.subFileList lastObject] retain] autorelease];
    float progressValue = [[self.subIndexList lastObject] floatValue] / self.subFileCount;
    [self.subIndexList removeLastObject];
    [self.subFileList removeLastObject];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ArcosGenericObjectWithImage* xmlResult = [ArcosXMLParser doXMLParse:fileName deserializeTo:[[ArcosGenericObjectWithImage alloc] autorelease]];
        
        if (xmlResult.ErrorModel.Code >= 0) {
            ArcosArrayOfGenericReturnObjectWithImage* objects = (ArcosArrayOfGenericReturnObjectWithImage*)xmlResult.ArrayOfData;
            for (ArcosGenericReturnObjectWithImage* anObject in objects) {//load objects
                [[ArcosCoreData sharedArcosCoreData]loadContactWithSoapOB:anObject];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [self.updateDelegate activateProgressViewWithValue:progressValue animated:YES];
            self.isSubLoadingFinished = YES;
        });
    });
}

#pragma mark ConLocLink
- (void)importConLocLinkData {
    if (!self.isMainLoadingFinished) return;
    self.isMainLoadingFinished = NO;
    [self createDataWithSelectorName:[GlobalSharedClass shared].conLocLinkSelectorName];
    self.subTimer = [NSTimer scheduledTimerWithTimeInterval:self.timeLength target:self selector:@selector(checkConLocLinkDataCenter) userInfo:nil repeats:YES];
    [self.updateDelegate startImportData:[GlobalSharedClass shared].conLocLinkSelectorName];
}

- (void)checkConLocLinkDataCenter {
    if (!self.isSubLoadingFinished) return;
    if ([self.subFileList count] <= 0) {
        [self.subTimer invalidate];
        self.subTimer = nil;
        [self.updateDelegate completeLoadingData:[GlobalSharedClass shared].conLocLinkSelectorName];
        [self updateTableProgressView];
        self.isMainLoadingFinished = YES;
    } else {
        [self processConLocLinkDataCenter];
    }
}

- (void)processConLocLinkDataCenter {
    if (!self.isSubLoadingFinished) return;
    self.isSubLoadingFinished = NO;
    NSString* fileName = [[[self.subFileList lastObject] retain] autorelease];
    float progressValue = [[self.subIndexList lastObject] floatValue] / self.subFileCount;
    [self.subIndexList removeLastObject];
    [self.subFileList removeLastObject];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ArcosGenericObjectWithImage* xmlResult = [ArcosXMLParser doXMLParse:fileName deserializeTo:[[ArcosGenericObjectWithImage alloc] autorelease]];
        
        if (xmlResult.ErrorModel.Code >= 0) {
            ArcosArrayOfGenericReturnObjectWithImage* objects = (ArcosArrayOfGenericReturnObjectWithImage*)xmlResult.ArrayOfData;
            for (ArcosGenericReturnObjectWithImage* anObject in objects) {//load objects
                [[ArcosCoreData sharedArcosCoreData]loadConLocLinkWithSoapOB:anObject];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [self.updateDelegate activateProgressViewWithValue:progressValue animated:YES];
            self.isSubLoadingFinished = YES;
        });
    });
}

#pragma mark Presenter
- (void)importPresenterData {
    if (!self.isMainLoadingFinished) return;
    self.isMainLoadingFinished = NO;
    [self createDataWithSelectorName:[GlobalSharedClass shared].presenterSelectorName];
    self.subTimer = [NSTimer scheduledTimerWithTimeInterval:self.timeLength target:self selector:@selector(checkPresenterDataCenter) userInfo:nil repeats:YES];
    [self.updateDelegate startImportData:[GlobalSharedClass shared].presenterSelectorName];
}

- (void)checkPresenterDataCenter {
    if (!self.isSubLoadingFinished) return;
    if ([self.subFileList count] <= 0) {
        [self.subTimer invalidate];
        self.subTimer = nil;
        [self.updateDelegate completeLoadingData:[GlobalSharedClass shared].presenterSelectorName];
        [self updateTableProgressView];
        self.isMainLoadingFinished = YES;
    } else {
        [self processPresenterDataCenter];
    }
}

- (void)processPresenterDataCenter {
    if (!self.isSubLoadingFinished) return;
    self.isSubLoadingFinished = NO;
    NSString* fileName = [[[self.subFileList lastObject] retain] autorelease];
    float progressValue = [[self.subIndexList lastObject] floatValue] / self.subFileCount;
    [self.subIndexList removeLastObject];
    [self.subFileList removeLastObject];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ArcosArrayOfPresenter* objects = [ArcosXMLParser doXMLParse:fileName deserializeTo:[[ArcosArrayOfPresenter alloc] autorelease]];
        
        for (ArcosPresenter* anObject in objects) {
            [[ArcosCoreData sharedArcosCoreData]loadPresenterWithSoapOB:anObject];
        }
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [self.updateDelegate activateProgressViewWithValue:progressValue animated:YES];
            self.isSubLoadingFinished = YES;
        });
    });
}

#pragma mark Product
- (void)importProductData {
    if (!self.isMainLoadingFinished) return;
    self.isMainLoadingFinished = NO;
    [self createDataWithSelectorName:[GlobalSharedClass shared].productSelectorName];
    self.subTimer = [NSTimer scheduledTimerWithTimeInterval:self.timeLength target:self selector:@selector(checkProductDataCenter) userInfo:nil repeats:YES];
    [self.updateDelegate startImportData:[GlobalSharedClass shared].productSelectorName];
}

- (void)checkProductDataCenter {
    if (!self.isSubLoadingFinished) return;
    if ([self.subFileList count] <= 0) {
        [self.subTimer invalidate];
        self.subTimer = nil;
        [self.updateDelegate completeLoadingData:[GlobalSharedClass shared].productSelectorName];
        [self updateTableProgressView];
        self.isMainLoadingFinished = YES;
    } else {
        [self processProductDataCenter];
    }
}

- (void)processProductDataCenter {
    if (!self.isSubLoadingFinished) return;
    self.isSubLoadingFinished = NO;
    NSString* fileName = [[[self.subFileList lastObject] retain] autorelease];
    float progressValue = [[self.subIndexList lastObject] floatValue] / self.subFileCount;
    [self.subIndexList removeLastObject];
    [self.subFileList removeLastObject];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ArcosGenericObjectWithImage* xmlResult = [ArcosXMLParser doXMLParse:fileName deserializeTo:[[ArcosGenericObjectWithImage alloc] autorelease]];
        
        if (xmlResult.ErrorModel.Code >= 0) {
            ArcosArrayOfGenericReturnObjectWithImage* objects = (ArcosArrayOfGenericReturnObjectWithImage*)xmlResult.ArrayOfData;
            for (ArcosGenericReturnObjectWithImage* anObject in objects) {//load objects
                [[ArcosCoreData sharedArcosCoreData]LoadProductWithSoapOB:anObject];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [self.updateDelegate activateProgressViewWithValue:progressValue animated:YES];
            self.isSubLoadingFinished = YES;
        });
    });
}

#pragma mark Journey
- (void)importJourneyData {
    if (!self.isMainLoadingFinished) return;
    self.isMainLoadingFinished = NO;
    [self createDataWithSelectorName:[GlobalSharedClass shared].journeySelectorName];
    self.subTimer = [NSTimer scheduledTimerWithTimeInterval:self.timeLength target:self selector:@selector(checkJourneyDataCenter) userInfo:nil repeats:YES];
    [self.updateDelegate startImportData:[GlobalSharedClass shared].journeySelectorName];
}

- (void)checkJourneyDataCenter {
    if (!self.isSubLoadingFinished) return;
    if ([self.subFileList count] <= 0) {
        [self.subTimer invalidate];
        self.subTimer = nil;
        [self.updateDelegate completeLoadingData:[GlobalSharedClass shared].journeySelectorName];
        [self updateTableProgressView];
        self.isMainLoadingFinished = YES;
    } else {
        [self processJourneyDataCenter];
    }
}

- (void)processJourneyDataCenter {
    if (!self.isSubLoadingFinished) return;
    self.isSubLoadingFinished = NO;
    NSString* fileName = [[[self.subFileList lastObject] retain] autorelease];
    float progressValue = [[self.subIndexList lastObject] floatValue] / self.subFileCount;
    [self.subIndexList removeLastObject];
    [self.subFileList removeLastObject];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ArcosArrayOfJourneyBO* arcosArrayOfJourneyBO = [ArcosXMLParser doXMLParse:fileName deserializeTo:[[ArcosArrayOfJourneyBO alloc] autorelease]];
        
        for (ArcosJourneyBO* arcosJourneyBO in arcosArrayOfJourneyBO) {
            [[ArcosCoreData sharedArcosCoreData] loadJourneyWithSoapOB:arcosJourneyBO];
        }
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [self.updateDelegate activateProgressViewWithValue:progressValue animated:YES];
            self.isSubLoadingFinished = YES;
        });
    });
}

#pragma mark Order
- (void)importOrderData {
    if (!self.isMainLoadingFinished) return;
    self.isMainLoadingFinished = NO;
    [self createDataWithSelectorName:[GlobalSharedClass shared].orderHeaderSelectorName];
    self.subTimer = [NSTimer scheduledTimerWithTimeInterval:self.timeLength target:self selector:@selector(checkOrderDataCenter) userInfo:nil repeats:YES];
    [self.updateDelegate startImportData:[GlobalSharedClass shared].orderHeaderSelectorName];
}

- (void)checkOrderDataCenter {
    if (!self.isSubLoadingFinished) return;
    if ([self.subFileList count] <= 0) {
        [self.subTimer invalidate];
        self.subTimer = nil;
        [self.updateDelegate completeLoadingData:[GlobalSharedClass shared].orderHeaderSelectorName];
        [self updateTableProgressView];
        self.isMainLoadingFinished = YES;
    } else {
        [self processOrderDataCenter];
    }
}

- (void)processOrderDataCenter {
    if (!self.isSubLoadingFinished) return;
    self.isSubLoadingFinished = NO;
    NSString* fileName = [[[self.subFileList lastObject] retain] autorelease];
    float progressValue = [[self.subIndexList lastObject] floatValue] / self.subFileCount;
    [self.subIndexList removeLastObject];
    [self.subFileList removeLastObject];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ArcosArrayOfOrderHeaderBO* objects = [ArcosXMLParser doXMLParse:fileName deserializeTo:[[ArcosArrayOfOrderHeaderBO alloc] autorelease]];
        
        for (ArcosOrderHeaderBO* anObject in objects) {
            [[ArcosCoreData sharedArcosCoreData]loadOrderWithSoapOB:anObject];
        }
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [self.updateDelegate activateProgressViewWithValue:progressValue animated:YES];
            self.isSubLoadingFinished = YES;
        });
    });
}

#pragma mark Call
- (void)importCallData {
    if (!self.isMainLoadingFinished) return;
    self.isMainLoadingFinished = NO;
    [self createDataWithSelectorName:[GlobalSharedClass shared].callOrderHeaderSelectorName];
    self.subTimer = [NSTimer scheduledTimerWithTimeInterval:self.timeLength target:self selector:@selector(checkCallDataCenter) userInfo:nil repeats:YES];
    [self.updateDelegate startImportData:[GlobalSharedClass shared].callOrderHeaderSelectorName];
}

- (void)checkCallDataCenter {
    if (!self.isSubLoadingFinished) return;
    if ([self.subFileList count] <= 0) {
        [self.subTimer invalidate];
        self.subTimer = nil;
        [self.updateDelegate completeLoadingData:[GlobalSharedClass shared].callOrderHeaderSelectorName];
        [self updateTableProgressView];
        self.isMainLoadingFinished = YES;
    } else {
        [self processCallDataCenter];
    }
}

- (void)processCallDataCenter {
    if (!self.isSubLoadingFinished) return;
    self.isSubLoadingFinished = NO;
    NSString* fileName = [[[self.subFileList lastObject] retain] autorelease];
    float progressValue = [[self.subIndexList lastObject] floatValue] / self.subFileCount;
    [self.subIndexList removeLastObject];
    [self.subFileList removeLastObject];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ArcosArrayOfCallBO* objects = [ArcosXMLParser doXMLParse:fileName deserializeTo:[[ArcosArrayOfCallBO alloc] autorelease]];
        
        for (ArcosCallBO* anObject in objects) {
            [[ArcosCoreData sharedArcosCoreData]loadCallWithSoapOB:anObject];
        }
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [self.updateDelegate activateProgressViewWithValue:progressValue animated:YES];
            self.isSubLoadingFinished = YES;
        });
    });
}

#pragma mark Resource
- (void)importResourceData {
    if (!self.isMainLoadingFinished) return;
    self.isMainLoadingFinished = NO;
    [self createDataWithSelectorName:[GlobalSharedClass shared].resourcesSelectorName];
    self.subTimer = [NSTimer scheduledTimerWithTimeInterval:self.timeLength target:self selector:@selector(checkResourceDataCenter) userInfo:nil repeats:YES];
    [FileCommon createFolder:@"presenter"];
    [self.updateDelegate startImportData:[GlobalSharedClass shared].resourcesSelectorName];
    NSMutableArray* objectList = [[ArcosCoreData sharedArcosCoreData] presenterProducts];
    self.presenterFileList = [NSMutableArray arrayWithCapacity:[objectList count]];
    for (int i = 0; i < [objectList count]; i++) {
        NSString* fileName = [[objectList objectAtIndex:i] objectForKey:@"Name"];
        if (fileName != nil && ![@"" isEqualToString:fileName]) {
            [self.presenterFileList addObject:[NSString stringWithFormat:@"%@", fileName]];
        }
    }
}

- (void)checkResourceDataCenter {
    if (!self.isSubLoadingFinished) return;
    if ([self.subFileList count] <= 0) {
        [self.subTimer invalidate];
        self.subTimer = nil;
        [self.updateDelegate completeLoadingData:[GlobalSharedClass shared].resourcesSelectorName];
        [self updateTableProgressView];
        self.isMainLoadingFinished = YES;
    } else {
        [self processResourceDataCenter];
    }
}

- (void)processResourceDataCenter {
    if (!self.isSubLoadingFinished) return;
    self.isSubLoadingFinished = NO;
    NSString* fileName = [[[self.subFileList lastObject] retain] autorelease];
    float progressValue = [[self.subIndexList lastObject] floatValue] / self.subFileCount;
    [self.subIndexList removeLastObject];
    [self.subFileList removeLastObject];
    NSString* presenterFileName = [[[self.presenterFileList lastObject] retain] autorelease];

    [self.presenterFileList removeLastObject];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString* result = [ArcosXMLParser doXMLParse:fileName deserializeTo:@"NSData"];
        NSData* myNSData = [[[NSData alloc] initWithBase64EncodedString:result options:0] autorelease];
        NSString* filePath = [NSString stringWithFormat:@"%@/%@", [FileCommon presenterPath], presenterFileName];
        [myNSData writeToFile:filePath atomically:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [self.updateDelegate activateProgressViewWithValue:progressValue animated:YES];
            self.isSubLoadingFinished = YES;
        });
    });
}

- (void)updateTableProgressView {
    NSUInteger currentSelectorLength = [self.selectorList count];
    NSUInteger resultLength = self.totalSelectorLength - currentSelectorLength;
    float result = resultLength * 1.0 / self.totalSelectorLength;
    [self.updateDelegate activateTableProgressViewWithValue:result animated:YES];
}

@end
