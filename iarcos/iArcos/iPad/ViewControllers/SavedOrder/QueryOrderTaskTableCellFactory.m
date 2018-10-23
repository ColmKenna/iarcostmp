//
//  QueryOrderTaskTableCellFactory.m
//  Arcos
//
//  Created by David Kilmartin on 28/05/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "QueryOrderTaskTableCellFactory.h"
@interface QueryOrderTaskTableCellFactory ()

-(QueryOrderTMBaseTableCell*)getCellWithIdentifier:(NSString*)idendifier;

@end

@implementation QueryOrderTaskTableCellFactory

+(id)factory{
    return [[[self alloc]init]autorelease];
}

-(QueryOrderTMBaseTableCell*)createCustomerBaseTableCellWithData:(NSMutableDictionary*)data {
    int fieldTypeCode = [[data objectForKey:@"fieldTypeCode"] intValue];
    QueryOrderTMBaseTableCell* cell = nil;
    switch (fieldTypeCode) {
        case 0:
            cell = [self createTaskIURTableCell];
            break;
            
        case 1:
            cell = [self createTaskStringTableCell];
            break;
            
        case 2:
            cell = [self createTaskBooleanTableCell];
            break;
            
        case 3:
            cell = [self createTaskDateTableCell];
            break;
            
        case 4:
            cell = [self createTaskByteTableCell];
            break;
            
        case 5:
            cell = [self createTaskIntTableCell];
            break;
            
        default:
            cell = [self createTaskByteTableCell];
            break;
    }
    return cell;
}

-(QueryOrderTMBaseTableCell*)createTaskIURTableCell {
    return [self getCellWithIdentifier:@"IdQueryOrderTaskIURTableCell"];
}

-(QueryOrderTMBaseTableCell*)createTaskStringTableCell {
    return [self getCellWithIdentifier:@"IdQueryOrderTaskStringViewTableCell"];
}

-(QueryOrderTMBaseTableCell*)createTaskBooleanTableCell {
    return [self getCellWithIdentifier:@"IdQueryOrderTaskBooleanTableCell"];
}

-(QueryOrderTMBaseTableCell*)createTaskDateTableCell {
    return [self getCellWithIdentifier:@"IdQueryOrderTaskDateTableCell"];
}

-(QueryOrderTMBaseTableCell*)createTaskByteTableCell {
    return [self getCellWithIdentifier:@"IdQueryOrderTaskByteTableCell"];
}

-(QueryOrderTMBaseTableCell*)createTaskIntTableCell {
    return [self getCellWithIdentifier:@"IdQueryOrderTaskIntTableCell"];
}

-(UITableViewCell*)getCellWithIdentifier:(NSString*)idendifier {
    UITableViewCell* cell=nil;
    
    NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"QueryOrderTaskTypeTableCells" owner:self options:nil];
    
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
            identifier = @"IdQueryOrderTaskIURTableCell";
            break;
        case 1:
            identifier = @"IdQueryOrderTaskStringViewTableCell";
            break;
        case 2:
            identifier = @"IdQueryOrderTaskBooleanTableCell";
            break;
        case 3:
            identifier = @"IdQueryOrderTaskDateTableCell";
            break;
        case 4:
            identifier = @"IdQueryOrderTaskByteTableCell";
            break;
        case 5:
            identifier = @"IdQueryOrderTaskIntTableCell";
            break;
            
        default:
            identifier = @"IdQueryOrderTaskByteTableCell";
            break;
    }
    return identifier;
}

@end
