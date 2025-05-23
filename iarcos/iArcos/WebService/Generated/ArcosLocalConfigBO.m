/*
	ArcosLocalConfigBO.h
	The implementation of properties and methods for the ArcosLocalConfigBO object.
	Generated by SudzC.com
*/
#import "ArcosLocalConfigBO.h"

@implementation ArcosLocalConfigBO
	@synthesize EmployeeIUR = _EmployeeIUR;
	@synthesize Name = _Name;
	@synthesize OwnDataOnly = _OwnDataOnly;
	@synthesize OTiur = _OTiur;
	@synthesize CTiur = _CTiur;
	@synthesize OSiur = _OSiur;
	@synthesize SentIUR = _SentIUR;
	@synthesize TransmittedIUR = _TransmittedIUR;

	- (id) init
	{
		if(self = [super init])
		{
			self.Name = nil;

		}
		return self;
	}

	+ (ArcosLocalConfigBO*) createWithNode: (CXMLNode*) node
	{
		if(node == nil) { return nil; }
		return [[[self alloc] initWithNode: node] autorelease];
	}

	- (id) initWithNode: (CXMLNode*) node {
		if(self = [super initWithNode: node])
		{
			self.EmployeeIUR = [[Soap getNodeValue: node withName: @"EmployeeIUR"] intValue];
			self.Name = [Soap getNodeValue: node withName: @"Name"];
			self.OwnDataOnly = [[Soap getNodeValue: node withName: @"OwnDataOnly"] boolValue];
			self.OTiur = [[Soap getNodeValue: node withName: @"OTiur"] intValue];
			self.CTiur = [[Soap getNodeValue: node withName: @"CTiur"] intValue];
			self.OSiur = [[Soap getNodeValue: node withName: @"OSiur"] intValue];
			self.SentIUR = [[Soap getNodeValue: node withName: @"SentIUR"] intValue];
			self.TransmittedIUR = [[Soap getNodeValue: node withName: @"TransmittedIUR"] intValue];
		}
		return self;
	}

	- (NSMutableString*) serialize
	{
		return [self serialize: @"LocalConfigBO"];
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
		[s appendFormat: @"<EmployeeIUR>%@</EmployeeIUR>", [NSString stringWithFormat: @"%i", self.EmployeeIUR]];
		if (self.Name != nil) [s appendFormat: @"<Name>%@</Name>", [[self.Name stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		[s appendFormat: @"<OwnDataOnly>%@</OwnDataOnly>", (self.OwnDataOnly)?@"true":@"false"];
		[s appendFormat: @"<OTiur>%@</OTiur>", [NSString stringWithFormat: @"%i", self.OTiur]];
		[s appendFormat: @"<CTiur>%@</CTiur>", [NSString stringWithFormat: @"%i", self.CTiur]];
		[s appendFormat: @"<OSiur>%@</OSiur>", [NSString stringWithFormat: @"%i", self.OSiur]];
		[s appendFormat: @"<SentIUR>%@</SentIUR>", [NSString stringWithFormat: @"%i", self.SentIUR]];
		[s appendFormat: @"<TransmittedIUR>%@</TransmittedIUR>", [NSString stringWithFormat: @"%i", self.TransmittedIUR]];

		return s;
	}
	
	- (NSMutableString*) serializeAttributes
	{
		NSMutableString* s = [super serializeAttributes];

		return s;
	}
	
	-(BOOL)isEqual:(id)object{
		if(object != nil && [object isKindOfClass:[ArcosLocalConfigBO class]]) {
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
		[super dealloc];
	}

@end
