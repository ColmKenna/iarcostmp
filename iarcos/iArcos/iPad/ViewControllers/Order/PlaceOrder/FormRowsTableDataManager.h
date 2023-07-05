//
//  FormRowsTableDataManager.h
//  iArcos
//
//  Created by David Kilmartin on 19/04/2016.
//  Copyright (c) 2016 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosCoreData.h"
#import "OrderSharedClass.h"

@interface FormRowsTableDataManager : NSObject {
    NSDictionary* _currentFormDetailDict;
    BOOL _prevStandardOrderPadFlag;
    NSNumber* _prevNumber;
    NSIndexPath* _currentIndexPath;
}

@property(nonatomic, retain) NSDictionary* currentFormDetailDict;
@property(nonatomic, assign) BOOL prevStandardOrderPadFlag;
@property(nonatomic, retain) NSNumber* prevNumber;
@property(nonatomic, retain) NSIndexPath* currentIndexPath;

- (NSMutableArray*)retrieveTableViewDataSourceWithSearchText:(NSString*)aSearchText orderFormDetails:(NSString*)anOrderFormDetails;
- (NSMutableArray*)retrievePredicativeTableViewDataSourceWithOrderFormDetails:(NSString*)anOrderFormDetails;

@end
