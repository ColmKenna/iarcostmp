//
//  GetRecordGenericDataManager.h
//  iArcos
//
//  Created by David Kilmartin on 20/05/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GetRecordGenericReturnObject.h"
#import "ArcosGenericReturnObject.h"
#import "PropertyUtils.h"
#import "GlobalSharedClass.h"
#import "ArcosCoreData.h"
#import "GetRecordTypeGenericIURObject.h"
#import "GetRecordTypeGenericStringObject.h"
#import "GetRecordTypeGenericBooleanObject.h"
#import "GetRecordTypeGenericDateObject.h"
#import "GetRecordTypeGenericIntObject.h"
#import "GetRecordTypeGenericDecimalObject.h"

@interface GetRecordGenericDataManager : NSObject {
    NSMutableDictionary* _constantFieldTypeDict;
    NSString* _iURFieldTypeText;
    NSString* _stringFieldTypeText;
    NSString* _booleanFieldTypeText;
    NSString* _dateTimeFieldTypeText;
    NSString* _intFieldTypeText;
    NSString* _decimalFieldTypeText;
    int _rowPointer;
}

@property(nonatomic,retain) NSMutableDictionary* constantFieldTypeDict;
@property(nonatomic,retain) NSString* iURFieldTypeText;
@property(nonatomic,retain) NSString* stringFieldTypeText;
@property(nonatomic,retain) NSString* booleanFieldTypeText;
@property(nonatomic,retain) NSString* dateTimeFieldTypeText;
@property(nonatomic,retain) NSString* intFieldTypeText;
@property(nonatomic,retain) NSString* decimalFieldTypeText;
@property(nonatomic,assign) int rowPointer;

- (GetRecordGenericReturnObject*)processRawData:(ArcosGenericReturnObject*)aGenericReturnObject;
- (int)retrieveEmployeeSecurityLevel;

@end
