//
//  CustomerMemoDataManager.h
//  Arcos
//
//  Created by David Kilmartin on 24/02/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosGenericClass.h"
#import "ArcosUtils.h"
#import "SettingManager.h"
#import "ArcosCoreData.h"
#import "ArcosCreateRecordObject.h"

@interface CustomerMemoDataManager : NSObject {
    NSMutableArray* _displayList;
    NSMutableArray* _originalDisplayList;
    NSMutableArray* _changedDataList;
    NSString* _locationMemoDateString;
    NSMutableArray* _locationMemoOriginalDisplayList;
    NSMutableArray* _locationMemoChangedDataList;
    BOOL _isLocationMemoExistent;
    NSNumber* _locationIUR;
    ArcosCreateRecordObject* _locationMemoArcosCreateRecordObject;
}

@property(nonatomic,retain) NSMutableArray* displayList;
@property(nonatomic,retain) NSMutableArray* originalDisplayList;
@property(nonatomic,retain) NSMutableArray* changedDataList;
@property(nonatomic,retain) NSString* locationMemoDateString;
@property(nonatomic,retain) NSMutableArray* locationMemoOriginalDisplayList;
@property(nonatomic,retain) NSMutableArray* locationMemoChangedDataList;
@property(nonatomic,assign) BOOL isLocationMemoExistent;
@property(nonatomic,retain) NSNumber* locationIUR;
@property(nonatomic,retain) ArcosCreateRecordObject* locationMemoArcosCreateRecordObject;

-(void)processRawData:(NSMutableArray*)aDataList;
-(void)updateChangedData:(id)data withIndexPath:(NSIndexPath*)anIndexPath;
-(NSMutableArray*)getChangedDataList;
-(NSMutableArray*)getAllChangedDataList;
-(void)checkLocationMemoExistence;
-(NSString*)employeeName;
-(ArcosGenericClass*)createLocationMemoArcosGenericClass;
-(NSMutableArray*)getLocationMemoChangedDataList;

@end
