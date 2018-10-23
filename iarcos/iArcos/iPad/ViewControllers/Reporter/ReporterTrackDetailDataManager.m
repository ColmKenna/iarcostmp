//
//  ReporterTrackDetailDataManager.m
//  Arcos
//
//  Created by David Kilmartin on 11/07/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "ReporterTrackDetailDataManager.h"

@implementation ReporterTrackDetailDataManager
@synthesize displayList = _displayList;

- (id)init{
    self = [super init];
    if (self != nil) {        
        self.displayList = [NSMutableArray array];
    }
    return self;
}

- (void)dealloc {
    if (self.displayList != nil) { self.displayList = nil; }
            
    [super dealloc];
}

- (void)processRawData:(NSMutableArray*)anArrayOfData {
    self.displayList = anArrayOfData;
}

- (NSString*)createReportServerFilePath:(NSString*)fileName {
    NSString* serviceAddress = [SettingManager serviceAddress];
    NSRange range;
    NSString* filePath = @"";
    @try {
        range = [serviceAddress rangeOfString:@"/" options:NSBackwardsSearch];
        filePath = [NSString stringWithFormat:@"%@/Resources/%@", [serviceAddress substringToIndex:range.location], fileName];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", [exception reason]);
    }    
    return filePath;
}

@end
