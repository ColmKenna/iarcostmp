//
//  ImageFormRowsDataManager.m
//  Arcos
//
//  Created by David Kilmartin on 22/10/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "ImageFormRowsDataManager.h"

@implementation ImageFormRowsDataManager
@synthesize numberOfImages = _numberOfImages;
@synthesize displayList = _displayList;
@synthesize descrDetailList = _descrDetailList;
@synthesize numberOfRows = _numberOfRows;
@synthesize searchedDisplayList = _searchedDisplayList;

- (id)init{
    self = [super init];
    if (self != nil) {
        self.numberOfImages = [NSNumber numberWithInt:5];
        self.numberOfRows = [NSNumber numberWithInt:0];
    }
    return self;
}

- (void)dealloc {
    if (self.numberOfImages != nil) { self.numberOfImages = nil; }    
    if (self.displayList != nil) { self.displayList = nil; }
    if (self.descrDetailList != nil) { self.descrDetailList = nil; }    
    if (self.numberOfRows != nil) { self.numberOfRows = nil; }        
    if (self.searchedDisplayList != nil) { self.searchedDisplayList = nil; }
    
    [super dealloc];
}

- (void)createImageFormRowsData {
    ArcosFormDetailBO* arcosFormDetailBO = [[[ArcosFormDetailBO alloc] init] autorelease];
    arcosFormDetailBO.iur = 13;
    arcosFormDetailBO.Details = @"Image Form (-2)";
    arcosFormDetailBO.DefaultDeliverDate = [NSDate date];    
    arcosFormDetailBO.Active = YES;
    arcosFormDetailBO.FormType = 102;
    arcosFormDetailBO.Type = @"102";
    arcosFormDetailBO.PrintDeliveryDocket = NO;
    [[ArcosCoreData sharedArcosCoreData] loadFormDetailsWithSoapOB:arcosFormDetailBO];
}

/*
 * L4Dict
 *    -L5Children (hasActiveProduct)
 */
- (void)getLevel4DescrDetail {
    NSMutableArray* tmpDisplayList = [[ArcosCoreData  sharedArcosCoreData] descrDetailWithDescrCodeType:@"L4" parentCode:nil];    
    NSMutableDictionary* tmpL4DescrDetailCodeHashMap = [NSMutableDictionary dictionaryWithCapacity:[tmpDisplayList count]];
    for (NSDictionary* tmpL4DescrDetailDict in tmpDisplayList) {
        [tmpL4DescrDetailCodeHashMap setObject:[tmpL4DescrDetailDict objectForKey:@"DescrDetailIUR"] forKey:[ArcosUtils convertNilToEmpty:[tmpL4DescrDetailDict objectForKey:@"DescrDetailCode"]]];        
    }
    NSArray* tmpL4DescrDetailCodeList = [tmpL4DescrDetailCodeHashMap allKeys];
//    NSLog(@"tmpL4DescrDetailCodeList: %d", [tmpL4DescrDetailCodeList count]);
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"DescrTypeCode = 'L5' and Active = 1 and ParentCode in %@", tmpL4DescrDetailCodeList];
    NSArray* properties = [NSArray arrayWithObjects:@"DescrDetailIUR", @"ImageIUR", @"Detail", @"DescrDetailCode", @"ParentCode", nil];
    NSMutableArray* l5ObjectArray = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"DescrDetail" withPropertiesToFetch:properties withPredicate:predicate withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
//    NSLog(@"l5ObjectArray: %d", [l5ObjectArray count]);
    NSMutableDictionary* tmpL5DescrDetailCodeDict = [NSMutableDictionary dictionaryWithCapacity:[l5ObjectArray count]];
    for (NSDictionary* l5DescrDetailDict in l5ObjectArray) {
        [tmpL5DescrDetailCodeDict setObject:[NSNull null] forKey:[ArcosUtils convertNilToEmpty:[l5DescrDetailDict objectForKey:@"DescrDetailCode"]]];
    }
    NSArray* tmpL5DescrDetailCodeList = [tmpL5DescrDetailCodeDict allKeys];
//    NSLog(@"tmpL5DescrDetailCodeList: %d", [tmpL5DescrDetailCodeList count]);
    NSMutableArray* l5CodeProductList = [[ArcosCoreData sharedArcosCoreData] activeProductWithL5CodeList:tmpL5DescrDetailCodeList];
//    NSLog(@"l5ListProductList: %d", [l5CodeProductList count]);
    NSMutableDictionary* l5CodeProductHashMap = [NSMutableDictionary dictionaryWithCapacity:[l5CodeProductList count]];
    for (NSDictionary* l5CodeProductDict in l5CodeProductList) {
        [l5CodeProductHashMap setObject:[l5CodeProductDict objectForKey:@"L5Code"] forKey:[l5CodeProductDict objectForKey:@"L5Code"]];
    }
//    NSLog(@"l5CodeProductHashMap: %d", [l5CodeProductHashMap count]);
    NSMutableArray* l4l5ActiveProductList = [NSMutableArray arrayWithCapacity:[l5ObjectArray count]];
    for (NSDictionary* tmpL5Object in l5ObjectArray) {
        if ([l5CodeProductHashMap objectForKey:[tmpL5Object objectForKey:@"DescrDetailCode"]] != nil) {//this l5 has product
            NSMutableDictionary* l4l5ActiveProductDict = [NSMutableDictionary dictionaryWithDictionary:tmpL5Object];
            [l4l5ActiveProductDict setObject:[tmpL4DescrDetailCodeHashMap objectForKey:[tmpL5Object objectForKey:@"ParentCode"]] forKey:@"L4CodeIUR"];
            [l4l5ActiveProductList addObject:l4l5ActiveProductDict];
        }        
    }
//    NSLog(@"l4l5ActiveProductList: %d", [l4l5ActiveProductList count]);
    if ([l4l5ActiveProductList count] == 0) {
        self.displayList = [NSMutableArray array];
        self.descrDetailList = [NSMutableArray array];
//        [ArcosUtils showMsg:@"Please Check for Active Product Group Assignments." delegate:nil];
        [ArcosUtils showDialogBox:@"Please Check for Active Product Group Assignments." title:@"" target:[ArcosUtils getRootView] handler:nil];
        return;
    }
    NSSortDescriptor* descriptor = [[[NSSortDescriptor alloc] initWithKey:@"L4CodeIUR" ascending:YES] autorelease];
    [l4l5ActiveProductList sortUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
//    NSLog(@"l4l5ActiveProductList: %@",l4l5ActiveProductList);
//    NSLog(@"l4l5ActiveProductList: %d %@", [l4l5ActiveProductList count], l4l5ActiveProductList);
    
//    NSLog(@"tmpProductList: %@ %d", l5ListProductList, [l5ListProductList count]);    
    self.displayList = [NSMutableArray arrayWithCapacity:[tmpDisplayList count]];        
    for (NSDictionary* tmpL4DescrDetailDict in tmpDisplayList) {
        NSNumber* l4CodeIUR = [tmpL4DescrDetailDict objectForKey:@"DescrDetailIUR"];
        int location = [self binarySearchWithArrayOfDict:l4l5ActiveProductList keyword:l4CodeIUR];
        if (location != -1) {
            int startIndex = location;
            int forwardLength = 0;
            for (int i = location - 1; i >= 0; i--) {//backward
                if ([l4CodeIUR isEqualToNumber:[[l4l5ActiveProductList objectAtIndex:i] objectForKey:@"L4CodeIUR"]]) {
                    startIndex = i;
                } else {
                    break;
                }            
            }
            for (int i = location + 1; i < [l4l5ActiveProductList count]; i++) {//forward
                if ([l4CodeIUR isEqualToNumber:[[l4l5ActiveProductList objectAtIndex:i] objectForKey:@"L4CodeIUR"]]) {
                    forwardLength++;
                } else {
                    break;
                }
            }
            NSArray* subsetL4l5ActiveProductList = [l4l5ActiveProductList subarrayWithRange:NSMakeRange(startIndex, location - startIndex + 1 + forwardLength)];
            NSMutableDictionary* l4DescrDetailDict = [NSMutableDictionary dictionaryWithDictionary:tmpL4DescrDetailDict];
            NSMutableArray* l5DescrDetailDictList = [NSMutableArray arrayWithArray:subsetL4l5ActiveProductList];
            
            NSSortDescriptor* l5Descriptor = [[[NSSortDescriptor alloc] initWithKey:@"Detail" ascending:YES selector:@selector(caseInsensitiveCompare:)] autorelease];
            [l5DescrDetailDictList sortUsingDescriptors:[NSArray arrayWithObjects:l5Descriptor,nil]];
            
            [l4DescrDetailDict setObject:l5DescrDetailDictList forKey:@"L5Children"];
            [self.displayList addObject:l4DescrDetailDict];
        }
    }
//    NSLog(@"self.displayList:%d", [self.displayList count]);
    [self processRawData:self.displayList];
}

- (void)processRawData:(NSMutableArray*)aDisplayList {
    self.descrDetailList = [NSMutableArray array];
    NSMutableArray* subsetDisplayList = [NSMutableArray array];
    for(int i = 0; i < [aDisplayList count]; i++) {
        [subsetDisplayList addObject:[aDisplayList objectAtIndex:i]];
        if ((i + 1) % [self.numberOfImages intValue] == 0) {
            [self.descrDetailList addObject:subsetDisplayList];
            subsetDisplayList = [NSMutableArray array];
        }
    }
    if ([subsetDisplayList count] > 0) {//the last loop
        [self.descrDetailList addObject:subsetDisplayList];        
    }
//    NSLog(@"self.descrDetailList is: %@", self.descrDetailList);
}

- (NSInteger)getNumberOfRows {
    float numberOfRows = (float)([self.displayList count] / 5.0f);
//    NSLog(@"numberOfRowsInSection is: %f, %d, %f", numberOfRows, (NSInteger)ceilf(numberOfRows), ceilf(numberOfRows));
    return (NSInteger)ceilf(numberOfRows);
}

- (void)searchDescrDetailWithKeyword:(NSString*)aKeyword {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"Detail BEGINSWITH[c] %@", aKeyword];
    NSArray* tmpArray = [self.displayList filteredArrayUsingPredicate:predicate];
    self.searchedDisplayList = [NSMutableArray arrayWithArray:tmpArray];    
    [self processRawData:self.searchedDisplayList];
}

- (void)clearDescrDetailList {
    self.descrDetailList = nil;
}

- (void)getAllDescrDetailList {
    [self processRawData:self.displayList];
}

- (int)binarySearchWithArrayOfDict:(NSMutableArray*)anArrayOfDict keyword:(NSNumber*)aKeyword {
    int loc = 0;
    int start = 0;
    unsigned int lengthOfArrayOfDict = [ArcosUtils convertNSUIntegerToUnsignedInt:anArrayOfDict.count];
    int end = lengthOfArrayOfDict - 1;
    int mid = lengthOfArrayOfDict / 2;
    
    while(start <= end && [[[anArrayOfDict objectAtIndex:mid] objectForKey:@"L4CodeIUR"] intValue] != [aKeyword intValue]) {
        if([aKeyword intValue] < [[[anArrayOfDict objectAtIndex:mid] objectForKey:@"L4CodeIUR"] intValue]) {
            end = mid - 1;
        }else{
            start = mid + 1;
        }
        mid = (start + end) / 2;
    }
    if([[[anArrayOfDict objectAtIndex:mid] objectForKey:@"L4CodeIUR"] intValue] == [aKeyword intValue]) {
        loc = mid;
    }else{
        loc = -1;
    }
    //    NSLog(@"%@ location is at: %d", aKeyword, loc);
    return loc;
}

@end
