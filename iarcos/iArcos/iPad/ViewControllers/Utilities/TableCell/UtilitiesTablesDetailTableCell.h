//
//  UtilitiesTablesDetailTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 20/03/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UtilitiesTablesDetailTableCell : UITableViewCell {
    UILabel* tableName;
    UILabel* recordQuantity;
    NSMutableDictionary* cellData;
    NSIndexPath* indexPath;
}

@property(nonatomic, retain) IBOutlet UILabel* tableName;
@property(nonatomic, retain) IBOutlet UILabel* recordQuantity;
@property(nonatomic, retain) NSMutableDictionary* cellData;
@property(nonatomic, retain) NSIndexPath* indexPath;
@end
