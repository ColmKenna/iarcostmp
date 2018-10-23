//
//  ArcosMailTableViewControllerDelegate.h
//  iArcos
//
//  Created by David Kilmartin on 20/03/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    ArcosMailComposeResultCancelled = 0,
    ArcosMailComposeResultSent
} ArcosMailComposeResult;

@protocol ArcosMailTableViewControllerDelegate <NSObject>

- (void)arcosMailDidFinishWithResult:(ArcosMailComposeResult)aResult error:(NSError *)anError;

@end
