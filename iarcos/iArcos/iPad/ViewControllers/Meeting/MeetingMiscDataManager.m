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

- (void)createBasicDataWithReturnObject:(ArcosMeetingWithDetailsDownload*)anArcosMeetingWithDetailsDownload {
//    [self createDataObjectDict];
    NSMutableDictionary* approvedByDict = [self createDefaultEmployeeDict];
    NSMutableDictionary* l4FieldDataDict = [self createDefaultIURDict];
    NSMutableDictionary* l5FieldDataDict = [self createDefaultIURDict];
    NSNumber* speakerAgreementNumber = [NSNumber numberWithBool:YES];
    NSString* speakerAgreementDetails = @"";
    if (anArcosMeetingWithDetailsDownload != nil) {
        approvedByDict = [self createDefaultEmployeeDictWithIUR:[NSNumber numberWithInt:anArcosMeetingWithDetailsDownload.ApprovedByIUR] title:anArcosMeetingWithDetailsDownload.ApprovedByName];
        l4FieldDataDict = [self createDefaultIURDictWithIUR:[NSNumber numberWithInt:anArcosMeetingWithDetailsDownload.L4iur] title:anArcosMeetingWithDetailsDownload.L4Details];
        l5FieldDataDict = [self createDefaultIURDictWithIUR:[NSNumber numberWithInt:anArcosMeetingWithDetailsDownload.L5iur] title:anArcosMeetingWithDetailsDownload.L5Details];
        speakerAgreementNumber = [NSNumber numberWithBool:anArcosMeetingWithDetailsDownload.SpeakerAgreement];
        speakerAgreementDetails = [ArcosUtils convertNilToEmpty:anArcosMeetingWithDetailsDownload.SpeakerAgreementDetails];
    }
    
    self.groupedDataDict = [NSMutableDictionary dictionaryWithCapacity:3];
    NSMutableArray* auditorDisplayList = [NSMutableArray arrayWithCapacity:1];
    [auditorDisplayList addObject:[self createEmployeeCellWithFieldName:@"Approved By" cellKey:self.meetingCellKeyDefinition.approvedByKey fieldData:approvedByDict]];
    [self.groupedDataDict setObject:auditorDisplayList forKey:self.auditorSectionTitle];
    NSMutableArray* detailingDisplayList = [NSMutableArray arrayWithCapacity:2];
    NSMutableArray* l4ObjectList = [[ArcosCoreData sharedArcosCoreData] descrDetailWithDescrTypeCode:@"SD" descrDetailCode:@"L4"];
    NSString* l4FieldName = @"";
    if ([l4ObjectList count] > 0) {
        NSDictionary* l4DescrDetailDict = [l4ObjectList objectAtIndex:0];
        NSString* l4Detail = [l4DescrDetailDict objectForKey:@"Detail"];
        l4FieldName = [ArcosUtils convertNilToEmpty:l4Detail];
    }
    NSString* l5FieldName = @"";
    NSMutableArray* l5ObjectList = [[ArcosCoreData sharedArcosCoreData] descrDetailWithDescrTypeCode:@"SD" descrDetailCode:@"L5"];
    if ([l5ObjectList count] > 0) {
        NSDictionary* l5DescrDetailDict = [l5ObjectList objectAtIndex:0];
        NSString* l5Detail = [l5DescrDetailDict objectForKey:@"Detail"];
        l5FieldName = [ArcosUtils convertNilToEmpty:l5Detail];
    }
    [detailingDisplayList addObject:[self createIURCellWithFieldName:l4FieldName cellKey:self.meetingCellKeyDefinition.l4Key fieldData:l4FieldDataDict descrTypeCode:@"L4"]];
    [detailingDisplayList addObject:[self createIURCellWithFieldName:l5FieldName cellKey:self.meetingCellKeyDefinition.l5Key fieldData:l5FieldDataDict descrTypeCode:@"L5"]];
    [self.groupedDataDict setObject:detailingDisplayList forKey:self.detailingSectionTitle];
    NSMutableArray* speakerDisplayList = [NSMutableArray arrayWithCapacity:2];
    [speakerDisplayList addObject:[self createBooleanCellWithFieldName:@"Agreed" cellKey:self.meetingCellKeyDefinition.speakerAgreementKey fieldData:speakerAgreementNumber]];
    [speakerDisplayList addObject:[self createTextViewCellWithFieldName:@"Terms" cellKey:self.meetingCellKeyDefinition.speakerAgreementDetailsKey fieldData:speakerAgreementDetails]];
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

- (void)dataMeetingBaseInputFinishedWithData:(id)aData atIndexPath:(NSIndexPath*)anIndexPath {
    NSMutableDictionary* tmpDataDict = [self cellDataWithIndexPath:anIndexPath];
    [tmpDataDict setObject:aData forKey:@"FieldData"];
}

- (void)displayListHeadOfficeAdaptor {
    self.headOfficeDataObjectDict = [NSMutableDictionary dictionaryWithCapacity:5];
    for (int i = 0; i < [self.sectionTitleList count]; i++) {
        NSString* tmpSectionTitle = [self.sectionTitleList objectAtIndex:i];
        NSMutableArray* tmpDisplayList = [self.groupedDataDict objectForKey:tmpSectionTitle];
        for (int j = 0; j < [tmpDisplayList count]; j++) {
            NSMutableDictionary* tmpDataDict = [tmpDisplayList objectAtIndex:j];
            NSString* auxCellKey = [tmpDataDict objectForKey:@"CellKey"];
            [self.headOfficeDataObjectDict setObject:[tmpDataDict objectForKey:@"FieldData"] forKey:auxCellKey];
        }
    }
}

- (void)populateArcosMeetingWithDetails:(ArcosMeetingWithDetailsUpload*)anArcosMeetingWithDetailsUpload {
    @try {
        NSMutableDictionary* resApprovedByDict = [self.headOfficeDataObjectDict objectForKey:self.meetingCellKeyDefinition.approvedByKey];
        anArcosMeetingWithDetailsUpload.ApprovedByIUR = [[resApprovedByDict objectForKey:@"IUR"] intValue];
        NSMutableDictionary* resL4Dict = [self.headOfficeDataObjectDict objectForKey:self.meetingCellKeyDefinition.l4Key];
        anArcosMeetingWithDetailsUpload.L4iur = [[resL4Dict objectForKey:@"DescrDetailIUR"] intValue];
        NSMutableDictionary* resL5Dict = [self.headOfficeDataObjectDict objectForKey:self.meetingCellKeyDefinition.l5Key];
        anArcosMeetingWithDetailsUpload.L5iur = [[resL5Dict objectForKey:@"DescrDetailIUR"] intValue];
        NSNumber* resSpeakerAgreement = [self.headOfficeDataObjectDict objectForKey:self.meetingCellKeyDefinition.speakerAgreementKey];
        anArcosMeetingWithDetailsUpload.SpeakerAgreement = [resSpeakerAgreement boolValue];
        anArcosMeetingWithDetailsUpload.SpeakerAgreementDetails = [self.headOfficeDataObjectDict objectForKey:self.meetingCellKeyDefinition.speakerAgreementDetailsKey];
    } @catch (NSException *exception) {
        NSLog(@"%@", [exception reason]);
    } @finally {
        
    }
}

@end
