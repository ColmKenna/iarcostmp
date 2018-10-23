//
//  UploadWebServiceProcessor.m
//  iArcos
//
//  Created by David Kilmartin on 07/04/2016.
//  Copyright (c) 2016 Strata IT Limited. All rights reserved.
//

#import "UploadWebServiceProcessor.h"
#import "UtilitiesUpdateDetailViewController.h"
#import "CompositeErrorResult.h"
@interface UploadWebServiceProcessor()
- (void)createPhotoTransferProcessMachineInstance:(NSMutableArray*)aCollectedDataDictList;
- (void)checkUploadFileExistsWithList;
- (CompositeErrorResult*)handleResultErrorProcess:(id)result;
@end

@implementation UploadWebServiceProcessor
@synthesize myDelegate = _myDelegate;
@synthesize arcosService = _arcosService;
@synthesize isUploadingFinished = _isUploadingFinished;
@synthesize isPaginatedUploadingFinished = _isPaginatedUploadingFinished;
@synthesize photoTransferProcessMachine = _photoTransferProcessMachine;
@synthesize utilitiesUpdateDetailViewController = _utilitiesUpdateDetailViewController;
@synthesize sectionTitle = _sectionTitle;
@synthesize photoFileInfoProvider = _photoFileInfoProvider;
@synthesize uploadWebServiceDataManager = _uploadWebServiceDataManager;

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.arcosService = [ArcosService service];
        self.isUploadingFinished = YES;
        self.isPaginatedUploadingFinished = YES;
        self.photoFileInfoProvider = [[[PhotoFileInfoProvider alloc] init] autorelease];
    }
    return self;
}

- (void)dealloc {
    self.arcosService = nil;
    self.photoTransferProcessMachine = nil;
    self.sectionTitle = nil;
    self.utilitiesUpdateDetailViewController = nil;
    self.photoFileInfoProvider = nil;
    self.uploadWebServiceDataManager = nil;
    
    [super dealloc];
}

- (void)uploadPhoto {
    if (self.isUploadingFinished) {
        self.isUploadingFinished = NO;
        [self.myDelegate uploadProcessStarted];
        self.uploadWebServiceDataManager = [[[UploadWebServiceDataManager alloc] init] autorelease];
        NSMutableDictionary* recordDataDict = [self.utilitiesUpdateDetailViewController.utilitiesUpdateDetailDataManager retrieveDataDictWithSelectorName:[GlobalSharedClass shared].collectedSelectorName sectionTitle:self.sectionTitle];
        NSNumber* downloadMode = [recordDataDict objectForKey:@"DownloadMode"];
        NSMutableArray* dataDictList = [NSMutableArray array];
        if ([downloadMode intValue] == 0) {//full
            dataDictList = [self.photoFileInfoProvider retrieveFullPhotoInfo];
        }
        if ([downloadMode intValue] == 1) {//partial
            dataDictList = [self.photoFileInfoProvider retrievePartialPhotoInfo];
        }
        self.uploadWebServiceDataManager.collectedDataDictList = dataDictList;
        if ([self.uploadWebServiceDataManager.collectedDataDictList count] == 0) {
            self.isUploadingFinished = YES;
            return;
        }
        [self checkUploadFileExistsWithList];
    }
}

- (void)uploadPartialPhoto {
    if (self.isUploadingFinished) {
        self.isUploadingFinished = NO;
        [self.myDelegate uploadProcessStarted];
        self.uploadWebServiceDataManager = [[[UploadWebServiceDataManager alloc] init] autorelease];
        
        NSMutableArray* dataDictList = [self.photoFileInfoProvider retrievePartialPhotoInfo];
        self.uploadWebServiceDataManager.collectedDataDictList = dataDictList;
        if ([self.uploadWebServiceDataManager.collectedDataDictList count] == 0) {
            self.isUploadingFinished = YES;
            return;
        }
        [self checkUploadFileExistsWithList];
    }
}

- (void)createPhotoTransferProcessMachineInstance:(NSMutableArray*)aCollectedDataDictList {
    self.photoTransferProcessMachine = [[[PhotoTransferProcessMachine alloc] initWithTarget:self action:@selector(paginatedUploadPhoto:) loadingAction:@selector(paginatedUploadingActionFlag) dataDictList:aCollectedDataDictList] autorelease];
    self.photoTransferProcessMachine.transferDelegate = self;
    [self.photoTransferProcessMachine runTask];
}

- (void)checkUploadFileExistsWithList {
    if (self.uploadWebServiceDataManager.collectedRowPointer == [self.uploadWebServiceDataManager.collectedDataDictList count]) {
        if ([self.uploadWebServiceDataManager.filteredCollectedDataDictList count] == 0) {
            self.isUploadingFinished = YES;
            return;
        }
        [self createPhotoTransferProcessMachineInstance:self.uploadWebServiceDataManager.filteredCollectedDataDictList];
        return;
    }
    NSDictionary* myCollectedDataDict = [self.uploadWebServiceDataManager.collectedDataDictList objectAtIndex:self.uploadWebServiceDataManager.collectedRowPointer];
    [self.arcosService CheckUploadFileExists:self action:@selector(backFromCheckUploadFileExists:) _fileName:[myCollectedDataDict objectForKey:@"Comments"]];
}

- (void)backFromCheckUploadFileExists:(id)result {
    CompositeErrorResult* tmpCompositeErrorResult = [self handleResultErrorProcess:result];
    if (!tmpCompositeErrorResult.successFlag) {
        [self.myDelegate uploadProcessWithErrorMsg:tmpCompositeErrorResult.errorMsg];
    } else {
        if (![result boolValue]) {
            [self.uploadWebServiceDataManager.filteredCollectedDataDictList addObject:[self.uploadWebServiceDataManager.collectedDataDictList objectAtIndex:self.uploadWebServiceDataManager.collectedRowPointer]];
        }
        self.uploadWebServiceDataManager.collectedRowPointer++;
        [self checkUploadFileExistsWithList];
    }
}

- (void)paginatedUploadPhoto:(NSDictionary*)aCollectedDict {
    if (self.isPaginatedUploadingFinished) {
        self.isPaginatedUploadingFinished = NO;
        NSString* fileName = [aCollectedDict objectForKey:@"Comments"];
        NSString* filePath = [NSString stringWithFormat:@"%@/%@", [FileCommon photosPath], fileName];
        NSData* myData = nil;
        if ([[ArcosConfigDataManager sharedArcosConfigDataManager] enableSendOriginalPhotoFlag]) {
            myData = [NSData dataWithContentsOfFile:filePath];
        } else {
            UIImage* myImage = [UIImage imageWithContentsOfFile:filePath];
            CGSize newSize = CGSizeMake(1280.0f, 960.0f);
            UIGraphicsBeginImageContext(newSize);
            [myImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
            UIImage* compressedImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            myData = UIImageJPEGRepresentation(compressedImage, 0.85);
        }
        
        NSNumber* iUR = [aCollectedDict objectForKey:@"IUR"];
        NSString* tableName = @"Location";
        if ([iUR intValue] == -1) {
            tableName = @"GDPR";
        } else if ([iUR intValue] > 0) {
            tableName = @"Question";
        }
        [self.arcosService UploadFileNew:self action:@selector(backFromPaginatedUploadPhotoService:) contents:myData _fileName:fileName _description:[NSString stringWithFormat:@"Taken on %@'s iPad", [self.photoTransferProcessMachine retrieveEmployeeName]] tableIUR:[ArcosUtils convertNumberToIntString:iUR] tableName:tableName employeeiur:[[SettingManager employeeIUR] intValue] Locationiur:[[aCollectedDict objectForKey:@"LocationIUR"] intValue] DateAttached:[aCollectedDict objectForKey:@"DateCollected"]];
    }
}

- (BOOL)paginatedUploadingActionFlag {
    return self.isPaginatedUploadingFinished;
}

- (void)backFromPaginatedUploadPhotoService:(id)result {
    CompositeErrorResult* tmpCompositeErrorResult = [self handleResultErrorProcess:result];
    if (!tmpCompositeErrorResult.successFlag) {
        [self.photoTransferProcessMachine stopTask];
        [self.myDelegate uploadProcessWithErrorMsg:tmpCompositeErrorResult.errorMsg];
    } else {
        int myResult = [ArcosUtils convertNSIntegerToInt:[result integerValue]];
        self.photoTransferProcessMachine.successfulFileCount++;
        if ([[self.photoTransferProcessMachine.currentCollectedDict objectForKey:@"CallIUR"] intValue] == 0 && myResult > 0) {
            [self.photoTransferProcessMachine saveResultToCollectedTable:myResult];
        }
        [self.myDelegate uploadProgressViewWithValue:[self.photoTransferProcessMachine progressValue]];
    }
    self.isPaginatedUploadingFinished = YES;
}

#pragma mark PhotoTransferProcessMachineDelegate
- (void)photoTransferStartedWithText:(NSString*)aText {
    [self.myDelegate uploadProcessWithText:aText];
}

- (void)photoTransferCompleted:(int)anOverallFileCount {
    self.isUploadingFinished = YES;
    [self.myDelegate uploadProcessFinished:@"" sectionTitle:self.sectionTitle overallNumber:anOverallFileCount];
}

- (CompositeErrorResult*)handleResultErrorProcess:(id)result {
    CompositeErrorResult* myCompositeErrorResult = [[[CompositeErrorResult alloc] init] autorelease];
    if ([result isKindOfClass:[SoapFault class]]) {
        SoapFault* aSoapFault = (SoapFault*)result;
        myCompositeErrorResult.errorMsg = [aSoapFault faultString];
    } else if ([result isKindOfClass:[NSError class]]) {
        NSError* anError = (NSError*)result;
        myCompositeErrorResult.errorMsg = [anError localizedDescription];
    } else {
        myCompositeErrorResult.successFlag = YES;
    }
    return myCompositeErrorResult;
}

@end
