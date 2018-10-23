//
//  BranchLeafProductGridListTableViewCell.h
//  Arcos
//
//  Created by David Kilmartin on 06/09/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArcosCoreData.h"
#import <QuartzCore/QuartzCore.h>
@protocol BranchLeafProductGridListTableViewCellDelegate;

@interface BranchLeafProductGridListTableViewCell : UITableViewCell {
//    UIImageView* _selectedImageView;
    UIImageView* _productImageView;
    UILabel* _orderPadDetails;//brands
    UILabel* _description;
    UILabel* _productCode;
    UILabel* _productSize;
    UILabel* _qty;
    UILabel* _bonus;
    UILabel* _divideLabel;
    UILabel* _spQty;
    UILabel* _spBon;
    UILabel* _spDividerLabel;
    UILabel* _discount;
    NSIndexPath* _indexPath;
    id<BranchLeafProductGridListTableViewCellDelegate> _cellDelegate;
    NSMutableDictionary* _theCellData;
}

//@property(nonatomic, retain) IBOutlet UIImageView* selectedImageView;
@property(nonatomic, retain) IBOutlet UIImageView* productImageView;
@property(nonatomic, retain) IBOutlet UILabel* orderPadDetails;
@property(nonatomic, retain) IBOutlet UILabel* description;
@property(nonatomic, retain) IBOutlet UILabel* productCode;
@property(nonatomic, retain) IBOutlet UILabel* productSize;
@property(nonatomic, retain) IBOutlet UILabel* qty;
@property(nonatomic, retain) IBOutlet UILabel* bonus;
@property(nonatomic, retain) IBOutlet UILabel* divideLabel;
@property(nonatomic, retain) IBOutlet UILabel* spQty;
@property(nonatomic, retain) IBOutlet UILabel* spBon;
@property(nonatomic, retain) IBOutlet UILabel* spDividerLabel;
@property(nonatomic, retain) IBOutlet UILabel* discount;
@property(nonatomic, retain) NSIndexPath* indexPath;
@property(nonatomic, assign) id<BranchLeafProductGridListTableViewCellDelegate> cellDelegate;
@property(nonatomic, retain) NSMutableDictionary* theCellData;

-(void)configCellWithData:(NSMutableDictionary*)theData;
- (void)configSelectedImageView:(NSIndexPath*)selectedIndexPath;
- (void)configToShowDiscBonus:(NSNumber*)aDiscountAllowedNumber;
- (void)configToShowSplitPack:(BOOL)aShowSeparator;

@end

@protocol BranchLeafProductGridListTableViewCellDelegate <NSObject>

- (void)showBigProductImageWithProductCode:(NSString*)aProductCode;
- (void)showProductDetailWithProductIUR:(NSNumber*)aProductIUR indexPath:(NSIndexPath*)anIndexPath;

@end
