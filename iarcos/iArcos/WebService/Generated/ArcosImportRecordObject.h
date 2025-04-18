/*
	ArcosImportRecordObject.h
	The interface definition of properties and methods for the ArcosImportRecordObject object.
	Generated by SudzC.com
*/

#import "Soap.h"
	
@class ArcosArrayOfImportRecordField;

@interface ArcosImportRecordObject : SoapObject
{
	NSMutableArray* _FieldValues;
	
}
		
	@property (retain, nonatomic) NSMutableArray* FieldValues;

	+ (ArcosImportRecordObject*) createWithNode: (CXMLNode*) node;
	- (id) initWithNode: (CXMLNode*) node;
	- (NSMutableString*) serialize;
	- (NSMutableString*) serialize: (NSString*) nodeName;
	- (NSMutableString*) serializeAttributes;
	- (NSMutableString*) serializeElements;

@end
