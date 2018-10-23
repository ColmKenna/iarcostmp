//
//  ActivateConfigurationDataManager.h
//  iArcos
//
//  Created by David Kilmartin on 27/04/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileCommon.h"
#import "ArcosGenericClass.h"

@interface ActivateConfigurationDataManager : NSObject {
    
}

+ (id)configInstance;
- (void)createConfigurationPlist;
- (void)populateConfigurationPlistWithData:(NSMutableArray*)aDataList;
- (void)presetConfigurationPlistForDemo;

@end
