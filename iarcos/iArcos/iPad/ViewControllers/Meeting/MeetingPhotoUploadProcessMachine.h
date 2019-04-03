//
//  MeetingPhotoUploadProcessMachine.h
//  iArcos
//
//  Created by David Kilmartin on 29/03/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MeetingPhotoUploadProcessMachineDelegate.h"
#import "ArcosAttachmentSummary.h"

@interface MeetingPhotoUploadProcessMachine : NSObject {
    id<MeetingPhotoUploadProcessMachineDelegate> _uploadDelegate;
    BOOL _isBusy;
    NSTimer* _fileTimer;
    id _target;
    SEL _action;
    SEL _loadingAction;
    NSMutableArray* _arcosAttachmentList;
    ArcosAttachmentSummary* _currentArcosAttachmentSummary;
}

@property(nonatomic, assign) id<MeetingPhotoUploadProcessMachineDelegate> uploadDelegate;
@property(nonatomic, assign) BOOL isBusy;
@property(nonatomic, retain) NSTimer* fileTimer;
@property(nonatomic, assign) id target;
@property(nonatomic, assign) SEL action;
@property(nonatomic, assign) SEL loadingAction;
@property(nonatomic, retain) NSMutableArray* arcosAttachmentList;
@property(nonatomic, retain) ArcosAttachmentSummary* currentArcosAttachmentSummary;

- (instancetype)initWithTarget:(id)aTarget action:(SEL)anAction loadingAction:(SEL)aLoadingAction dataDictList:(NSMutableArray*)aDataDictList;
- (void)runTask;
- (void)stopTask;

@end

