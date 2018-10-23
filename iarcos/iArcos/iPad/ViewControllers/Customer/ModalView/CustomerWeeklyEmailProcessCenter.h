//
//  CustomerWeeklyEmailProcessCenter.h
//  Arcos
//
//  Created by David Kilmartin on 10/04/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "CustomerWeeklyMainDataManager.h"

@interface CustomerWeeklyEmailProcessCenter : NSObject

-(NSString*)buildEmailMessageWithDataManager:(CustomerWeeklyMainDataManager*)customerWeeklyMainDataManager;

@end
