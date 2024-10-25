//
//  ArcosConstantsDataManager.h
//  iArcos
//
//  Created by Apple on 28/12/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"
#import <MSAL/MSAL.h>

@interface ArcosConstantsDataManager : NSObject {
    NSString* _kClientID;
    NSString* _kAuthority;
    NSString* _kGraphURI;
    NSString* _accessToken;
    MSALPublicClientApplication* _applicationContext;
    NSString* _currentAccountAddress;
    NSString* _kGraphMessageURI;
    NSString* _kGraphEventURI;
    NSString* _acctNotSignInMsg;
    NSArray* _kScopes;
}

+ (ArcosConstantsDataManager*)sharedArcosConstantsDataManager;
@property(nonatomic, retain) NSString* kClientID;
@property(nonatomic, retain) NSString* kAuthority;
@property (nonatomic,retain) NSString* kGraphURI;
@property (nonatomic,retain) NSString* accessToken;
@property(nonatomic, retain) MSALPublicClientApplication* applicationContext;
@property(nonatomic, retain) NSString* currentAccountAddress;
@property(nonatomic, retain) NSString* kGraphMessageURI;
@property(nonatomic, retain) NSString* kGraphEventURI;
@property(nonatomic, retain) NSString* acctNotSignInMsg;
@property(nonatomic, retain) NSArray* kScopes;

- (MSALAccount*)currentAccount;

@end


