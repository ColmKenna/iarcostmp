//
//  FormDetailDataManager.m
//  Arcos
//
//  Created by David Kilmartin on 05/11/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "FormDetailDataManager.h"

@implementation FormDetailDataManager
@synthesize displayList = _displayList;
@synthesize formNameList = _formNameList;
@synthesize formNameDict = _formNameDict;

- (id)init{
    self = [super init];
    if (self != nil) {
        self.displayList = [[ArcosCoreData sharedArcosCoreData] formDetailWithoutAll];
        self.formNameList = [NSMutableArray arrayWithObjects:@"Dynamic",@"Image Form (-2)", @"L3Search", @"Search", nil];
        self.formNameDict = [NSMutableDictionary dictionaryWithObjects:self.formNameList forKeys:self.formNameList];
    }
    return self;
}

- (void)dealloc {
    if (self.displayList != nil) { self.displayList = nil; }
    if (self.formNameList != nil) { self.formNameList = nil; }
    if (self.formNameDict != nil) { self.formNameDict = nil; }
    
    [super dealloc];
}

- (NSDictionary*)formDetailRecordDictWithIUR:(NSNumber*)aFormDetailIUR {
    for (int i = 0; i < [self.displayList count]; i++) {
        NSDictionary* formDetailRecordDict = [self.displayList objectAtIndex:i];
        NSNumber* formDetailIUR = [formDetailRecordDict objectForKey:@"IUR"];
        if ([formDetailIUR isEqualToNumber:aFormDetailIUR]) {
            return formDetailRecordDict;
        }
    }
    return nil;
}

- (void)createBasicData {
    self.displayList = [[ArcosCoreData sharedArcosCoreData] formDetailWithoutAll];
}


@end
