//
//  CustomerContactBaseTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 29/02/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerContactInputDelegate.h"

@interface CustomerContactBaseTableCell : UITableViewCell {
    id<CustomerContactInputDelegate> delegate;
    NSMutableDictionary* cellData;
    NSIndexPath* indexPath;
}

@property(nonatomic,assign) id<CustomerContactInputDelegate> delegate;
@property(nonatomic,retain) NSMutableDictionary* cellData;
@property(nonatomic,retain) NSIndexPath* indexPath;

-(void)configCellWithData:(NSMutableDictionary*)theData;

@end
