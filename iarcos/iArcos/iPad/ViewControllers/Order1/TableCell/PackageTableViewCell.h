//
//  PackageTableViewCell.h
//  iArcos
//
//  Created by Richard on 21/07/2022.
//  Copyright © 2022 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PackageTableViewCellDelegate.h"
#import "ArcosCoreData.h"

@interface PackageTableViewCell : UITableViewCell {
    id<PackageTableViewCellDelegate> _actionDelegate;
    UIImageView* _myImageView;
    UILabel* _packageDesc;
    UILabel* _accountCode;
    NSIndexPath* _myIndexPath;
}

@property(nonatomic, assign) id<PackageTableViewCellDelegate> actionDelegate;
@property(nonatomic, retain) IBOutlet UIImageView* myImageView;
@property(nonatomic, retain) IBOutlet UILabel* packageDesc;
@property(nonatomic, retain) IBOutlet UILabel* accountCode;
@property(nonatomic, retain) NSIndexPath* myIndexPath;

- (void)configCellWithData:(NSMutableDictionary*)aData;

@end


