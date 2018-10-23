//
//  ReporterTrackDetailDataManager.h
//  Arcos
//
//  Created by David Kilmartin on 11/07/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SettingManager.h"

@interface ReporterTrackDetailDataManager : NSObject {
    NSMutableArray* _displayList;
}

@property(nonatomic, retain) NSMutableArray* displayList;

- (void)processRawData:(NSMutableArray*)anArrayOfData;
- (NSString*)createReportServerFilePath:(NSString*)fileName;

@end
