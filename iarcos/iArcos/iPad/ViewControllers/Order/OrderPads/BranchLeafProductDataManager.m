//
//  BranchLeafProductDataManager.m
//  Arcos
//
//  Created by David Kilmartin on 03/09/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "BranchLeafProductDataManager.h"

@implementation BranchLeafProductDataManager
@synthesize itemPerRow = _itemPerRow;
@synthesize displayList = _displayList;
@synthesize descrDetailList = _descrDetailList;
@synthesize selectedIndexPath = _selectedIndexPath;
@synthesize funcBtnProductSpecHashMap = _funcBtnProductSpecHashMap;
@synthesize productSectionDict = _productSectionDict;
@synthesize sortKeyList = _sortKeyList;
@synthesize formType = _formType;
@synthesize formTypeNumber = _formTypeNumber;
@synthesize formIUR = _formIUR;
@synthesize leafChildrenList = _leafChildrenList;
@synthesize currentFormDetailDict = _currentFormDetailDict;

- (id)init{
    self = [super init];
    if (self != nil) {
        self.itemPerRow = 4;
        self.funcBtnProductSpecHashMap = [NSMutableDictionary dictionaryWithCapacity:5];
        //must sync with product spec
        [self.funcBtnProductSpecHashMap setObject:@"Qty" forKey:[NSNumber numberWithInt:0]];
        [self.funcBtnProductSpecHashMap setObject:@"Bonus" forKey:[NSNumber numberWithInt:1]];
        [self.funcBtnProductSpecHashMap setObject:@"InStock" forKey:[NSNumber numberWithInt:2]];
        [self.funcBtnProductSpecHashMap setObject:@"FOC" forKey:[NSNumber numberWithInt:3]];
        [self.funcBtnProductSpecHashMap setObject:@"DiscountPercent" forKey:[NSNumber numberWithInt:4]];
    }
    return self;
}

- (void)dealloc {
    if (self.displayList != nil) { self.displayList = nil; }
    if (self.descrDetailList != nil) { self.descrDetailList = nil; }    
    if (self.selectedIndexPath != nil) { self.selectedIndexPath = nil; }
    if (self.funcBtnProductSpecHashMap != nil) { self.funcBtnProductSpecHashMap = nil; }
    if (self.productSectionDict != nil) { self.productSectionDict = nil; }
    if (self.sortKeyList != nil) { self.sortKeyList = nil; }
    if (self.formType != nil) { self.formType = nil; }
    if (self.formIUR != nil) { self.formIUR = nil; }
    if (self.leafChildrenList != nil) { self.leafChildrenList = nil; }
    self.currentFormDetailDict = nil;
    
    [super dealloc];
}

- (void)processRawData:(NSMutableArray*)aDisplayList {
    self.descrDetailList = [NSMutableArray array];
    NSMutableArray* subsetDisplayList = [NSMutableArray array];
    for(int i = 0; i < [aDisplayList count]; i++) {
        [subsetDisplayList addObject:[aDisplayList objectAtIndex:i]];
        if ((i + 1) % self.itemPerRow == 0) {
            [self.descrDetailList addObject:subsetDisplayList];
            subsetDisplayList = [NSMutableArray array];
        }
    }
    if ([subsetDisplayList count] > 0) {//the last loop
        [self.descrDetailList addObject:subsetDisplayList];        
    }
}

- (void)processRawData4DisplayList {
    [self processRawData:self.displayList];
}

- (void)categoriseSortedListIntoSection:(NSMutableArray*)aSortedList formTypeNumber:(int)aFormTypeNumber {
//    NSLog(@"aFormTypeNumber: %d", aFormTypeNumber);
    self.productSectionDict = [NSMutableDictionary dictionary];
    self.sortKeyList = [NSMutableArray array];
    if ([aSortedList count] == 0) return;    
    
    //get the first char of the  list
    NSString* currentChar = @"";
    if ([aSortedList count] > 0) {
        NSMutableDictionary* aDescrDetailDict = [aSortedList objectAtIndex:0];        
        NSString* detail = [aDescrDetailDict objectForKey:@"Details"];
        
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
    
    if (aFormTypeNumber == [[GlobalSharedClass shared].formRowFormTypeNumber intValue]) {
        [self.productSectionDict setObject:aSortedList forKey:currentChar];
        return;
    }
    
    //location and length used to get the sub array of customer list
    int location=0;
    int length=1;
    
    //start sorting the customer in to the sections
    for (int i = 1; i < [aSortedList count]; i++) {
        //sotring the name into the array
        NSMutableDictionary* aDescrDetailDict = [aSortedList objectAtIndex:i];
        NSString* detail = [aDescrDetailDict objectForKey:@"Details"];        
        
        if (detail == nil || [detail isEqualToString:@""]) {
            detail = @" ";
        }
        
        //sorting
        if ([currentChar caseInsensitiveCompare:[detail substringToIndex:1]]==NSOrderedSame) {
            
            
        }else{
            //store the sub array of customer to the section dictionary
            NSMutableArray* tempArray = [[aSortedList subarrayWithRange:NSMakeRange(location, length)]mutableCopy];
            [self.productSectionDict setObject:tempArray forKey:currentChar];
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
    [self.productSectionDict setObject:tempArray forKey:currentChar];
    [tempArray release];
//    NSLog(@"sortKeyList:%@, productSectionDict:%@", self.sortKeyList, self.productSectionDict);
}

- (void)getFormDividerWithFormIUR:(NSNumber*)aFormIUR {
    NSMutableArray* tmpLeafChildrenList = [[ArcosCoreData sharedArcosCoreData] selectionWithFormIUR:aFormIUR];
    self.leafChildrenList = [NSMutableArray arrayWithCapacity:[tmpLeafChildrenList count]];
    for (int i = 0; i < [tmpLeafChildrenList count]; i++) {
        NSDictionary* tmpDividerDict = [tmpLeafChildrenList objectAtIndex:i];
        NSMutableDictionary* dividerDict = [NSMutableDictionary dictionaryWithDictionary:tmpDividerDict];
        NSString* details = [ArcosUtils convertNilToEmpty:[dividerDict objectForKey:@"Details"]];
        [dividerDict setObject:details forKey:@"Detail"];
        [self.leafChildrenList addObject:dividerDict];
    }
}

- (void)fillTheUnsortListWithData:(NSMutableArray*)anUnsortedList {    
    for (int i=0; i < [anUnsortedList count]; i++) {
        NSMutableDictionary* aRow = [anUnsortedList objectAtIndex:i];
        
        NSString* combinationkey = [aRow objectForKey:@"CombinationKey"];
        
        NSMutableDictionary* aDict = [[OrderSharedClass sharedOrderSharedClass].currentOrderCart objectForKey:combinationkey];
        if (aDict!=nil) {
            [anUnsortedList replaceObjectAtIndex:i withObject:aDict];
        } else {
            [ProductFormRowConverter resetFormRowFigureWithFormRowDict:aRow];
        }
    }
}

- (NSMutableDictionary*)analyseLeafFormTypeRawData:(NSString*)aFormType {
    NSMutableDictionary* formTypeMiscDict = [NSMutableDictionary dictionaryWithCapacity:3];
    NSRange formTypeRange = NSMakeRange(0, 1);
    NSRange leafRange = NSMakeRange(2, 1);
    NSNumber* formTypeId = [ArcosUtils convertStringToNumber:[aFormType substringWithRange:formTypeRange]];
    NSString* leafCode = [aFormType substringWithRange:leafRange];
    NSString* leafDescrTypeCode = [NSString stringWithFormat:@"L%@", leafCode];
    NSString* leafLxCode = [NSString stringWithFormat:@"L%@Code", leafCode];
    [formTypeMiscDict setObject:formTypeId forKey:@"formTypeId"];
    [formTypeMiscDict setObject:leafDescrTypeCode forKey:@"leafDescrTypeCode"];
    [formTypeMiscDict setObject:leafLxCode forKey:@"leafLxCode"];

    return formTypeMiscDict;
}

- (void)retrieveLeafNodesWithLeafDescrTypeCode:(NSString*)anLeafDescrTypeCode leafLxCode:(NSString*)anLeafLxCode {
    NSMutableArray* tmpDisplayList = [[ArcosCoreData  sharedArcosCoreData] descrDetailWithDescrCodeType:anLeafDescrTypeCode parentCode:nil];
    NSMutableDictionary* leafDescrDetailIURHashMap = [NSMutableDictionary dictionaryWithCapacity:[tmpDisplayList count]];
    for (NSDictionary* tmpDescrDetailDict in tmpDisplayList) {
        NSString* leafDescDetailCode = [ArcosUtils convertNilToEmpty:[tmpDescrDetailDict objectForKey:@"DescrDetailCode"]];
        [leafDescrDetailIURHashMap setObject:[ArcosUtils convertNilToEmpty:[tmpDescrDetailDict objectForKey:@"DescrDetailIUR"]] forKey:leafDescDetailCode];
    }
    NSArray* tmpLeafDescrDetailCodeList = [leafDescrDetailIURHashMap allKeys];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"ColumnDescription >= '1' and %K in %@", anLeafLxCode, tmpLeafDescrDetailCodeList];
    NSArray* properties=[NSArray arrayWithObjects:anLeafLxCode, nil];
    
    NSMutableArray* objectsArray = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"Product" withPropertiesToFetch:properties  withPredicate:predicate withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:YES ascending:nil];
    NSMutableDictionary* productLeafLxCodeHashMap = [NSMutableDictionary dictionaryWithCapacity:[objectsArray count]];
    for (NSDictionary* productDict in objectsArray) {
        NSString* tmpLeafLxCode = [ArcosUtils convertNilToEmpty:[productDict objectForKey:anLeafLxCode]];
        [productLeafLxCodeHashMap setObject:tmpLeafLxCode forKey:tmpLeafLxCode];
    }
    self.leafChildrenList = [NSMutableArray arrayWithCapacity:[tmpDisplayList count]];
    for (NSDictionary* tmpDescrDetailDict in tmpDisplayList) {
        NSString* leafDescDetailCode = [ArcosUtils convertNilToEmpty:[tmpDescrDetailDict objectForKey:@"DescrDetailCode"]];
        if ([productLeafLxCodeHashMap objectForKey:leafDescDetailCode] != nil) {
            [self.leafChildrenList addObject:[NSDictionary dictionaryWithDictionary:tmpDescrDetailDict]];
        }
    }
    if ([self.leafChildrenList count] == 0) {
//        [ArcosUtils showMsg:@"Please Check for Active Product Group Assignments." delegate:nil];
        [ArcosUtils showDialogBox:@"Please Check for Active Product Group Assignments." title:@"" target:[ArcosUtils getRootView] handler:nil];
    }
//    NSLog(@"%@", self.leafChildrenList);
}

@end
