//
//  CustomerSurveyDetailsDataManager.h
//  iArcos
//
//  Created by David Kilmartin on 21/06/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosGenericClass.h"
#import "ArcosUtils.h"
#import "ArcosCoreData.h"

@interface CustomerSurveyDetailsDataManager : NSObject {
    NSMutableArray* _displayList;
    NSMutableArray* _sectionNoList;
    NSMutableDictionary* _groupedDataDict;
    NSMutableArray* _sectionTitleList;
    NSString* _editFieldName;
    NSIndexPath* _currentIndexPath;
}

@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) NSMutableArray* sectionNoList;
@property(nonatomic, retain) NSMutableDictionary* groupedDataDict;
@property(nonatomic, retain) NSMutableArray* sectionTitleList;
@property(nonatomic, retain) NSString* editFieldName;
@property(nonatomic, retain) NSIndexPath* currentIndexPath;

- (void)processRawData:(NSMutableArray*)aDataList;
- (ArcosGenericClass*)cellDataWithIndexPath:(NSIndexPath*)anIndexPath;
- (NSString*)buildEmailMessage;
- (void)updateResponseRecord;
- (void)updateBooleanResponseRecord;

@end
