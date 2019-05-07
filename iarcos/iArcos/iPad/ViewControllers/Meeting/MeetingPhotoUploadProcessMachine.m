//
//  MeetingPhotoUploadProcessMachine.m
//  iArcos
//
//  Created by David Kilmartin on 29/03/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import "MeetingPhotoUploadProcessMachine.h"

@implementation MeetingPhotoUploadProcessMachine
@synthesize uploadDelegate = _uploadDelegate;
@synthesize isBusy = _isBusy;
@synthesize fileTimer = _fileTimer;
@synthesize target = _target;
@synthesize action = _action;
@synthesize loadingAction = _loadingAction;
@synthesize arcosAttachmentList = _arcosAttachmentList;
@synthesize currentArcosAttachmentSummary = _currentArcosAttachmentSummary;

- (instancetype)initWithTarget:(id)aTarget action:(SEL)anAction loadingAction:(SEL)aLoadingAction dataDictList:(NSMutableArray*)aDataDictList {
    self = [super init];
    if (self != nil) {
        self.target = aTarget;
        self.action = anAction;
        self.loadingAction = aLoadingAction;
        self.isBusy = NO;
        self.arcosAttachmentList = aDataDictList;
    }
    return self;
}

- (void)dealloc {
    self.arcosAttachmentList = nil;
    self.currentArcosAttachmentSummary = nil;
    
    [super dealloc];
}

- (void)runTask {
    if ([self.arcosAttachmentList count] <= 0 || self.isBusy) return;
    self.isBusy = YES;
    self.fileTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(checkFileStack) userInfo:nil repeats:YES];
}

- (void)checkFileStack {
    if (![self.target performSelector:self.loadingAction]) return;
    if ([self.arcosAttachmentList count] <= 0) {
        [self.fileTimer invalidate];
        self.fileTimer = nil;
        [self.uploadDelegate photoUploadCompleted];
        self.isBusy = NO;
    } else {
        ArcosAttachmentSummary* topArcosAttachmentSummary = [[[self.arcosAttachmentList lastObject] retain] autorelease];
        self.currentArcosAttachmentSummary = topArcosAttachmentSummary;
        [self.uploadDelegate photoUploadStartedWithText:[NSString stringWithFormat:@"Uploading %@", self.currentArcosAttachmentSummary.FileName]];
        [self.target performSelector:self.action withObject:self.currentArcosAttachmentSummary];
        [self.arcosAttachmentList removeLastObject];
    }
}

- (void)stopTask {
    [self.fileTimer invalidate];
    self.fileTimer = nil;
    self.isBusy = NO;
    [self.arcosAttachmentList removeAllObjects];
}



@end
