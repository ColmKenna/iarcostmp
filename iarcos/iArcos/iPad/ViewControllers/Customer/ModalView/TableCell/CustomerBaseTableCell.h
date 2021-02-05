//
//  CustomerBaseTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 09/01/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerTypeTableCellDelegate.h"
#import "GlobalSharedClass.h"

@interface CustomerBaseTableCell : UITableViewCell {
    id<CustomerTypeTableCellDelegate> _delegate;
    NSMutableDictionary* cellData;
    NSIndexPath* indexPath;
    int _employeeSecurityLevel;
    UILabel* _redAsterixLabel;
}

@property(nonatomic,assign) id<CustomerTypeTableCellDelegate> delegate;
@property(nonatomic,retain) NSMutableDictionary* cellData;
@property(nonatomic,retain) NSIndexPath* indexPath;
@property(nonatomic,assign) int employeeSecurityLevel;
@property(nonatomic,retain) IBOutlet UILabel* redAsterixLabel;

-(void)configCellWithData:(NSMutableDictionary*)theData;
- (void)configRedAsterix;

@end
