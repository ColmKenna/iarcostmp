//
//  DashboardGenericDataManager.h
//  iArcos
//
//  Created by David Kilmartin on 15/05/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DashboardGenericDataManager : NSObject {
    NSMutableArray* _displayList;
}

@property(nonatomic, retain) NSMutableArray* displayList;

- (void)createBasicData;

@end
