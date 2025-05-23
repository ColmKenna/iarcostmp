/*
	ArcosCreateRecordObject.h
	The interface definition of properties and methods for the ArcosCreateRecordObject object.
	Generated by SudzC.com
*/

#import "Soap.h"
	
@class ArcosArrayOfString;
@class ArcosArrayOfString;

@interface ArcosCreateRecordObject : SoapObject
{
	NSMutableArray* _FieldValues;
	NSMutableArray* _FieldNames;
	
}
		
	@property (retain, nonatomic) NSMutableArray* FieldValues;
	@property (retain, nonatomic) NSMutableArray* FieldNames;

	+ (ArcosCreateRecordObject*) createWithNode: (CXMLNode*) node;
	- (id) initWithNode: (CXMLNode*) node;
	- (NSMutableString*) serialize;
	- (NSMutableString*) serialize: (NSString*) nodeName;
	- (NSMutableString*) serializeAttributes;
	- (NSMutableString*) serializeElements;

@end
