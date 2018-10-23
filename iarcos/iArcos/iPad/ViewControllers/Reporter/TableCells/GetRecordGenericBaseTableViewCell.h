//
//  GetRecordGenericBaseTableViewCell.h
//  iArcos
//
//  Created by David Kilmartin on 20/05/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetRecordGenericTypeTableCellDelegate.h"
#import "GetRecordTypeGenericBaseObject.h"

@interface GetRecordGenericBaseTableViewCell : UITableViewCell {
    id<GetRecordGenericTypeTableCellDelegate> _delegate;
    UILabel* _fieldDesc;
    NSIndexPath* _indexPath;
    int _employeeSecurityLevel;
    NSMutableDictionary* _cellData;
}

@property(nonatomic, assign) id<GetRecordGenericTypeTableCellDelegate> delegate;
@property(nonatomic, retain) IBOutlet UILabel* fieldDesc;
@property(nonatomic, retain) NSIndexPath* indexPath;
@property(nonatomic, assign) int employeeSecurityLevel;
@property(nonatomic, retain) NSMutableDictionary* cellData;

- (void)configCellWithData:(NSMutableDictionary*)aData;

@end
