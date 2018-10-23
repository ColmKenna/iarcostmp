//
//  CustomerContactEmailDelegate.h
//  Arcos
//
//  Created by David Kilmartin on 23/03/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CustomerContactEmailDelegate <NSObject>

- (void)createEmailComposeViewController:(NSString*)anEmail;

@end
