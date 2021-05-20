//
//  ArcosConstantsDataManager.m
//  iArcos
//
//  Created by Apple on 28/12/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import "ArcosConstantsDataManager.h"

@implementation ArcosConstantsDataManager
SYNTHESIZE_SINGLETON_FOR_CLASS(ArcosConstantsDataManager);
@synthesize kClientID = _kClientID;
@synthesize kAuthority = _kAuthority;
@synthesize kGraphURI = _kGraphURI;
@synthesize accessToken = _accessToken;
@synthesize applicationContext = _applicationContext;
@synthesize currentAccountAddress = _currentAccountAddress;
@synthesize kGraphMessageURI = _kGraphMessageURI;

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.kClientID = @"6aa698d7-5fd4-42f4-8702-cd04b9d9c52e";
//        self.kClientID = @"e06cc226-c91e-4273-8fdb-c2b335d6334e";
        self.kAuthority = @"https://login.microsoftonline.com/common";
        self.kGraphURI = @"https://graph.microsoft.com/v1.0/me/sendMail";
        self.accessToken = @"";
        NSURL* authorityURL = [NSURL URLWithString:self.kAuthority];
        MSALAuthority* authority = [MSALAuthority authorityWithURL:authorityURL error:nil];
        MSALPublicClientApplicationConfig* config =
        [[[MSALPublicClientApplicationConfig alloc] initWithClientId:self.kClientID redirectUri:nil authority:authority] autorelease];
        self.applicationContext = [[[MSALPublicClientApplication alloc] initWithConfiguration:config error:nil] autorelease];
        self.currentAccountAddress = nil;
        self.kGraphMessageURI = @"https://graph.microsoft.com/v1.0/me/messages";
    }
    
    return self;
}

- (void)dealloc {
    self.kClientID = nil;    
    self.kAuthority = nil;
    self.kGraphURI = nil;
    self.accessToken = nil;
    self.applicationContext = nil;
    self.currentAccountAddress = nil;
    self.kGraphMessageURI = nil;
    
    [super dealloc];
}

@end
