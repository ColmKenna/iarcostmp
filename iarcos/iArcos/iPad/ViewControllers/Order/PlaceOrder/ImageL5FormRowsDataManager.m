//
//  ImageL5FormRowsDataManager.m
//  Arcos
//
//  Created by David Kilmartin on 23/10/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "ImageL5FormRowsDataManager.h"

@implementation ImageL5FormRowsDataManager
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

- (void)getLevel5DescrDetail:(NSString*)aParentCode {
//    self.displayList = [[ArcosCoreData  sharedArcosCoreData] descrDetailWithDescrCodeType:@"L5" parentCode:aParentCode];
    NSMutableArray* tmpDisplayList = [[ArcosCoreData  sharedArcosCoreData] descrDetailWithDescrCodeType:@"L5" parentCode:aParentCode];
    self.displayList = [NSMutableArray arrayWithCapacity:[tmpDisplayList count]];
    for (NSDictionary* descrDetailDict in tmpDisplayList) {
        NSNumber* countActiveProduct = [[ArcosCoreData  sharedArcosCoreData] countActiveProductWithL5Code:[descrDetailDict objectForKey:@"DescrDetailCode"]];
        if ([countActiveProduct intValue] > 0) {
            [self.displayList addObject:descrDetailDict];
        }
    }
    
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
