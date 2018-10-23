//
//  QueryOrderTMBaseTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 29/05/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerTypeTableCellDelegate.h"

@interface QueryOrderTMBaseTableCell : UITableViewCell {
    id<CustomerTypeTableCellDelegate> _delegate;
    NSMutableDictionary* cellData;
    NSIndexPath* indexPath;
    int _employeeSecurityLevel;
    NSNumber* _locationIUR;
    NSString* _locationName;
}

@property(nonatomic,assign) id<CustomerTypeTableCellDelegate> delegate;
@property(nonatomic,retain) NSMutableDictionary* cellData;
@property(nonatomic,retain) NSIndexPath* indexPath;
@property(nonatomic,assign) int employeeSecurityLevel;
@property(nonatomic,retain) NSNumber* locationIUR;
@property(nonatomic,retain) NSString* locationName;

- (void)configCellWithData:(NSMutableDictionary*)theData;

@end
