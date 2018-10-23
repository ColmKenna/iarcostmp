//
//  EmailRecipientBaseDataManager.h
//  Arcos
//
//  Created by David Kilmartin on 26/02/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosCoreData.h"

@interface EmailRecipientBaseDataManager : NSObject {
    NSNumber* _locationIUR;    
    NSMutableArray* _displayList;
    NSMutableDictionary* _groupedDataDict;
    NSMutableArray* _sectionTypeList;
    NSMutableDictionary* _wholesalerDict;    
    NSNumber* _isSealedBOOLNumber;
}

@property(nonatomic, retain) NSNumber* locationIUR;
@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) NSMutableDictionary* groupedDataDict;
@property(nonatomic, retain) NSMutableArray* sectionTypeList;
@property(nonatomic, retain) NSMutableDictionary* wholesalerDict;
@property(nonatomic, retain) NSNumber* isSealedBOOLNumber;

- (void)getAllRecipients;
- (void)getLocationRecipient;
- (void)getContactRecipient;
- (void)getWholesalerRecipient;
- (void)getEmployeeRecipient;
- (void)createOtherRecipient;
- (NSMutableDictionary*)createRecipient:(NSString*)aTitle email:(NSString*)anEmail recipientType:(NSNumber*)aRecipientType;

@end
