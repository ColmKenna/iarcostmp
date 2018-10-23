//
//  BranchLeafProductGridListTableViewCell.m
//  Arcos
//
//  Created by David Kilmartin on 06/09/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "BranchLeafProductGridListTableViewCell.h"

@implementation BranchLeafProductGridListTableViewCell
//@synthesize selectedImageView = _selectedImageView;
@synthesize productImageView = _productImageView;
@synthesize orderPadDetails = _orderPadDetails;
@synthesize description = _description;
@synthesize productCode = _productCode;
@synthesize productSize = _productSize;
@synthesize qty = _qty;
@synthesize bonus = _bonus;
@synthesize divideLabel = _divideLabel;
@synthesize spQty = _spQty;
@synthesize spBon = _spBon;
@synthesize spDividerLabel = _spDividerLabel;
@synthesize discount = _discount;
@synthesize indexPath = _indexPath;
@synthesize cellDelegate = _cellDelegate;
@synthesize theCellData = _theCellData;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc {
//    if (self.selectedImageView != nil) { self.selectedImageView = nil; }
    if (self.productImageView != nil) { self.productImageView = nil; }
    if (self.orderPadDetails != nil) { self.orderPadDetails = nil; }
    if (self.description != nil) { self.description = nil; }
    if (self.productCode != nil) { self.productCode = nil; }
    if (self.productSize != nil) { self.productSize = nil; }
    if (self.qty != nil) { self.qty = nil; }
    if (self.bonus != nil) { self.bonus = nil; }
    if (self.divideLabel != nil) { self.divideLabel = nil; }
    if (self.spQty != nil) { self.spQty = nil; }
    if (self.spBon != nil) { self.spBon = nil; }
    if (self.spDividerLabel != nil) { self.spDividerLabel = nil; }
    if (self.discount != nil) { self.discount = nil; }
    if (self.indexPath != nil) { self.indexPath = nil; }
    if (self.theCellData != nil) { self.theCellData = nil; }
    
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configCellWithData:(NSMutableDictionary*)theData {
    self.productImageView.layer.masksToBounds = YES;
    [self.productImageView.layer setCornerRadius:5.0f];
    self.theCellData = theData;
    NSNumber* imageIur = [theData objectForKey:@"ImageIUR"];
    UIImage* anImage = nil;
    BOOL isCompanyImage = NO;
    if ([imageIur intValue] > 0) {
        anImage= [[ArcosCoreData sharedArcosCoreData]thumbWithIUR:imageIur];
    }else{
        anImage= [[ArcosCoreData sharedArcosCoreData]thumbWithIUR:[NSNumber numberWithInt:1]];
        isCompanyImage = YES;
    }
    if (anImage == nil) {
        anImage = [UIImage imageNamed:@"iArcos_72.png"];
    }
    self.productImageView.image = anImage;
    if (isCompanyImage) {
        self.productImageView.alpha = [GlobalSharedClass shared].imageCellAlpha;
    } else {
        self.productImageView.alpha = 1.0;
    }
    UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapGesture)];
    doubleTap.numberOfTapsRequired = 2;
    [self.productImageView addGestureRecognizer:doubleTap];
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture)];
    [singleTap requireGestureRecognizerToFail:doubleTap];
    [self.productImageView addGestureRecognizer:singleTap];
    
    [doubleTap release];
    [singleTap release];
    self.orderPadDetails.text = [theData objectForKey:@"OrderPadDetails"];
    self.productCode.text = [theData objectForKey:@"ProductCode"];
    self.productSize.text = [theData objectForKey:@"ProductSize"];
    self.description.text = [theData objectForKey:@"Details"];
    NSNumber* bonusBy = [theData objectForKey:@"Bonusby"];
    NSNumber* stockAvailable = [theData objectForKey:@"StockAvailable"];
    if (stockAvailable != nil && [stockAvailable intValue] == 0) {
        self.description.textColor = [UIColor lightGrayColor];
    } else if ([bonusBy intValue] != 78) {
        self.description.textColor = [UIColor colorWithRed:1.0 green:0.64453125 blue:0.0 alpha:1.0];
    } else {
        self.description.textColor = [UIColor blackColor];
    }
    self.qty.text = [ArcosUtils convertZeroToBlank:[[theData objectForKey:@"Qty"]stringValue]];
    self.bonus.text = [ArcosUtils convertZeroToBlank:[[theData objectForKey:@"Bonus"]stringValue]];
    self.spQty.text = [ArcosUtils convertZeroToBlank:[[theData objectForKey:@"InStock"]stringValue]];
    self.spBon.text = [ArcosUtils convertZeroToBlank:[[theData objectForKey:@"FOC"]stringValue]];
    if ([ProductFormRowConverter isSelectedWithFormRowDict:theData] && [[theData objectForKey:@"DiscountPercent"]floatValue] != 0) {
        self.discount.text = [NSString stringWithFormat:@"%1.2f%%",[[theData objectForKey:@"DiscountPercent"]floatValue]];
    } else {
        self.discount.text = @"";
    }
}

- (void)configSelectedImageView:(NSIndexPath*)selectedIndexPath {
    if (selectedIndexPath != nil && self.indexPath.row == selectedIndexPath.row) {
//        self.selectedImageView.backgroundColor = [UIColor redColor];
    } else {
//        self.selectedImageView.backgroundColor = [UIColor clearColor];
    }
}

- (void)handleDoubleTapGesture {
    [self.cellDelegate showBigProductImageWithProductCode:self.productCode.text];
}

- (void)handleSingleTapGesture {
    [self.cellDelegate showProductDetailWithProductIUR:[self.theCellData objectForKey:@"ProductIUR"] indexPath:self.indexPath];
}

- (void)configToShowDiscBonus:(NSNumber*)aDiscountAllowedNumber {
    BOOL discountAllowedFlag = [aDiscountAllowedNumber boolValue];
    if ([aDiscountAllowedNumber boolValue]) {
        self.discount.hidden = !discountAllowedFlag;
        self.bonus.hidden = discountAllowedFlag;
        self.spBon.hidden = discountAllowedFlag;
        self.spDividerLabel.hidden = discountAllowedFlag;
    }     
}

- (void)configToShowSplitPack:(BOOL)aShowSeparator {
    self.spQty.hidden = !aShowSeparator;
    self.spBon.hidden = !aShowSeparator;
    self.spDividerLabel.hidden = !aShowSeparator;
}

@end
