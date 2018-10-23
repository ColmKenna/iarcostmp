//
//  OrderDetailEmailActionDelegate.h
//  Arcos
//
//  Created by David Kilmartin on 29/01/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@protocol OrderDetailEmailActionDelegate <NSObject>
@required
- (NSMutableDictionary*)didSelectEmailRecipientRowWithCellData:(NSDictionary*)aCellData;
- (NSString*)retrieveFileName;
/*
- (void)didSelectEmailRecipientRow:(MFMailComposeViewController*)aMailController cellData:(NSDictionary*)aCellData;
- (void)emailButtonPressed:(MFMailComposeViewController*)aMailController;
- (void)wholesalerEmailButtonPressed:(MFMailComposeViewController*)aMailController;
- (void)contactEmailButtonPressed:(MFMailComposeViewController*)aMailController;
*/
@end
