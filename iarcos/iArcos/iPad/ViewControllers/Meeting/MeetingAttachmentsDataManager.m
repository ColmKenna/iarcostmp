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
@synthesize currentFileName = _currentFileName;
@synthesize currentSelectedDeleteIndexPath = _currentSelectedDeleteIndexPath;

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
    self.currentFileName = nil;
    self.currentSelectedDeleteIndexPath = nil;
    
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

- (void)populateArcosMeetingWithDetails:(ArcosMeetingWithDetailsDownload*)anArcosMeetingWithDetailsDownload {
    for (int i = 0; i < [self.sectionTitleList count]; i++) {
        NSString* tmpSectionTitle = [self.sectionTitleList objectAtIndex:i];
        NSMutableArray* tmpDisplayList = [self.groupedDataDict objectForKey:tmpSectionTitle];
        for (int j = 0; j < [tmpDisplayList count]; j++) {
            ArcosAttachmentSummary* auxArcosAttachmentSummary = [tmpDisplayList objectAtIndex:j];
            if (auxArcosAttachmentSummary.PCiur == -999) {
                auxArcosAttachmentSummary.Description = @"DELETE";
            }
            [anArcosMeetingWithDetailsDownload.LinkedAttachments addObject:auxArcosAttachmentSummary];
        }
    }
}

- (ArcosAttachmentSummary*)cellDataWithIndexPath:(NSIndexPath*)anIndexPath {
    NSString* tmpSectionTitle = [self.sectionTitleList objectAtIndex:anIndexPath.section];
    NSMutableArray* tmpDisplayList = [self.groupedDataDict objectForKey:tmpSectionTitle];
    return [tmpDisplayList objectAtIndex:anIndexPath.row];
}

- (NSMutableArray*)retrieveBrandNewAttachmentList {
    NSMutableArray* resultDisplayList = [NSMutableArray array];
    NSMutableArray* tmpDisplayList = [self.groupedDataDict objectForKey:self.attachmentsTitle];
    for (int i = 0; i < [tmpDisplayList count]; i++) {
        ArcosAttachmentSummary* tmpArcosAttachmentSummary = [tmpDisplayList objectAtIndex:i];
        if (tmpArcosAttachmentSummary.IUR == 0) {
            [resultDisplayList addObject:tmpArcosAttachmentSummary];
        }        
    }
    return resultDisplayList;
}

- (NSString*)retrieveEmployeeName {
    NSDictionary* employeeDict = [[ArcosCoreData sharedArcosCoreData] employeeWithIUR:[SettingManager employeeIUR]];
    return [NSString stringWithFormat:@"%@ %@", [ArcosUtils convertNilToEmpty:[employeeDict objectForKey:@"ForeName"]], [ArcosUtils convertNilToEmpty:[employeeDict objectForKey:@"Surname"]]];
}

@end
