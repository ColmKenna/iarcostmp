/*
	ArcosMemoBO.h
	The interface definition of properties and methods for the ArcosMemoBO object.
	Generated by SudzC.com
*/

#import "Soap.h"
	

@interface ArcosMemoBO : SoapObject
{
	int _iur;
	int _MTiur;
	int _Contactiur;
	int _Locationiur;
	int _Calliur;
	int _Tableiur;
	NSString* _TableName;
	int _Employeeiur;
	BOOL _FullFilled;
	NSDate* _DateEntered;
	NSString* _Details;
	NSString* _Subject;
	NSDate* _DateLastModified;
	int _TaskIUR;
	
}
		
	@property int iur;
	@property int MTiur;
	@property int Contactiur;
	@property int Locationiur;
	@property int Calliur;
	@property int Tableiur;
	@property (retain, nonatomic) NSString* TableName;
	@property int Employeeiur;
	@property BOOL FullFilled;
	@property (retain, nonatomic) NSDate* DateEntered;
	@property (retain, nonatomic) NSString* Details;
	@property (retain, nonatomic) NSString* Subject;
	@property (retain, nonatomic) NSDate* DateLastModified;
	@property int TaskIUR;

	+ (ArcosMemoBO*) createWithNode: (CXMLNode*) node;
	- (id) initWithNode: (CXMLNode*) node;
	- (NSMutableString*) serialize;
	- (NSMutableString*) serialize: (NSString*) nodeName;
	- (NSMutableString*) serializeAttributes;
	- (NSMutableString*) serializeElements;

@end
