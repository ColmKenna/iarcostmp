//
//  FlagsContactFlagDataManager.m
//  iArcos
//
//  Created by Richard on 20/10/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import "FlagsContactFlagDataManager.h"

@implementation FlagsContactFlagDataManager
@synthesize displayList = _displayList;
@synthesize ACRO = _ACRO;

- (void)dealloc {
    self.displayList = nil;
    self.ACRO = nil;
        
    [super dealloc];
}

- (void)createBasicData {
    self.displayList = [NSMutableArray arrayWithCapacity:1];
    NSMutableDictionary* dataDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [dataDict setObject:@"" forKey:@"fieldValue"];
    [self.displayList addObject:dataDict];
}

- (void)contactFlagWithFieldNameList:(NSMutableArray*)aFieldNameList fieldValueList:(NSMutableArray*)aFieldValueList iur:(NSNumber*)anIUR {
    NSManagedObjectContext* context = [[ArcosCoreData sharedArcosCoreData] addManagedObjectContext];
    DescrDetail* descrDetail = [NSEntityDescription insertNewObjectForEntityForName:@"DescrDetail" inManagedObjectContext:context];
    
    NSDictionary* propsDict = [PropertyUtils classPropsFor:[descrDetail class]];
        
    for (int i = 0; i < [aFieldNameList count]; i++) {
        NSString* aFieldName = [aFieldNameList objectAtIndex:i];
        NSString* aFieldValue = [aFieldValueList objectAtIndex:i];
        if ([aFieldName isEqualToString:@"Details"]) {
            aFieldName = @"Detail";
        }
        [PropertyUtils updateRecord:descrDetail fieldName:aFieldName fieldValue:aFieldValue propDict:propsDict];
    }
    descrDetail.DescrDetailIUR = anIUR;
    
    [[ArcosCoreData sharedArcosCoreData] saveContext:context];
}

@end
