//
//  MeetingAttachmentsDataManager.h
//  iArcos
//
//  Created by David Kilmartin on 15/03/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosMeetingWithDetailsDownload.h"
#import "MeetingBaseDataManager.h"
#import "ArcosAttachmentSummary.h"
#import "ArcosCoreData.h"

@interface MeetingAttachmentsDataManager : MeetingBaseDataManager {
    NSString* _emptyTitle;
    NSString* _attachmentsTitle;
    NSMutableArray* _sectionTitleList;
    NSMutableDictionary* _groupedDataDict;
    NSString* _currentFileName;
    NSIndexPath* _currentSelectedDeleteIndexPath;
}

@property(nonatomic, retain) NSString* emptyTitle;
@property(nonatomic, retain) NSString* attachmentsTitle;
@property(nonatomic, retain) NSMutableArray* sectionTitleList;
@property(nonatomic, retain) NSMutableDictionary* groupedDataDict;
@property(nonatomic, retain) NSString* currentFileName;
@property(nonatomic, retain) NSIndexPath* currentSelectedDeleteIndexPath;

- (ArcosAttachmentSummary*)cellDataWithIndexPath:(NSIndexPath*)anIndexPath;
- (NSMutableArray*)retrieveBrandNewAttachmentList;
- (NSString*)retrieveEmployeeName;

@end

