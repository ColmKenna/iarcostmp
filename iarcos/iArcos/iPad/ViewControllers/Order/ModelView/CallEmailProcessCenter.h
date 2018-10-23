//
//  CallEmailProcessCenter.h
//  Arcos
//
//  Created by David Kilmartin on 29/01/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosCoreData.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "ArcosConfigDataManager.h"

@interface CallEmailProcessCenter : NSObject {
    NSMutableDictionary* _orderHeader;
//    NSMutableArray* _detailingSelectionNames;
//    NSMutableArray* _detailingSelections;
    BOOL _hasDetailing;
    BOOL _hasKeyMessages;
    BOOL _hasSamples;
    BOOL _hasPromotionalItems;
    BOOL _hasPresenter;
    BOOL _hasMeetingContact;
    NSString* _adoptionLadderKey;
    NSString* _keyMessagesKey;
    NSString* _samplesKey;
    NSString* _promotionalItemsKey;
    NSString* _presenterKey;
    NSString* _meetingContactKey;
    
    NSMutableDictionary* _detailingHeaderDict;
    NSMutableArray* _detailingActiveKeyList;
    NSMutableDictionary* _detailingRowDict;
//    ArcosConfigDataManager* _arcosConfigDataManager;
}

@property(nonatomic,retain) NSMutableDictionary* orderHeader;
//@property(nonatomic,retain) NSMutableArray* detailingSelectionNames;
//@property(nonatomic,retain) NSMutableArray* detailingSelections;
@property(nonatomic,assign) BOOL hasDetailing;
@property(nonatomic,assign) BOOL hasKeyMessages;
@property(nonatomic,assign) BOOL hasSamples;
@property(nonatomic,assign) BOOL hasPromotionalItems;
@property(nonatomic,assign) BOOL hasPresenter;
@property(nonatomic,assign) BOOL hasMeetingContact;
@property(nonatomic, retain) NSString* adoptionLadderKey;
@property(nonatomic, retain) NSString* keyMessagesKey;
@property(nonatomic, retain) NSString* samplesKey;
@property(nonatomic, retain) NSString* promotionalItemsKey;
@property(nonatomic, retain) NSString* presenterKey;
@property(nonatomic, retain) NSString* meetingContactKey;
@property(nonatomic, retain) NSMutableDictionary* detailingHeaderDict;
@property(nonatomic, retain) NSMutableArray* detailingActiveKeyList;
@property(nonatomic, retain) NSMutableDictionary* detailingRowDict;
//@property(nonatomic, retain) ArcosConfigDataManager* arcosConfigDataManager;

-(id)initWithOrderHeader:(NSMutableDictionary*)anOrderHeader;
-(NSString*)employeeName;
-(NSString*)companyName;
-(NSString*)buildCallEmailMessageWithController;
-(void)fillCallTranTemplate;

@end
