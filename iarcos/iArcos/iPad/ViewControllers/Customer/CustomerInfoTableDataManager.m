//
//  CustomerInfoTableDataManager.m
//  Arcos
//
//  Created by David Kilmartin on 09/09/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "CustomerInfoTableDataManager.h"
#import "ArcosConfigDataManager.h"
#import "GlobalSharedClass.h"

@implementation CustomerInfoTableDataManager
@synthesize locationIUR = _locationIUR;
@synthesize orderCallLabel = _orderCallLabel;
@synthesize invoicesLabel = _invoicesLabel;
@synthesize memosLabel = _memosLabel;
@synthesize surveysLabel = _surveysLabel;
@synthesize issuesLabel = _issuesLabel;
@synthesize issuesImageLabel = _issuesImageLabel;
@synthesize contactsLabel = _contactsLabel;
@synthesize flagsLabel = _flagsLabel;
@synthesize locationStatusDict = _locationStatusDict;
@synthesize codeType = _codeType;
@synthesize creditStatusDict = _creditStatusDict;
@synthesize csIUR = _csIUR;
@synthesize sectionTitleList = _sectionTitleList;
@synthesize historyKeyList = _historyKeyList;
@synthesize historyImageKeyList = _historyImageKeyList;
@synthesize analysisKeyList = _analysisKeyList;
@synthesize analysisImageKeyList = _analysisImageKeyList;
@synthesize overviewKeyList = _overviewKeyList;
@synthesize overviewImageKeyList = _overviewImageKeyList;
@synthesize extraBuyingGroupItemQty = _extraBuyingGroupItemQty;
@synthesize buyingGroupIndex = _buyingGroupIndex;
@synthesize buyingGroupLabel = _buyingGroupLabel;
@synthesize accountOverviewLabel = _accountOverviewLabel;
@synthesize accountOverviewImageLabel = _accountOverviewImageLabel;
@synthesize lastCallLabel = _lastCallLabel;
@synthesize nextCallLabel = _nextCallLabel;
@synthesize linkedToLabel = _linkedToLabel;
@synthesize linkedToIndex = _linkedToIndex;
@synthesize faxNumberLabel = _faxNumberLabel;
@synthesize creditStatusLabel = _creditStatusLabel;
@synthesize locationTypeLabel = _locationTypeLabel;
@synthesize locationStatusLabel = _locationStatusLabel;
@synthesize accessTimesLabel = _accessTimesLabel;
//@synthesize lastCallIndex = _lastCallIndex;
@synthesize nextCallIndex = _nextCallIndex;
@synthesize faxNumberIndex = _faxNumberIndex;
@synthesize creditStatusIndex = _creditStatusIndex;
@synthesize custKeyList = _custKeyList;
@synthesize linkedContactDictList = _linkedContactDictList;
@synthesize lpItemDictList = _lpItemDictList;
@synthesize cpItemDictList = _cpItemDictList;
@synthesize headerItemList = _headerItemList;
@synthesize moreFooterItemList = _moreFooterItemList;
@synthesize currentContactPopoverTag = _currentContactPopoverTag;//1:header contact 2:linked to
@synthesize auxLinkedContactIUR = _auxLinkedContactIUR;
@synthesize auxContactFullName = _auxContactFullName;
@synthesize auxLinkedContactCOiur = _auxLinkedContactCOiur;
@synthesize auxLinkedContactContactTitle = _auxLinkedContactContactTitle;
//@synthesize weekdayHashtable = _weekdayHashtable;
@synthesize mapLabel = _mapLabel;
@synthesize mapImageLabel = _mapImageLabel;
@synthesize photosLabel = _photosLabel;
@synthesize photosImageLabel = _photosImageLabel;
@synthesize gdprLabel = _gdprLabel;
@synthesize gdprImageLabel = _gdprImageLabel;
@synthesize infoSectionTitle = _infoSectionTitle;
@synthesize historySectionTitle = _historySectionTitle;
@synthesize analysisSectionTitle = _analysisSectionTitle;
@synthesize overviewSectionTitle = _overviewSectionTitle;
@synthesize startTimeLabel = _startTimeLabel;
@synthesize phoneNumberLabel = _phoneNumberLabel;
@synthesize emailLabel = _emailLabel;
@synthesize headerTailItemList = _headerTailItemList;
@synthesize priceGroupsLabel = _priceGroupsLabel;
@synthesize unassignedText = _unassignedText;
@synthesize popoverOpenFlag = _popoverOpenFlag;
@synthesize nextCallHashMap = _nextCallHashMap;
@synthesize nextAppointmentTitle = _nextAppointmentTitle;
@synthesize nextJourneyTitle = _nextJourneyTitle;
@synthesize suggestedCallTitle = _suggestedCallTitle;
@synthesize lastOrderHeaderFoundFlag = _lastOrderHeaderFoundFlag;

- (id)initWithLocationIUR:(NSNumber*)aLocationIUR {
    self = [super init];
    if (self != nil) {
        self.unassignedText = @"unassigned";
        self.phoneNumberLabel = @"Phone Number";
        self.emailLabel = @"Email";
        self.priceGroupsLabel = @"Price Group";
        self.extraBuyingGroupItemQty = 0;
        self.locationIUR = aLocationIUR;
        self.orderCallLabel = @"Orders / Calls";
        self.invoicesLabel = @"Invoices";
        self.memosLabel = @"Memos";
        self.surveysLabel = @"Surveys";
        self.issuesLabel = @"Issues";
        self.infoSectionTitle = @"Information";
        self.historySectionTitle = @"History";
        self.analysisSectionTitle = @"Analysis";
        self.overviewSectionTitle = @"Overview";
        NSString* definedIssuesText = [ArcosUtils retrieveDefinedIssuesText];
        if (![definedIssuesText isEqualToString:@""]) {
            self.issuesLabel = definedIssuesText;
        }
        self.issuesImageLabel = @"Query";
        self.contactsLabel = @"Contacts";
        self.flagsLabel = @"Flags";
        self.mapLabel = @"Map";
        self.mapImageLabel = @"Coordinate";
        self.photosLabel = @"Photos";
        self.photosImageLabel = @"Photo";
        self.gdprLabel = @"GDPR";
        self.gdprImageLabel = @"GDPR";
        self.sectionTitleList = [NSMutableArray arrayWithObjects:self.infoSectionTitle,self.historySectionTitle,self.analysisSectionTitle,self.overviewSectionTitle, nil];
        if ([[ArcosConfigDataManager sharedArcosConfigDataManager] enableCallOnlyFlag]) {
            self.sectionTitleList = [NSMutableArray arrayWithObjects:self.infoSectionTitle,self.historySectionTitle,self.overviewSectionTitle, nil];
        }
        NSString* finalContactLabel = self.contactsLabel;
        NSUInteger contactCount = [[ArcosCoreData sharedArcosCoreData] locationContactsWithLocationIUR:aLocationIUR];
        if (contactCount > 0) {
            finalContactLabel = [NSString stringWithFormat:@"%@ (%d)", self.contactsLabel, [ArcosUtils convertNSIntegerToInt:contactCount]];
        }
        self.historyKeyList = [NSMutableArray arrayWithObjects:self.orderCallLabel,self.invoicesLabel,self.memosLabel,self.surveysLabel,finalContactLabel,self.flagsLabel, nil];
        self.historyImageKeyList = [NSMutableArray arrayWithObjects:@"Order",@"Invoice",@"Memo",@"Survey",@"Contact",@"Flags", nil];
        self.analysisKeyList = [NSMutableArray arrayWithObjects:@"M.A.T.",@"TY -v- LY",@"Not Buy", nil];
        self.analysisImageKeyList = [NSMutableArray arrayWithObjects:@"Analysis",@"TY-V-LY",@"Not Buy", nil];
        self.overviewKeyList = [NSMutableArray arrayWithObjects:self.mapLabel,self.photosLabel, nil];
        self.overviewImageKeyList = [NSMutableArray arrayWithObjects:self.mapImageLabel,self.photosImageLabel, nil];
        self.buyingGroupLabel = @"Buying Group";
        self.accountOverviewLabel = @"Detailed Account";
        self.accountOverviewImageLabel = @"AccountOverview";
        self.lastCallLabel = @"Last Call";
        self.nextCallLabel = @"Next Call";
        self.linkedToLabel = @"Linked To";
        self.faxNumberLabel = @"Fax Number";
        self.creditStatusLabel = @"Credit Status";
        self.locationTypeLabel = @"Location Type";
        self.locationStatusLabel = @"Location Status";
        self.accessTimesLabel = @"Access Times";
        self.startTimeLabel = @"Start Time";
        self.faxNumberIndex = 0;
        self.creditStatusIndex = 0;
        
        self.headerTailItemList = [NSMutableArray arrayWithObjects:self.phoneNumberLabel, self.lastCallLabel, self.nextCallLabel, nil];
        self.headerItemList = [NSMutableArray arrayWithObjects:@"Address", @"Address2", @"Address3", @"Address4", @"Address5", nil];
        if ([[SettingManager databaseName] isEqualToString:[GlobalSharedClass shared].myDbName]) {
            NSDictionary* pgDict = [[ArcosCoreData sharedArcosCoreData] descrTypeAllRecordsWithTypeCode:@"PG"];
            if (pgDict != nil) {
                NSString* pgDetails = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:[pgDict objectForKey:@"Details"]]];
                if (![pgDetails isEqualToString:@""]) {
                    self.priceGroupsLabel = pgDetails;
                }
            }
            [self.headerItemList addObject:self.priceGroupsLabel];
        }
        
        [self.headerItemList addObjectsFromArray:self.headerTailItemList];
        
        NSDictionary* csDict = [[ArcosCoreData sharedArcosCoreData] descrTypeAllRecordsWithTypeCode:@"CS"];
        if (csDict != nil) {
            NSString* csDetails = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:[csDict objectForKey:@"Details"]]];
            if (![csDetails isEqualToString:@""]) {
                self.creditStatusLabel = csDetails;
            }
        }
        
        NSDictionary* ltDict = [[ArcosCoreData sharedArcosCoreData] descrTypeAllRecordsWithTypeCode:@"LT"];
        if (ltDict != nil) {
            NSString* ltDetails = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:[ltDict objectForKey:@"Details"]]];
            if (![ltDetails isEqualToString:@""]) {
                self.locationTypeLabel = ltDetails;
            }
        }
        
        NSDictionary* lsDict = [[ArcosCoreData sharedArcosCoreData] descrTypeAllRecordsWithTypeCode:@"LS"];
        if (lsDict != nil) {
            NSString* lsDetails = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:[lsDict objectForKey:@"Details"]]];
            if (![lsDetails isEqualToString:@""]) {
                self.locationStatusLabel = lsDetails;
            }
        }      
        
        
        self.moreFooterItemList = [NSMutableArray arrayWithObjects:self.faxNumberLabel, self.emailLabel, self.creditStatusLabel, self.locationTypeLabel, self.locationStatusLabel, @"Location Code", @"Member Of", self.accessTimesLabel, self.buyingGroupLabel, nil];
        if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showStartTimeAtHomePageFlag]) {
            int auxAccessTimesIndex = [self retrieveMoreFooterIndexByLabel:self.accessTimesLabel];
            if (auxAccessTimesIndex != -1) {
                [self.moreFooterItemList insertObject:self.startTimeLabel atIndex:auxAccessTimesIndex + 1];
            }
        }
//        self.weekdayHashtable = [NSMutableDictionary dictionaryWithCapacity:7];
//        [self.weekdayHashtable setObject:@"Sunday" forKey:[NSNumber numberWithInt:0]];
//        [self.weekdayHashtable setObject:@"Monday" forKey:[NSNumber numberWithInt:1]];
//        [self.weekdayHashtable setObject:@"Tuesday" forKey:[NSNumber numberWithInt:2]];
//        [self.weekdayHashtable setObject:@"Wednesday" forKey:[NSNumber numberWithInt:3]];
//        [self.weekdayHashtable setObject:@"Thursday" forKey:[NSNumber numberWithInt:4]];
//        [self.weekdayHashtable setObject:@"Friday" forKey:[NSNumber numberWithInt:5]];
//        [self.weekdayHashtable setObject:@"Saturday" forKey:[NSNumber numberWithInt:6]];
        self.popoverOpenFlag = NO;
        self.nextCallHashMap = [NSMutableDictionary dictionary];
        self.nextAppointmentTitle = @"Next Appointment";
        self.nextJourneyTitle = @"Next Journey";
        self.suggestedCallTitle = @"Suggested Call";
        self.lastOrderHeaderFoundFlag = NO;
    }
    return self;
}

- (void)dealloc {
    self.locationIUR = nil;
    self.orderCallLabel = nil;
    self.invoicesLabel = nil;
    self.memosLabel = nil;
    self.surveysLabel = nil;
    self.issuesLabel = nil;
    self.issuesImageLabel = nil;
    self.contactsLabel = nil;
    self.flagsLabel = nil;
    self.locationStatusDict = nil;
    self.codeType = nil;
    self.creditStatusDict = nil;
    self.csIUR = nil;
    self.sectionTitleList = nil;
    self.historyKeyList = nil;
    self.historyImageKeyList = nil;
    self.analysisKeyList = nil;
    self.analysisImageKeyList = nil;
    self.overviewKeyList = nil;
    self.overviewImageKeyList = nil;
    self.buyingGroupLabel = nil;
    self.accountOverviewLabel = nil;
    self.accountOverviewImageLabel = nil;
    self.lastCallLabel = nil;
    self.nextCallLabel = nil;
    self.linkedToLabel = nil;
    self.faxNumberLabel = nil;
    self.creditStatusLabel = nil;
    self.locationTypeLabel = nil;
    self.locationStatusLabel = nil;
    self.accessTimesLabel = nil;
    self.custKeyList = nil;
    self.linkedContactDictList = nil;
    self.lpItemDictList = nil;
    self.cpItemDictList = nil;
    self.headerItemList = nil;
    self.moreFooterItemList = nil;
    self.auxLinkedContactIUR = nil;
    self.auxContactFullName = nil;
    self.auxLinkedContactCOiur = nil;
    self.auxLinkedContactContactTitle = nil;
//    self.weekdayHashtable = nil;
    self.mapLabel = nil;
    self.mapImageLabel = nil;
    self.photosLabel = nil;
    self.photosImageLabel = nil;
    self.gdprLabel = nil;
    self.gdprImageLabel = nil;
    self.infoSectionTitle = nil;
    self.historySectionTitle = nil;
    self.analysisSectionTitle = nil;
    self.overviewSectionTitle = nil;
    self.startTimeLabel = nil;
    self.phoneNumberLabel = nil;
    self.emailLabel = nil;
    self.headerTailItemList = nil;
    self.priceGroupsLabel = nil;
    self.unassignedText = nil;
    self.nextCallHashMap = nil;
    self.nextAppointmentTitle = nil;
    self.nextJourneyTitle = nil;
    self.suggestedCallTitle = nil;
    
    [super dealloc];
}

- (void)locationStatusProcessor:(NSNumber*)aLsiur {
    self.locationStatusDict = [[ArcosCoreData sharedArcosCoreData] descriptionWithIUR:aLsiur needActive:NO];
    if (self.locationStatusDict != nil) {
        self.codeType = [self.locationStatusDict objectForKey:@"CodeType"];
        if ([self.codeType intValue] != 0) {
//            [ArcosUtils showMsg:[ArcosUtils convertNilToEmpty:[self.locationStatusDict objectForKey:@"Tooltip"]] delegate:nil];
            [ArcosUtils showDialogBox:[ArcosUtils convertNilToEmpty:[self.locationStatusDict objectForKey:@"Tooltip"]] title:@"" target:[ArcosUtils getRootView] handler:nil];
        }
    }
}

- (void)processIssuesRecord {
    int issueIndex = 4;
    NSString* thirdHistoryKey = [self.historyKeyList objectAtIndex:issueIndex];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] recordTasksFlag]) {
        if (![thirdHistoryKey isEqualToString:self.issuesLabel]) {
            [self.historyKeyList insertObject:self.issuesLabel atIndex:issueIndex];
            [self.historyImageKeyList insertObject:self.issuesImageLabel atIndex:issueIndex];
        }
    } else {
        if ([thirdHistoryKey isEqualToString:self.issuesLabel]) {
            [self.historyKeyList removeObjectAtIndex:issueIndex];
            [self.historyImageKeyList removeObjectAtIndex:issueIndex];
        }
    }
}

- (void)processAccountOverviewRecord {
//    NSString* lastOverviewKey = [self.overviewKeyList lastObject];
    int auxAccountOverviewIndex = [self retrieveOverviewIndexByLabel:self.accountOverviewLabel];
    int auxPhotosIndex = [self retrieveOverviewIndexByLabel:self.photosLabel];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showCompanyOverviewFlag]) {
        if (auxAccountOverviewIndex == -1) {
            [self.overviewKeyList insertObject:self.accountOverviewLabel atIndex:(auxPhotosIndex + 1)];
            [self.overviewImageKeyList insertObject:self.accountOverviewImageLabel atIndex:(auxPhotosIndex + 1)];
        }
    } else {
        if (auxAccountOverviewIndex != -1) {
            [self.overviewKeyList removeObjectAtIndex:auxAccountOverviewIndex];
            [self.overviewImageKeyList removeObjectAtIndex:auxAccountOverviewIndex];
        }
    }
}

- (void)processGDPRRecord {
    NSString* lastOverviewKey = [self.overviewKeyList lastObject];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showGDPRFlag]) {
        if (![lastOverviewKey isEqualToString:self.gdprLabel]) {
            [self.overviewKeyList addObject:self.gdprLabel];
            [self.overviewImageKeyList addObject:self.gdprImageLabel];
        }
    } else {
        if ([lastOverviewKey isEqualToString:self.gdprLabel]) {
            [self.overviewKeyList removeLastObject];
            [self.overviewImageKeyList removeLastObject];
        }
    }
}

- (int)retrieveOverviewIndexByLabel:(NSString*)aLabel {
    int tmpIndex = -1;
    for (int i = 0; i < [self.overviewKeyList count]; i++) {
        if ([aLabel isEqualToString:[self.overviewKeyList objectAtIndex:i]]) {
            tmpIndex = i;
            break;
        }
    }
    return tmpIndex;
}

- (int)retrieveIndexByLabel:(NSString*)aLabel {
    int tmpIndex = 0;
    for (int i = 0; i < [self.custKeyList count]; i++) {
        if ([aLabel isEqualToString:[self.custKeyList objectAtIndex:i]]) {
            tmpIndex = i;
            break;
        }
    }
    return tmpIndex;
}

- (int)retrieveMoreFooterIndexByLabel:(NSString*)aLabel {
    int tmpIndex = -1;
    for (int i = 0; i < [self.moreFooterItemList count]; i++) {
        if ([aLabel isEqualToString:[self.moreFooterItemList objectAtIndex:i]]) {
            tmpIndex = i;
            break;
        }
    }
    return tmpIndex;
}

- (void)createCustKeysOnStartUp {
    self.custKeyList = [NSMutableArray arrayWithArray:self.headerItemList];
    [self.custKeyList addObjectsFromArray:self.moreFooterItemList];
    self.buyingGroupIndex = [self retrieveIndexByLabel:self.buyingGroupLabel];
}

- (void)createCustKeysOnProcessing:(NSMutableDictionary*)aCustomerDict {
    self.nextCallIndex = [self retrieveIndexByLabel:self.nextCallLabel];
    self.faxNumberIndex = [self retrieveIndexByLabel:self.faxNumberLabel];
//    self.creditStatusIndex = [self retrieveIndexByLabel:self.creditStatusLabel];
    for (int i = self.faxNumberIndex - 1; i > self.nextCallIndex; i--) {
        NSString* tmpCustKey = [self.custKeyList objectAtIndex:i];
        [aCustomerDict removeObjectForKey:tmpCustKey];
        [self.custKeyList removeObjectAtIndex:i];
    }
    int linkedContactDictCount = [ArcosUtils convertNSUIntegerToUnsignedInt:[self.linkedContactDictList count]];
    int cpItemDictCount = [ArcosUtils convertNSUIntegerToUnsignedInt:[self.cpItemDictList count]];
    for (int i = 0; i < linkedContactDictCount; i++) {
        NSMutableDictionary* tmpLinkedContactDict = [self.linkedContactDictList objectAtIndex:i];
        [self.custKeyList insertObject:[tmpLinkedContactDict objectForKey:@"fieldDesc"] atIndex:(self.nextCallIndex + 1 + i)];
        [aCustomerDict setObject:[tmpLinkedContactDict objectForKey:@"fieldValue"] forKey:[tmpLinkedContactDict objectForKey:@"fieldDesc"]];
    }
    for (int i = 0; i < cpItemDictCount; i++) {
        NSMutableDictionary* tmpCpItemDict = [self.cpItemDictList objectAtIndex:i];
        [self.custKeyList insertObject:[tmpCpItemDict objectForKey:@"fieldDesc"] atIndex:(self.nextCallIndex + 1 + linkedContactDictCount + i)];
        [aCustomerDict setObject:[tmpCpItemDict objectForKey:@"fieldValue"] forKey:[tmpCpItemDict objectForKey:@"fieldDesc"]];
    }
    for (int i = 0; i < [self.lpItemDictList count]; i++) {
        NSMutableDictionary* tmpLpItemDict = [self.lpItemDictList objectAtIndex:i];
        [self.custKeyList insertObject:[tmpLpItemDict objectForKey:@"fieldDesc"] atIndex:(self.nextCallIndex + 1 + linkedContactDictCount + cpItemDictCount + i)];
        [aCustomerDict setObject:[tmpLpItemDict objectForKey:@"fieldValue"] forKey:[tmpLpItemDict objectForKey:@"fieldDesc"]];
    }
    self.buyingGroupIndex = [self retrieveIndexByLabel:self.buyingGroupLabel];
}

- (void)processLocationProfileWithDict:(NSDictionary*)aDict {
    self.lpItemDictList = [NSMutableArray arrayWithCapacity:10];
    NSString* prefixKey = @"lP";
    NSMutableArray* lpValueList = [NSMutableArray arrayWithCapacity:10];
    NSMutableArray* descrTypeCodeList = [NSMutableArray arrayWithCapacity:10];
    for (int i = 1; i <= 10; i++) {
        NSString* suffixKey = (i == 10) ? [NSString stringWithFormat:@"%d", i] : [NSString stringWithFormat:@"0%d", i];
        NSString* lpKey = [NSString stringWithFormat:@"%@%@",prefixKey, suffixKey];
        NSNumber* lpValue = [aDict objectForKey:lpKey];
        if ([lpValue intValue] != 0) {
            [lpValueList addObject:lpValue];
            [descrTypeCodeList addObject:[NSString stringWithFormat:@"%d", (20 + i)]];
        }
    }
    if ([lpValueList count] == 0) return;
    NSMutableArray* lpDescrDetailList = [[ArcosCoreData sharedArcosCoreData] descriptionWithIURList:lpValueList needActive:YES];
    NSMutableDictionary* lpDescrDetailHashMap = [NSMutableDictionary dictionaryWithCapacity:[lpDescrDetailList count]];
    for (int i = 0; i < [lpDescrDetailList count]; i++) {
        NSDictionary* tmpDescrDetailDict = [lpDescrDetailList objectAtIndex:i];
        [lpDescrDetailHashMap setObject:tmpDescrDetailDict forKey:[tmpDescrDetailDict objectForKey:@"DescrDetailIUR"]];
    }
    NSMutableArray* descrTypeList = [self descrTypeWithTypeCodeList:descrTypeCodeList];
    NSMutableDictionary* descrTypeHashMap = [NSMutableDictionary dictionaryWithCapacity:[descrTypeList count]];
    for (int i = 0; i < [descrTypeList count]; i++) {
        NSDictionary* tmpDescrTypeDict = [descrTypeList objectAtIndex:i];
        [descrTypeHashMap setObject:tmpDescrTypeDict forKey:[tmpDescrTypeDict objectForKey:@"DescrTypeCode"]];
    }
    for (int i = 0; i < [lpValueList count]; i++) {
        NSNumber* lpValue = [lpValueList objectAtIndex:i];
        NSString* descrTypeCode = [descrTypeCodeList objectAtIndex:i];
        NSDictionary* descrTypeDict = [descrTypeHashMap objectForKey:descrTypeCode];
        NSDictionary* descrDetailDict = [lpDescrDetailHashMap objectForKey:lpValue];
        NSString* fieldDesc = [ArcosUtils convertNilToEmpty:[descrTypeDict objectForKey:@"Details"]];
        NSString* fieldValue = [ArcosUtils convertNilToEmpty:[descrDetailDict objectForKey:@"Detail"]];
        if (![fieldDesc isEqualToString:@""] && ![fieldValue isEqualToString:@""] && ![[ArcosUtils trim:[fieldValue lowercaseString]] isEqualToString:self.unassignedText]) {
            NSMutableDictionary* tmpLpItemDict = [NSMutableDictionary dictionaryWithCapacity:2];
            [tmpLpItemDict setObject:fieldDesc forKey:@"fieldDesc"];
            [tmpLpItemDict setObject:fieldValue forKey:@"fieldValue"];
            [self.lpItemDictList addObject:tmpLpItemDict];
        }
    }
}

- (NSMutableArray*)descrTypeWithTypeCodeList:(NSMutableArray*)aTypeCodeList {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"DescrTypeCode in %@", aTypeCodeList];
    NSMutableArray* objectList = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"DescrType" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    if ([objectList count] > 0) {
        return objectList;
    }else{
        return nil;
    }
}

- (void)processContactProfileWithContactIUR:(NSNumber*)aContactIUR {
    self.linkedContactDictList = [NSMutableArray arrayWithCapacity:1];
    self.cpItemDictList = [NSMutableArray arrayWithCapacity:10];
    self.auxLinkedContactCOiur = [NSNumber numberWithInt:0];
    self.auxLinkedContactContactTitle = @"";
    if ([aContactIUR intValue] == 0) return;
    NSMutableArray* contactList = [[ArcosCoreData sharedArcosCoreData] contactWithIUR:aContactIUR];
    if ([contactList count] == 0) return;
    NSDictionary* contactDict = [contactList objectAtIndex:0];
    NSNumber* tmpLinkedContactIUR = [contactDict objectForKey:@"linkedContactIUR"];
    if ([tmpLinkedContactIUR intValue] != 0) {
        NSMutableArray* linkedContactList = [[ArcosCoreData sharedArcosCoreData] contactWithIUR:tmpLinkedContactIUR];
        if ([linkedContactList count] > 0) {
            NSDictionary* linkedContactDict = [linkedContactList objectAtIndex:0];
            NSString* fullName = [NSString stringWithFormat:@"%@ %@", [ArcosUtils convertNilToEmpty:[linkedContactDict objectForKey:@"Forename"]], [ArcosUtils convertNilToEmpty:[linkedContactDict objectForKey:@"Surname"]]];
            NSMutableDictionary* tmpLinkedContactItemDict = [NSMutableDictionary dictionaryWithCapacity:2];
            [tmpLinkedContactItemDict setObject:self.linkedToLabel forKey:@"fieldDesc"];
            [tmpLinkedContactItemDict setObject:fullName forKey:@"fieldValue"];
            [self.linkedContactDictList addObject:tmpLinkedContactItemDict];
            [self processLinkedContactCOiur:[linkedContactDict objectForKey:@"COiur"]];
        }
    } else {
        NSMutableDictionary* tmpLinkedContactItemDict = [NSMutableDictionary dictionaryWithCapacity:2];
        [tmpLinkedContactItemDict setObject:self.linkedToLabel forKey:@"fieldDesc"];
        [tmpLinkedContactItemDict setObject:[GlobalSharedClass shared].unassignedText forKey:@"fieldValue"];
        [self.linkedContactDictList addObject:tmpLinkedContactItemDict];
    }
    NSString* prefixKey = @"cP";
    NSMutableArray* cpValueList = [NSMutableArray arrayWithCapacity:10];
    NSMutableArray* descrTypeCodeList = [NSMutableArray arrayWithCapacity:10];
    for (int i = 1; i <= 10; i++) {
        NSString* suffixKey = (i == 10) ? [NSString stringWithFormat:@"%d", i] : [NSString stringWithFormat:@"0%d", i];
        NSString* cpKey = [NSString stringWithFormat:@"%@%@",prefixKey, suffixKey];
        NSNumber* cpValue = [contactDict objectForKey:cpKey];
        if ([cpValue intValue] != 0) {
            [cpValueList addObject:cpValue];
            [descrTypeCodeList addObject:suffixKey];
        }
    }
    if ([cpValueList count] == 0) return;
    NSMutableArray* cpDescrDetailList = [[ArcosCoreData sharedArcosCoreData] descriptionWithIURList:cpValueList];
    NSMutableDictionary* cpDescrDetailHashMap = [NSMutableDictionary dictionaryWithCapacity:[cpDescrDetailList count]];
    for (int i = 0; i < [cpDescrDetailList count]; i++) {
        NSDictionary* tmpDescrDetailDict = [cpDescrDetailList objectAtIndex:i];
        [cpDescrDetailHashMap setObject:tmpDescrDetailDict forKey:[tmpDescrDetailDict objectForKey:@"DescrDetailIUR"]];
    }
    NSMutableArray* descrTypeList = [self descrTypeWithTypeCodeList:descrTypeCodeList];
    NSMutableDictionary* descrTypeHashMap = [NSMutableDictionary dictionaryWithCapacity:[descrTypeList count]];
    for (int i = 0; i < [descrTypeList count]; i++) {
        NSDictionary* tmpDescrTypeDict = [descrTypeList objectAtIndex:i];
        [descrTypeHashMap setObject:tmpDescrTypeDict forKey:[tmpDescrTypeDict objectForKey:@"DescrTypeCode"]];
        
    }
    for (int i = 0; i < [cpValueList count]; i++) {
        NSNumber* cpValue = [cpValueList objectAtIndex:i];
        NSString* descrTypeCode = [descrTypeCodeList objectAtIndex:i];
        NSDictionary* descrTypeDict = [descrTypeHashMap objectForKey:descrTypeCode];
        NSDictionary* descrDetailDict = [cpDescrDetailHashMap objectForKey:cpValue];
        NSString* fieldDesc = [ArcosUtils convertNilToEmpty:[descrTypeDict objectForKey:@"Details"]];
        NSString* fieldValue = [ArcosUtils convertNilToEmpty:[descrDetailDict objectForKey:@"Detail"]];
        if (![fieldDesc isEqualToString:@""] && ![fieldValue isEqualToString:@""]) {
            NSMutableDictionary* tmpLpItemDict = [NSMutableDictionary dictionaryWithCapacity:2];
            [tmpLpItemDict setObject:fieldDesc forKey:@"fieldDesc"];
            [tmpLpItemDict setObject:fieldValue forKey:@"fieldValue"];
            [self.cpItemDictList addObject:tmpLpItemDict];
        }
    }
}

- (void)updateLinkedContactIUR:(NSNumber*)aLinkedContactIUR {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"IUR = %@", [GlobalSharedClass shared].currentSelectedContactIUR];
    NSMutableArray* objectList = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"Contact" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
    if ([objectList count] == 1) {
        Contact* myContact = [objectList objectAtIndex:0];
        myContact.linkedContactIUR = aLinkedContactIUR;
        [[ArcosCoreData sharedArcosCoreData] saveContext:[ArcosCoreData sharedArcosCoreData].fetchManagedObjectContext];
    }
}

- (void)processLinkedContactCOiur:(NSNumber*)aCOiur {
    self.auxLinkedContactCOiur = aCOiur;
    self.auxLinkedContactContactTitle = @"";
    if ([self.auxLinkedContactCOiur intValue] != 0) {
        NSMutableArray* descrDetailList = [[ArcosCoreData sharedArcosCoreData] descrDetailWithDescrDetailIUR:self.auxLinkedContactCOiur];
        if ([descrDetailList count] > 0) {
            self.auxLinkedContactContactTitle = [[descrDetailList objectAtIndex:0] objectForKey:@"Detail"];
        }
    }
}



@end
