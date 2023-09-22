//
//  L3SearchDataManager.m
//  Arcos
//
//  Created by David Kilmartin on 21/11/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "L3SearchDataManager.h"

@implementation L3SearchDataManager
@synthesize numberOfImages = _numberOfImages;
@synthesize displayList = _displayList;
@synthesize descrDetailList = _descrDetailList;
@synthesize searchedDisplayList = _searchedDisplayList;
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
@synthesize branchLeafProductBaseDataManager = _branchLeafProductBaseDataManager;

- (id)init{
    self = [super init];
    if (self != nil) {
        self.numberOfImages = [NSNumber numberWithInt:5];
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
    if (self.searchedDisplayList != nil) { self.searchedDisplayList = nil; }
    
    if (self.descrDetailSectionDict != nil) { self.descrDetailSectionDict = nil; }
    if (self.sortKeyList != nil) { self.sortKeyList = nil; }
    if (self.formType != nil) { self.formType = nil; }
    if (self.branchDescrTypeCode != nil) { self.branchDescrTypeCode = nil; }
    if (self.leafDescrTypeCode != nil) { self.leafDescrTypeCode = nil; }
    if (self.branchLxCode != nil) { self.branchLxCode = nil; }
    if (self.leafLxCode != nil) { self.leafLxCode = nil; }
    if (self.branchLeafDataProcessCenter != nil) { self.branchLeafDataProcessCenter = nil; }
    if (self.branchLeafProductBaseDataManager != nil) { self.branchLeafProductBaseDataManager = nil; }
    
    [super dealloc];
}


- (void)createL3SearchFormRowsData {
    ArcosFormDetailBO* arcosFormDetailBO = [[[ArcosFormDetailBO alloc] init] autorelease];
    arcosFormDetailBO.iur = 15;
    arcosFormDetailBO.Details = @"L3Search";
    arcosFormDetailBO.DefaultDeliveryDate = [NSDate date];    
    arcosFormDetailBO.Active = YES;
    arcosFormDetailBO.FormType = 103;
    arcosFormDetailBO.Type = @"103";
    arcosFormDetailBO.PrintDeliveryDocket = NO;
    [[ArcosCoreData sharedArcosCoreData] loadFormDetailsWithSoapOB:arcosFormDetailBO];
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
        self.descrDetailList = [NSMutableArray array];
//        [ArcosUtils showMsg:@"Please Check for Active Product Assignments." delegate:nil];
        [ArcosUtils showDialogBox:@"Please Check for Active Product Assignments." title:@"" target:[ArcosUtils getRootView] handler:nil];
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
    [self processRawData:self.displayList];
    /*
    if ([self.displayList count] <= self.maxCount) {
        [self processRawData:self.displayList];
    }
    */
}

- (void)processRawData:(NSMutableArray*)aDisplayList {
    /*
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
    */
    [self categoriseSortedListIntoSection:aDisplayList];
}

- (void)searchDescrDetailWithKeyword:(NSString*)aKeyword {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"Detail BEGINSWITH[c] %@", aKeyword];
    NSArray* tmpArray = [self.displayList filteredArrayUsingPredicate:predicate];
    self.searchedDisplayList = [NSMutableArray arrayWithArray:tmpArray];
//    NSLog(@"self.searchedDisplayList count:%d %@",[self.searchedDisplayList count], self.searchedDisplayList);
    if ([aKeyword length] > 0) {
        self.sortKeyList = [NSMutableArray array];
        self.descrDetailSectionDict = [NSMutableDictionary dictionary];
        NSString* sortKey = [aKeyword substringToIndex:1];
        [self.sortKeyList addObject:sortKey];
        NSMutableArray* processedTempArray = [self processSubsetArrayData:self.searchedDisplayList];
        [self.descrDetailSectionDict setObject:processedTempArray forKey:sortKey];
        NSLog(@"sortKeyList-2: %@", self.sortKeyList);
        NSLog(@"descrDetailSectionDict-2: %@", self.descrDetailSectionDict);
    }
    
    [self processRawData:self.searchedDisplayList];
}

- (void)clearDescrDetailList {
    self.descrDetailList = nil;
}

- (void)getAllDescrDetailList {
    [self processRawData:self.displayList];
}

- (NSMutableArray*)getL5CodeList:(NSString*)aL3Code {
    NSMutableArray* products = [[ArcosCoreData sharedArcosCoreData] productWithL3Code:aL3Code];
    NSMutableArray* l5CodeList = [NSMutableArray arrayWithCapacity:[products count]];
    for (NSMutableDictionary* product in products) {
        [l5CodeList addObject:[product objectForKey:@"L5Code"]];
    }
    return l5CodeList;
}

- (NSArray*)getL5CodeListWithL3L5ProductList:(NSArray*)aL3L5ProductList {
    NSMutableDictionary* tmpL5ListDict = [NSMutableDictionary dictionaryWithCapacity:[aL3L5ProductList count]];
    for (NSDictionary* tmpL3L5Dict in aL3L5ProductList) {
        [tmpL5ListDict setObject:[NSNull null] forKey:[ArcosUtils convertNilToEmpty:[tmpL3L5Dict objectForKey:@"L5Code"]]];
    }
    return [tmpL5ListDict allKeys];
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

- (void)getBranchLeafData {
    [self retrieveAnalyseFormTypeRawData];
    switch ([self.formTypeId intValue]) {
        case 6: {
            self.branchLeafProductBaseDataManager = [[[BranchLeafProductListDataManager alloc] init] autorelease];
        }            
            break;
        case 7: {
            self.branchLeafProductBaseDataManager = [[[BranchLeafProductGridDataManager alloc] init] autorelease];
        }            
            break;
        default: {
            self.branchLeafProductBaseDataManager = [[[BranchLeafProductListDataManager alloc] init] autorelease];
        }
            break;
    }
    self.displayList = [self.branchLeafDataProcessCenter getBranchLeafData:self.branchDescrTypeCode leafDescrTypeCode:self.leafDescrTypeCode branchLxCode:self.branchLxCode leafLxCode:self.leafLxCode];
    [self categoriseSortedListIntoSection:self.displayList];
}

- (void)retrieveAnalyseFormTypeRawData {
    NSMutableDictionary* formTypeMiscDict = [self.branchLeafDataProcessCenter analyseFormTypeRawData:self.formType];
    self.formTypeId = [formTypeMiscDict objectForKey:@"formTypeId"];
    self.branchDescrTypeCode = [formTypeMiscDict objectForKey:@"branchDescrTypeCode"];
    self.leafDescrTypeCode = [formTypeMiscDict objectForKey:@"leafDescrTypeCode"];
    self.branchLxCode = [formTypeMiscDict objectForKey:@"branchLxCode"];
    self.leafLxCode = [formTypeMiscDict objectForKey:@"leafLxCode"];
}

- (void)createBranchBoxL45Data {
    ArcosFormDetailBO* arcosFormDetailBO = [[[ArcosFormDetailBO alloc] init] autorelease];
    arcosFormDetailBO.iur = 60;
    arcosFormDetailBO.Details = @"Branch Box Product Drilldown";
    arcosFormDetailBO.DefaultDeliveryDate = [NSDate date];    
    arcosFormDetailBO.Active = YES;
    arcosFormDetailBO.FormType = 645;
    arcosFormDetailBO.Type = @"645";
    arcosFormDetailBO.PrintDeliveryDocket = NO;
    [[ArcosCoreData sharedArcosCoreData] loadFormDetailsWithSoapOB:arcosFormDetailBO];
}

- (void)createBranchBoxL35Data {
    ArcosFormDetailBO* arcosFormDetailBO = [[[ArcosFormDetailBO alloc] init] autorelease];
    arcosFormDetailBO.iur = 61;
    arcosFormDetailBO.Details = @"Branch Box Brand Drilldown";
    arcosFormDetailBO.DefaultDeliveryDate = [NSDate date];    
    arcosFormDetailBO.Active = YES;
    arcosFormDetailBO.FormType = 635;
    arcosFormDetailBO.Type = @"635";
    arcosFormDetailBO.PrintDeliveryDocket = NO;
    [[ArcosCoreData sharedArcosCoreData] loadFormDetailsWithSoapOB:arcosFormDetailBO];
}

- (void)createBranchBoxGridL35Data {
    ArcosFormDetailBO* arcosFormDetailBO = [[[ArcosFormDetailBO alloc] init] autorelease];
    arcosFormDetailBO.iur = 71;
    arcosFormDetailBO.Details = @"Branch Box Grid Brand Drilldown";
    arcosFormDetailBO.DefaultDeliveryDate = [NSDate date];    
    arcosFormDetailBO.Active = YES;
    arcosFormDetailBO.FormType = 735;
    arcosFormDetailBO.Type = @"735";
    arcosFormDetailBO.PrintDeliveryDocket = NO;
    [[ArcosCoreData sharedArcosCoreData] loadFormDetailsWithSoapOB:arcosFormDetailBO];
}

- (void)createBranchBoxGridL45Data {
    ArcosFormDetailBO* arcosFormDetailBO = [[[ArcosFormDetailBO alloc] init] autorelease];
    arcosFormDetailBO.iur = 70;
    arcosFormDetailBO.Details = @"Branch Box Grid Product Drilldown";
    arcosFormDetailBO.DefaultDeliveryDate = [NSDate date];    
    arcosFormDetailBO.Active = YES;
    arcosFormDetailBO.FormType = 745;
    arcosFormDetailBO.Type = @"745";
    arcosFormDetailBO.PrintDeliveryDocket = NO;
    arcosFormDetailBO.ShowSeperators = YES;
    [[ArcosCoreData sharedArcosCoreData] loadFormDetailsWithSoapOB:arcosFormDetailBO];
}

@end
