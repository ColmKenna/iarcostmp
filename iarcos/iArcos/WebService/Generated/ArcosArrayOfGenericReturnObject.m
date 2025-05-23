/*
	ArcosArrayOfGenericReturnObject.h
	The implementation of properties and methods for the ArcosArrayOfGenericReturnObject array.
	Generated by SudzC.com
*/
#import "ArcosArrayOfGenericReturnObject.h"

#import "ArcosGenericReturnObject.h"
@implementation ArcosArrayOfGenericReturnObject

	+ (id) createWithNode: (CXMLNode*) node
	{
		return [[[self alloc] initWithNode: node] autorelease];
	}

	- (id) initWithNode: (CXMLNode*) node
	{
		if(self = [self init]) {
			for(CXMLElement* child in [node children])
			{
				ArcosGenericReturnObject* value = [[ArcosGenericReturnObject createWithNode: child] object];
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
			[s appendString: [item serialize: @"GenericReturnObject"]];
		}
		return s;
	}
@end
