//
//  QueryOrderMemoCellFactory.m
//  Arcos
//
//  Created by David Kilmartin on 30/05/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "QueryOrderMemoCellFactory.h"
@interface QueryOrderMemoCellFactory ()

-(QueryOrderTMBaseTableCell*)getCellWithIdentifier:(NSString*)idendifier;

@end

@implementation QueryOrderMemoCellFactory

+(id)factory{
    return [[[self alloc]init]autorelease];
}

-(QueryOrderTMBaseTableCell*)createCustomerBaseTableCellWithData:(NSMutableDictionary*)data {
    int fieldTypeCode = [[data objectForKey:@"fieldTypeCode"] intValue];
    QueryOrderTMBaseTableCell* cell = nil;
    switch (fieldTypeCode) {
        case 0:
            cell = [self createMemoIURTableCell];
            break;
            
        case 1:
            cell = [self createMemoStringTableCell];
            break;
            
        case 2:
            cell = [self createMemoBooleanTableCell];
            break;
            
        default:
            cell = [self createMemoStringTableCell];
            break;
    }
    return cell;
}

-(QueryOrderTMBaseTableCell*)createMemoIURTableCell {
    return [self getCellWithIdentifier:@"IdQueryOrderMemoIURTableCell"];
}

-(QueryOrderTMBaseTableCell*)createMemoStringTableCell {
    return [self getCellWithIdentifier:@"IdQueryOrderMemoStringViewTableCell"];
}

-(QueryOrderTMBaseTableCell*)createMemoBooleanTableCell {
    return [self getCellWithIdentifier:@"IdQueryOrderMemoBooleanTableCell"];
}

-(UITableViewCell*)getCellWithIdentifier:(NSString*)idendifier {
    UITableViewCell* cell=nil;
    
    NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"QueryOrderMemoTypeTableCells" owner:self options:nil];
    
    for (id nibItem in nibContents) {
        if ([nibItem isKindOfClass:[UITableViewCell class]] && [[(UITableViewCell *)nibItem reuseIdentifier] isEqualToString: idendifier]) {
            cell = (UITableViewCell *) nibItem;
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
            identifier = @"IdQueryOrderMemoIURTableCell";
            break;
        case 1:
            identifier = @"IdQueryOrderMemoStringViewTableCell";
            break;
        case 2:
            identifier = @"IdQueryOrderMemoBooleanTableCell";
            break;
            
        default:
            identifier = @"IdQueryOrderMemoIURTableCell";
            break;
    }
    return identifier;
}


@end
