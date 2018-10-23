//
//  LargeSmallFormDetailDataManager.m
//  Arcos
//
//  Created by David Kilmartin on 19/07/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "LargeSmallFormDetailDataManager.h"

@implementation LargeSmallFormDetailDataManager
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

- (void)createLargeSmallFormDetailData {
    ArcosFormDetailBO* arcosFormDetailBO = [[[ArcosFormDetailBO alloc] init] autorelease];
    arcosFormDetailBO.iur = 30;
    arcosFormDetailBO.Details = @"Large Small OTC Order Pad";
    arcosFormDetailBO.DefaultDeliveryDate = [NSDate date];    
    arcosFormDetailBO.Active = YES;
    arcosFormDetailBO.FormType = 304;
    arcosFormDetailBO.Type = @"304";
    arcosFormDetailBO.PrintDeliveryDocket = NO;
    [[ArcosCoreData sharedArcosCoreData] loadFormDetailsWithSoapOB:arcosFormDetailBO];
}

/*
 *Divider
 * SubDivider
 * HasProduct
 */
- (void)getFormDividerDetail:(NSNumber*)aFormIUR {
    NSMutableArray* dividerList = [[ArcosCoreData sharedArcosCoreData] selectionWithFormIUR:aFormIUR];
//    NSLog(@"dividerList: %@", dividerList);
    NSMutableDictionary* dividerIURHashMap = [NSMutableDictionary dictionaryWithCapacity:[dividerList count]];
    for (NSDictionary* tmpDividerDict in dividerList) {
        [dividerIURHashMap setObject:[tmpDividerDict objectForKey:@"IUR"] forKey:[tmpDividerDict objectForKey:@"IUR"]];
    }
    NSArray* tmpDividerIURList = [dividerIURHashMap allKeys];
//    NSLog(@"tmpDividerIURList:%d %@", [tmpDividerIURList count],tmpDividerIURList);
    //product branch
    NSPredicate* dividerProductPredicate = [NSPredicate predicateWithFormat:@"ProductIUR > 0 and Level5IUR in %@", tmpDividerIURList];
    NSArray* dividerProductProperties = [NSArray arrayWithObjects:@"IUR", @"Level5IUR", nil];
    NSMutableArray* dividerProductObjectArray = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"FormRow" withPropertiesToFetch:dividerProductProperties withPredicate:dividerProductPredicate withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    NSMutableDictionary* dividerProductHashMap = [NSMutableDictionary dictionaryWithCapacity:[dividerProductObjectArray count]];
    for (NSDictionary* tmpProductDividerDict in dividerProductObjectArray) {
        [dividerProductHashMap setObject:[tmpProductDividerDict objectForKey:@"Level5IUR"] forKey:[tmpProductDividerDict objectForKey:@"Level5IUR"]];
    }
//    NSLog(@"dividerProductHashMap: %@",dividerProductHashMap);
    //end
    NSPredicate* subDividerPredicate = [NSPredicate predicateWithFormat:@"ProductIUR = -1 and Level5IUR in %@", tmpDividerIURList];
    NSArray* subDividerProperties = [NSArray arrayWithObjects:@"IUR", @"Level5IUR", @"ImageIUR", @"Details", @"SequenceNumber", @"FormIUR", nil];
    NSMutableArray* subDividerObjectArray = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"FormRow" withPropertiesToFetch:subDividerProperties withPredicate:subDividerPredicate withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
//    NSLog(@"subDividerObjectArray:%d %@", [subDividerObjectArray count],subDividerObjectArray);
    NSMutableDictionary* tmpSubDividerIURHashMap = [NSMutableDictionary dictionaryWithCapacity:[subDividerObjectArray count]];
    for (NSDictionary* tmpSubDividerDict in subDividerObjectArray) {
        [tmpSubDividerIURHashMap setObject:[NSNull null] forKey:[tmpSubDividerDict objectForKey:@"IUR"]];
    }
    NSArray* tmpSubDividerIURList = [tmpSubDividerIURHashMap allKeys];
//    NSLog(@"tmpSubDividerIURList:%d %@", [tmpSubDividerIURList count],tmpSubDividerIURList);
    NSPredicate* productPredicate = [NSPredicate predicateWithFormat:@"ProductIUR > 0 and Level5IUR in %@", tmpSubDividerIURList];
    NSArray* productProperties = [NSArray arrayWithObjects:@"IUR", @"Level5IUR", nil];
    NSMutableArray* productObjectArray = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"FormRow" withPropertiesToFetch:productProperties withPredicate:productPredicate withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
//    NSLog(@"productObjectArray: %@", productObjectArray);
    NSMutableDictionary* tmpProductLevel5IURHashMap = [NSMutableDictionary dictionaryWithCapacity:[productObjectArray count]];
    for (NSDictionary* tmpProductDict in productObjectArray) {
        [tmpProductLevel5IURHashMap setObject:[tmpProductDict objectForKey:@"Level5IUR"] forKey:[tmpProductDict objectForKey:@"Level5IUR"]];
    }
//    NSLog(@"tmpProductLevel5IURHashMap: %@", tmpProductLevel5IURHashMap);
    NSMutableArray* activeSubDividerProductList = [NSMutableArray arrayWithCapacity:[subDividerObjectArray count]];
    for (NSDictionary* tmpSubDividerDict in subDividerObjectArray) {
        if ([tmpProductLevel5IURHashMap objectForKey:[tmpSubDividerDict objectForKey:@"IUR"]] != nil) {//has product
            NSMutableDictionary* activeSubDividerProductDict = [NSMutableDictionary dictionaryWithDictionary:tmpSubDividerDict];
            [activeSubDividerProductList addObject:activeSubDividerProductDict];
        }
    }
//    NSLog(@"activeSubDividerProductList: %d %@", [activeSubDividerProductList count], activeSubDividerProductList);
    NSSortDescriptor* subDividerProductDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"Level5IUR" ascending:YES] autorelease];
    [activeSubDividerProductList sortUsingDescriptors:[NSArray arrayWithObjects:subDividerProductDescriptor,nil]];
    self.displayList = [NSMutableArray arrayWithCapacity:[dividerList count]];
    
    for (NSDictionary* tmpDividerDict in dividerList) {
        NSNumber* dividerIUR = [tmpDividerDict objectForKey:@"IUR"];
        int location = [self binarySearchWithArrayOfDict:activeSubDividerProductList keyword:dividerIUR];
        if (location != -1) {
            int startIndex = location;
            int forwardLength = 0;
            for (int i = location - 1; i >= 0; i--) {//backward
                if ([dividerIUR isEqualToNumber:[[activeSubDividerProductList objectAtIndex:i] objectForKey:@"Level5IUR"]]) {
                    startIndex = i;
                } else {
                    break;
                }            
            }
            for (int i = location + 1; i < [activeSubDividerProductList count]; i++) {//forward
                if ([dividerIUR isEqualToNumber:[[activeSubDividerProductList objectAtIndex:i] objectForKey:@"Level5IUR"]]) {
                    forwardLength++;
                } else {
                    break;
                }
            }
            NSArray* subsetActiveSubDividerProductList = [activeSubDividerProductList subarrayWithRange:NSMakeRange(startIndex, location - startIndex + 1 + forwardLength)];
            NSMutableDictionary* dividerDict = [NSMutableDictionary dictionaryWithDictionary:tmpDividerDict];
            NSMutableArray* subDividerDictList = [NSMutableArray arrayWithArray:subsetActiveSubDividerProductList];
            
            NSSortDescriptor* subDividerDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"SequenceNumber" ascending:YES] autorelease];
            [subDividerDictList sortUsingDescriptors:[NSArray arrayWithObjects:subDividerDescriptor,nil]];
            
            [dividerDict setObject:subDividerDictList forKey:@"SubDivider"];
            [dividerDict setObject:[NSNumber numberWithBool:NO] forKey:@"HasProduct"];
            [self.displayList addObject:dividerDict];
        } else {
            if ([dividerProductHashMap objectForKey:dividerIUR] != nil) {
                NSMutableDictionary* dividerDict = [NSMutableDictionary dictionaryWithDictionary:tmpDividerDict];
                [dividerDict setObject:[NSNumber numberWithBool:YES] forKey:@"HasProduct"];
                [self.displayList addObject:dividerDict];
            }
        }
    }
//    NSLog(@"self.displayList:%d %@", [self.displayList count], self.displayList);
}

- (int)binarySearchWithArrayOfDict:(NSMutableArray*)anArrayOfDict keyword:(NSNumber*)aKeyword {
    if ([anArrayOfDict count] == 0) return -1;
    int loc = 0;
    int start = 0;
    unsigned int lengthOfArrayOfDict = [ArcosUtils convertNSUIntegerToUnsignedInt:anArrayOfDict.count];
    int end = lengthOfArrayOfDict - 1;
    int mid = lengthOfArrayOfDict / 2;
    
    while(start <= end && [[[anArrayOfDict objectAtIndex:mid] objectForKey:@"Level5IUR"] intValue] != [aKeyword intValue]) {
        if([aKeyword intValue] < [[[anArrayOfDict objectAtIndex:mid] objectForKey:@"Level5IUR"] intValue]) {
            end = mid - 1;
        }else{
            start = mid + 1;
        }
        mid = (start + end) / 2;
    }
    if([[[anArrayOfDict objectAtIndex:mid] objectForKey:@"Level5IUR"] intValue] == [aKeyword intValue]) {
        loc = mid;
    }else{
        loc = -1;
    }
    //    NSLog(@"%@ location is at: %d", aKeyword, loc);
    return loc;
}

- (void)createLargeSmallFormDetailSlideViewItemData {
    self.slideViewItemList = [NSMutableArray arrayWithCapacity:[self.displayList count]];
    for (int i = 0; i < [self.displayList count]; i++) {        
        LargeImageSlideViewItemController* LISVIC = [[LargeImageSlideViewItemController alloc]initWithNibName:@"LargeImageSlideViewItemController" bundle:nil];
        
        [self.slideViewItemList addObject:LISVIC];
        [LISVIC release];
    }
}

- (void)fillLargeSmallFormDetailSlideViewItemWithIndex:(int)anIndex {
    LargeImageSlideViewItemController* aLISVIC = (LargeImageSlideViewItemController*)[self.slideViewItemList objectAtIndex:anIndex];
    NSMutableDictionary* cellDataDict = [self.displayList objectAtIndex:anIndex];
    NSNumber* imageIur = [cellDataDict objectForKey:@"ImageIUR"];
    UIImage* anImage = nil;
    BOOL isCompanyImage = NO;
    if ([imageIur intValue] > 0) {
        anImage= [[ArcosCoreData sharedArcosCoreData]thumbWithIUR:imageIur];        
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

- (void)createPlaceholderLargeSmallFormDetailSlideViewItemData {
    self.slideViewItemList = [NSMutableArray arrayWithCapacity:[self.displayList count]];
    for (int i = 0; i < [self.displayList count]; i++) {
        [self.slideViewItemList addObject:[NSNull null]];
    }
}

@end
