/*
	ArcosArrayOfRequestItemBO.h
	The implementation of properties and methods for the ArcosArrayOfRequestItemBO array.
	Generated by SudzC.com
*/
#import "ArcosArrayOfRequestItemBO.h"

#import "ArcosRequestItemBO.h"
@implementation ArcosArrayOfRequestItemBO

	+ (id) createWithNode: (CXMLNode*) node
	{
		return [[[self alloc] initWithNode: node] autorelease];
	}

	- (id) initWithNode: (CXMLNode*) node
	{
		if(self = [self init]) {
			for(CXMLElement* child in [node children])
			{
				ArcosRequestItemBO* value = [[ArcosRequestItemBO createWithNode: child] object];
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
			[s appendString: [item serialize: @"RequestItemBO"]];
		}
		return s;
	}
@end
