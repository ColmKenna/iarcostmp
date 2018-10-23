//
//  CustomerFlagDataManager.h
//  Arcos
//
//  Created by David Kilmartin on 11/04/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosCoreData.h"
#import "ArcosGenericClass.h"
#import "ArcosCreateRecordObject.h"

@interface CustomerFlagDataManager : NSObject {
    NSMutableArray* _originalDisplayList;
    NSMutableArray* _displayList;
    NSNumber* _locationIUR;
    NSMutableArray* _changedDataList;
}

@property (nonatomic,retain) NSMutableArray* originalDisplayList;
@property (nonatomic,retain) NSMutableArray* displayList;
@property (nonatomic,retain) NSNumber* locationIUR;
@property (nonatomic,retain) NSMutableArray* changedDataList;

- (id)initWithLocationIUR:(NSNumber*)aLocationIUR;
- (void)createBasicData;
- (void)processRawData:(NSMutableArray*)anArrayOfData;
- (void)updateChangedData:(NSNumber*)aLocationFlag indexPath:(NSIndexPath*)anIndexPath;
- (void)getChangedDataList;

@end
