//
//  LargeSmallImageFormRowsDataManager.m
//  Arcos
//
//  Created by David Kilmartin on 13/06/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "LargeSmallImageFormRowsDataManager.h"

@implementation LargeSmallImageFormRowsDataManager
@synthesize displayList = _displayList;
@synthesize slideViewItemList = _slideViewItemList;
@synthesize currentPage = _currentPage;
@synthesize previousPage = _previousPage;
@synthesize bufferSize = _bufferSize;
@synthesize halfBufferSize = _halfBufferSize;

- (id)init{
    self = [super init];
    if (self != nil) {
        self.displayList = [NSMutableArray array];        
        self.slideViewItemList = [NSMutableArray array];
        self.currentPage = 0;
        self.previousPage = 0;
        self.bufferSize = 7;
        self.halfBufferSize = self.bufferSize / 2;
    }
    return self;
}

- (void)dealloc {
    if (self.displayList != nil) { self.displayList = nil; }
    if (self.slideViewItemList != nil) { self.slideViewItemList = nil; }    
    
    [super dealloc];
}

- (void)createLargeSmallImageFormRowsData {
    ArcosFormDetailBO* arcosFormDetailBO = [[[ArcosFormDetailBO alloc] init] autorelease];
    arcosFormDetailBO.iur = 22;
    arcosFormDetailBO.Details = @"Large Small Image Product Drilldown";
    arcosFormDetailBO.DefaultDeliveryDate = [NSDate date];    
    arcosFormDetailBO.Active = YES;
    arcosFormDetailBO.FormType = 302;
    arcosFormDetailBO.Type = @"302";
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
        [ArcosUtils showMsg:@"Please Check for Active Product Group Assignments." delegate:nil];
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
//    NSLog(@"self.displayList:%d %@", [self.displayList count], self.displayList);
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

- (void)createLargeSmallImageSlideViewItemData {
    self.slideViewItemList = [NSMutableArray arrayWithCapacity:[self.displayList count]];
    for (int i = 0; i < [self.displayList count]; i++) {        
        LargeImageSlideViewItemController* LISVIC = [[LargeImageSlideViewItemController alloc]initWithNibName:@"LargeImageSlideViewItemController" bundle:nil];
        
        [self.slideViewItemList addObject:LISVIC];
        [LISVIC release];
    }
}

- (void)fillLargeSmallImageSlideViewItemWithIndex:(int)anIndex {
    LargeImageSlideViewItemController* aLISVIC = (LargeImageSlideViewItemController*)[self.slideViewItemList objectAtIndex:anIndex];
    NSMutableDictionary* cellDataDict = [self.displayList objectAtIndex:anIndex];
    NSNumber* imageIur = [cellDataDict objectForKey:@"ImageIUR"];
    UIImage* anImage = nil;
    BOOL isCompanyImage = NO;
    if ([imageIur intValue] > 0) {
        anImage= [[ArcosCoreData sharedArcosCoreData]thumbWithIUR:imageIur];
        //        anImage = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", [FileCommon photosPath],@"Benefiber.png"]];
    }else{
        anImage= [[ArcosCoreData sharedArcosCoreData]thumbWithIUR:[NSNumber numberWithInt:1]];        
        isCompanyImage = YES;
    }
    if (anImage == nil) {
        anImage = [UIImage imageNamed:@"iArcos_72.png"];
    }
//    anImage = [[ArcosCoreData sharedArcosCoreData]thumbWithIUR:[NSNumber numberWithInt:99575]];
    [aLISVIC.myButton setImage:anImage forState:UIControlStateNormal];
    if (isCompanyImage) {
        aLISVIC.myButton.alpha = [GlobalSharedClass shared].imageCellAlpha;
    } else {
        aLISVIC.myButton.alpha = 1.0;
    }
    aLISVIC.myButton.adjustsImageWhenHighlighted = NO;
}

- (void)createPlaceholderLargeSmallImageSlideViewItemData {
    self.slideViewItemList = [NSMutableArray arrayWithCapacity:[self.displayList count]];
    for (int i = 0; i < [self.displayList count]; i++) {
        [self.slideViewItemList addObject:[NSNull null]];
    }
}

@end
