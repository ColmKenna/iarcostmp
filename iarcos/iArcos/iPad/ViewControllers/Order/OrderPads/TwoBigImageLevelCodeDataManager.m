//
//  TwoBigImageLevelCodeDataManager.m
//  Arcos
//
//  Created by David Kilmartin on 07/11/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "TwoBigImageLevelCodeDataManager.h"

@implementation TwoBigImageLevelCodeDataManager
@synthesize numberOfImages = _numberOfImages;
@synthesize displayList = _displayList;
@synthesize descrDetailList = _descrDetailList;
@synthesize maxCount = _maxCount;

@synthesize descrDetailSectionDict = _descrDetailSectionDict;
@synthesize sortKeyList = _sortKeyList;
@synthesize formType = _formType;
@synthesize branchDescrTypeCode = _branchDescrTypeCode;
@synthesize leafDescrTypeCode = _leafDescrTypeCode;
@synthesize branchLxCode = _branchLxCode;
@synthesize leafLxCode = _leafLxCode;
@synthesize formTypeId = _formTypeId;
@synthesize branchLeafDataProcessCenter = _branchLeafDataProcessCenter;
@synthesize myDescrDetailArrayList = _myDescrDetailArrayList;

- (id)init{
    self = [super init];
    if (self != nil) {
        self.numberOfImages = [NSNumber numberWithInt:3];
        self.maxCount = 1500;
        
        self.descrDetailSectionDict = [NSMutableDictionary dictionary];
        self.sortKeyList = [NSMutableArray array];
        self.branchLeafDataProcessCenter = [[[BranchLeafDataProcessCenter alloc] init] autorelease];
    }
    return self;
}

- (void)dealloc {
    if (self.numberOfImages != nil) { self.numberOfImages = nil; }
    if (self.displayList != nil) { self.displayList = nil; }
    if (self.descrDetailList != nil) { self.descrDetailList = nil; }
    
    if (self.descrDetailSectionDict != nil) { self.descrDetailSectionDict = nil; }
    if (self.sortKeyList != nil) { self.sortKeyList = nil; }
    if (self.formType != nil) { self.formType = nil; }
    if (self.branchDescrTypeCode != nil) { self.branchDescrTypeCode = nil; }
    if (self.leafDescrTypeCode != nil) { self.leafDescrTypeCode = nil; }
    if (self.branchLxCode != nil) { self.branchLxCode = nil; }
    if (self.leafLxCode != nil) { self.leafLxCode = nil; }
    if (self.branchLeafDataProcessCenter != nil) { self.branchLeafDataProcessCenter = nil; }
    self.myDescrDetailArrayList = nil;
    
    [super dealloc];
}

- (void)getBranchLeafData {
    [self retrieveAnalyseFormTypeRawData];
    self.displayList = [self.branchLeafDataProcessCenter getBranchLeafData:self.branchDescrTypeCode leafDescrTypeCode:self.leafDescrTypeCode branchLxCode:self.branchLxCode leafLxCode:self.leafLxCode];
//    [self categoriseSortedListIntoSection:self.displayList];
    [self processDescrDetailArrayList:self.displayList];
}

- (void)processDescrDetailArrayList:(NSMutableArray*)aDisplayList {
    self.myDescrDetailArrayList = [NSMutableArray array];
    self.myDescrDetailArrayList = [self processSubsetArrayData:aDisplayList];
}

- (void)categoriseSortedListIntoSection:(NSMutableArray*)aSortedList {
    self.descrDetailSectionDict = [NSMutableDictionary dictionary];
    self.sortKeyList = [NSMutableArray array];
    if ([aSortedList count] == 0) return;
    
    //get the first char of the  list
    NSString* currentChar = @"";
    if ([aSortedList count] > 0) {
        NSMutableDictionary* aDescrDetailDict = [aSortedList objectAtIndex:0];
        NSString* detail = [aDescrDetailDict objectForKey:@"Detail"];
        
        if (detail != nil) {
            if ([detail length] >= 1) {
                currentChar = [detail substringToIndex:1];
            } else {
                currentChar = @" ";
            }
        }
        //add first Char
        [self.sortKeyList addObject:currentChar];
    }
    
    //location and length used to get the sub array of customer list
    int location=0;
    int length=1;
    
    //start sorting the customer in to the sections
    for (int i = 1; i < [aSortedList count]; i++) {
        //sotring the name into the array
        NSMutableDictionary* aDescrDetailDict = [aSortedList objectAtIndex:i];
        NSString* detail = [aDescrDetailDict objectForKey:@"Detail"];
        
        if (detail == nil || [detail isEqualToString:@""]) {
            detail = @" ";
        }
        
        //sorting
        if ([currentChar caseInsensitiveCompare:[detail substringToIndex:1]]==NSOrderedSame) {
            
            
        }else{
            //store the sub array of customer to the section dictionary
            NSMutableArray* tempArray = [[aSortedList subarrayWithRange:NSMakeRange(location, length)]mutableCopy];
            NSMutableArray* processedTempArray = [self processSubsetArrayData:tempArray];
            [self.descrDetailSectionDict setObject:processedTempArray forKey:currentChar];
            [tempArray release];
            //reset the location and length
            location=location+length;//bug fit to duplicate outlet entry
            length=0;
            //get the current char
            currentChar = [detail substringToIndex:1];
            //add char to sort key
            [self.sortKeyList addObject:currentChar];
        }
        length++;
    }
    //the last loop or length == 1
    NSMutableArray* tempArray = [[aSortedList subarrayWithRange:NSMakeRange(location, length)]mutableCopy];
    NSMutableArray* processedTempArray = [self processSubsetArrayData:tempArray];
    [self.descrDetailSectionDict setObject:processedTempArray forKey:currentChar];
    [tempArray release];
    
    //    NSLog(@"sortKeyList: %@", self.sortKeyList);
    //    NSLog(@"descrDetailSectionDict: %@", self.descrDetailSectionDict);
}

- (NSMutableArray*)processSubsetArrayData:(NSMutableArray*)aDisplayList {
    NSMutableArray* descrDetailArrayList  = [NSMutableArray array];
    NSMutableArray* subsetDisplayList = [NSMutableArray array];
    for(int i = 0; i < [aDisplayList count]; i++) {
        [subsetDisplayList addObject:[aDisplayList objectAtIndex:i]];
        if ((i + 1) % [self.numberOfImages intValue] == 0) {
            [descrDetailArrayList addObject:subsetDisplayList];
            subsetDisplayList = [NSMutableArray array];
        }
    }
    if ([subsetDisplayList count] > 0) {//the last loop
        [descrDetailArrayList addObject:subsetDisplayList];
    }
    return descrDetailArrayList;
}

- (void)retrieveAnalyseFormTypeRawData {
    NSMutableDictionary* formTypeMiscDict = [self.branchLeafDataProcessCenter analyseFormTypeRawData:self.formType];
    self.formTypeId = [formTypeMiscDict objectForKey:@"formTypeId"];
    self.branchDescrTypeCode = [formTypeMiscDict objectForKey:@"branchDescrTypeCode"];
    self.leafDescrTypeCode = [formTypeMiscDict objectForKey:@"leafDescrTypeCode"];
    self.branchLxCode = [formTypeMiscDict objectForKey:@"branchLxCode"];
    self.leafLxCode = [formTypeMiscDict objectForKey:@"leafLxCode"];
}

- (void)createTwoBigBoxGridL45Data {
    ArcosFormDetailBO* arcosFormDetailBO = [[[ArcosFormDetailBO alloc] init] autorelease];
    arcosFormDetailBO.iur = 110;
    arcosFormDetailBO.Details = @"Two Big Image Box Grid Product Drilldown";
    arcosFormDetailBO.DefaultDeliveryDate = [NSDate date];
    arcosFormDetailBO.Active = YES;
    arcosFormDetailBO.FormType = 945;
    arcosFormDetailBO.Type = @"945";
    arcosFormDetailBO.PrintDeliveryDocket = NO;
    [[ArcosCoreData sharedArcosCoreData] loadFormDetailsWithSoapOB:arcosFormDetailBO];
}

@end
