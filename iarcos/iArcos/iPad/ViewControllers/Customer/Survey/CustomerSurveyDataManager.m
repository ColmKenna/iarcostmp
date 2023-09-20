//
//  CustomerSurveyDataManager.m
//  Arcos
//
//  Created by David Kilmartin on 12/02/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "CustomerSurveyDataManager.h"

@interface CustomerSurveyDataManager (Private)
-(void)initiateMasterSection;
@end

@implementation CustomerSurveyDataManager
@synthesize groupedDataDict = _groupedDataDict;
@synthesize originalGroupedDataDict = _originalGroupedDataDict;
@synthesize displayList = _displayList;
@synthesize sectionNoList = _sectionNoList;

@synthesize surveyDict = _surveyDict;
@synthesize contactDict = _contactDict;
@synthesize sectionTitleList = _sectionTitleList;
@synthesize locationIUR = _locationIUR;
@synthesize masterSectionKey = _masterSectionKey;
@synthesize changedDataList = _changedDataList;
@synthesize originalChangedDataList = _originalChangedDataList;
@synthesize isSurveySaved = _isSurveySaved;
@synthesize currentIndexPath = _currentIndexPath;
@synthesize isImagePickerDisplayed = _isImagePickerDisplayed;
@synthesize innerBaseDataManager = _innerBaseDataManager;
@synthesize rankingHashMap = _rankingHashMap;
@synthesize rankQuestionType = _rankQuestionType;

-(id)init{
    self = [super init];
    if (self != nil) {
//        self.groupedDataDict = [NSMutableDictionary dictionary];
//        self.displayList = [[[NSMutableArray alloc] init] autorelease];
//        self.sectionNoList = [[[NSMutableArray alloc] init] autorelease];
//        self.sectionTitleList = [[[NSMutableArray alloc] init] autorelease];
        self.rankQuestionType = 15;
        self.masterSectionKey = [NSNumber numberWithInt:99999999];         
        [self initiateMasterSection];
        self.isImagePickerDisplayed = NO;
        if ([[ArcosConfigDataManager sharedArcosConfigDataManager] unloadSurveyResponseFlag]) {
            self.innerBaseDataManager = [[[CustomerSurveyBlankSentAnswerDataManager alloc] init] autorelease];
        } else {
            self.innerBaseDataManager = [[[CustomerSurveyLoadAnswerDataManager alloc] init] autorelease];
        }
        self.rankingHashMap = [NSMutableDictionary dictionary];
    }
    return self;
}

-(void)initiateMasterSection {
    self.groupedDataDict = [NSMutableDictionary dictionary];
    self.originalGroupedDataDict = [NSMutableDictionary dictionary];
    self.displayList = [[[NSMutableArray alloc] init] autorelease];
    self.sectionNoList = [[[NSMutableArray alloc] init] autorelease];
    self.sectionTitleList = [[[NSMutableArray alloc] init] autorelease];
    //sectionno for master section is set to be 99999999
    [self.sectionTitleList addObject:@"Survey Details"];
    [self.sectionNoList addObject:self.masterSectionKey];
    NSMutableDictionary* surveyDataDict = [NSMutableDictionary dictionary];
    [surveyDataDict setObject:self.masterSectionKey forKey:@"sectionNo"];
    [surveyDataDict setObject:[NSNumber numberWithInt:90] forKey:@"QuestionType"];
    [surveyDataDict setObject:@"Touch to pick a survey" forKey:@"Title"];
    if (self.surveyDict != nil) {
        [surveyDataDict setObject:[ArcosUtils convertNilToEmpty:[self.surveyDict objectForKey:@"Title"]] forKey:@"Title"];
        [surveyDataDict setObject:[self.surveyDict objectForKey:@"IUR"] forKey:@"Answer"];
    }
    NSMutableArray* masterDisplayList = [[[NSMutableArray alloc] init] autorelease];
    [masterDisplayList addObject:surveyDataDict];
    NSMutableDictionary* contactDataDict = [NSMutableDictionary dictionary];
    [contactDataDict setObject:self.masterSectionKey forKey:@"sectionNo"];
    [contactDataDict setObject:[NSNumber numberWithInt:91] forKey:@"QuestionType"];
    //Touch to pick a contact
    [contactDataDict setObject:@"UnAssigned" forKey:@"Title"];
    if (self.contactDict != nil) {
        [contactDataDict setObject:[self.contactDict objectForKey:@"Title"] forKey:@"Title"];
        [contactDataDict setObject:[self.contactDict objectForKey:@"IUR"] forKey:@"Answer"];
    }
    [masterDisplayList addObject:contactDataDict];
    [self.groupedDataDict setObject:masterDisplayList forKey:self.masterSectionKey];
    
//    NSLog(@"___: %@", self.groupedDataDict);
}

-(void)dealloc{
    if (self.groupedDataDict != nil) { self.groupedDataDict = nil;}
    self.originalGroupedDataDict = nil;
    if (self.displayList != nil) { self.displayList = nil;}
    if (self.sectionNoList != nil) { self.sectionNoList = nil;}    
    if (self.sectionTitleList != nil) { self.sectionTitleList = nil;}    
    if (self.surveyDict != nil) { self.surveyDict = nil;}    
    if (self.contactDict != nil) { self.contactDict = nil;}
    if (self.locationIUR != nil) { self.locationIUR = nil;}
    if (self.masterSectionKey != nil) { self.masterSectionKey = nil;}
    self.changedDataList = nil;
    self.originalChangedDataList = nil;
    self.currentIndexPath = nil;
    self.innerBaseDataManager = nil;
    self.rankingHashMap = nil;
    
    [super dealloc];
}

-(NSMutableDictionary*)cellDataWithIndexPath:(NSIndexPath*)anIndexPath {
    NSNumber* sectionNo = [self.sectionNoList objectAtIndex:anIndexPath.section];
    NSMutableArray* tmpDisplayList = [self.groupedDataDict objectForKey:sectionNo];
    return [tmpDisplayList objectAtIndex:anIndexPath.row];
}

-(void)processRawData:(NSMutableArray*)objectsArray {
    [self initiateMasterSection];    
    //get the section information
    for (NSMutableDictionary* anObject in objectsArray) { 
        NSNumber* sectionNo = [anObject objectForKey:@"sectionNo"];
        if (![self.sectionNoList containsObject:sectionNo]) {
            [self.sectionNoList addObject:sectionNo];
            NSNumber* questionType = [anObject objectForKey:@"QuestionType"];
            if ([questionType intValue] == 7) {
                [self.sectionTitleList addObject:[anObject objectForKey:@"Narrative"]];
            } else {
                [self.sectionTitleList addObject:@""];
            }            
        }        
    }
    //group the questions
    if ([self.sectionNoList count] <= 1) {
        return;
    }
    NSNumber* contactIUR;
    if (self.contactDict != nil) {
        contactIUR = [self.contactDict objectForKey:@"IUR"];
    } else {
        contactIUR = [NSNumber numberWithInt:0];
    }
    NSNumber* surveyIUR = [self.surveyDict objectForKey:@"IUR"];
    NSMutableArray* questionIURList = [NSMutableArray arrayWithCapacity:[objectsArray count]];
    
    for (int i = 0; i < [objectsArray count]; i++) {
        NSMutableDictionary* tmpDataDict = [objectsArray objectAtIndex:i];
        [questionIURList addObject:[tmpDataDict objectForKey:@"IUR"]];
    }
    NSMutableArray* responseDictList = [self.innerBaseDataManager retrieveResponseWithLocationIUR:self.locationIUR surveyIUR:surveyIUR contactIUR:contactIUR questionIURList:questionIURList];
//    NSMutableArray* responseDictList = [[ArcosCoreData sharedArcosCoreData] responseWithLocationIUR:self.locationIUR contactIUR:contactIUR surveyIUR:surveyIUR questionIURList:questionIURList];
    NSMutableDictionary* responseHashTable = [NSMutableDictionary dictionaryWithCapacity:[responseDictList count]];
    for (int i = 0; i < [responseDictList count]; i++) {
        NSDictionary* tmpResponseDict = [responseDictList objectAtIndex:i];
        [responseHashTable setObject:tmpResponseDict forKey:[tmpResponseDict objectForKey:@"QuestionIUR"]];
    }
    
    for (int i = 1; i < [self.sectionNoList count]; i++) {
        NSMutableArray* tmpSectionDisplayList = [[[NSMutableArray alloc] init] autorelease];
        NSMutableArray* originalTmpSectionDisplayList = [[[NSMutableArray alloc] init] autorelease];
        NSNumber* sectionNo = [self.sectionNoList objectAtIndex:i];
        for (NSMutableDictionary* anObject in objectsArray) {
            if ([sectionNo isEqualToNumber:[anObject objectForKey:@"sectionNo"]]
                && [[anObject objectForKey:@"QuestionType"] intValue] != 7) {
//                NSLog(@"%@, %@, %@, %@", self.locationIUR, contactIUR, [anObject objectForKey:@"SurveyIUR"], [anObject objectForKey:@"IUR"]);
//                NSDictionary* responseDict = [[ArcosCoreData sharedArcosCoreData] responseWithLocationIUR:self.locationIUR contactIUR:contactIUR surveyIUR:[anObject objectForKey:@"SurveyIUR"] questionIUR:[anObject objectForKey:@"IUR"]];
                NSDictionary* responseDict = [responseHashTable objectForKey:[anObject objectForKey:@"IUR"]];
//                NSLog(@"responseDict is %@", responseDict);
                if (responseDict != nil) {
//                    NSLog(@"number of responseDict is %@", [anObject objectForKey:@"Answer"]);
//                    NSLog(@"anObject before %@",anObject);
                    NSString* tmpAnswer = [responseDict objectForKey:@"Answer"];
                    if ([[anObject objectForKey:@"QuestionType"] intValue] == self.rankQuestionType) {
                        NSMutableDictionary* contentRankingHashMap = [self.rankingHashMap objectForKey:[anObject objectForKey:@"sectionNo"]];
                        if (contentRankingHashMap == nil) {
                            contentRankingHashMap = [NSMutableDictionary dictionary];
                            [self.rankingHashMap setObject:contentRankingHashMap forKey:[anObject objectForKey:@"sectionNo"]];
                        }
                        if (tmpAnswer != nil && ![tmpAnswer isEqualToString:@""] && ![tmpAnswer isEqualToString:[GlobalSharedClass shared].unknownText]) {
                            [contentRankingHashMap setObject:tmpAnswer forKey:tmpAnswer];
                        }                        
                    }
                    [anObject setObject:[ArcosUtils convertNilToEmpty:tmpAnswer] forKey:@"Answer"];
                    [anObject setObject:[responseDict objectForKey:@"IUR"] forKey:@"ResponseIUR"];
//                    NSLog(@"anObject after %@",anObject);
                    if ([[anObject objectForKey:@"QuestionType"] intValue] == 12 && ![tmpAnswer isEqualToString:@""]) {
                        NSArray* tmpFileNameList = [tmpAnswer componentsSeparatedByString:[GlobalSharedClass shared].fieldDelimiter];
                        for (int i = 0; i < [tmpFileNameList count]; i++) {
                            NSString* tmpFileName = [tmpFileNameList objectAtIndex:i];
                            NSString* srcFilePath = [NSString stringWithFormat:@"%@/%@", [FileCommon photosPath], tmpFileName];
                            NSString* descFilePath = [NSString stringWithFormat:@"%@/%@", [FileCommon surveyPath], tmpFileName];
                            //                        NSError* tmpError = nil;
                            CompositeErrorResult* tmpCompositeErrorResult = [FileCommon testCopyItemAtPath:srcFilePath toPath:descFilePath];
                            if (!tmpCompositeErrorResult.successFlag) {
//                                [ArcosUtils showMsg:tmpCompositeErrorResult.errorMsg delegate:nil];
                                [ArcosUtils showDialogBox:tmpCompositeErrorResult.errorMsg title:@"" target:[ArcosUtils getRootView] handler:nil];
                            }
                        }                        
                    }
                }
                NSMutableDictionary* originalAnObject = [NSMutableDictionary dictionaryWithDictionary:anObject];
                [tmpSectionDisplayList addObject:anObject];
                [originalTmpSectionDisplayList addObject:originalAnObject];
            }
        }
        [self.groupedDataDict setObject:tmpSectionDisplayList forKey:sectionNo];
        [self.originalGroupedDataDict setObject:originalTmpSectionDisplayList forKey:sectionNo];
    }
//    NSLog(@"___: %@ *** %@", self.groupedDataDict, self.originalGroupedDataDict);
}

-(void)updateChangedData:(id)anAnswer withIndexPath:(NSIndexPath*)anIndexPath {
    NSNumber* sectionNo = [self.sectionNoList objectAtIndex:anIndexPath.section];
    NSMutableArray* tmpDisplayList = [self.groupedDataDict objectForKey:sectionNo];
    NSMutableDictionary* cellData = [tmpDisplayList objectAtIndex:anIndexPath.row];
    [cellData setObject:anAnswer forKey:@"Answer"];
//    [tmpDisplayList replaceObjectAtIndex:anIndexPath.row withObject:cellData];
//    [self.groupedDataDict setObject:tmpDisplayList forKey:sectionNo];
//    NSLog(@"___: %@ ***** %@", self.groupedDataDict, self.originalGroupedDataDict);
}

-(BOOL)processRawDataFromContact{    
    if (self.surveyDict == nil) return NO;
    NSNumber* surveyIUR = [self.surveyDict objectForKey:@"IUR"];
    NSMutableArray* objectsArray = [[ArcosCoreData sharedArcosCoreData] questionWithSurveyIUR:surveyIUR];
    [self processRawData:objectsArray];
    return YES;
}

-(NSMutableArray*)getChangedDataList {
    self.changedDataList = [NSMutableArray array];
    self.originalChangedDataList = [NSMutableArray array];
    for (int i = 1; i < [self.sectionNoList count]; i++) {
        NSMutableArray* tmpSectionDisplayList = [self.groupedDataDict objectForKey:[self.sectionNoList objectAtIndex:i]];
        NSMutableArray* originalTmpSectionDisplayList = [self.originalGroupedDataDict objectForKey:[self.sectionNoList objectAtIndex:i]];
        for (int j = 0; j < [tmpSectionDisplayList count]; j++) {
            NSMutableDictionary* dataDict = [tmpSectionDisplayList objectAtIndex:j];
            NSMutableDictionary* originalDataDict = [originalTmpSectionDisplayList objectAtIndex:j];
            if (![[ArcosUtils convertToString:[dataDict objectForKey:@"Answer"]] isEqualToString:[ArcosUtils convertToString:[originalDataDict objectForKey:@"Answer"]]]) {
                [self.changedDataList addObject:dataDict];
                [self.originalChangedDataList addObject:originalDataDict];
            }
        }
    }
    return self.changedDataList;
}

- (void)removePhotoWithIndexPath:(NSIndexPath *)anIndexPath currentFileName:(NSString *)aCurrentFileName {
    NSString* srcFilePath = [NSString stringWithFormat:@"%@/%@", [FileCommon surveyPath], aCurrentFileName];
    [FileCommon removeFileAtPath:srcFilePath];
}

- (void)removePhotoWithFileName:(NSString *)aFileName {
    NSString* srcFilePath = [NSString stringWithFormat:@"%@/%@", [FileCommon surveyPath], aFileName];
    [FileCommon removeFileAtPath:srcFilePath];
}

- (BOOL)turnOnHighlightFlagAndFindMustAnswerQuestion {
    BOOL mustAnswerQuestionFound = NO;
    for (int i = 1; i < [self.sectionNoList count]; i++) {
        NSMutableArray* tmpSectionDisplayList = [self.groupedDataDict objectForKey:[self.sectionNoList objectAtIndex:i]];
        for (int j = 0; j < [tmpSectionDisplayList count]; j++) {
            NSMutableDictionary* tmpDataDict = [tmpSectionDisplayList objectAtIndex:j];
            [tmpDataDict setObject:[NSNumber numberWithBool:YES] forKey:@"Highlight"];            
            if ([[tmpDataDict objectForKey:@"active"] boolValue]) {
                int auxQuestionType = [[tmpDataDict objectForKey:@"QuestionType"] intValue];
                NSString* tmpAnswer = [tmpDataDict objectForKey:@"Answer"];                
                if (auxQuestionType != 14) {
                    if (auxQuestionType == 16) {
                        
                    } else if ([tmpAnswer isEqualToString:@""] || [tmpAnswer isEqualToString:[GlobalSharedClass shared].unknownText]) {
                        mustAnswerQuestionFound = YES;
                    }
                } else {
                    NSArray* tmpAnswerArray = [tmpAnswer componentsSeparatedByString:[GlobalSharedClass shared].fieldDelimiter];
                    if ([tmpAnswerArray count] == 1) {
                        NSString* tmpAnswer = [tmpAnswerArray objectAtIndex:0];
                        if ([tmpAnswer isEqualToString:@""] || [tmpAnswer isEqualToString:[GlobalSharedClass shared].unknownText]) {
                            mustAnswerQuestionFound = YES;
                        }                        
                    } else if ([tmpAnswerArray count] == 2) {
                        NSString* firstTmpAnswer = [tmpAnswerArray objectAtIndex:0];
                        NSString* secondTmpAnswer = [tmpAnswerArray objectAtIndex:1];
                        if (([firstTmpAnswer isEqualToString:@""] || [firstTmpAnswer isEqualToString:[GlobalSharedClass shared].unknownText]) && ([secondTmpAnswer isEqualToString:@""] || [secondTmpAnswer isEqualToString:[GlobalSharedClass shared].unknownText])) {
                            mustAnswerQuestionFound = YES;
                        }
                    }
                }                
            }
        }
    }
    return mustAnswerQuestionFound;
}

@end
