//
//  CustomerContactTypesTableCellFactory.m
//  Arcos
//
//  Created by David Kilmartin on 26/06/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "CustomerContactTypesTableCellFactory.h"

@interface CustomerContactTypesTableCellFactory (Private)

-(CustomerBaseTableCell*)getCellWithIdentifier:(NSString*)idendifier;

@end

@implementation CustomerContactTypesTableCellFactory

+(id)factory{
    return [[[self alloc]init]autorelease];
}

-(CustomerBaseTableCell*)createCustomerContactBaseTableCellWithData:(NSMutableDictionary*)data {
    int fieldTypeCode = [[data objectForKey:@"fieldTypeCode"] intValue];
    CustomerBaseTableCell* cell = nil;
    switch (fieldTypeCode) {
        case 0:
            cell = [self createCustomerContactIURTableCell];
            break;
            
        case 1:
            cell = [self createCustomerContactStringTableCell];
            break;
            
        case 2:
            cell = [self createCustomerContactBooleanTableCell];
            break;
            
        default:
            cell = [self createCustomerContactStringTableCell];
            break;
    }
    return cell;
}

-(CustomerBaseTableCell*)createCustomerContactIURTableCell {
    return [self getCellWithIdentifier:@"IdCustomerContactIURTableCell"];
}

-(CustomerBaseTableCell*)createCustomerContactStringTableCell {
    return [self getCellWithIdentifier:@"IdCustomerContactStringTableCell"];
}

-(CustomerBaseTableCell*)createCustomerContactBooleanTableCell {
    return [self getCellWithIdentifier:@"IdCustomerContactBooleanTableCell"];
}

-(UITableViewCell*)getCellWithIdentifier:(NSString*)idendifier {
    UITableViewCell* cell = nil;
    
    NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"CustomerContactTypeTableCells" owner:self options:nil];
    
    for (id nibItem in nibContents) {
        //switch between editable and none editable order product cell
        if ([nibItem isKindOfClass:[UITableViewCell class]] && [[(UITableViewCell *)nibItem reuseIdentifier] isEqualToString: idendifier]) {
            cell= (UITableViewCell *) nibItem;            
        }        
    }    
    return cell;
}

-(NSString*)identifierWithData:(NSMutableDictionary*)data {
    int fieldTypeCode = [[data objectForKey:@"fieldTypeCode"] intValue];
    NSString* identifier = nil;
    switch (fieldTypeCode) {
        case 0:
            identifier = @"IdCustomerContactIURTableCell";
            break;
        case 1:
            identifier = @"IdCustomerContactStringTableCell";
            break;
        case 2:
            identifier = @"IdCustomerContactBooleanTableCell";
            break;
            
        default:
            identifier = @"IdCustomerContactStringTableCell";
            break;
    }
    return identifier;
}

@end
