//
//  EmailRecipientTableViewController.h
//  Arcos
//
//  Created by David Kilmartin on 14/02/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmailRecipientDataManager.h"
#import "EmailRecipientDelegate.h"
#import "EmailRecipientTableCell.h"

@interface EmailRecipientTableViewController : UITableViewController {
    NSNumber* _locationIUR;
    EmailRequestSource _requestSource;
    NSMutableDictionary* _wholesalerDict;
    EmailRecipientDataManager* _emailRecipientDataManager;
    id<EmailRecipientDelegate> _recipientDelegate;
    NSNumber* _isSealedBOOLNumber;
}

@property(nonatomic, retain) NSNumber* locationIUR;
@property(nonatomic, assign) EmailRequestSource requestSource;
@property(nonatomic, retain) NSMutableDictionary* wholesalerDict;
@property(nonatomic, retain) EmailRecipientDataManager* emailRecipientDataManager;
@property(nonatomic, assign) id<EmailRecipientDelegate> recipientDelegate;
@property(nonatomic, retain) NSNumber* isSealedBOOLNumber;

@end
