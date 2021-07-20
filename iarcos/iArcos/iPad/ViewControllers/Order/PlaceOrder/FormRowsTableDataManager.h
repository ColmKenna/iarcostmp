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
}

@property(nonatomic, retain) NSDictionary* currentFormDetailDict;

- (NSMutableArray*)retrieveTableViewDataSourceWithSearchText:(NSString*)aSearchText;
- (NSMutableArray*)retrievePredicativeTableViewDataSource;

@end
