//
//  ConnectivityCheck.m
//  Arcos
//
//  Created by David Kilmartin on 21/12/2011.
//  Copyright (c) 2011 Strata IT Limited. All rights reserved.
//

#import "ConnectivityCheck.h"
#import "SettingManager.h"
#import "ArcosService.h"
#import "ArcosGenericReturnObject.h"
#import "SettingManager.h"
#import "ActivateAppStatusManager.h"
#import "ArcosUtils.h"
NSString *const kConnectivityChangeNotification = @"ConnectivityChangeNotification";

@interface ConnectivityCheck (Private) 
-(void)connectionReset;
-(BOOL)webFileExistsOnAddress:(NSString*)address;
-(BOOL)fillStatus;
-(void)connectionErrorString;
-(void)asyncWebFileExistsOnAddress:(NSString*)address;
-(NSError*)asyncRegisterErrorGenerator;
@end

@implementation ConnectivityCheck
@synthesize  wifiConnected;
@synthesize  cell3GConnected;
@synthesize  VPNConnected;
@synthesize  hostConnected;
@synthesize  serviceConnected;
@synthesize  serviceCallAvailable;
@synthesize  needVPNCheck;
@synthesize  hostReach;
@synthesize internetReach;
@synthesize serviceTimeout;
@synthesize errorString;
@synthesize delegate;
@synthesize isRegisterValidation = _isRegisterValidation;
@synthesize asyncDelegate = _asyncDelegate;
@synthesize httpStatusCode = _httpStatusCode;
@synthesize urlConnection = _urlConnection;
-(id)init{
    self=[super init];
    if (self!=nil) {
        //[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
        
        //seprate the port number out of host address
        NSString* hostAddress=[SettingManager hostAddress];
        NSRange rng = [hostAddress rangeOfString:@":"];
        NSString* hostString=@"";
        NSString* portString=@"";
        
        //any port number associated with host address
        if (rng.location != NSNotFound) {
            NSArray* comps=[hostAddress componentsSeparatedByString:@":"];
            hostString=[comps objectAtIndex:0];
            portString=[comps objectAtIndex:1];
        }else{
            hostString=hostAddress;
        }
        hostString = @"www.stratait.ie";
//        NSLog(@"hostString: %@",hostString);
        //init all flags
        self.wifiConnected=NO;
        self.cell3GConnected=NO;
        self.VPNConnected=NO;
        self.hostConnected=NO;
        self.serviceConnected=NO;
        
        self.needVPNCheck=NO;
        self.serviceCallAvailable=NO;
        
        timeOutCounter=0;
        self.serviceTimeout=NO;
        //init a host reachability
//        self.hostReach=[Reachability reachabilityWithHostName:hostString];
        //self.hostReach=[Reachability reachabilityWithHostName:@"10.205.104.63"];
//        [self.hostReach startNotifier];
        
        self.internetReach=[Reachability reachabilityForInternetConnection];
        //[self.internetReach startNotifier];
        
        busy=NO;
        needAsync=YES;
        
        errorString=@"Unknown error!";
        self.isRegisterValidation = NO;
        self.httpStatusCode = -1;
    }
    return self;
}

//Called by Reachability whenever status changes.
- (void) reachabilityChanged: (NSNotification* )note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    
    //set the flags
    if (curReach==self.hostReach) {
        [self fillStatus];
        
    }
}
-(BOOL)fillStatus{
    
    //check basic connection  (step 1)
    self.wifiConnected=self.hostReach.isReachableViaWiFi;
    self.cell3GConnected=self.hostReach.isReachableViaWWAN;
    
    //check VPN
    if (self.needVPNCheck) {
        self.VPNConnected=self.hostReach.isVPNRequired;
    }
    self.wifiConnected = YES;
    self.cell3GConnected = YES;
    self.VPNConnected = YES;
    
    //check host reachable    (step 2)
//    NSLog(@"is host reachable %d %d %d",self.hostReach.isReachable, self.wifiConnected, self.cell3GConnected);
    if (self.wifiConnected||self.cell3GConnected) {//we have wifi or 3G
        if (self.needVPNCheck) {//we need VPN check
            if (self.VPNConnected) {//VPN connected 
                self.hostConnected=YES;
            }else{//VPN not connected
                self.hostConnected=NO;
            }
        }else{//not need VPN check
            self.hostConnected=YES;
        }
    }else{//we don't have wifi and 3G
        self.hostConnected=NO;
        self.serviceConnected=NO;
        self.serviceCallAvailable=NO;
        
        if (needAsync) {
            [self connectionReset];
            return NO;
        }else {
            return NO;
        }
    }
    
    //check service connection  (step 3)
    NSString* serviceAddress=[SettingManager serviceAddress];
    //NSString* serviceAddress=@"http://172.19.18.109/iarcoswebservice/service.asm";
    
    

    self.serviceConnected=[self webFileExistsOnAddress:serviceAddress];
    //self.serviceConnected=[self webFileExistsOnAddress:@"http://172.19.18.109/iarcoswebservice/service.asmx"];//use to test the url with VPN
   
    
    if (needAsync) {
        if (!self.serviceConnected) {
            [self connectionReset];
            return NO;
        }
    }else {
        if (self.serviceConnected) {
            return YES;
        }else {
            return NO;
        }
    }

    
    
    //check service call connection  (step 4)
    self.serviceTimeout=NO;
    //set the service time out interval 
    [GlobalSharedClass shared].serviceTimeoutInterval=60.0;
    ArcosService* se=[ArcosService serviceWithUsername:@"u1103395_Support" andPassword:@"Strata411325"];
    NSString* sqlStatement =@"SELECT IUR FROM CONFIG WHERE IUR = 1";
    [se GetData:self action:@selector(serviceCheck:) stateMent:sqlStatement];

    
//    //overrall connection   (step 5)
//    if (self.hostConnected&&self.serviceConnected) {
//        self.serviceCallAvailable=YES;
//    }else{
//        self.serviceCallAvailable=NO;
//    }
//    
//    //post the notification  (final step)
//    [self connectionReset];
    return NO;
}

-(BOOL)syncStart{
    needAsync=NO;
    BOOL success=NO;
    
    if (!busy) {
        busy=YES;
        success=[self fillStatus];
        [self connectionErrorString];
        [self stop];
    }
    
    return success;
}

-(void)asyncStart{
    needAsync=YES;
    
    if (!busy) {
        busy=YES;
        
        //[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
        [self fillStatus];
    }
}
-(void)stop{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    //init all flags
    self.wifiConnected=NO;
    self.cell3GConnected=NO;
    self.VPNConnected=NO;
    self.hostConnected=NO;
    self.serviceConnected=NO;
    
    self.needVPNCheck=NO;
    self.serviceCallAvailable=NO;
    
    busy=NO;
}
-(void)connectionReset{
    //set error string
    [self connectionErrorString];
    
    // Post a notification to notify the client that the network reachability changed.
	//[[NSNotificationCenter defaultCenter] postNotificationName: kConnectivityChangeNotification 
														//object: (ConnectivityCheck *) self];
    [self.delegate connectivityChanged:self];
    //reset busy
    [self stop];
}
//check is the web file exsit
-(BOOL) webFileExistsOnAddress:(NSString*)address{
    return YES;
    /*
    NSString *url = address;
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
    NSHTTPURLResponse* response = nil;
    NSError* error = nil;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSLog(@"statusCode = %ld", [response statusCode]);
    self.httpStatusCode = [ArcosUtils convertNSIntegerToInt:[response statusCode]];
    if ([response statusCode] >= 400||[response statusCode] == 0){
        return NO;
    }
    else{
        return YES;
    }
     */
}

-(void)asyncWebFileExistsOnAddress:(NSString*)address {
    NSString *url = address;
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
    self.urlConnection = [[[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES] autorelease];
}

-(void)asyncWebStart {
    //check basic connection  (step 1)
    self.wifiConnected=self.hostReach.isReachableViaWiFi;
    self.cell3GConnected=self.hostReach.isReachableViaWWAN;
    
    //check VPN
    if (self.needVPNCheck) {
        self.VPNConnected=self.hostReach.isVPNRequired;
    }
    self.wifiConnected = YES;
    self.cell3GConnected = YES;
    self.VPNConnected = YES;
    
    //check host reachable    (step 2)
    //    NSLog(@"is host reachable %d %d %d",self.hostReach.isReachable, self.wifiConnected, self.cell3GConnected);
    if (self.wifiConnected||self.cell3GConnected) {//we have wifi or 3G
        if (self.needVPNCheck) {//we need VPN check
            if (self.VPNConnected) {//VPN connected
                self.hostConnected=YES;
            }else{//VPN not connected
                self.hostConnected=NO;
            }
        }else{//not need VPN check
            self.hostConnected=YES;
        }
    }else{//we don't have wifi and 3G
        self.hostConnected=NO;
        self.serviceConnected=NO;
        self.serviceCallAvailable=NO;
        [self connectionErrorString];
        NSError* tmpError = [self asyncRegisterErrorGenerator];
        [self.asyncDelegate asyncFailWithError:tmpError];
        return;
    }
    NSString* serviceAddress = [SettingManager serviceAddress];
    [self asyncWebFileExistsOnAddress:serviceAddress];
}
//web service call testing call back
-(void)serviceCheck:(id)result{
    //service time out do nothing
    
    BOOL callAvailable=NO;

    if (result!=nil) {
        if ([result isKindOfClass:[NSError class]]) {
            NSError* anError=(NSError*)result;
            NSLog(@"An error come back from service %@",[anError description]);
            callAvailable=NO;
            errorString=[anError description];
        } else if([result isKindOfClass:[SoapFault class]]){
            SoapFault* anFault=(SoapFault*) result;
            NSLog(@"An error come back from service %@",[anFault faultString]);
            callAvailable=NO;
            errorString=[anFault faultString];
        }else  {
            ArcosGenericReturnObject* objects=(ArcosGenericReturnObject*)result;
            if(objects.ErrorModel !=nil){
                callAvailable=YES;
//                NSLog(@"object back %@",objects);
            }else{
                callAvailable=NO;
            }
            
        }
        
    }else{
        NSLog(@"A null come back from service");
        callAvailable=NO;
    }
    
    //overrall connection   (step 5)
    if (self.hostConnected&&self.serviceConnected&&callAvailable) {
        self.serviceCallAvailable=YES;
    }else{
        self.serviceCallAvailable=NO;
    }
    
    
    //log the status
    NSLog(@"\n wifiConnected %d \n cell3GConnected %d \n VPNConnected %d \n hostConnected  %d \n serviceConnected %d \n serviceCallAvailable %d \n",self.wifiConnected,self.cell3GConnected,self.VPNConnected,self.hostConnected,self.serviceConnected,self.serviceCallAvailable);
    
    //post the notification  (final step)
    [self connectionReset];
    
}
-(void)checkServiceTimeOut{
    NSLog(@"connection check tick %d",timeOutCounter);
    //timeOutCounter++;
    if (timeOutCounter>5) {
        self.serviceTimeout=YES;
        self.serviceCallAvailable=NO;
        [self connectionReset];
    }
}

-(void)connectionErrorString{
    if (!self.wifiConnected && !self.cell3GConnected) {
//        errorString=@"No internet connection!";
        errorString=@"No 3G or Wi-Fi currently available!";
    }else if(self.needVPNCheck&&!self.VPNConnected){
        errorString= @"VPN is not connected!";
    }else if(!self.hostConnected){
        errorString= @"Host is not reachable!";
    }else if(!self.serviceConnected && !self.isRegisterValidation){
        ActivateAppStatusManager* tmpActivateAppStatusManager = [ActivateAppStatusManager appStatusInstance];
        if ([[tmpActivateAppStatusManager getAppStatus] isEqualToNumber:tmpActivateAppStatusManager.demoAppStatusNum]) {
            errorString = @"No Internet Access";
        } else {
//            errorString= [NSString stringWithFormat: @"Service is not available! %@ ",[SettingManager serviceAddress]];
            errorString= [NSString stringWithFormat: @"Service could not be accessed.\n%@\nReturned code was:%d",[SettingManager serviceAddress], self.httpStatusCode];
        }
    }else if(!self.serviceConnected && self.isRegisterValidation) {
        errorString = @"No Internet Access or URL not available.";
    }else if(!self.serviceCallAvailable){
        //errorString= @"Service call is not avaliable!";
    }else {
        errorString=@"No errors!";
    }
}

- (void)dealloc {
    if (self.hostReach != nil) {
        self.hostReach = nil;
    }
    if (self.internetReach != nil) {
        self.internetReach = nil;
    }
    self.urlConnection = nil;
//    self.delegate=nil;
    [super dealloc];
}

#pragma mark NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse*)response {
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSLog(@"http statusCode: %ld",httpResponse.statusCode);
    self.httpStatusCode = [ArcosUtils convertNSIntegerToInt:httpResponse.statusCode];
//    if (httpResponse.statusCode == 200) {
//        [self.asyncDelegate asyncConnectionResult:YES];
//    } else {
//        NSError* tmpError = [self asyncRegisterErrorGenerator];
//        [self.asyncDelegate asyncFailWithError:tmpError];
//    }
    if (self.httpStatusCode >= 400 || self.httpStatusCode == 0) {
        NSError* tmpError = [self asyncRegisterErrorGenerator];
        [self.asyncDelegate asyncFailWithError:tmpError];
    } else {
        [self.asyncDelegate asyncConnectionResult:YES];
    }
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)anError{
    NSError* tmpError = [self asyncRegisterErrorGenerator];
    [self.asyncDelegate asyncFailWithError:tmpError];
}
-(NSError*)asyncRegisterErrorGenerator {
    self.serviceConnected = NO;
    [self connectionErrorString];
    NSMutableDictionary* errorDetail = [NSMutableDictionary dictionary];
    [errorDetail setObject:self.errorString forKey:NSLocalizedDescriptionKey];
    return [NSError errorWithDomain:@"" code:404 userInfo:errorDetail];
}
@end
