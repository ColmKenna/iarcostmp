//
//  OrderSharedClass.h
//  Arcos
//
//  Created by David Kilmartin on 27/07/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"
#import "ArcosArrayOfCallTran.h"
#import "SettingManager.h"


@interface OrderSharedClass : NSObject {
    //order global variable
    NSMutableDictionary* currentOrderForm;
    NSMutableDictionary* currentOrderCart;
    NSMutableDictionary* currentOrderHeader;

    //IURs
    NSNumber* currentFormIUR;
    NSNumber* currentSelectionIUR;
    NSMutableDictionary* _lastPositionDict;
}
+ (OrderSharedClass *)sharedOrderSharedClass;
-(id)init;


@property (nonatomic,retain)     NSMutableDictionary* currentOrderForm;
@property (nonatomic,retain)     NSMutableDictionary* currentOrderCart;
@property (nonatomic,retain)     NSMutableDictionary* currentOrderHeader;

//IURs
@property (nonatomic,retain) NSNumber* currentFormIUR;
@property (nonatomic,retain)  NSNumber* currentSelectionIUR;
@property (nonatomic,retain) NSMutableDictionary* lastPositionDict;

//order form
-(BOOL)anyForm;
-(BOOL)isFormExist:(NSString*)formName;
-(NSString*)getFormName;
-(void)insertForm:(NSString*)formName;
-(void)insertFormIUR:(NSNumber*)aFormIUR;
-(void)clearForms;
-(BOOL)isProductInCurrentFormWithIUR:(NSNumber*)anIUR;
//order selecction
-(BOOL)anySelections;
-(BOOL)isSelectionExist:(NSString*)selectionName;
-(BOOL)insertSelection:(NSString*)selectionName;
-(BOOL)anyFormRowsForSelection:(NSString*)selectionName;
-(NSMutableDictionary*)formRowsFromSelection:(NSString*)selectionName;
-(BOOL)setFormRows:(NSMutableDictionary*)formRows ForSelection:(NSString*)selectionName;

-(BOOL)debugOrderForm;
//order cart
-(BOOL)saveOrderLine:(NSMutableDictionary*)anOrderLine;
-(NSMutableArray*)getSortedCartKeys:(NSArray*)valueList;
-(BOOL)anyOrderLine;

//detailing
-(BOOL)saveAnOrderWithHearder:(NSMutableDictionary*)orderHeader withCallTrans:(ArcosArrayOfCallTran*)callTrans;
-(NSMutableDictionary*)getADefaultOrderHeader;
//customer
-(NSString*)currentCustomerName;
-(NSString*)currentCustomerAddress;
-(NSString*)currentCustomerPhoneNumber;
-(NSString*)currentContactName;

//order header
-(void)setOrderHeaderToDefault;
-(void)refreshCurrentOrderDate;
-(void)resetTheWholesellerWithLocation:(NSNumber*)anIUR;
//clear current order
-(void)clearCurrentOrder;

//save current order
-(BOOL)saveCurrentOrder:(NSNumber**)anOrderNumberResult;
-(BOOL)saveCall;

//sync to all selection
-(BOOL)syncAllSelectionsWithRowData:(NSMutableDictionary*)data;
-(NSMutableDictionary*)syncRowWithCurrentCart:(NSMutableDictionary*)row;
-(NSMutableDictionary*)syncNewSelection:(NSMutableDictionary*)formRows;
-(NSMutableArray*)createAlphabeticSortedKey:(NSArray*)valueList;

@end
