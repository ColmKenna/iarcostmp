//
//  CustomerPhotoSlideDataManager.m
//  Arcos
//
//  Created by David Kilmartin on 13/02/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "CustomerPhotoSlideDataManager.h"

@implementation CustomerPhotoSlideDataManager
@synthesize displayList = _displayList;
@synthesize locationIUR = _locationIUR;
@synthesize slideViewItemList = _slideViewItemList;
@synthesize currentPage = _currentPage;
@synthesize photoCoordinateType = _photoCoordinateType;
@synthesize remotePhotoHashMap = _remotePhotoHashMap;

- (id)initWithLocationIUR:(NSNumber*)aLocationIUR{
    self = [super init];
    if (self != nil) {
        self.displayList = [NSMutableArray array];
        self.locationIUR = aLocationIUR;
        self.currentPage = 0;
        self.photoCoordinateType = PhotoLocalCoordinateType;
    }
    return self;
}

-(void)dealloc {
    if (self.displayList != nil) { self.displayList = nil; }
    if (self.locationIUR != nil) { self.locationIUR = nil; }
    if (self.slideViewItemList != nil) { self.slideViewItemList = nil; }
    self.remotePhotoHashMap = nil;
    
    [super dealloc];
}

- (void)createPhotoSlideBasicData {
    self.displayList = [NSMutableArray array];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"LocationIUR=%@", self.locationIUR];
    NSArray* sortDescNames = [NSArray arrayWithObjects:@"DateCollected",nil];
    NSArray* properties = [NSArray arrayWithObjects:@"LocationIUR",@"Comments",@"DateCollected",nil];
    
    NSMutableArray* objectsArray = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"Collected" withPropertiesToFetch:properties withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:[NSNumber numberWithBool:NO]];
    if ([objectsArray count] > 0) {
//        self.displayList = objectsArray;
        for (NSDictionary* anObject in objectsArray) {
            NSString* comments = [anObject objectForKey:@"Comments"];
            NSString* filePath = [self getFilePathWithFileName:comments];
            if ([FileCommon fileExistAtPath:filePath]) {
                [self.displayList addObject:[NSMutableDictionary dictionaryWithDictionary:anObject]];
            }
        }
    }
}

- (void)createPhotoSlideViewItemData {
    self.slideViewItemList = [NSMutableArray arrayWithCapacity:[self.displayList count]];
    for (int i = 0; i < [self.displayList count]; i++) {
        PresenterSlideViewItemController* PSVIC = [[[PresenterSlideViewItemController alloc]initWithNibName:@"PresenterSlideViewItemController" bundle:nil] autorelease];        
        [self.slideViewItemList addObject:PSVIC];
    }
//    NSLog(@"self.slideViewItemList: %d", [self.slideViewItemList count]);
}

- (void)fillPhotoSlideViewItem:(PresenterSlideViewItemController*)psvic index:(int)anIndex {
    NSDictionary* collected = [self.displayList objectAtIndex:anIndex];
    NSString* fileName = [collected objectForKey:@"Comments"];
    NSString* filePath = [self getFilePathWithFileName:fileName];
    UIImage* anImage = [UIImage imageWithContentsOfFile:filePath];
    PresenterSlideViewItemController* aPSVIC = (PresenterSlideViewItemController*)[self.slideViewItemList objectAtIndex:anIndex];
    aPSVIC.myImage.image = anImage;
}

- (NSString*)getFilePathWithFileName:(NSString*)aFileName {
    return [NSString stringWithFormat:@"%@/%@", [FileCommon photosPath],aFileName];
}

- (BOOL)deleteCollectedRecordWithCurrentPage:(int)aCurrentPage {
    NSDictionary* collectedDict = [self.displayList objectAtIndex:aCurrentPage];
    NSNumber* aLocationIUR = [collectedDict objectForKey:@"LocationIUR"];
    NSString* aComments = [collectedDict objectForKey:@"Comments"];
    return [[ArcosCoreData sharedArcosCoreData] deleteCollectedWithLocationIUR:aLocationIUR comments:aComments];
}

- (CompositeErrorResult*)deleteCollectedFileWithCurrentPage:(int)aCurrentPage {
    NSDictionary* collectedDict = [self.displayList objectAtIndex:aCurrentPage];
    NSString* aComments = [collectedDict objectForKey:@"Comments"];
    NSString* filePath = [self getFilePathWithFileName:aComments];
    return [FileCommon removeFileAtPath:filePath];
}

- (void)emptyPhotoSlideViewItemWithIndex:(int)anIndex {
    for (int i = 0; i < [self.slideViewItemList count]; i++) {
        PresenterSlideViewItemController* aPSVIC = (PresenterSlideViewItemController*)[self.slideViewItemList objectAtIndex:i];
        aPSVIC.myImage.image = nil;
    }
}

- (void)updateResponseRecordWithCurrentPage:(int)aCurrentPage {
    NSDictionary* collectedDict = [self.displayList objectAtIndex:aCurrentPage];
    NSNumber* aLocationIUR = [collectedDict objectForKey:@"LocationIUR"];
    NSString* aComments = [collectedDict objectForKey:@"Comments"];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"LocationIUR = %@ and Answer CONTAINS[c]  %@", aLocationIUR, aComments];
    NSMutableArray* objectList = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"Response" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
    if ([objectList count] > 0) {
        Response* anExistResponse = [objectList objectAtIndex:0];
        NSArray* tmpFileNameList = [anExistResponse.Answer componentsSeparatedByString:[GlobalSharedClass shared].fieldDelimiter];
        NSMutableArray* auxFileNameList = [NSMutableArray arrayWithArray:tmpFileNameList];
        for (int i = 0; i < [auxFileNameList count]; i++) {
            NSString* auxFileName = [auxFileNameList objectAtIndex:i];
            if ([auxFileName isEqualToString:aComments]) {
                [auxFileNameList removeObjectAtIndex:i];
            }
        }
        NSString* auxAnswer = [auxFileNameList componentsJoinedByString:[GlobalSharedClass shared].fieldDelimiter];
        anExistResponse.Answer = auxAnswer;
        if ([anExistResponse.IUR intValue] != 0) {//sent
            anExistResponse.IUR = [NSNumber numberWithInt:0];
            anExistResponse.CallIUR = [NSNumber numberWithInt:1];//an auxiliary
            NSString* existingResponseDateStr = [ArcosUtils stringFromDate:anExistResponse.ResponseDate format:[GlobalSharedClass shared].dateFormat];
            NSDate* currentDate = [NSDate date];
            NSString* currentDateStr = [ArcosUtils stringFromDate:currentDate format:[GlobalSharedClass shared].dateFormat];
            anExistResponse.ResponseDate = currentDate;
            if ([[ArcosConfigDataManager sharedArcosConfigDataManager] unloadSurveyResponseFlag] && ![existingResponseDateStr isEqualToString:currentDateStr]) {
                [[ArcosCoreData sharedArcosCoreData].fetchManagedObjectContext deleteObject:anExistResponse];
            }
        } else {
            if ([anExistResponse.CallIUR intValue] == 0 && ([auxAnswer isEqualToString:@""] || [auxAnswer isEqualToString:[GlobalSharedClass shared].unknownText])) {
                [[ArcosCoreData sharedArcosCoreData].fetchManagedObjectContext deleteObject:anExistResponse];
            }
            if ([anExistResponse.CallIUR intValue] != 0) {
                anExistResponse.ResponseDate = [NSDate date];
            }
        }
        [[ArcosCoreData sharedArcosCoreData] saveContext:[ArcosCoreData sharedArcosCoreData].fetchManagedObjectContext];
    }
}

@end
