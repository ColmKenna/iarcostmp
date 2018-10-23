//
//  ConnectivityCheck.h
//  Arcos
//
//  Created by David Kilmartin on 21/12/2011.
//  Copyright (c) 2011 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

extern NSString *const kConnectivityChangeNotification;

@protocol ConnectivityDelegate;
@protocol AsyncWebConnectionDelegate;

@interface ConnectivityCheck : NSObject{
    BOOL wifiConnected;
    BOOL cell3GConnected;
    BOOL VPNConnected;
    BOOL hostConnected;
    BOOL serviceConnected;
    BOOL serviceCallAvailable;
    BOOL needVPNCheck;
    Reachability* hostReach;
    Reachability* internetReach;
    
    BOOL serviceTimeout;
    int timeOutCounter;
    
    NSString* errorString;
    
    BOOL busy;
    BOOL needAsync;
    //delegate
    id<ConnectivityDelegate> delegate;
    BOOL _isRegisterValidation;
    id<AsyncWebConnectionDelegate> _asyncDelegate;
}
@property(nonatomic,assign) BOOL wifiConnected;
@property(nonatomic,assign) BOOL cell3GConnected;
@property(nonatomic,assign) BOOL VPNConnected;
@property(nonatomic,assign) BOOL hostConnected;
@property(nonatomic,assign) BOOL serviceConnected;
@property(nonatomic,assign) BOOL serviceCallAvailable;
@property(nonatomic,assign) BOOL needVPNCheck;
@property(nonatomic,retain) Reachability* hostReach;
@property(nonatomic,retain) Reachability* internetReach;
@property(nonatomic,assign) BOOL serviceTimeout;
@property(nonatomic,retain) NSString* errorString;
@property(nonatomic,assign) id<ConnectivityDelegate> delegate;
@property(nonatomic,assign) BOOL isRegisterValidation;
@property(nonatomic,assign) id<AsyncWebConnectionDelegate> asyncDelegate;

-(void)stop;
-(BOOL)syncStart;
-(void)asyncStart;
-(void)asyncWebStart;

@end

@protocol ConnectivityDelegate

@optional
-(void)connectivityChanged: (ConnectivityCheck* )check;
    
@end
@protocol AsyncWebConnectionDelegate <NSObject>

@optional
- (void)asyncConnectionResult:(BOOL)result;
- (void)asyncFailWithError:(NSError *)anError;
@end
