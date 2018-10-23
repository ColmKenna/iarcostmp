//
//  FormDetailDataManager.h
//  Arcos
//
//  Created by David Kilmartin on 05/11/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosCoreData.h"

@interface FormDetailDataManager : NSObject {
    NSMutableArray* _displayList;
    NSMutableArray* _formNameList;
    NSMutableDictionary* _formNameDict;
}

@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) NSMutableArray* formNameList;
@property(nonatomic, retain) NSMutableDictionary* formNameDict;

- (NSDictionary*)formDetailRecordDictWithIUR:(NSNumber*)aFormDetailIUR;
- (void)createBasicData;

@end
