//
//  EmailRecipientDataManager.h
//  Arcos
//
//  Created by David Kilmartin on 15/02/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EmailRecipientPhotoDataManager.h"
#import "EmailRecipientOrderDataManager.h"
#import "EmailRecipientCallDataManager.h"
#import "EmailRecipientReporterDataManager.h"
#import "EmailRecipientPresenterDataManager.h"
#import "EmailRecipientAccountOverviewDataManager.h"
#import "EmailRecipientEmployeeDataManager.h"
typedef enum {
    EmailRequestSourcePhoto = 0,
    EmailRequestSourceOrder,
    EmailRequestSourceCall,
    EmailRequestSourceReporter,
    EmailRequestSourcePresenter,
    EmailRequestSourceAccountOverview,
    EmailRequestSourceEmployee
} EmailRequestSource;

@interface EmailRecipientDataManager : NSObject {
    EmailRecipientBaseDataManager* _emailRecipientBaseDataManager;
    EmailRequestSource _requestSource;
    NSNumber* _locationIUR;    
    NSMutableArray* _displayList;
    NSMutableDictionary* _groupedDataDict;
    NSMutableArray* _sectionTypeList;
    NSMutableDictionary* _wholesalerDict;
    NSMutableDictionary* _currentRecipientDict;
}

@property(nonatomic, retain) EmailRecipientBaseDataManager* emailRecipientBaseDataManager;
@property(nonatomic, assign) EmailRequestSource requestSource;
@property(nonatomic, retain) NSNumber* locationIUR;
@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) NSMutableDictionary* groupedDataDict;
@property(nonatomic, retain) NSMutableArray* sectionTypeList;
@property(nonatomic, retain) NSMutableDictionary* wholesalerDict;
@property(nonatomic, retain) NSMutableDictionary* currentRecipientDict;

- (id)initWithLocationIUR:(NSNumber*)aLocationIUR requestSource:(EmailRequestSource)aRequestSource;


@end
