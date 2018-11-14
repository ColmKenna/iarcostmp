//
//  EmailButtonAddressSelectDelegate.h
//  iArcos
//
//  Created by David Kilmartin on 13/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol EmailButtonAddressSelectDelegate <NSObject>

@required
- (void)emailDidSelectEmailRecipientRow:(NSDictionary*)cellData;
//- (void)emailAlertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

