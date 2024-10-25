//
//  UtilitiesMailDataManager.m
//  iArcos
//
//  Created by Richard on 24/10/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import "UtilitiesMailDataManager.h"

@implementation UtilitiesMailDataManager

- (void)renewPressedProcessorWithFailureHandler:(void (^)(void))failureHandler successHandler:(void (^)(void))successHandler completionHandler:(void (^)(void))completionHandler {
    
    MSALAccount* myMSALAccount = [[ArcosConstantsDataManager sharedArcosConstantsDataManager] currentAccount];
    MSALSilentTokenParameters* myMSALSilentTokenParameters = [[[MSALSilentTokenParameters alloc] initWithScopes:[ArcosConstantsDataManager sharedArcosConstantsDataManager].kScopes account:myMSALAccount] autorelease];
    [[ArcosConstantsDataManager sharedArcosConstantsDataManager].applicationContext acquireTokenSilentWithParameters:myMSALSilentTokenParameters completionBlock:^(MSALResult * _Nullable result, NSError * _Nullable error) {
        if (!error) {
            [ArcosConstantsDataManager sharedArcosConstantsDataManager].accessToken = result.accessToken;
            NSLog(@"renew pc token: %@", result.accessToken);
            [ArcosConstantsDataManager sharedArcosConstantsDataManager].currentAccountAddress = [result.account username];
            NSLog(@"renew pc expired at: %@", result.expiresOn);
            dispatch_async(dispatch_get_main_queue(), ^{
                successHandler();
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                failureHandler();
            });
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler();
        });        
    }];
}

@end
