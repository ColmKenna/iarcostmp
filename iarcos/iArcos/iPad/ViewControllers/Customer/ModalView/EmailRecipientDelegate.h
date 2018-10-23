//
//  EmailRecipientDelegate.h
//  Arcos
//
//  Created by David Kilmartin on 15/02/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EmailRecipientDelegate <NSObject>

- (void)didSelectEmailRecipientRow:(NSDictionary*)cellData;

@end
