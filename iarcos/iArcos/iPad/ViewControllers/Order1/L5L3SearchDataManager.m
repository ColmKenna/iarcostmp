//
//  L5L3SearchDataManager.m
//  Arcos
//
//  Created by David Kilmartin on 21/11/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "L5L3SearchDataManager.h"

@implementation L5L3SearchDataManager
@synthesize numberOfImages = _numberOfImages;
@synthesize displayList = _displayList;
@synthesize descrDetailList = _descrDetailList;
@synthesize searchedDisplayList = _searchedDisplayList;

- (id)init{
    self = [super init];
    if (self != nil) {
        self.numberOfImages = [NSNumber numberWithInt:5];
    }
    return self;
}

- (void)dealloc {
    if (self.numberOfImages != nil) { self.numberOfImages = nil; }    
    if (self.displayList != nil) { self.displayList = nil; }
    if (self.descrDetailList != nil) { self.descrDetailList = nil; }
    if (self.searchedDisplayList != nil) { self.searchedDisplayList = nil; }
    
    [super dealloc];
}

/*
 *
 */
- (void)getLevel5DescrDetail:(NSString*)aParentCode {
//    self.displayList = [[ArcosCoreData  sharedArcosCoreData] descrDetailWithDescrCodeType:@"L5" parentCode:aParentCode];
//@"58"    
    NSMutableArray* products = [[ArcosCoreData sharedArcosCoreData] productWithL3Code:aParentCode];
    NSMutableArray* l5CodeList = [NSMutableArray arrayWithCapacity:[products count]];
    for (NSMutableDictionary* product in products) {
        [l5CodeList addObject:[product objectForKey:@"L5Code"]];
    }
    NSLog(@"products is: %@ l5CodeList: %@", products, l5CodeList);
    self.displayList = [[ArcosCoreData sharedArcosCoreData] descrDetailWithL5CodeList:l5CodeList descrTypeCode:@"L5" active:1];
    NSLog(@"getLevel5DescrDetailself.displayList %@", self.displayList);
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

- (void)processRawData4DisplayList {
    [self processRawData:self.displayList];
}

@end
