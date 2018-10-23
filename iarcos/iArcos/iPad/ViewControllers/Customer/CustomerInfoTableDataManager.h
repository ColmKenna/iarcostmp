//
//  CustomerInfoTableDataManager.h
//  Arcos
//
//  Created by David Kilmartin on 09/09/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosCoreData.h"

@interface CustomerInfoTableDataManager : NSObject {
    NSNumber* _locationIUR;
    NSString* _orderCallLabel;
    NSString* _invoicesLabel;
    NSString* _memosLabel;
    NSString* _surveysLabel;
    NSString* _issuesLabel;
    NSString* _issuesImageLabel;
    NSString* _contactsLabel;
    NSString* _flagsLabel;
    NSDictionary* _locationStatusDict;
    NSNumber* _codeType;
    NSDictionary* _creditStatusDict;
    NSNumber* _csIUR;
    NSMutableArray* _sectionTitleList;
    NSMutableArray* _historyKeyList;
    NSMutableArray* _historyImageKeyList;
    NSMutableArray* _analysisKeyList;
    NSMutableArray* _analysisImageKeyList;
    NSMutableArray* _overviewKeyList;
    NSMutableArray* _overviewImageKeyList;
    int _extraBuyingGroupItemQty;
    int _buyingGroupIndex;
    NSString* _buyingGroupLabel;
    NSString* _accountOverviewLabel;
    NSString* _accountOverviewImageLabel;
    NSString* _lastCallLabel;
    NSString* _linkedToLabel;
    int _linkedToIndex;
    NSString* _faxNumberLabel;
    NSString* _creditStatusLabel;
    NSString* _accessTimesLabel;
    int _lastCallIndex;
    int _faxNumberIndex;
    int _creditStatusIndex;
    NSMutableArray* _custKeyList;
    NSMutableArray* _linkedContactDictList;
    NSMutableArray* _lpItemDictList;
    NSMutableArray* _cpItemDictList;
    NSMutableArray* _headerItemList;
    NSMutableArray* _moreFooterItemList;
    int _currentContactPopoverTag;
    NSNumber* _auxLinkedContactIUR;
    NSString* _auxContactFullName;
    NSNumber* _auxLinkedContactCOiur;
    NSString* _auxLinkedContactContactTitle;
//    NSMutableDictionary* _weekdayHashtable;
    NSString* _mapLabel;
    NSString* _mapImageLabel;
    NSString* _photosLabel;
    NSString* _photosImageLabel;
    NSString* _gdprLabel;
    NSString* _gdprImageLabel;
}

@property(nonatomic, retain) NSNumber* locationIUR;
@property(nonatomic, retain) NSString* orderCallLabel;
@property(nonatomic, retain) NSString* invoicesLabel;
@property(nonatomic, retain) NSString* memosLabel;
@property(nonatomic, retain) NSString* surveysLabel;
@property(nonatomic, retain) NSString* issuesLabel;
@property(nonatomic, retain) NSString* issuesImageLabel;
@property(nonatomic, retain) NSString* contactsLabel;
@property(nonatomic, retain) NSString* flagsLabel;
@property(nonatomic, retain) NSDictionary* locationStatusDict;
@property(nonatomic, retain) NSNumber* codeType;
@property(nonatomic, retain) NSDictionary* creditStatusDict;
@property(nonatomic, retain) NSNumber* csIUR;
@property(nonatomic, retain) NSMutableArray* sectionTitleList;
@property(nonatomic, retain) NSMutableArray* historyKeyList;
@property(nonatomic, retain) NSMutableArray* historyImageKeyList;
@property(nonatomic, retain) NSMutableArray* analysisKeyList;
@property(nonatomic, retain) NSMutableArray* analysisImageKeyList;
@property(nonatomic, retain) NSMutableArray* overviewKeyList;
@property(nonatomic, retain) NSMutableArray* overviewImageKeyList;
@property(nonatomic, assign) int extraBuyingGroupItemQty;
@property(nonatomic, assign) int buyingGroupIndex;
@property(nonatomic, retain) NSString* buyingGroupLabel;
@property(nonatomic, retain) NSString* accountOverviewLabel;
@property(nonatomic, retain) NSString* accountOverviewImageLabel;
@property(nonatomic, retain) NSString* lastCallLabel;
@property(nonatomic, retain) NSString* linkedToLabel;
@property(nonatomic, assign) int linkedToIndex;
@property(nonatomic, retain) NSString* faxNumberLabel;
@property(nonatomic, retain) NSString* creditStatusLabel;
@property(nonatomic, retain) NSString* accessTimesLabel;
@property(nonatomic, assign) int lastCallIndex;
@property(nonatomic, assign) int faxNumberIndex;
@property(nonatomic, assign) int creditStatusIndex;
@property(nonatomic, retain) NSMutableArray* custKeyList;
@property(nonatomic, retain) NSMutableArray* linkedContactDictList;
@property(nonatomic, retain) NSMutableArray* lpItemDictList;
@property(nonatomic, retain) NSMutableArray* cpItemDictList;
@property(nonatomic, retain) NSMutableArray* headerItemList;
@property(nonatomic, retain) NSMutableArray* moreFooterItemList;
@property(nonatomic, assign) int currentContactPopoverTag;
@property(nonatomic, retain) NSNumber* auxLinkedContactIUR;
@property(nonatomic, retain) NSString* auxContactFullName;
@property(nonatomic, retain) NSNumber* auxLinkedContactCOiur;
@property(nonatomic, retain) NSString* auxLinkedContactContactTitle;
//@property(nonatomic, retain) NSMutableDictionary* weekdayHashtable;
@property(nonatomic, retain) NSString* mapLabel;
@property(nonatomic, retain) NSString* mapImageLabel;
@property(nonatomic, retain) NSString* photosLabel;
@property(nonatomic, retain) NSString* photosImageLabel;
@property(nonatomic, retain) NSString* gdprLabel;
@property(nonatomic, retain) NSString* gdprImageLabel;

- (id)initWithLocationIUR:(NSNumber*)aLocationIUR;
- (void)locationStatusProcessor:(NSNumber*)aLsiur;
- (void)processIssuesRecord;
- (void)processAccountOverviewRecord;
- (void)processGDPRRecord;
- (int)retrieveIndexByLabel:(NSString*)aLabel;
- (void)createCustKeysOnStartUp;
- (void)createCustKeysOnProcessing:(NSMutableDictionary*)aCustomerDict;
- (void)processLocationProfileWithDict:(NSDictionary*)aDict;
- (NSMutableArray*)descrTypeWithTypeCodeList:(NSMutableArray*)aTypeCodeList;
- (void)processContactProfileWithContactIUR:(NSNumber*)aContactIUR;
- (void)updateLinkedContactIUR:(NSNumber*)aLinkedContactIUR;
- (void)processLinkedContactCOiur:(NSNumber*)aCOiur;
//- (NSString*)retrieveAccessTimesInfoValue:(NSMutableDictionary*)aCustDict;

@end
