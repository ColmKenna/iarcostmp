/*
	ArcosSudzc.h
	Creates a list of the services available with the Arcos prefix.
	Generated by SudzC.com
*/
#import "ArcosService.h"

@interface ArcosSudzC : NSObject {
	BOOL logging;
	NSString* server;
	NSString* defaultServer;
ArcosService* service;

}

-(id)initWithServer:(NSString*)serverName;
-(void)updateService:(SoapService*)service;
-(void)updateServices;
+(ArcosSudzC*)sudzc;
+(ArcosSudzC*)sudzcWithServer:(NSString*)serverName;

@property (nonatomic) BOOL logging;
@property (nonatomic, retain) NSString* server;
@property (nonatomic, retain) NSString* defaultServer;

@property (nonatomic, retain, readonly) ArcosService* service;

@end
			