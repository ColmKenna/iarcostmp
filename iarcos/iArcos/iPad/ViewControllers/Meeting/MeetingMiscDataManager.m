//
//  MeetingMiscDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 06/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "MeetingMiscDataManager.h"

@implementation MeetingMiscDataManager
@synthesize auditorSectionTitle = _auditorSectionTitle;
@synthesize detailingSectionTitle = _detailingSectionTitle;
@synthesize speakerSectionTitle = _speakerSectionTitle;
@synthesize sectionTitleList = _sectionTitleList;
@synthesize groupedDataDict = _groupedDataDict;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.auditorSectionTitle = @"Auditor";
        self.detailingSectionTitle = @"Detailing";
        self.speakerSectionTitle = @"Speaker";
        self.sectionTitleList = [NSMutableArray arrayWithObjects:self.auditorSectionTitle, self.detailingSectionTitle, self.speakerSectionTitle, nil];
        
    }
    
    return self;
}

- (void)dealloc {
    self.sectionTitleList = nil;
    self.auditorSectionTitle = nil;
    self.detailingSectionTitle = nil;
    self.speakerSectionTitle = nil;
    self.groupedDataDict = nil;
    
    [super dealloc];
}

- (void)createBasicData {
    [self createDataObjectDict];
    self.groupedDataDict = [NSMutableDictionary dictionaryWithCapacity:3];
    NSMutableArray* auditorDisplayList = [NSMutableArray arrayWithCapacity:1];
    [auditorDisplayList addObject:[self createEmployeeCellWithFieldName:@"Approved By"]];
    [self.groupedDataDict setObject:auditorDisplayList forKey:self.auditorSectionTitle];
    NSMutableArray* detailingDisplayList = [NSMutableArray arrayWithCapacity:2];
    [detailingDisplayList addObject:[self createIURCellWithFieldName:@"L4"]];
    [detailingDisplayList addObject:[self createIURCellWithFieldName:@"L5"]];
    [self.groupedDataDict setObject:detailingDisplayList forKey:self.detailingSectionTitle];
    NSMutableArray* speakerDisplayList = [NSMutableArray arrayWithCapacity:2];
    [speakerDisplayList addObject:[self createTextViewCellWithFieldName:@"Terms"]];
    [self.groupedDataDict setObject:speakerDisplayList forKey:self.speakerSectionTitle];
}

- (void)createDataObjectDict {
    self.headOfficeDataObjectDict = [NSMutableDictionary dictionaryWithCapacity:5];
    [self.headOfficeDataObjectDict setObject:[NSMutableDictionary dictionary] forKey:self.meetingCellKeyDefinition.approvedByKey];
    [self.headOfficeDataObjectDict setObject:[self createDefaultIURDict] forKey:self.meetingCellKeyDefinition.l4Key];
    [self.headOfficeDataObjectDict setObject:[self createDefaultIURDict] forKey:self.meetingCellKeyDefinition.l5Key];
    [self.headOfficeDataObjectDict setObject:[NSNumber numberWithBool:YES] forKey:self.meetingCellKeyDefinition.speakerAgreementKey];
    [self.headOfficeDataObjectDict setObject:@"" forKey:self.meetingCellKeyDefinition.speakerAgreementDetailsKey];
}

- (NSMutableDictionary*)cellDataWithIndexPath:(NSIndexPath*)anIndexPath {
    NSString* tmpSectionTitle = [self.sectionTitleList objectAtIndex:anIndexPath.section];
    NSMutableArray* tmpDisplayList = [self.groupedDataDict objectForKey:tmpSectionTitle];
    return [tmpDisplayList objectAtIndex:anIndexPath.row];
}

@end
