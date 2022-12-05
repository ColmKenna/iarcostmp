//
//  ReporterMainDataManager.m
//  Arcos
//
//  Created by David Kilmartin on 01/07/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "ReporterMainDataManager.h"

@implementation ReporterMainDataManager
@synthesize displayList = _displayList;
@synthesize dateDictDisplayList = _dateDictDisplayList;
@synthesize locationList = _locationList;
@synthesize selectedReporterHolder = _selectedReporterHolder;

- (id)init{
    self = [super init];
    if (self != nil) {
        self.displayList = [NSMutableArray array];
        self.dateDictDisplayList = [NSMutableArray array];
        self.locationList = [NSMutableArray array];
    }
    return self;
}

- (void)dealloc {
    if (self.displayList != nil) { self.displayList = nil; }
    if (self.dateDictDisplayList != nil) { self.dateDictDisplayList = nil; }    
    if (self.locationList != nil) { self.locationList = nil; }
    self.selectedReporterHolder = nil;
    
    [super dealloc];
}

- (void)processRawData:(NSMutableArray*)aDisplayList {
    self.displayList = aDisplayList;
    self.dateDictDisplayList = [NSMutableArray arrayWithCapacity:[self.displayList count]];
    for (int i = 0; i < [self.displayList count]; i++) {
        ArcosGenericClass* aReporter = [self.displayList objectAtIndex:i];
        NSDate* tmpStartDate = [ArcosUtils convertNilDateToDate:[ArcosUtils dateFromString:aReporter.Field12 format:[GlobalSharedClass shared].dateFormat]];
        
        NSDate* tmpEndDate = [ArcosUtils convertNilDateToDate:[ArcosUtils dateFromString:aReporter.Field13 format:[GlobalSharedClass shared].dateFormat]];
        NSMutableDictionary* tmpDateDict = [NSMutableDictionary dictionaryWithCapacity:6];
        [tmpDateDict setObject:tmpStartDate forKey:@"StartDate"];
        [tmpDateDict setObject:tmpEndDate forKey:@"EndDate"];
        [tmpDateDict setObject:@"Location" forKey:@"TableName"];
        [tmpDateDict setObject:[NSNumber numberWithInt:0] forKey:@"SelectedIUR"];
        [tmpDateDict setObject:@"All" forKey:@"SelectedIURName"];
        if (![[ArcosUtils trim:[ArcosUtils convertNilToEmpty:aReporter.Field15]] isEqualToString:@""]) {
            [tmpDateDict setObject:[ArcosUtils trim:[ArcosUtils convertNilToEmpty:aReporter.Field16]] forKey:@"SortBy"];
        }
        [self.dateDictDisplayList addObject:tmpDateDict];
    }
    
    self.locationList = [[ArcosCoreData sharedArcosCoreData]outletsWithMasterIUR:[NSNumber numberWithInt:-1] withResultType:NSDictionaryResultType];
}

- (void)dateSelectedFromDate:(NSDate*)aStartDate ToDate:(NSDate*)anEndDate indexPath:(NSIndexPath*)anIndexPath {
    NSMutableDictionary* dateDict = [self.dateDictDisplayList objectAtIndex:anIndexPath.row];
    [dateDict setObject:aStartDate forKey:@"StartDate"];
    [dateDict setObject:anEndDate forKey:@"EndDate"];    
}

- (void)didSelectCustomerSelectionListingRecord:(NSMutableDictionary*)aCustDict indexPath:(NSIndexPath *)anIndexPath {
    NSMutableDictionary* dateDict = [self.dateDictDisplayList objectAtIndex:anIndexPath.row];
    [dateDict setObject:[aCustDict objectForKey:@"Name"] forKey:@"SelectedIURName"];
    [dateDict setObject:[aCustDict objectForKey:@"LocationIUR"] forKey:@"SelectedIUR"];
}

@end
