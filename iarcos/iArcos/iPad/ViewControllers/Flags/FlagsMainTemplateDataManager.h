//
//  FlagsMainTemplateDataManager.h
//  iArcos
//
//  Created by Richard on 05/10/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FlagsMainTemplateDataManager : NSObject {
    NSMutableDictionary* _contactOrderCart;
    int _actionType;
    NSMutableDictionary* _locationOrderCart;
    NSString* _contactText;
    NSString* _locationText;
    NSString* _iURText;
    NSString* _locationIURText;
    NSString* _contactAssignmentType;
    NSString* _locationAssignmentType;
    NSString* _contactFlagDescrTypeCode;
    NSString* _locationFlagDescrTypeCode;
    
    NSString* _actionTypeTitle;
    NSString* _iURKeyText;
    NSString* _assignmentType;
    NSString* _flagDescrTypeCode;
    
}

@property(nonatomic, retain) NSMutableDictionary* contactOrderCart;
@property(nonatomic, assign) int actionType;
@property(nonatomic, retain) NSMutableDictionary* locationOrderCart;
@property(nonatomic, retain) NSString* contactText;
@property(nonatomic, retain) NSString* locationText;
@property(nonatomic, retain) NSString* iURText;
@property(nonatomic, retain) NSString* locationIURText;
@property(nonatomic, retain) NSString* contactAssignmentType;
@property(nonatomic, retain) NSString* locationAssignmentType;
@property(nonatomic, retain) NSString* contactFlagDescrTypeCode;
@property(nonatomic, retain) NSString* locationFlagDescrTypeCode;

@property(nonatomic, retain) NSString* actionTypeTitle;
@property(nonatomic, retain) NSString* iURKeyText;
@property(nonatomic, retain) NSString* assignmentType;
@property(nonatomic, retain) NSString* flagDescrTypeCode;

- (void)saveContactToOrderCart:(NSMutableDictionary*)aContactDict;
- (NSMutableArray*)retrieveSelectedContactListProcessor;
- (void)saveLocationToOrderCart:(NSMutableDictionary*)aLocationDict;
- (void)defineConfigAsContact;
- (void)defineConfigAsLocation;
- (NSMutableArray*)retrieveSelectedLocationListProcessor;
- (NSMutableArray*)dictMutableListWithData:(NSMutableArray*)aDictList;

@end

