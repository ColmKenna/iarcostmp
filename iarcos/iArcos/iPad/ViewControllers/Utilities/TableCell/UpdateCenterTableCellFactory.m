//
//  UpdateCenterTableCellFactory.m
//  Arcos
//
//  Created by David Kilmartin on 04/12/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "UpdateCenterTableCellFactory.h"

@interface UpdateCenterTableCellFactory (Private)

-(UtilitiesUpdateCenterDataTableCell*)getCellWithIdentifier:(NSString*)idendifier;
@end

@implementation UpdateCenterTableCellFactory

+(id)factory{
    return [[[self alloc]init]autorelease];
}



-(UtilitiesUpdateCenterDataTableCell*)createUpdateCenterCellWithData:(NSMutableDictionary*)aCellData {
    return [self createUpdateCenterDataTableCell];
}

-(UtilitiesUpdateCenterDataTableCell*)createUpdateCenterDataTableCell {
    return [self getCellWithIdentifier:@"UtilitiesUpdateCenterDataTableCell"];
}

-(UITableViewCell*)getCellWithIdentifier:(NSString*)idendifier{
    UITableViewCell* cell=nil;
    
    NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"UtilitiesUpdateCenterDataTableCell" owner:self options:nil];
    
    for (id nibItem in nibContents) {
        //swith between editable and none editable order product cell
        if ([nibItem isKindOfClass:[UITableViewCell class]] && [[(UITableViewCell *)nibItem reuseIdentifier] isEqualToString: idendifier]) {
            cell= (UITableViewCell *) nibItem;          
            
        }    
        
    }
    
    return cell;
}
@end
