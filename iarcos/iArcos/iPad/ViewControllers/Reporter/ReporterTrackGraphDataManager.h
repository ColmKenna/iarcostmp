//
//  ReporterTrackGraphDataManager.h
//  Arcos
//
//  Created by David Kilmartin on 05/07/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosCoreData.h"

@interface ReporterTrackGraphDataManager : NSObject {
    NSMutableArray* _displayList;
    NSNumber* _employeeIUR;
    NSDictionary* _configDict;
    NSNumber* _maxOfBarAxis;
    NSMutableDictionary* _barSets;
    NSMutableArray* _xLabelList;
    NSMutableDictionary* _barDataDict;
    NSString* _buyKey;
    NSString* _notBuyKey;
    int _selectedBarRecordIndex;
    int _previousSelectedBarRecordIndex;
}

@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) NSNumber* employeeIUR;
@property(nonatomic, retain) NSDictionary* configDict;
@property(nonatomic, retain) NSNumber* maxOfBarAxis;
@property(nonatomic, retain) NSMutableDictionary* barSets;
@property(nonatomic, retain) NSMutableArray* xLabelList;
@property(nonatomic, retain) NSMutableDictionary* barDataDict;
@property(nonatomic, retain) NSString* buyKey;
@property(nonatomic, retain) NSString* notBuyKey;
@property(nonatomic, assign) int selectedBarRecordIndex;
@property(nonatomic, assign) int previousSelectedBarRecordIndex;

-(void)processRawData:(NSMutableArray*)anArrayOfData;

@end
