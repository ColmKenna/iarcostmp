//
//  EmailButtonAddressSelectBaseDataManager.h
//  iArcos
//
//  Created by David Kilmartin on 13/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EmailButtonAddressSelectDelegate.h"

@interface EmailButtonAddressSelectBaseDataManager : NSObject <EmailButtonAddressSelectDelegate> {
    id _target;
    SEL _didSelectEmailRecipientRowSelector;
}

@property(nonatomic, assign) id target;
@property(nonatomic, assign) SEL didSelectEmailRecipientRowSelector;

- (instancetype)initWithTarget:(id)aTarget;

@end

