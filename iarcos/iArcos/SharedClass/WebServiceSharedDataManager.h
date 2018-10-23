//
//  WebServiceSharedDataManager.h
//  iArcos
//
//  Created by David Kilmartin on 04/07/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosCoreData.h"
@class ArcosRootViewController;

@interface WebServiceSharedDataManager : NSObject {
    ArcosRootViewController* _myRootViewController;
}

@property(nonatomic, retain) ArcosRootViewController* myRootViewController;

- (NSMutableArray*)retrieveAllLocationIUR;

- (void)removeAllSentOrderHeaderWithLocationIURList:(NSMutableArray*)aLocationIURList;

- (void)resetLocationList;
- (void)removeLocationProductMATWithLocationIURList:(NSMutableArray*)aLocationIURList;
- (void)removeLocationProductMATWithLevelIUR:(NSNumber*)aLevelIUR;

@end
