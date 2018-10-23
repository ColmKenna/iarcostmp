//
//  OrderLineDetailProductDataManager.m
//  Arcos
//
//  Created by David Kilmartin on 25/06/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "OrderLineDetailProductDataManager.h"
#import "ArcosCoreData.h"

@implementation OrderLineDetailProductDataManager
@synthesize displayList = _displayList;
@synthesize originalDisplayList = _originalDisplayList;
@synthesize orderLineOrderCart = _orderLineOrderCart;
@synthesize parentOrderLineList = _parentOrderLineList;
@synthesize orderNumber = _orderNumber;
@synthesize formIUR = _formIUR;
@synthesize standardOrderFormFlag = _standardOrderFormFlag;

- (id)init {
    self = [super init];
    if (self != nil) {
        self.displayList = [NSMutableArray array];
        self.originalDisplayList = [NSMutableArray array];
        self.standardOrderFormFlag = NO;
    }
    return self;
}

- (void)dealloc {
    if (self.displayList != nil) { self.displayList = nil; }
    self.originalDisplayList = nil;
    if (self.orderLineOrderCart != nil) { self.orderLineOrderCart = nil; }
    if (self.parentOrderLineList != nil) { self.parentOrderLineList = nil; }
    if (self.orderNumber != nil) { self.orderNumber = nil; }        
    self.formIUR = nil;
        
    [super dealloc];
}

- (NSMutableArray*)productWithDescriptionKeyword:(NSString*)aKeyword {
    NSMutableArray* products = [[ArcosCoreData sharedArcosCoreData] productWithDescriptionKeyword:aKeyword];
    if (products == nil) {
        self.displayList = [NSMutableArray array];
    } else {
        self.displayList = [NSMutableArray arrayWithCapacity:[products count]];
        for (NSMutableDictionary* aProduct in products) {//loop products            
            NSMutableDictionary* formRow = [ProductFormRowConverter createFormRowWithProduct:aProduct];
            formRow = [self syncFormRowWithOrderCart:formRow];
            [self.displayList addObject:formRow];
        }
    }    
    return self.displayList;
}

- (void)importExistentOrderLineToOrderCart:(NSMutableArray*)anOrderLineList {
    self.orderLineOrderCart = [NSMutableDictionary dictionary];
    self.parentOrderLineList = [NSMutableArray arrayWithArray:anOrderLineList];
//    NSLog(@"self.parentOrderLineList %@", self.parentOrderLineList);
    
    for (int i = 0; i < [self.parentOrderLineList count]; i++) {
        NSMutableDictionary* tmpOrderLine = [self.parentOrderLineList objectAtIndex:i];        
        NSMutableDictionary* tmpFormRow = [ProductFormRowConverter createFormRowWithOrderLine:tmpOrderLine];
        [tmpFormRow setObject:[NSNumber numberWithBool:YES] forKey:@"IsSelected"];
        [self.orderLineOrderCart setObject:tmpFormRow forKey:[tmpFormRow objectForKey:@"CombinationKey"]];
    }    
}

- (NSMutableDictionary*)syncFormRowWithOrderCart:(NSMutableDictionary*)aFormRowDict {
    NSString* combinationKey = [aFormRowDict objectForKey:@"CombinationKey"];
    if (self.orderLineOrderCart != nil) {
        NSMutableDictionary* tmpOrderLineDict = [self.orderLineOrderCart objectForKey:combinationKey];
        if (tmpOrderLineDict != nil) {
            return tmpOrderLineDict;
        }
    }
    return aFormRowDict;
}

- (void)saveOrderLineToOrderCart:(NSMutableDictionary*)anOrderLineDict {
    NSString* detail = [anOrderLineDict objectForKey:@"Details"];
    NSNumber* productIUR = [anOrderLineDict objectForKey:@"ProductIUR"];
    NSString* cartKey = [NSString stringWithFormat:@"%@->%@",detail,[productIUR stringValue]];
    
    NSMutableDictionary* tmpOrderLine = [self.orderLineOrderCart objectForKey:cartKey];
    
    NSNumber* isSelected = [anOrderLineDict objectForKey:@"IsSelected"];
    if (tmpOrderLine == nil && [isSelected boolValue]) {
        if (anOrderLineDict != nil) {
            [self.orderLineOrderCart setObject:anOrderLineDict forKey:cartKey];
        }
    } else {
        if ([isSelected boolValue]) {
            [self.orderLineOrderCart setObject:anOrderLineDict forKey:cartKey];
        } else {
            [self.orderLineOrderCart removeObjectForKey:cartKey];
        }
    }
}

- (BOOL)checkFormIURStandardFlag {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"FormIUR = %@ AND ProductIUR > 0", self.formIUR];
    NSMutableArray* objectList = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"FormRow" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:nil withResulType:NSCountResultType needDistinct:NO ascending:nil];
    NSNumber* recordCount = [objectList objectAtIndex:0];
    self.standardOrderFormFlag = [recordCount boolValue];
    return self.standardOrderFormFlag;
}

- (BOOL)showSeparatorWithFormIUR:(NSNumber*)aFormIUR {
    NSDictionary* formDetailDict = [[ArcosCoreData sharedArcosCoreData] formDetailWithFormIUR:aFormIUR];
    if (formDetailDict != nil) {
        NSNumber* showSeparator = [formDetailDict objectForKey:@"ShowSeperators"];
        return [showSeparator boolValue];
    }
    return NO;
}

- (void)retrieveStandardFormDataList:(NSNumber*)aLocationIUR {
    NSMutableArray* formRowDictList = [[ArcosCoreData sharedArcosCoreData] formRowWithDividerIURSortByNatureOrder:[NSNumber numberWithInt:-1] withFormIUR:self.formIUR locationIUR:aLocationIUR];
    if (formRowDictList == nil) {
        self.displayList = [NSMutableArray array];
    } else {
        self.displayList = [NSMutableArray arrayWithCapacity:[formRowDictList count]];
        for (NSMutableDictionary* aFormRowDict in formRowDictList) {//loop formRowDictList
            NSMutableDictionary* auxFormRowDict = [self syncFormRowWithOrderCart:aFormRowDict];
            [self.displayList addObject:auxFormRowDict];
        }
    }
    self.originalDisplayList = [NSMutableArray arrayWithArray:self.displayList];
}

@end
