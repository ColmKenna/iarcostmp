//
//  FormRowsFooterMatDataManager.h
//  iArcos
//
//  Created by Richard on 14/08/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosCoreData.h"

@interface FormRowsFooterMatDataManager : NSObject {
    NSMutableArray* _displayList;
    BOOL _matDataFoundFlag;
    NSMutableArray* _headerMonthList;
}

@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, assign) BOOL matDataFoundFlag;
@property(nonatomic, retain) NSMutableArray* headerMonthList;

- (void)createBasicData;
- (void)retrieveFooterMatDataWithProductIUR:(NSNumber*)aProductIUR locationIUR:(NSNumber*)aLocationIUR;

@end

