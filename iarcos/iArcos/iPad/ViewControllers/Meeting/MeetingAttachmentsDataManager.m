//
//  MeetingAttachmentsDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 15/03/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import "MeetingAttachmentsDataManager.h"

@implementation MeetingAttachmentsDataManager
@synthesize emptyTitle = _emptyTitle;
@synthesize attachmentsTitle = _attachmentsTitle;
@synthesize sectionTitleList = _sectionTitleList;
@synthesize groupedDataDict = _groupedDataDict;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.emptyTitle = @"";
        self.attachmentsTitle = @"Attachments";
        self.sectionTitleList = [NSMutableArray arrayWithObjects:self.emptyTitle, self.attachmentsTitle, nil];
    }
    return self;
}

- (void)dealloc {
    self.emptyTitle = nil;
    self.attachmentsTitle = nil;
    self.sectionTitleList = nil;
    self.groupedDataDict = nil;
    
    [super dealloc];
}

- (void)createBasicDataWithReturnObject:(ArcosMeetingWithDetailsDownload*)anArcosMeetingWithDetailsDownload {
    self.groupedDataDict = [NSMutableDictionary dictionaryWithCapacity:2];
    NSMutableArray* emptyDisplayList = [NSMutableArray arrayWithCapacity:0];
    [self.groupedDataDict setObject:emptyDisplayList forKey:self.emptyTitle];
    NSMutableArray* attachmentsDisplayList = [NSMutableArray array];
    [self.groupedDataDict setObject:attachmentsDisplayList forKey:self.attachmentsTitle];
    if (anArcosMeetingWithDetailsDownload == nil) return;
    if ([anArcosMeetingWithDetailsDownload.LinkedAttachments count] == 0) return;
    for (int i = 0; i < [anArcosMeetingWithDetailsDownload.LinkedAttachments count]; i++) {
        ArcosAttachmentSummary* auxArcosAttachmentSummary = [anArcosMeetingWithDetailsDownload.LinkedAttachments objectAtIndex:i];
        [attachmentsDisplayList addObject:auxArcosAttachmentSummary];
    }
}


@end
