/*
	ArcosArrayOfDescrTypeBO.h
	The implementation of properties and methods for the ArcosArrayOfDescrTypeBO array.
	Generated by SudzC.com
*/
#import "ArcosArrayOfDescrTypeBO.h"

#import "ArcosDescrTypeBO.h"
@implementation ArcosArrayOfDescrTypeBO

	+ (id) createWithNode: (CXMLNode*) node
	{
		return [[[self alloc] initWithNode: node] autorelease];
	}

	- (id) initWithNode: (CXMLNode*) node
	{
		if(self = [self init]) {
			for(CXMLElement* child in [node children])
			{
				ArcosDescrTypeBO* value = [[ArcosDescrTypeBO createWithNode: child] object];
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
			[s appendString: [item serialize: @"DescrTypeBO"]];
		}
		return s;
	}
@end
