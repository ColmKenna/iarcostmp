//
//  ActivateLocalDataManager.h
//  Arcos
//
//  Created by David Kilmartin on 22/04/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileCommon.h"
#import "ArcosXMLParser.h"
#import "ArcosCoreData.h"
#import "ActivateProgressViewUpdateDelegate.h"
#import "ActivateAppStatusManager.h"


@interface ActivateLocalDataManager : NSObject {
    id<ActivateProgressViewUpdateDelegate> _updateDelegate;
    NSTimer* _mainTimer;
    BOOL _isMainLoadingFinished;    
    
    NSTimer* _subTimer;
    BOOL _isSubLoadingFinished;
    NSMutableArray* _subFileList;
    NSMutableArray* _subIndexList;
    NSUInteger _subFileCount;
    float _timeLength;
    float _halfTimeLength;
    
    NSMutableArray* _selectorList;
    NSString* _currentSelectorName;
    
    NSMutableArray* _presenterFileList;
    NSUInteger _totalSelectorLength;
    BOOL _isFree;
}

@property(nonatomic, assign) id<ActivateProgressViewUpdateDelegate> updateDelegate;
@property(nonatomic,retain) NSTimer* mainTimer;
@property(nonatomic, assign) BOOL isMainLoadingFinished;
@property(nonatomic,retain) NSTimer* subTimer;
@property(nonatomic, assign) BOOL isSubLoadingFinished;
@property(nonatomic,retain) NSMutableArray* subFileList;
@property(nonatomic,retain) NSMutableArray* subIndexList;
@property(nonatomic, assign) NSUInteger subFileCount;
@property(nonatomic, assign) float timeLength;
@property(nonatomic, assign) float halfTimeLength;

@property(nonatomic,retain) NSMutableArray* selectorList;
@property(nonatomic,retain) NSString* currentSelectorName;
@property(nonatomic,retain) NSMutableArray* presenterFileList;
@property(nonatomic, assign) NSUInteger totalSelectorLength;
@property(nonatomic, assign) BOOL isFree;

- (void)buildSelectorDataList;
- (void)pushSelector:(SEL)aSelector withName:(NSString*)aName;
- (SEL)popSelector;
- (NSMutableDictionary*)createDataWithSelectorName:(NSString*)aSelectorName;
- (void)importAllData;
- (void)checkAllData;

- (void)importLocationData;
- (void)checkLocationDataCenter;
- (void)processLocationDataCenter;

- (void)importSurveyData;
- (void)checkSurveyDataCenter;
- (void)processSurveyDataCenter;

- (void)importConfigData;
- (void)checkConfigDataCenter;
- (void)processConfigDataCenter;

- (void)importDescrDetailData;
- (void)checkDescrDetailDataCenter;
- (void)processDescrDetailDataCenter;

- (void)importDescrTypeData;
- (void)checkDescrTypeDataCenter;
- (void)processDescrTypeDataCenter;

- (void)importImageData;
- (void)checkImageDataCenter;
- (void)processImageDataCenter;

- (void)importEmployeeData;
- (void)checkEmployeeDataCenter;
- (void)processEmployeeDataCenter;

- (void)importFormDetailData;
- (void)checkFormDetailDataCenter;
- (void)processFormDetailDataCenter;

- (void)importFormRowData;
- (void)checkFormRowDataCenter;
- (void)processFormRowDataCenter;

- (void)importContactData;
- (void)checkContactDataCenter;
- (void)processContactDataCenter;

- (void)importConLocLinkData;
- (void)checkConLocLinkDataCenter;
- (void)processConLocLinkDataCenter;

- (void)importPresenterData;
- (void)checkPresenterDataCenter;
- (void)processPresenterDataCenter;

- (void)importProductData;
- (void)checkProductDataCenter;
- (void)processProductDataCenter;

- (void)importJourneyData;
- (void)checkJourneyDataCenter;
- (void)processJourneyDataCenter;

- (void)importOrderData;
- (void)checkOrderDataCenter;
- (void)processOrderDataCenter;

- (void)importCallData;
- (void)checkCallDataCenter;
- (void)processCallDataCenter;

- (void)importResourceData;
- (void)checkResourceDataCenter;
- (void)processResourceDataCenter;

- (void)updateTableProgressView;

@end
