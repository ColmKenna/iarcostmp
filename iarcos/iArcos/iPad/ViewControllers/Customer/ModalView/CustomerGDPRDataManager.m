//
//  CustomerGDPRDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 03/05/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "CustomerGDPRDataManager.h"

@implementation CustomerGDPRDataManager
@synthesize displayList = _displayList;
@synthesize locationIUR = _locationIUR;
@synthesize locationName = _locationName;
@synthesize locationAddress = _locationAddress;
@synthesize contactDict = _contactDict;
@synthesize orderHeader = _orderHeader;
@synthesize configErrorMsg = _configErrorMsg;
@synthesize callTranList = _callTranList;
@synthesize detailIUR = _detailIUR;
@synthesize score = _score;

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        [self createBasicData];
    }
    return self;
}

- (void)dealloc {
    self.displayList = nil;
    self.locationIUR = nil;
    self.locationName = nil;
    self.locationAddress = nil;
    self.contactDict = nil;
    self.orderHeader = nil;
    self.configErrorMsg = nil;
    self.callTranList = nil;
    self.detailIUR = nil;
    self.score = nil;
    
    [super dealloc];
}

- (void)createBasicData {
    self.displayList = [NSMutableArray arrayWithCapacity:2];
    [self.displayList addObject:[self createDataDictWithIUR:[NSNumber numberWithInt:10] title:@"Consent" tickFlag:[NSNumber numberWithBool:NO]]];
    [self.displayList addObject:[self createDataDictWithIUR:[NSNumber numberWithInt:20] title:@"Withdraw" tickFlag:[NSNumber numberWithBool:NO]]];
    self.configErrorMsg = @"System not Configured for GDPR -\nTry FULL download of Description table";
}

- (NSMutableDictionary*)createDataDictWithIUR:(NSNumber*)anIUR title:(NSString*)aTitle tickFlag:(NSNumber*)aTickFlag {
    NSMutableDictionary* dataDict = [NSMutableDictionary dictionaryWithCapacity:3];
    [dataDict setObject:anIUR forKey:@"IUR"];
    [dataDict setObject:aTitle forKey:@"Title"];
    [dataDict setObject:aTickFlag forKey:@"TickFlag"];
    return dataDict;
}

- (BOOL)enableSignatureAmendment {
    BOOL tickFlagResult = [self tickSelectedCondition];
    if (tickFlagResult) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)tickSelectedCondition {
    BOOL tickFlagResult = NO;
    for (int i = 0; i < [self.displayList count]; i++) {
        NSMutableDictionary* auxDataDict = [self.displayList objectAtIndex:i];
        if ([[auxDataDict objectForKey:@"TickFlag"] boolValue]) {
            tickFlagResult = YES;
        }
    }
    return tickFlagResult;
}

- (NSNumber*)tickSelectedIUR {
    NSNumber* selectedIUR = nil;
    for (int i = 0; i < [self.displayList count]; i++) {
        NSMutableDictionary* auxDataDict = [self.displayList objectAtIndex:i];
        if ([[auxDataDict objectForKey:@"TickFlag"] boolValue]) {
            selectedIUR = [auxDataDict objectForKey:@"IUR"];
        }
    }
    return selectedIUR;
}

- (BOOL)contactSelectedCondition {
    BOOL contactSelectedFlag = NO;
    if (self.contactDict != nil && [[self.contactDict objectForKey:@"IUR"] intValue] != 0) {
        contactSelectedFlag = YES;
    }
    return contactSelectedFlag;
}



@end
