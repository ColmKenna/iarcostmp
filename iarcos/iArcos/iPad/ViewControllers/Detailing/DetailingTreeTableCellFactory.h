//
//  DetailingTreeTableCellFactory.h
//  iArcos
//
//  Created by Richard on 23/02/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DetailingTreeBaseTableCell.h"


@interface DetailingTreeTableCellFactory : NSObject {
    NSString* _branchTableCellId;
    NSString* _leafTableCellId;
}

@property(nonatomic, retain) NSString* branchTableCellId;
@property(nonatomic, retain) NSString* leafTableCellId;

- (NSString*)identifierWithData:(NSMutableDictionary*)aData;
- (DetailingTreeBaseTableCell*)createDetailingTreeBaseTableCellWithData:(NSMutableDictionary*)aData;

@end


