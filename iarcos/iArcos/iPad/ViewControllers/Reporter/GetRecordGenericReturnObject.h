//
//  GetRecordGenericReturnObject.h
//  iArcos
//
//  Created by David Kilmartin on 20/05/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetRecordGenericReturnObject : NSObject {
    NSMutableArray* _fieldNameList;
    NSMutableArray* _displayList;
    NSMutableArray* _seqFieldTypeList;
    NSMutableDictionary* _groupedDataDict;
    NSMutableDictionary* _originalGroupedDataDict;
}

@property(nonatomic, retain) NSMutableArray* fieldNameList;
@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) NSMutableArray* seqFieldTypeList;
@property(nonatomic, retain) NSMutableDictionary* groupedDataDict;
@property(nonatomic, retain) NSMutableDictionary* originalGroupedDataDict;

- (void)configDataWithFieldNameList:(NSMutableArray*)aFieldNameList displayList:(NSMutableArray*)aDisplayList seqFieldTypeList:(NSMutableArray*)aSeqFieldTypeList groupedDataDict:(NSMutableDictionary*)aGroupedDataDict originalGroupedDataDict:(NSMutableDictionary*)anOriginalGroupedDataDict;

@end
