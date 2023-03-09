//
//  DetailingDataManager.m
//  Arcos
//
//  Created by Apple on 01/02/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "DetailingDataManager.h"
#import "ArcosConfigDataManager.h"

@implementation DetailingDataManager
@synthesize detailingHeaderDict = _detailingHeaderDict;
@synthesize detailingActiveKeyList = _detailingActiveKeyList;
@synthesize detailingRowDict = _detailingRowDict;
@synthesize basicInfoKey = _basicInfoKey;
@synthesize adoptionLadderKey = _adoptionLadderKey;
@synthesize keyMessagesKey = _keyMessagesKey;
@synthesize samplesKey = _samplesKey;
@synthesize promotionalItemsKey = _promotionalItemsKey;
@synthesize presenterKey = _presenterKey;
@synthesize meetingContactKey = _meetingContactKey;
@synthesize isCallSaved = _isCallSaved;
@synthesize actionType = _actionType;
@synthesize presentationsKey = _presentationsKey;
@synthesize originalPresentationsDisplayList = _originalPresentationsDisplayList;
@synthesize presentationsHashMap = _presentationsHashMap;
@synthesize presentationsDisplayList = _presentationsDisplayList;

- (id)init {
    self = [super init];
    if (self != nil) {
        self.basicInfoKey = @"MA";
        self.adoptionLadderKey = @"DT";
        self.keyMessagesKey = @"KM";
        self.samplesKey = @"SM";
        self.promotionalItemsKey = @"RG";
        self.presenterKey = @"PS";
        self.meetingContactKey = @"MC";
        self.presentationsKey = @"PP";
        self.detailingHeaderDict = [NSMutableDictionary dictionaryWithCapacity:5];
        self.detailingActiveKeyList = [NSMutableArray arrayWithCapacity:5];
        self.detailingRowDict = [NSMutableDictionary dictionaryWithCapacity:5];
        [self.detailingHeaderDict setObject:@"" forKey:self.basicInfoKey];
        NSString* adoptionLadderValue = @"Adoption Ladder";
        NSDictionary* adoptionLadderDict = [[ArcosCoreData sharedArcosCoreData]descrTypeAllRecordsWithTypeCode:@"DD"];
        if (adoptionLadderDict != nil) {
            adoptionLadderValue = [ArcosUtils convertNilToEmpty:[adoptionLadderDict objectForKey:@"Details"]];
        }
        [self.detailingHeaderDict setObject:adoptionLadderValue forKey:self.adoptionLadderKey];
        NSString* keyMessagesValue = @"Key Messages";
        NSDictionary* keyMessagesDict = [[ArcosCoreData sharedArcosCoreData]descrTypeAllRecordsWithTypeCode:@"KM"];
        if (keyMessagesDict != nil) {
            keyMessagesValue = [ArcosUtils convertNilToEmpty:[keyMessagesDict objectForKey:@"Details"]];
        }
        [self.detailingHeaderDict setObject:keyMessagesValue forKey:self.keyMessagesKey];
        [self.detailingHeaderDict setObject:@"Samples" forKey:self.samplesKey];
        NSString* promotionalItemsValue = @"Promotional Items";
        NSDictionary* promotionalItemsDict = [[ArcosCoreData sharedArcosCoreData]descrTypeAllRecordsWithTypeCode:@"PI"];
        if (promotionalItemsDict != nil) {
            promotionalItemsValue = [ArcosUtils convertNilToEmpty:[promotionalItemsDict objectForKey:@"Details"]];
        }
        [self.detailingHeaderDict setObject:promotionalItemsValue forKey:self.promotionalItemsKey];
        [self.detailingHeaderDict setObject:@"Presenter" forKey:self.presenterKey];
        [self.detailingHeaderDict setObject:@"Attendees" forKey:self.meetingContactKey];
        [self.detailingHeaderDict setObject:@"Presentations" forKey:self.presentationsKey];
    }
    
    return self;
}

- (void) dealloc {
    self.detailingHeaderDict = nil;
    self.detailingActiveKeyList = nil;
    self.detailingRowDict = nil;
    self.basicInfoKey = nil;
    self.adoptionLadderKey = nil;
    self.keyMessagesKey = nil;
    self.samplesKey = nil;
    self.promotionalItemsKey = nil;
    self.presenterKey = nil;
    self.meetingContactKey = nil;
    self.actionType = nil;
    self.presentationsKey = nil;
    self.originalPresentationsDisplayList = nil;
    self.presentationsHashMap = nil;
    self.presentationsDisplayList = nil;
    
    [super dealloc];
}

- (void)createBasicData {
    [self.detailingActiveKeyList addObject:self.basicInfoKey];
    NSMutableArray* basicInfo=[NSMutableArray arrayWithObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0],@"IUR",@"MA",@"DetailLevel",@"Basic Information",@"Label",nil]];
    [self.detailingRowDict setObject:basicInfo forKey:self.basicInfoKey];
    NSMutableArray* detailingQAList = [[ArcosCoreData sharedArcosCoreData]detailingQA];
    if ([detailingQAList count] != 0) {
        [self.detailingActiveKeyList addObject:self.adoptionLadderKey];
        [self.detailingRowDict setObject:detailingQAList forKey:self.adoptionLadderKey];
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"DescrTypeCode='KM' and Active=1"];
        NSMutableArray* kmObjectsArray = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"DescrDetail" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
        if ([kmObjectsArray count] != 0) {
            [self.detailingActiveKeyList addObject:self.keyMessagesKey];
            NSMutableArray* detailingKeyMessagesList = [NSMutableArray arrayWithCapacity:[detailingQAList count]];
            for (NSMutableDictionary* aDict in detailingQAList) {
                NSMutableDictionary* newDict = [NSMutableDictionary dictionaryWithDictionary:aDict];
                [newDict setObject:self.keyMessagesKey forKey:@"DetailLevel"];
                [detailingKeyMessagesList addObject:newDict];
            }
            [self.detailingRowDict setObject:detailingKeyMessagesList forKey:self.keyMessagesKey];
        }
    }
    NSMutableArray* detailingSamplesList = [[ArcosCoreData sharedArcosCoreData]detailingSamples];
    if ([detailingSamplesList count] != 0) {
        [self.detailingActiveKeyList addObject:self.samplesKey];
        [self.detailingRowDict setObject:detailingSamplesList forKey:self.samplesKey];
    }
    NSMutableArray* detailingRNGList = [[ArcosCoreData sharedArcosCoreData]detailingRNG];
    if ([detailingRNGList count] != 0) {
        if ([self.actionType isEqualToString:@"create"] && ![[ArcosConfigDataManager sharedArcosConfigDataManager] recordPIRequestFlag] && ![[ArcosConfigDataManager sharedArcosConfigDataManager] recordPIGivenFlag]) {
            
        } else {
            [self.detailingActiveKeyList addObject:self.promotionalItemsKey];
            [self.detailingRowDict setObject:detailingRNGList forKey:self.promotionalItemsKey];
        }
    }
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showPresenterInDetailingFlag]) {
        [self createBasicPresentationsData];
        self.presentationsDisplayList = [NSMutableArray arrayWithArray:self.originalPresentationsDisplayList];
        [self.detailingActiveKeyList addObject:self.presentationsKey];
        [self.detailingRowDict setObject:self.presentationsDisplayList forKey:self.presentationsKey];
    }
}

- (NSMutableArray*)rowListWithSection:(NSInteger)section {
    NSString* activeKey = [self activeKeyWithSection:section];
    return [self.detailingRowDict objectForKey:activeKey];
}

- (NSString*)activeKeyWithSection:(NSInteger)section {
    return [self.detailingActiveKeyList objectAtIndex:section];
}

- (void)resetDataToShowResultOnlyWhenSent {
    int keyListCount = [ArcosUtils convertNSUIntegerToUnsignedInt:[self.detailingActiveKeyList count]];
    for (int i = keyListCount - 1; i >= 0; i--) {
        NSString* tmpKey = [self.detailingActiveKeyList objectAtIndex:i];
        if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showPresenterInDetailingFlag] && [tmpKey isEqualToString:self.presentationsKey]) {
            continue;
        }
        NSMutableArray* tmpSelection = [self.detailingRowDict objectForKey:tmpKey];
        int selectionCount = [ArcosUtils convertNSUIntegerToUnsignedInt:[tmpSelection count]];
        for (int j = selectionCount - 1; j >= 0; j--) {
            NSMutableDictionary* tmpDict = [tmpSelection objectAtIndex:j];
            if ([tmpDict objectForKey:@"data"] == nil) {
                [tmpSelection removeObjectAtIndex:j];
            }
        }
        if ([tmpSelection count] == 0) {
            [self.detailingActiveKeyList removeObjectAtIndex:i];
        }
    }
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showPresenterInDetailingFlag]) {
        int secondKeyListCount = [ArcosUtils convertNSUIntegerToUnsignedInt:[self.detailingActiveKeyList count]];
        int presentationsKeyListCount = [ArcosUtils convertNSUIntegerToUnsignedInt:[self.presentationsDisplayList count]];
        for (int i = secondKeyListCount - 1; i >= 0; i--) {
            NSString* tmpKey = [self.detailingActiveKeyList objectAtIndex:i];
            if (![tmpKey isEqualToString:self.presentationsKey]) {
                continue;
            }
            for (int j = presentationsKeyListCount - 1; j >= 0; j--) {
                NSMutableDictionary* ppHeaderDict = [self.presentationsDisplayList objectAtIndex:j];
                NSMutableArray* ppDictList = [self.presentationsHashMap objectForKey:[ppHeaderDict objectForKey:@"DescrDetailIUR"]];
                int ppDictListCount = [ArcosUtils convertNSUIntegerToUnsignedInt:[ppDictList count]];
                for (int k = ppDictListCount - 1; k >= 0; k--) {
                    NSMutableDictionary* tmpPpDict = [ppDictList objectAtIndex:k];
                    if ([tmpPpDict objectForKey:@"data"] == nil) {
                        [ppDictList removeObjectAtIndex:k];
                    }
                }
                if ([ppDictList count] == 0) {
                    [self.presentationsDisplayList removeObjectAtIndex:j];
                    [self.originalPresentationsDisplayList removeObjectAtIndex:j];
                }
            }
            if ([self.presentationsDisplayList count] == 0) {
                [self.detailingActiveKeyList removeObjectAtIndex:i];
            }
        }    
    }
}

- (void)refreshContactField {
    NSMutableArray* basicInfo = [self.detailingRowDict objectForKey:self.basicInfoKey];
    NSMutableDictionary* basicInfoDict = [basicInfo objectAtIndex:0];
    NSMutableDictionary* MData = [basicInfoDict objectForKey:@"data"];
    if ([[GlobalSharedClass shared].currentSelectedContactIUR intValue] == 0) {
        if (MData == nil) {
            MData = [NSMutableDictionary dictionary];
        }
        [MData setObject:[[GlobalSharedClass shared] createUnAssignedContact] forKey:@"Contact"];
        [basicInfoDict setObject:MData forKey:@"data"];
    } else {
        NSMutableDictionary* tmpContactDict = [[ArcosCoreData sharedArcosCoreData] compositeContactWithIUR:[GlobalSharedClass shared].currentSelectedContactIUR];
        if (tmpContactDict != nil) {
            if (MData == nil) {
                MData = [NSMutableDictionary dictionary];
            }
            [MData setObject:tmpContactDict forKey:@"Contact"];
            [basicInfoDict setObject:MData forKey:@"data"];
        }
    }
}

- (void)createBasicPresentationsData {
    self.originalPresentationsDisplayList = [NSMutableArray array];
    NSMutableArray* tmpPresenterParentDataList = [self retrievePresenterParentData];
    NSMutableArray* tmpDescrDetailIURList = [NSMutableArray arrayWithCapacity:[tmpPresenterParentDataList count]];
    for (int i = 0; i < [tmpPresenterParentDataList count]; i++) {
        NSDictionary* tmpDescrDetailDict = [tmpPresenterParentDataList objectAtIndex:i];
        NSNumber* tmpDescrDetailIUR = [tmpDescrDetailDict objectForKey:@"DescrDetailIUR"];
        [tmpDescrDetailIURList addObject:[ArcosUtils convertNilToZero:tmpDescrDetailIUR]];
    }
    NSMutableArray* tmpPresenterDataList = [self retrievePresenterWithDescrDetailIURList:tmpDescrDetailIURList];
    self.presentationsHashMap = [NSMutableDictionary dictionaryWithCapacity:[tmpPresenterParentDataList count]];
    for (int i = 0; i < [tmpPresenterDataList count]; i++) {
        NSDictionary* tmpPresenterDataDict = [tmpPresenterDataList objectAtIndex:i];
        NSMutableDictionary* resPresenterDataDict = [NSMutableDictionary dictionaryWithDictionary:tmpPresenterDataDict];
        [resPresenterDataDict setObject:@"PP" forKey:@"DetailLevel"];
        NSNumber* tmpLocationIUR = [tmpPresenterDataDict objectForKey:@"LocationIUR"];
        NSMutableArray* subPresenterDataList = [self.presentationsHashMap objectForKey:tmpLocationIUR];
        if (subPresenterDataList == nil) {
            subPresenterDataList = [NSMutableArray array];
            [self.presentationsHashMap setObject:subPresenterDataList forKey:tmpLocationIUR];
        }
        [subPresenterDataList addObject:resPresenterDataDict];
    }

    for (int i = 0; i < [tmpPresenterParentDataList count]; i++) {
        NSDictionary* tmpDescrDetailDict = [tmpPresenterParentDataList objectAtIndex:i];
        NSNumber* tmpDescrDetailIUR = [ArcosUtils convertNilToZero:[tmpDescrDetailDict objectForKey:@"DescrDetailIUR"]];
        if ([[self.presentationsHashMap objectForKey:tmpDescrDetailIUR] count] > 0) {
            NSMutableDictionary* resDescrDetailDict = [NSMutableDictionary dictionaryWithDictionary:tmpDescrDetailDict];
            [resDescrDetailDict setObject:@"PPHEADER" forKey:@"DetailLevel"];
            [resDescrDetailDict setObject:[NSNumber numberWithBool:NO] forKey:@"OpenFlag"];
            [self.originalPresentationsDisplayList addObject:resDescrDetailDict];
        }
    }
//    NSLog(@"ap:%@", self.originalPresentationsDisplayList);
//    NSLog(@"az:%@", self.presentationsHashMap);
}

- (NSMutableArray*)retrievePresenterParentData {
    NSArray* properties = [NSArray arrayWithObjects:@"DescrDetailIUR", @"Detail", @"Active", nil];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"DescrTypeCode = 'PP' and Active = 1"];
    NSArray* sortArray = [NSArray arrayWithObjects:@"ProfileOrder", nil];
    return [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"DescrDetail" withPropertiesToFetch:properties  withPredicate:predicate withSortDescNames:sortArray withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
}

- (NSMutableArray*)retrievePresenterWithDescrDetailIURList:(NSMutableArray*)aDescrDetailIURList {
    NSArray* properties = [NSArray arrayWithObjects:@"IUR", @"fullTitle", @"Active", @"LocationIUR", @"ImageIUR", @"displaySequence", @"memoDetails", nil];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"LocationIUR in %@ and Active = 1", aDescrDetailIURList];
    NSArray* sortArray = [NSArray arrayWithObjects:@"displaySequence", nil];
    return [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"Presenter" withPropertiesToFetch:properties  withPredicate:predicate withSortDescNames:sortArray withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
}

- (void)resetBranchData {
    for (int i = 0; i < [self.originalPresentationsDisplayList count]; i++) {
        NSMutableDictionary* tmpBranchDict = [self.originalPresentationsDisplayList objectAtIndex:i];
        [tmpBranchDict setObject:[NSNumber numberWithBool:NO] forKey:@"OpenFlag"];
    }
}

@end
