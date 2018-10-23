//
//  ImageFormRowsDataManager.h
//  Arcos
//
//  Created by David Kilmartin on 22/10/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosCoreData.h"

@interface ImageFormRowsDataManager : NSObject {
    NSNumber* _numberOfImages;
    NSMutableArray* _displayList;
    NSMutableArray* _descrDetailList;
    NSNumber* _numberOfRows;
    NSMutableArray* _searchedDisplayList;
}
@property(nonatomic, retain) NSNumber* numberOfImages;
@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) NSMutableArray* descrDetailList;
@property(nonatomic, retain) NSNumber* numberOfRows;
@property(nonatomic, retain) NSMutableArray* searchedDisplayList;

- (void)createImageFormRowsData;
- (void)getLevel4DescrDetail;
- (void)processRawData:(NSMutableArray*)aDisplayList;
- (NSInteger)getNumberOfRows;
- (void)searchDescrDetailWithKeyword:(NSString*)aKeyword;
- (void)clearDescrDetailList;
- (void)getAllDescrDetailList;
- (int)binarySearchWithArrayOfDict:(NSMutableArray*)anArrayOfDict keyword:(NSNumber*)aKeyword;


@end
