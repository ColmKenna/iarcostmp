//
//  MainPresenterDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 29/03/2016.
//  Copyright (c) 2016 Strata IT Limited. All rights reserved.
//

#import "MainPresenterDataManager.h"
@interface MainPresenterDataManager ()

- (NSMutableArray*)processSubsetArrayData:(NSMutableArray*)aDisplayList;

@end

@implementation MainPresenterDataManager
@synthesize displayList = _displayList;
@synthesize numberOfBtn = _numberOfBtn;

- (instancetype)init{
    self = [super init];
    if (self != nil) {
        self.numberOfBtn = 5;
    }
    
    return self;
}

- (void)dealloc {
    self.displayList = nil;
    
    [super dealloc];
}

- (void)retrieveMainPresenterDataList {
//    NSString* descrTypeCode = @"PP";
//    NSMutableArray* tmpDescrDetailList = [[ArcosAuxiliaryDataProcessor sharedArcosAuxiliaryDataProcessor] descrDetailAllFieldsWithDescrTypeCode:descrTypeCode activeOnly:YES];
    NSArray* keys = [NSArray arrayWithObjects:@"Detail", @"DescrDetailIUR", @"Active", nil];
    NSArray* objs = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@",[GlobalSharedClass shared].unassignedText], [NSNumber numberWithInt:0], [NSNumber numberWithInt:1], nil];
    NSDictionary* unassignedDict = [NSDictionary dictionaryWithObjects:objs forKeys:keys];
//    [tmpDescrDetailList insertObject:dict atIndex:0];
//    self.displayList = [self processSubsetArrayData:tmpDescrDetailList];
    NSArray* properties = [NSArray arrayWithObjects:@"LocationIUR",nil];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"parentIUR = 0 AND Active = 1"];
    NSMutableArray* presenterList = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"Presenter" withPropertiesToFetch:properties withPredicate:predicate withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:YES ascending:nil];
    NSMutableArray* locationIURList = [NSMutableArray arrayWithCapacity:[presenterList count]];
    for (NSDictionary* presenterDict in presenterList) {
        [locationIURList addObject:[presenterDict objectForKey:@"LocationIUR"]];
    }
    NSMutableArray* descrDetailList = [[ArcosCoreData sharedArcosCoreData] descriptionWithIURList:locationIURList];
    for (int i = 0; i < [descrDetailList count]; i++) {
        NSDictionary* tmpDescrDetailDict = [descrDetailList objectAtIndex:i];
        if ([[tmpDescrDetailDict objectForKey:@"DescrDetailIUR"] intValue] == 0) {
            [descrDetailList replaceObjectAtIndex:i withObject:unassignedDict];
        }
    }
    NSSortDescriptor* detailDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"Detail" ascending:YES];
    [descrDetailList sortUsingDescriptors:[NSArray arrayWithObject:detailDescriptor]];
    self.displayList = [self processSubsetArrayData:descrDetailList];
}

- (NSMutableArray*)processSubsetArrayData:(NSMutableArray*)aDisplayList {
    NSMutableArray* descrDetailArrayList  = [NSMutableArray array];
    NSMutableArray* subsetDisplayList = [NSMutableArray array];
    for(int i = 0; i < [aDisplayList count]; i++) {
        [subsetDisplayList addObject:[aDisplayList objectAtIndex:i]];
        if ((i + 1) % self.numberOfBtn == 0) {
            [descrDetailArrayList addObject:subsetDisplayList];
            subsetDisplayList = [NSMutableArray array];
        }
    }
    if ([subsetDisplayList count] > 0) {//the last loop
        [descrDetailArrayList addObject:subsetDisplayList];
    }
    return descrDetailArrayList;
}

@end
