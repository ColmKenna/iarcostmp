//
//  MATFormRowsDataManager.h
//  Arcos
//
//  Created by David Kilmartin on 26/09/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosGenericClass.h"
#import "ArcosCoreData.h"
#import "OrderSharedClass.h"
#import "ArcosCoreData.h"

@interface MATFormRowsDataManager : NSObject {
    NSMutableArray* _originalDisplayList;
    NSMutableArray* _displayList;
    ArcosGenericClass* _originalFieldNames;
    ArcosGenericClass* _fieldNames;
    NSMutableArray* _qtyBonDisplayList;
    NSMutableArray* _originalQtyBonDisplayList;
    int _totalClickTime;
}

@property(nonatomic, retain) NSMutableArray* originalDisplayList;
@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) ArcosGenericClass* originalFieldNames;
@property(nonatomic, retain) ArcosGenericClass* fieldNames;
@property(nonatomic, retain) NSMutableArray* qtyBonDisplayList;
@property(nonatomic, retain) NSMutableArray* originalQtyBonDisplayList;
@property(nonatomic, assign) int totalClickTime;

//- (void)processRawData:(NSMutableArray*)aDisplayList;
- (void)newProcessRawData:(NSMutableArray*)aDisplayList locationIUR:(NSNumber*)aLocationIUR packageIUR:(NSNumber*)aPackageIUR;
- (void)clearAllSubViews:(UIView*)aView;
- (void)createMATFormRowsData;
- (void)syncQtyBonDisplayList;
- (void)processLocationProductMATData:(NSNumber*)aLocationIUR packageIUR:(NSNumber*)aPackageIUR;
- (void)retrieveQtyBonDisplayListWithDisplayList:(NSMutableArray*)aDisplayList;

@end
