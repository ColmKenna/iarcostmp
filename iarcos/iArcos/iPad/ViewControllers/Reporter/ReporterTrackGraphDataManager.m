//
//  ReporterTrackGraphDataManager.m
//  Arcos
//
//  Created by David Kilmartin on 05/07/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "ReporterTrackGraphDataManager.h"

@implementation ReporterTrackGraphDataManager
@synthesize displayList = _displayList;
//@synthesize data = _data;
//@synthesize sets = _sets;
//@synthesize dates = _dates;
@synthesize employeeIUR = _employeeIUR;
@synthesize configDict = _configDict;
@synthesize maxOfBarAxis = _maxOfBarAxis;
@synthesize barSets = _barSets;
@synthesize xLabelList = _xLabelList;
@synthesize barDataDict = _barDataDict;
@synthesize buyKey = _buyKey;
@synthesize notBuyKey = _notBuyKey;
@synthesize selectedBarRecordIndex = _selectedBarRecordIndex;
@synthesize previousSelectedBarRecordIndex = _previousSelectedBarRecordIndex;

- (id)init{
    self = [super init];
    if (self != nil) {
        self.buyKey = @"Buy";
        self.notBuyKey = @"Not Buy";
        self.displayList = [NSMutableArray array];
        self.employeeIUR = [SettingManager employeeIUR];
        NSLog(@"self.employeeIUR: %@", self.employeeIUR);
        self.configDict = [[ArcosCoreData sharedArcosCoreData] configWithIUR:[NSNumber numberWithInt:0]];
        self.maxOfBarAxis = [NSNumber numberWithInt:10];
        self.barSets = [NSMutableDictionary dictionaryWithObjectsAndKeys:[UIColor greenColor], @"Buy", [UIColor redColor], @"Not Buy", nil];
        self.xLabelList = [NSMutableArray array];             
        self.barDataDict = [NSMutableDictionary dictionary];
        self.selectedBarRecordIndex = 0;
        self.previousSelectedBarRecordIndex = 0;
    }
    return self;
}

- (void)dealloc {
    if (self.displayList != nil) { self.displayList = nil; }
    if (self.employeeIUR != nil) { self.employeeIUR = nil; }
    if (self.configDict != nil) { self.configDict = nil; }
    if (self.maxOfBarAxis != nil) { self.maxOfBarAxis = nil; }
    if (self.barSets != nil) { self.barSets = nil; }
    if (self.xLabelList != nil) { self.xLabelList = nil; }
    if (self.barDataDict != nil) { self.barDataDict = nil; }
    if (self.buyKey != nil) { self.buyKey = nil; }
    if (self.notBuyKey != nil) { self.notBuyKey = nil; } 
    
    [super dealloc];
}

-(void)processRawData:(NSMutableArray*)anArrayOfData {
    self.displayList = [NSMutableArray arrayWithCapacity:[anArrayOfData count]];
    self.xLabelList = [NSMutableArray arrayWithCapacity:[anArrayOfData count]];
    self.barDataDict = [NSMutableDictionary dictionaryWithCapacity:[anArrayOfData count]];
    for (int i = 0; i < [anArrayOfData count]; i++) {        
        ArcosGenericClass* tmpArcosGenericClass = [anArrayOfData objectAtIndex:i];
        [self.xLabelList addObject:[ArcosUtils convertNilToEmpty:tmpArcosGenericClass.Field4]];
        NSMutableDictionary* tmpDataDict = [NSMutableDictionary dictionaryWithCapacity:5];
        [tmpDataDict setObject:[ArcosUtils convertStringToNumber:[ArcosUtils convertBlankToZero:[ArcosUtils trim:tmpArcosGenericClass.Field1]]] forKey:@"IUR"];
        NSNumber* buyNumber = [ArcosUtils convertStringToNumber:[ArcosUtils convertBlankToZero:[ArcosUtils trim:tmpArcosGenericClass.Field2]]];
        NSNumber* notBuyNumber = [ArcosUtils convertStringToNumber:[ArcosUtils convertBlankToZero:[ArcosUtils trim:tmpArcosGenericClass.Field3]]];
        NSNumber* totalNumber = [NSNumber numberWithInt:([buyNumber intValue] + [notBuyNumber intValue])];
        [tmpDataDict setObject:buyNumber forKey:@"Buy"];
        [tmpDataDict setObject:notBuyNumber forKey:@"Not Buy"];
        [tmpDataDict setObject:totalNumber forKey:@"Total"];
        [tmpDataDict setObject:[ArcosUtils convertNilToEmpty:tmpArcosGenericClass.Field4] forKey:@"Details"];
        [self.displayList addObject:tmpDataDict];
    }
    NSNumber* tmpMaxOfBarAxis = [self.displayList valueForKeyPath:@"@max.Total"];
    if ([tmpMaxOfBarAxis compare:self.maxOfBarAxis] == NSOrderedDescending) {
        self.maxOfBarAxis = tmpMaxOfBarAxis;
    }
    NSLog(@"maxOfBarAxis: %@", self.maxOfBarAxis);
    
    for (int i = 0; i < [self.xLabelList count]; i++) {
        NSString* xLabel = [self.xLabelList objectAtIndex:i];
        NSMutableDictionary* tmpBarDataDict = [NSMutableDictionary dictionary];
        NSMutableDictionary* dataDict = [self.displayList objectAtIndex:i];
        [tmpBarDataDict setObject:[dataDict objectForKey:@"Buy"] forKey:self.buyKey];
        [tmpBarDataDict setObject:[dataDict objectForKey:@"Not Buy"] forKey:self.notBuyKey];
        [self.barDataDict setObject:tmpBarDataDict forKey:xLabel];
    }
}

@end
