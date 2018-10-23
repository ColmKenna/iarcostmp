//
//  UploadWebServiceProcessor.h
//  iArcos
//
//  Created by David Kilmartin on 07/04/2016.
//  Copyright (c) 2016 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosService.h"
#import "ArcosUtils.h"
#import "UploadWebServiceProcessorDelegate.h"
#import "PhotoTransferProcessMachine.h"
@class UtilitiesUpdateDetailViewController;
#import "PhotoFileInfoProvider.h"
#import "UploadWebServiceDataManager.h"
#import "ArcosConfigDataManager.h"

@interface UploadWebServiceProcessor : NSObject <PhotoTransferProcessMachineDelegate> {
    id<UploadWebServiceProcessorDelegate> _myDelegate;
    ArcosService* _arcosService;
    BOOL _isUploadingFinished;
    BOOL _isPaginatedUploadingFinished;
    PhotoTransferProcessMachine* _photoTransferProcessMachine;
    UtilitiesUpdateDetailViewController* _utilitiesUpdateDetailViewController;
    NSString* _sectionTitle;
    PhotoFileInfoProvider* _photoFileInfoProvider;
    UploadWebServiceDataManager* _uploadWebServiceDataManager;
}

@property(nonatomic, assign) id<UploadWebServiceProcessorDelegate> myDelegate;
@property(nonatomic, retain) ArcosService* arcosService;
@property(nonatomic, assign) BOOL isUploadingFinished;
@property(nonatomic, assign) BOOL isPaginatedUploadingFinished;
@property(nonatomic, retain) PhotoTransferProcessMachine* photoTransferProcessMachine;
@property(nonatomic, assign) UtilitiesUpdateDetailViewController* utilitiesUpdateDetailViewController;
@property(nonatomic, retain) NSString* sectionTitle;
@property(nonatomic, retain) PhotoFileInfoProvider* photoFileInfoProvider;
@property(nonatomic, retain) UploadWebServiceDataManager* uploadWebServiceDataManager;

- (void)uploadPhoto;
- (BOOL)paginatedUploadingActionFlag;
- (void)paginatedUploadPhoto:(NSDictionary*)aCollectedDict;
- (void)uploadPartialPhoto;

@end
