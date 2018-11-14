//
//  EmailButtonAddressSelectBaseDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 13/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "EmailButtonAddressSelectBaseDataManager.h"

@implementation EmailButtonAddressSelectBaseDataManager
@synthesize didSelectEmailRecipientRowSelector = _didSelectEmailRecipientRowSelector;

- (instancetype)initWithTarget:(id)aTarget{
    self = [super init];
    if (self != nil) {
        self.target = aTarget;
    }
    return self;
}

- (void)emailDidSelectEmailRecipientRow:(NSDictionary*)cellData {
    [self.target performSelector:self.didSelectEmailRecipientRowSelector withObject:cellData];
}


@end
