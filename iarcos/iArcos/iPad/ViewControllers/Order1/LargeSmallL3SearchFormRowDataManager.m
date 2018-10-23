//
//  LargeSmallL3SearchFormRowDataManager.m
//  Arcos
//
//  Created by David Kilmartin on 09/07/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "LargeSmallL3SearchFormRowDataManager.h"

@implementation LargeSmallL3SearchFormRowDataManager
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

- (void)createLargeSmallL3SearchFormRowsData {
    ArcosFormDetailBO* arcosFormDetailBO = [[[ArcosFormDetailBO alloc] init] autorelease];
    arcosFormDetailBO.iur = 23;
    arcosFormDetailBO.Details = @"Large Small Search by Brand/PG";
    arcosFormDetailBO.DefaultDeliverDate = [NSDate date];    
    arcosFormDetailBO.Active = YES;
    arcosFormDetailBO.FormType = 303;
    arcosFormDetailBO.Type = @"303";
    arcosFormDetailBO.PrintDeliveryDocket = NO;
    [[ArcosCoreData sharedArcosCoreData] loadFormDetailsWithSoapOB:arcosFormDetailBO];
}

- (NSArray*)getL5CodeListWithL3L5ProductList:(NSArray*)aL3L5ProductList {
    NSMutableDictionary* tmpL5ListDict = [NSMutableDictionary dictionaryWithCapacity:[aL3L5ProductList count]];
    for (NSDictionary* tmpL3L5Dict in aL3L5ProductList) {
        [tmpL5ListDict setObject:[NSNull null] forKey:[ArcosUtils convertNilToEmpty:[tmpL3L5Dict objectForKey:@"L5Code"]]];
    }
    return [tmpL5ListDict allKeys];
}

/*
 * Dict
 *    -L5Children
 */
- (void)getLevel3DescrDetail {
    NSMutableArray* tmpDisplayList = [[ArcosCoreData  sharedArcosCoreData] descrDetailWithDescrCodeType:@"L3" parentCode:nil];
//    NSLog(@"tmpDisplayList: %@", tmpDisplayList);
    
    NSMutableDictionary* l3DescrDetailIURHashMap = [NSMutableDictionary dictionaryWithCapacity:[tmpDisplayList count]];
    for (NSDictionary* tmpDescrDetailDict in tmpDisplayList) {
        NSString* l3DescDetailCode = [ArcosUtils convertNilToEmpty:[tmpDescrDetailDict objectForKey:@"DescrDetailCode"]];
        [l3DescrDetailIURHashMap setObject:[ArcosUtils convertNilToEmpty:[tmpDescrDetailDict objectForKey:@"DescrDetailIUR"]] forKey:l3DescDetailCode];
    }
    NSArray* tmpL3DescrDetailCodeList = [l3DescrDetailIURHashMap allKeys];    
    
    NSMutableArray* tmpL3L5ProductList = [[ArcosCoreData sharedArcosCoreData] productWithL3CodeList:tmpL3DescrDetailCodeList];
//    NSLog(@"tmpL3L5ProductList: %@", tmpL3L5ProductList);
    NSArray* tmpL5CodeList = [self getL5CodeListWithL3L5ProductList:tmpL3L5ProductList];
    
    NSMutableArray* tmpL5DescrDetailCodeList = [[ArcosCoreData sharedArcosCoreData] descrDetailWithL5CodeList:tmpL5CodeList descrTypeCode:@"L5" active:1];
    
    NSMutableDictionary* tmpL5DescrDetailCodeHashMap = [NSMutableDictionary dictionaryWithCapacity:[tmpL5DescrDetailCodeList count]];
    for (NSDictionary* tmpL5DescrDetailCodeDict in tmpL5DescrDetailCodeList) {
        [tmpL5DescrDetailCodeHashMap setObject:tmpL5DescrDetailCodeDict forKey:[tmpL5DescrDetailCodeDict objectForKey:@"DescrDetailCode"]];
    }
    
    //filter l5code that is inactive in descrdetail
    /*
     *L3CodeIUR L3Code L5DescrDetail
     */
    NSMutableArray* tmpActiveL3L5ProductList = [NSMutableArray arrayWithCapacity:[tmpL3L5ProductList count]];
    for (int i = 0; i < [tmpL3L5ProductList count]; i++) {
        NSDictionary* tmpL3L5ProductDict = [tmpL3L5ProductList objectAtIndex:i];
        NSDictionary* tmpL5DescrDetailDict = [tmpL5DescrDetailCodeHashMap objectForKey:[tmpL3L5ProductDict objectForKey:@"L5Code"]];
        if (tmpL5DescrDetailDict != nil) {
            NSMutableDictionary* tmpActiveL3L5ProductDict = [NSMutableDictionary dictionaryWithCapacity:3];
            NSString* l3Code = [tmpL3L5ProductDict objectForKey:@"L3Code"];
            [tmpActiveL3L5ProductDict setObject:[l3DescrDetailIURHashMap objectForKey:l3Code] forKey:@"L3CodeIUR"];
            [tmpActiveL3L5ProductDict setObject:l3Code forKey:@"L3Code"];
            [tmpActiveL3L5ProductDict setObject:tmpL5DescrDetailDict forKey:@"L5DescrDetail"];            
            [tmpActiveL3L5ProductList addObject:tmpActiveL3L5ProductDict];
        }
    }
    if ([tmpActiveL3L5ProductList count] == 0) {
        self.displayList = [NSMutableArray array];
        [ArcosUtils showMsg:@"Please Check for Active Product Assignments." delegate:nil];
        return;
    }
    NSSortDescriptor* descriptor = [[[NSSortDescriptor alloc] initWithKey:@"L3CodeIUR" ascending:YES] autorelease];
    [tmpActiveL3L5ProductList sortUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
//    NSLog(@"tmpActiveL3L5ProductList count: %d", [tmpActiveL3L5ProductList count]);   
    
    self.displayList = [NSMutableArray arrayWithCapacity:[tmpDisplayList count]];
    for (NSDictionary* tmpL3DescrDetailDict in tmpDisplayList) {
        NSNumber* l3CodeIUR = [tmpL3DescrDetailDict objectForKey:@"DescrDetailIUR"];
        int location = [self binarySearchWithArrayOfDict:tmpActiveL3L5ProductList keyword:l3CodeIUR];
        if (location != -1) {
            int startIndex = location;
            int forwardLength = 0;
            for (int i = location - 1; i >= 0; i--) {//backward
                if ([l3CodeIUR isEqualToNumber:[[tmpActiveL3L5ProductList objectAtIndex:i] objectForKey:@"L3CodeIUR"]]) {
                    startIndex = i;
                } else {
                    break;
                }            
            }
            for (int i = location + 1; i < [tmpActiveL3L5ProductList count]; i++) {//forward
                if ([l3CodeIUR isEqualToNumber:[[tmpActiveL3L5ProductList objectAtIndex:i] objectForKey:@"L3CodeIUR"]]) {
                    forwardLength++;
                } else {
                    break;
                }
            }
            NSArray* subsetTmpActiveL3L5ProductList = [tmpActiveL3L5ProductList subarrayWithRange:NSMakeRange(startIndex, location - startIndex + 1 + forwardLength)];            
            NSMutableDictionary* l3DescrDetailDict = [NSMutableDictionary dictionaryWithDictionary:tmpL3DescrDetailDict];
            NSMutableArray* l5DescrDetailDictList = [NSMutableArray arrayWithCapacity:[subsetTmpActiveL3L5ProductList count]];
            
            for (NSDictionary* subsetTmpActiveL3L5ProductDict in subsetTmpActiveL3L5ProductList) {
                NSDictionary* l5DescrDetailDict = [subsetTmpActiveL3L5ProductDict objectForKey:@"L5DescrDetail"];
                [l5DescrDetailDictList addObject:[NSDictionary dictionaryWithDictionary:l5DescrDetailDict]];
            }
            NSSortDescriptor* l5Descriptor = [[[NSSortDescriptor alloc] initWithKey:@"Detail" ascending:YES selector:@selector(caseInsensitiveCompare:)] autorelease];
            [l5DescrDetailDictList sortUsingDescriptors:[NSArray arrayWithObjects:l5Descriptor,nil]];
            [l3DescrDetailDict setObject:l5DescrDetailDictList forKey:@"L5Children"];
            [self.displayList addObject:l3DescrDetailDict];
        }
    }
//    NSLog(@"self.displayList: %d %@", [self.displayList count], self.displayList);
    
}

- (int)binarySearchWithArrayOfDict:(NSMutableArray*)anArrayOfDict keyword:(NSNumber*)aKeyword {
    int loc = 0;
    int start = 0;
    unsigned int lengthOfArrayOfDict = [ArcosUtils convertNSUIntegerToUnsignedInt:anArrayOfDict.count];
    int end = lengthOfArrayOfDict - 1;
    int mid = lengthOfArrayOfDict / 2;
    
    while(start <= end && [[[anArrayOfDict objectAtIndex:mid] objectForKey:@"L3CodeIUR"] intValue] != [aKeyword intValue]) {
        if([aKeyword intValue] < [[[anArrayOfDict objectAtIndex:mid] objectForKey:@"L3CodeIUR"] intValue]) {
            end = mid - 1;
        }else{
            start = mid + 1;
        }
        mid = (start + end) / 2;
    }
    if([[[anArrayOfDict objectAtIndex:mid] objectForKey:@"L3CodeIUR"] intValue] == [aKeyword intValue]) {
        loc = mid;
    }else{
        loc = -1;
    }
    //    NSLog(@"%@ location is at: %d", aKeyword, loc);
    return loc;
}

- (void)createLargeSmallL3SearchSlideViewItemData {
    self.slideViewItemList = [NSMutableArray arrayWithCapacity:[self.displayList count]];
    for (int i = 0; i < [self.displayList count]; i++) {        
        LargeImageSlideViewItemController* LISVIC = [[LargeImageSlideViewItemController alloc]initWithNibName:@"LargeImageSlideViewItemController" bundle:nil];
        
        [self.slideViewItemList addObject:LISVIC];
        [LISVIC release];
    }
}

- (void)fillLargeSmallL3SearchSlideViewItemWithIndex:(int)anIndex {
    LargeImageSlideViewItemController* aLISVIC = (LargeImageSlideViewItemController*)[self.slideViewItemList objectAtIndex:anIndex];
    NSMutableDictionary* cellDataDict = [self.displayList objectAtIndex:anIndex];
    NSNumber* imageIur = [cellDataDict objectForKey:@"ImageIUR"];
    UIImage* anImage = nil;
    BOOL isCompanyImage = NO;
    if ([imageIur intValue] > 0) {
        anImage= [[ArcosCoreData sharedArcosCoreData]thumbWithIUR:imageIur];
        //        anImage = [[ArcosCoreData sharedArcosCoreData]thumbWithIUR:[NSNumber numberWithInt:99575]];
    }else{
        anImage= [[ArcosCoreData sharedArcosCoreData]thumbWithIUR:[NSNumber numberWithInt:1]];        
        isCompanyImage = YES;
    }
    if (anImage == nil) {
        anImage = [UIImage imageNamed:@"iArcos_72.png"];
    }
    [aLISVIC.myButton setImage:anImage forState:UIControlStateNormal];
    if (isCompanyImage) {
        aLISVIC.myButton.alpha = [GlobalSharedClass shared].imageCellAlpha;
    } else {
        aLISVIC.myButton.alpha = 1.0;
    }
    aLISVIC.myButton.adjustsImageWhenHighlighted = NO;
}

- (void)createPlaceholderLargeSmallL3SearchSlideViewItemData {
    self.slideViewItemList = [NSMutableArray arrayWithCapacity:[self.displayList count]];
    for (int i = 0; i < [self.displayList count]; i++) {
        [self.slideViewItemList addObject:[NSNull null]];
    }
}

@end
