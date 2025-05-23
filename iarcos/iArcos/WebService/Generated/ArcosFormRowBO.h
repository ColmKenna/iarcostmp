/*
	ArcosFormRowBO.h
	The interface definition of properties and methods for the ArcosFormRowBO object.
	Generated by SudzC.com
*/

#import "Soap.h"
	

@interface ArcosFormRowBO : SoapObject
{
	int _Iur;
	int _FormIUR;
	int _ProductIUR;
	NSString* _Details;
	int _SequenceNumber;
	int _SequenceDivider;
	NSDecimalNumber* _UnitPrice;
	
}
		
	@property int Iur;
	@property int FormIUR;
	@property int ProductIUR;
	@property (retain, nonatomic) NSString* Details;
	@property int SequenceNumber;
	@property int SequenceDivider;
	@property (retain, nonatomic) NSDecimalNumber* UnitPrice;

	+ (ArcosFormRowBO*) createWithNode: (CXMLNode*) node;
	- (id) initWithNode: (CXMLNode*) node;
	- (NSMutableString*) serialize;
	- (NSMutableString*) serialize: (NSString*) nodeName;
	- (NSMutableString*) serializeAttributes;
	- (NSMutableString*) serializeElements;

@end
