//
//  ArcosEmailValidator.m
//  Arcos
//
//  Created by David Kilmartin on 10/04/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "ArcosEmailValidator.h"
#import "ArcosUtils.h"

@implementation ArcosEmailValidator

+(BOOL)checkCanSendMailStatus {
    if (![MFMailComposeViewController canSendMail]) {
//        UIAlertView *v = [[UIAlertView alloc] initWithTitle: @"No Mail Account" message: @"Please set up a Mail account in order to send email" delegate: nil cancelButtonTitle: @"OK" otherButtonTitles: nil, nil];
//        [v show];
//        [v release];
        return NO;
    }
    return YES;
}

+(BOOL)checkCanSendMailStatus:(UIViewController*)aTarget {
    if (![MFMailComposeViewController canSendMail]) {
        [ArcosUtils showDialogBox:@"Please set up a Mail account in order to send email" title:@"No Mail Account" target:aTarget handler:^(UIAlertAction *action) {}];
        return NO;
    }
    return YES;
}

@end
