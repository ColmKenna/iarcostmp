//
//  TargetDataManager.h
//  iArcos
//
//  Created by David Kilmartin on 30/08/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosGenericClass.h"
#import "ArcosUtils.h"
#import "ArcosArrayOfEmployeeTargets.h"
#import "ArcosEmployeeTargets.h"
#import "ArcosValidator.h"
#import "ArcosTargetDetail.h"
#import "ArcosDashBoardData.h"
#import "ArcosDashBoardRowData.h"

@interface TargetDataManager : NSObject {
    NSMutableArray* _displayList;
    NSDictionary* _monthMapDict;
}

@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) NSDictionary* monthMapDict;

- (void)createBasicData;
- (void)removeData;
- (void)processRawData:(ArcosArrayOfEmployeeTargets*)aDataList;
- (void)processG1RawData:(ArcosDashBoardData*)anArcosDashBoardData;

@end
