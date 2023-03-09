//
//  DetailingTreeBaseTableCell.h
//  iArcos
//
//  Created by Richard on 23/02/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface DetailingTreeBaseTableCell : UITableViewCell {
    UILabel* _descLabel;
    NSIndexPath* _myIndexPath;
}

@property(nonatomic, retain) IBOutlet UILabel* descLabel;
@property(nonatomic, retain) NSIndexPath* myIndexPath;

- (void)configCellWithData:(NSMutableDictionary*)aData;

@end


