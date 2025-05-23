/*
	ArcosArrayOfOrderOrCallHeaders.h
	The implementation of properties and methods for the ArcosArrayOfOrderOrCallHeaders array.
	Generated by SudzC.com
*/
#import "ArcosArrayOfOrderOrCallHeaders.h"

#import "ArcosOrderOrCallHeaders.h"
@implementation ArcosArrayOfOrderOrCallHeaders

	+ (id) createWithNode: (CXMLNode*) node
	{
		return [[[self alloc] initWithNode: node] autorelease];
	}

	- (id) initWithNode: (CXMLNode*) node
	{
		if(self = [self init]) {
			for(CXMLElement* child in [node children])
			{
				ArcosOrderOrCallHeaders* value = [[ArcosOrderOrCallHeaders createWithNode: child] object];
				if(value != nil) {
					[self addObject: value];
				}
			}
		}
		return self;
	}
	
	+ (NSMutableString*) serialize: (NSArray*) array
	{
		NSMutableString* s = [NSMutableString string];
		for(id item in array) {
			[s appendString: [item serialize: @"OrderOrCallHeaders"]];
		}
		return s;
	}
@end
