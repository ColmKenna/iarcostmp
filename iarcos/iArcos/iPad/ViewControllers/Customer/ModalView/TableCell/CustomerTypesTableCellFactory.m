//
//  CustomerTypesTableCellFactory.m
//  Arcos
//
//  Created by David Kilmartin on 10/01/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "CustomerTypesTableCellFactory.h"

@interface CustomerTypesTableCellFactory (Private)

-(CustomerBaseTableCell*)getCellWithIdentifier:(NSString*)idendifier;

@end

@implementation CustomerTypesTableCellFactory

+(id)factory{
    return [[[self alloc]init]autorelease];
}

-(CustomerBaseTableCell*)createCustomerBaseTableCellWithData:(NSMutableDictionary*)data {
    int fieldTypeCode = [[data objectForKey:@"fieldTypeCode"] intValue];
    CustomerBaseTableCell* cell = nil;
    switch (fieldTypeCode) {
        case 0:
            cell = [self createCustomerIURTableCell];
            break;
            
        case 1:
            cell = [self createCustomerStringTableCell];
            break;
            
        case 2:
            cell = [self createSwitchBooleanTableCell];
            break;
            
        default:
            cell = [self createCustomerStringTableCell];
            break;
    }
    return cell;
}

-(CustomerBaseTableCell*)createCustomerIURTableCell {
    return [self getCellWithIdentifier:@"IdCustomerIURTableCell"];
}

-(CustomerBaseTableCell*)createCustomerStringTableCell {
    return [self getCellWithIdentifier:@"IdCustomerStringTableCell"];
}

-(CustomerBaseTableCell*)createSwitchBooleanTableCell {
    return [self getCellWithIdentifier:@"IdCustomerBooleanTableCell"];
}

-(UITableViewCell*)getCellWithIdentifier:(NSString*)idendifier {
    UITableViewCell* cell=nil;
    
    NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"CustomerTypeTableCells" owner:self options:nil];
    
    for (id nibItem in nibContents) {
        //switch between editable and none editable order product cell
        if ([nibItem isKindOfClass:[UITableViewCell class]] && [[(UITableViewCell *)nibItem reuseIdentifier] isEqualToString: idendifier]) {
            cell= (UITableViewCell *) nibItem;
            break;
        }        
    }    
    return cell;
}

-(NSString*)identifierWithData:(NSMutableDictionary*)data {
    int fieldTypeCode = [[data objectForKey:@"fieldTypeCode"] intValue];
    NSString* identifier = nil;
    switch (fieldTypeCode) {
        case 0:
            identifier = @"IdCustomerIURTableCell";
            break;
        case 1:
            identifier = @"IdCustomerStringTableCell";
            break;
        case 2:
            identifier = @"IdCustomerBooleanTableCell";
            break;
            
        default:
            identifier = @"IdCustomerStringTableCell";
            break;
    }
    return identifier;
}

@end
