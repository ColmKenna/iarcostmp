/*
	ArcosLocationSummary.h
	The implementation of properties and methods for the ArcosLocationSummary object.
	Generated by SudzC.com
*/
#import "ArcosLocationSummary.h"

@implementation ArcosLocationSummary
	@synthesize Iur = _Iur;
	@synthesize Name = _Name;
	@synthesize Address1 = _Address1;
	@synthesize Address2 = _Address2;
	@synthesize Address3 = _Address3;
	@synthesize Address4 = _Address4;
	@synthesize Address5 = _Address5;

	- (id) init
	{
		if(self = [super init])
		{
			self.Name = nil;
			self.Address1 = nil;
			self.Address2 = nil;
			self.Address3 = nil;
			self.Address4 = nil;
			self.Address5 = nil;

		}
		return self;
	}

	+ (ArcosLocationSummary*) createWithNode: (CXMLNode*) node
	{
		if(node == nil) { return nil; }
		return [[[self alloc] initWithNode: node] autorelease];
	}

	- (id) initWithNode: (CXMLNode*) node {
		if(self = [super initWithNode: node])
		{
			self.Iur = [[Soap getNodeValue: node withName: @"Iur"] intValue];
			self.Name = [Soap getNodeValue: node withName: @"Name"];
			self.Address1 = [Soap getNodeValue: node withName: @"Address1"];
			self.Address2 = [Soap getNodeValue: node withName: @"Address2"];
			self.Address3 = [Soap getNodeValue: node withName: @"Address3"];
			self.Address4 = [Soap getNodeValue: node withName: @"Address4"];
			self.Address5 = [Soap getNodeValue: node withName: @"Address5"];
		}
		return self;
	}

	- (NSMutableString*) serialize
	{
		return [self serialize: @"LocationSummary"];
	}
  
	- (NSMutableString*) serialize: (NSString*) nodeName
	{
		NSMutableString* s = [NSMutableString string];
		[s appendFormat: @"<%@", nodeName];
		[s appendString: [self serializeAttributes]];
		[s appendString: @">"];
		[s appendString: [self serializeElements]];
		[s appendFormat: @"</%@>", nodeName];
		return s;
	}
	
	- (NSMutableString*) serializeElements
	{
		NSMutableString* s = [super serializeElements];
		[s appendFormat: @"<Iur>%@</Iur>", [NSString stringWithFormat: @"%i", self.Iur]];
		if (self.Name != nil) [s appendFormat: @"<Name>%@</Name>", [[self.Name stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Address1 != nil) [s appendFormat: @"<Address1>%@</Address1>", [[self.Address1 stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Address2 != nil) [s appendFormat: @"<Address2>%@</Address2>", [[self.Address2 stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Address3 != nil) [s appendFormat: @"<Address3>%@</Address3>", [[self.Address3 stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Address4 != nil) [s appendFormat: @"<Address4>%@</Address4>", [[self.Address4 stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Address5 != nil) [s appendFormat: @"<Address5>%@</Address5>", [[self.Address5 stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];

		return s;
	}
	
	- (NSMutableString*) serializeAttributes
	{
		NSMutableString* s = [super serializeAttributes];

		return s;
	}
	
	-(BOOL)isEqual:(id)object{
		if(object != nil && [object isKindOfClass:[ArcosLocationSummary class]]) {
			return [[self serialize] isEqualToString:[object serialize]];
		}
		return NO;
	}
	
	-(NSUInteger)hash{
		return [Soap generateHash:self];

	}
	
	- (void) dealloc
	{
		self.Name = nil;
		self.Address1 = nil;
		self.Address2 = nil;
		self.Address3 = nil;
		self.Address4 = nil;
		self.Address5 = nil;
		[super dealloc];
	}

@end
