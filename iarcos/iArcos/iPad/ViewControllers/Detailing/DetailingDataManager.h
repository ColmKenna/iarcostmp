//
//  DetailingDataManager.h
//  Arcos
//
//  Created by Apple on 01/02/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosCoreData.h"

@interface DetailingDataManager : NSObject {
    NSMutableDictionary* _detailingHeaderDict;
    NSMutableArray* _detailingActiveKeyList;
    NSMutableDictionary* _detailingRowDict;
    NSString* _basicInfoKey;
    NSString* _adoptionLadderKey;
    NSString* _keyMessagesKey;
    NSString* _samplesKey;
    NSString* _promotionalItemsKey;
    NSString* _presenterKey;
    NSString* _meetingContactKey;
    BOOL _isCallSaved;
    NSString* _actionType;
    NSString* _presentationsKey;
    NSMutableArray* _originalPresentationsDisplayList;
    NSMutableDictionary* _presentationsHashMap;
    NSMutableArray* _presentationsDisplayList;
}

@property(nonatomic, retain) NSMutableDictionary* detailingHeaderDict;
@property(nonatomic, retain) NSMutableArray* detailingActiveKeyList;
@property(nonatomic, retain) NSMutableDictionary* detailingRowDict;
@property(nonatomic, retain) NSString* basicInfoKey;
@property(nonatomic, retain) NSString* adoptionLadderKey;
@property(nonatomic, retain) NSString* keyMessagesKey;
@property(nonatomic, retain) NSString* samplesKey;
@property(nonatomic, retain) NSString* promotionalItemsKey;
@property(nonatomic, retain) NSString* presenterKey;
@property(nonatomic, retain) NSString* meetingContactKey;
@property(nonatomic, assign) BOOL isCallSaved;
@property (nonatomic, retain) NSString* actionType;
@property (nonatomic, retain) NSString* presentationsKey;
@property (nonatomic, retain) NSMutableArray* originalPresentationsDisplayList;
@property (nonatomic, retain) NSMutableDictionary* presentationsHashMap;
@property (nonatomic, retain) NSMutableArray* presentationsDisplayList;

- (void)createBasicData;
- (NSMutableArray*)rowListWithSection:(NSInteger)section;
- (NSString*)activeKeyWithSection:(NSInteger)section;
- (void)resetDataToShowResultOnlyWhenSent;
- (void)refreshContactField;
- (void)resetBranchData;
- (BOOL)presenterParentHasShownChildProcessor:(NSNumber*)aDescrDetailIUR;

@end
