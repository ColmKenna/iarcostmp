//
//  EmailOneButtonAddressSelectDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 13/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "EmailOneButtonAddressSelectDataManager.h"

@implementation EmailOneButtonAddressSelectDataManager

- (instancetype)initWithTarget:(id)aTarget{
    self = [super init];
    if (self != nil) {
        self.target = aTarget;
        self.didSelectEmailRecipientRowSelector = NSSelectorFromString(@"emailOneDidSelectEmailRecipientRow:");
    }
    return self;
}

@end
