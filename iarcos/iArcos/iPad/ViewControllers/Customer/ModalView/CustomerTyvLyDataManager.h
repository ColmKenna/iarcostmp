//
//  CustomerTyvLyDataManager.h
//  iArcos
//
//  Created by David Kilmartin on 25/05/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosCoreData.h"

@interface CustomerTyvLyDataManager : NSObject {
    NSMutableArray* _displayList;
    NSString* _databaseName;
}

@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) NSString* databaseName;

- (void)processTyvLyWithLocationIUR:(NSNumber*)aLocationIUR;
//- (void)addProductInfoToDictionary:(NSMutableDictionary*)aLocationProductMatDict productDict:(NSDictionary*)aProductDict;
//- (void)addBlankProductInfoToDictionary:(NSMutableDictionary*)aLocationProductMatDict;

@end
