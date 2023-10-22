//
//  FlagsContactFlagDataManager.h
//  iArcos
//
//  Created by Richard on 20/10/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosCreateRecordObject.h"
#import "ArcosCoreData.h"

@interface FlagsContactFlagDataManager : NSObject {
    NSMutableArray* _displayList;
    ArcosCreateRecordObject* _ACRO;
}

@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) ArcosCreateRecordObject* ACRO;

- (void)createBasicData;
- (void)contactFlagWithFieldNameList:(NSMutableArray*)aFieldNameList fieldValueList:(NSMutableArray*)aFieldValueList iur:(NSNumber*)anIUR;

@end


