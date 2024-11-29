//
//  LocationCreditStatusDataManager.m
//  iArcos
//
//  Created by Richard on 27/11/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import "LocationCreditStatusDataManager.h"

@implementation LocationCreditStatusDataManager
@synthesize locationIURList = _locationIURList;
@synthesize locationIURHashMap = _locationIURHashMap;

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        
    }
    return self;
}

- (void)dealloc {
    self.locationIURList = nil;
    self.locationIURHashMap = nil;
    
    [super dealloc];
}

- (void)configImageWithLocationStatusButton:(UIButton*)aLocationStatusButton creditStatusButton:(UIButton*)aCreditStatusButton lsiur:(NSNumber*)aLsiur csiur:(NSNumber*)aCsiur {
    NSLog(@"aLsiur %@ %@", aLsiur, aCsiur);
    NSMutableArray* descrDetailIURList = [NSMutableArray arrayWithObjects:aLsiur, aCsiur, nil];
    NSMutableArray* descrDetailDictList = [[ArcosCoreData sharedArcosCoreData] descriptionWithIURList:descrDetailIURList];
    NSMutableDictionary* descrDetailDictHashMap = [NSMutableDictionary dictionaryWithCapacity:[descrDetailDictList count]];
    for (int i = 0; i < [descrDetailDictList count]; i++) {
        NSDictionary* auxDescrDetailDict = [descrDetailDictList objectAtIndex:i];
//        NSNumber* auxCodeType = [auxDescrDetailDict objectForKey:@"CodeType"];
//        if ([auxCodeType intValue] == 0) continue;
        NSNumber* auxDescrDetailIUR = [auxDescrDetailDict objectForKey:@"DescrDetailIUR"];
        NSNumber* auxImageIUR = [auxDescrDetailDict objectForKey:@"ImageIUR"];
        [descrDetailDictHashMap setObject:auxImageIUR forKey:auxDescrDetailIUR];
    }
    NSNumber* locationStatusImageIUR = [descrDetailDictHashMap objectForKey:aLsiur];
    if ([locationStatusImageIUR intValue] != 0) {
        UIImage* locationStatusImage = [[ArcosCoreData sharedArcosCoreData] thumbWithIUR:locationStatusImageIUR];
        if (locationStatusImage != nil) {
            [aLocationStatusButton setImage:locationStatusImage forState:UIControlStateNormal];
        }
    }
    NSNumber* creditStatusImageIUR = [descrDetailDictHashMap objectForKey:aCsiur];
    if ([creditStatusImageIUR intValue] != 0) {
        UIImage* creditStatusImage = [[ArcosCoreData sharedArcosCoreData] thumbWithIUR:creditStatusImageIUR];
        if (creditStatusImage != nil) {
            [aCreditStatusButton setImage:creditStatusImage forState:UIControlStateNormal];
        }
    }
}

@end
