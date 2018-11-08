//
//  MeetingCellKeyDefinition.h
//  iArcos
//
//  Created by David Kilmartin on 06/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MeetingCellKeyDefinition : NSObject {
    //Details
    NSString* _dateKey;
    NSString* _timeKey;
    NSString* _durationKey;
    NSString* _codeKey;
    NSString* _venueKey;
    NSString* _statusKey;
    NSString* _typeKey;
    NSString* _styleKey;
    NSString* _titleKey;
    NSString* _operatorKey;
    NSString* _commentsKey;
    
    //Misc
    NSString* _approvedByKey;
    NSString* _l4Key;
    NSString* _l5Key;
    NSString* _speakerAgreementKey;
    NSString* _speakerAgreementDetailsKey;
}

@property(nonatomic, retain) NSString* dateKey;
@property(nonatomic, retain) NSString* timeKey;
@property(nonatomic, retain) NSString* durationKey;
@property(nonatomic, retain) NSString* codeKey;
@property(nonatomic, retain) NSString* venueKey;
@property(nonatomic, retain) NSString* statusKey;
@property(nonatomic, retain) NSString* typeKey;
@property(nonatomic, retain) NSString* styleKey;
@property(nonatomic, retain) NSString* titleKey;
@property(nonatomic, retain) NSString* operatorKey;
@property(nonatomic, retain) NSString* commentsKey;

@property(nonatomic, retain) NSString* approvedByKey;
@property(nonatomic, retain) NSString* l4Key;
@property(nonatomic, retain) NSString* l5Key;
@property(nonatomic, retain) NSString* speakerAgreementKey;
@property(nonatomic, retain) NSString* speakerAgreementDetailsKey;


@end

