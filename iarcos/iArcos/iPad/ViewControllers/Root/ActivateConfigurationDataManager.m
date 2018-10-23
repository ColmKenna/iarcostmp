//
//  ActivateConfigurationDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 27/04/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import "ActivateConfigurationDataManager.h"
#import "ArcosUtils.h"
#import "ArcosConfigDataManager.h"
#import "ArcosCoreData.h"

@implementation ActivateConfigurationDataManager

+ (id)configInstance {
    return [[[self alloc] init] autorelease];
}

- (void)createConfigurationPlist {
    NSMutableDictionary* configDict = [NSMutableDictionary dictionaryWithCapacity:1];
    NSMutableString* systemCodesContent = [NSMutableString string];
    for (int i = 0; i < 100; i++) {
        [systemCodesContent appendString:@"0"];
    }
    [configDict setObject:systemCodesContent forKey:@"SystemCodes"];
    [configDict writeToFile:[FileCommon configurationPlistPath] atomically:YES];
    [[ArcosConfigDataManager sharedArcosConfigDataManager] resetSystemCodes:systemCodesContent];
}

- (void)populateConfigurationPlistWithData:(NSMutableArray*)aDataList {
    for (int i = 0; i < [aDataList count]; i++) {
        ArcosGenericClass* arcosGenericClass = [aDataList objectAtIndex:i];
        NSString* descrDetailCode = [arcosGenericClass Field2];
        NSNumber* descrDetailCodeIndex = [ArcosUtils convertStringToNumber:descrDetailCode];
        [ArcosConfigDataManager sharedArcosConfigDataManager].systemCodes = [[ArcosConfigDataManager sharedArcosConfigDataManager].systemCodes stringByReplacingCharactersInRange:NSMakeRange([descrDetailCodeIndex intValue]-1, 1) withString:[NSString stringWithFormat:@"%d", [[NSNumber numberWithBool: [ArcosUtils convertStringToBool:arcosGenericClass.Field3]] intValue]]];
    }
    [[ArcosConfigDataManager sharedArcosConfigDataManager] persistentSystemCodes];
}

- (void)presetConfigurationPlistForDemo {
    NSArray* properties = [NSArray arrayWithObjects:@"Detail", @"DescrDetailCode", @"Toggle1", nil];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"DescrTypeCode = 'IO' and Active = 1"];
    NSMutableArray* objectArray = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"DescrDetail" withPropertiesToFetch:properties  withPredicate:predicate withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    if ([objectArray count] > 0) {
        for (int i = 0; i < [objectArray count]; i++) {
            NSDictionary* auxDescrDetailDict = [objectArray objectAtIndex:i];
            NSString* descrDetailCode = [auxDescrDetailDict objectForKey:@"DescrDetailCode"];
            NSNumber* descrDetailCodeIndex = [ArcosUtils convertStringToNumber:descrDetailCode];
            NSNumber* toggle1 = [auxDescrDetailDict objectForKey:@"Toggle1"];
            if (([descrDetailCodeIndex intValue] == 37 || [descrDetailCodeIndex intValue] == 38) && [toggle1 intValue] == 1) {
                [ArcosConfigDataManager sharedArcosConfigDataManager].systemCodes = [[ArcosConfigDataManager sharedArcosConfigDataManager].systemCodes stringByReplacingCharactersInRange:NSMakeRange([descrDetailCodeIndex intValue]-1, 1) withString:[NSString stringWithFormat:@"%d", [toggle1 intValue]]];
            }            
        }
        [[ArcosConfigDataManager sharedArcosConfigDataManager] persistentSystemCodes];
    }
}

@end
