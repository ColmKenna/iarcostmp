//
//  UtilitiesConfigurationDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 24/04/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import "UtilitiesConfigurationDataManager.h"

@implementation UtilitiesConfigurationDataManager
@synthesize displayList = _displayList;
@synthesize originalDisplayList = _originalDisplayList;
@synthesize changedList = _changedList;

-(id)init {
    self = [super init];
    if (self != nil) {
        
    }
    
    return self;
}

- (void)dealloc {
    self.displayList = nil;
    self.originalDisplayList = nil;
    self.changedList = nil;
    
    [super dealloc];
}

- (void)retrieveDescrDetailIOData {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"DescrTypeCode = 'IO' and Active = 1"];
    NSArray* properties = [NSArray arrayWithObjects:@"Detail",@"DescrDetailCode",@"Tooltip", nil];
    NSArray* sortDescNames = [NSArray arrayWithObjects:@"Detail", nil];
    NSMutableArray* objectArray = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"DescrDetail" withPropertiesToFetch:properties withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    self.displayList = [NSMutableArray arrayWithCapacity:[objectArray count]];
    self.originalDisplayList = [NSMutableArray arrayWithCapacity:[objectArray count]];
    @try {
        for (int i = 0; i < [objectArray count]; i++) {
            NSDictionary* tmpDict = [objectArray objectAtIndex:i];
            NSMutableDictionary* descrDetailDict = [NSMutableDictionary dictionaryWithDictionary:tmpDict];
            NSString* descrDetailCode = [descrDetailDict objectForKey:@"DescrDetailCode"];
            NSNumber* descrDetailCodeIndex = [ArcosUtils convertStringToNumber:descrDetailCode];
            NSString* configValueString = [[ArcosConfigDataManager sharedArcosConfigDataManager].systemCodes substringWithRange:NSMakeRange([descrDetailCodeIndex intValue]-1, 1)];
            [descrDetailDict setObject:[ArcosUtils convertStringToNumber:configValueString] forKey:@"Toggle1"];
            NSMutableDictionary* originalDescrDetailDict = [NSMutableDictionary dictionaryWithDictionary:descrDetailDict];
            [self.displayList addObject:descrDetailDict];
            [self.originalDisplayList addObject:originalDescrDetailDict];
        }
    }
    @catch (NSException *exception) {
//        [ArcosUtils showMsg:[exception reason] delegate:nil];
        [ArcosUtils showDialogBox:[exception reason] title:@"" target:[ArcosUtils getRootView] handler:nil];
    }
    
}

- (void)inputFinishedWithData:(id)data forIndexpath:(NSIndexPath *)theIndexpath {
    NSMutableDictionary* descrDetailDict = [self.displayList objectAtIndex:theIndexpath.row];
    [descrDetailDict setObject:data forKey:@"Toggle1"];
}

- (void)retrieveChangedList {
    self.changedList = [NSMutableArray array];
    for (int i = 0; i < [self.displayList count]; i++) {
        NSMutableDictionary* descrDetailDict = [self.displayList objectAtIndex:i];
        NSMutableDictionary* originalDescrDetailDict = [self.originalDisplayList objectAtIndex:i];
        NSNumber* toggle1 = [descrDetailDict objectForKey:@"Toggle1"];
        NSNumber* originalToggle1 = [originalDescrDetailDict objectForKey:@"Toggle1"];
        if (![toggle1 isEqualToNumber:originalToggle1]) {
            [self.changedList addObject:descrDetailDict];
        }
    }
//    NSLog(@"changedList: %@",self.changedList);
}

- (void)saveChangedList {
    for (int i = 0; i < [self.changedList count]; i++) {
        NSMutableDictionary* descrDetailDict = [self.changedList objectAtIndex:i];
        NSString* descrDetailCode = [descrDetailDict objectForKey:@"DescrDetailCode"];
        NSNumber* descrDetailCodeIndex = [ArcosUtils convertStringToNumber:descrDetailCode];
        [ArcosConfigDataManager sharedArcosConfigDataManager].systemCodes = [[ArcosConfigDataManager sharedArcosConfigDataManager].systemCodes stringByReplacingCharactersInRange:NSMakeRange([descrDetailCodeIndex intValue]-1, 1) withString:[ArcosUtils convertNumberToIntString:[descrDetailDict objectForKey:@"Toggle1"]]];
    }
    [[ArcosConfigDataManager sharedArcosConfigDataManager] persistentSystemCodes];
    self.originalDisplayList = [NSMutableArray arrayWithCapacity:[self.displayList count]];
    for (NSMutableDictionary* tmpDescrDetailDict in self.displayList) {
        [self.originalDisplayList addObject:[NSMutableDictionary dictionaryWithDictionary:tmpDescrDetailDict]];
    }
//    [ArcosUtils showMsg:@"Configuration has been saved." delegate:nil];
}

@end
