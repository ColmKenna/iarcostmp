//
//  OrderEmailProcessCenter.h
//  Arcos
//
//  Created by David Kilmartin on 31/01/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "ArcosCoreData.h"
#import "ArcosConfigDataManager.h"

@interface OrderEmailProcessCenter : NSObject {
    NSMutableDictionary* _orderHeader;
    NSMutableArray* _orderLines;
}

@property(nonatomic,retain) NSMutableDictionary* orderHeader;
@property(nonatomic,retain) NSMutableArray* orderLines;

-(id)initWithOrderHeader:(NSMutableDictionary*)anOrderHeader;
-(NSString*)buildEmailMessageWithController;
-(NSString*)employeeName;
-(NSString*)companyName;
-(BOOL)checkCanSendMailStatus;

@end
