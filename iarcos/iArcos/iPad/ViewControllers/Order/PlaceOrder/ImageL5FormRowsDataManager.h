//
//  ImageL5FormRowsDataManager.h
//  Arcos
//
//  Created by David Kilmartin on 23/10/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosCoreData.h"

@interface ImageL5FormRowsDataManager : NSObject {
    NSNumber* _numberOfImages;
    NSMutableArray* _displayList;
    NSMutableArray* _descrDetailList;
    NSMutableArray* _searchedDisplayList;
}

@property(nonatomic, retain) NSNumber* numberOfImages;
@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) NSMutableArray* descrDetailList;
@property(nonatomic, retain) NSMutableArray* searchedDisplayList;

- (void)getLevel5DescrDetail:(NSString*)aParentCode;
- (void)processRawData:(NSMutableArray*)aDisplayList;
- (void)searchDescrDetailWithKeyword:(NSString*)aKeyword;
- (void)clearDescrDetailList;
- (void)getAllDescrDetailList;
- (void)processRawData4DisplayList;

@end
