//
//  OrderProductTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 14/07/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "OrderProductTableCell.h"


@implementation OrderProductTableCell
@synthesize productImageView = _productImageView;
@synthesize  description;
@synthesize rrpPrice = _rrpPrice;
@synthesize  price;
@synthesize  qty;
@synthesize  value;
@synthesize  discount;
@synthesize  bonus;
@synthesize  editButton;
@synthesize  selectIndicator;
@synthesize  data;
@synthesize  theIndexPath;
@synthesize InStock;
@synthesize FOC;
@synthesize orderPadDetails;
@synthesize productCode;
@synthesize productSize;
@synthesize cellDelegate = _cellDelegate;
@synthesize cellData = _cellData;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)needEditButton:(BOOL)need{
    self.editButton.hidden=!need;
}

-(void)flipSelectStatus{
    isSelected=!isSelected;
    [(NSMutableDictionary*) self.data setObject:[NSNumber numberWithBool:isSelected] forKey:@"IsSelected"];
    if (isSelected) {
        self.selectIndicator.backgroundColor=[UIColor redColor];
        
    }else{
        self.selectIndicator.backgroundColor=[UIColor whiteColor];
        
    }
}
-(void)setSelectStatus:(BOOL)select{
    isSelected=select;
    if (isSelected) {
        self.selectIndicator.backgroundColor=[UIColor redColor];
        [self.selectIndicator setHidden:NO];
        self.backgroundColor = [UIColor colorWithRed:144.0/255.0 green:238.0/255.0 blue:144.0/255.0 alpha:.2];
    }else{
        self.selectIndicator.backgroundColor=[UIColor whiteColor];
        [self.selectIndicator setHidden:YES];
        self.backgroundColor = [UIColor whiteColor];
    }
}

- (void)configBackgroundColour:(BOOL)select {
    isSelected=select;
    if (isSelected) {
        self.backgroundColor = [UIColor colorWithRed:144.0/255.0 green:238.0/255.0 blue:144.0/255.0 alpha:.2];
    }else{
        self.backgroundColor = [UIColor whiteColor];
    }
}

- (void)dealloc
{
    if (self.productImageView != nil) { self.productImageView = nil; }
    if (self.description != nil) { self.description = nil; }
    self.rrpPrice = nil;
    if (self.price != nil) { self.price = nil; }    
    if (self.qty != nil) { self.qty = nil; }    
    if (self.value != nil) { self.value = nil; }
    if (self.discount != nil) { self.discount = nil; }    
    if (self.bonus != nil) { self.bonus = nil; }
    if (self.editButton != nil) { self.editButton = nil; }
    if (self.selectIndicator != nil) { self.selectIndicator = nil; }    
    if (self.data != nil) { self.data = nil; }    
    if (self.theIndexPath != nil) { self.theIndexPath = nil; }
    if (self.InStock != nil) { self.InStock = nil; }
    if (self.FOC != nil) { self.FOC = nil; }
    if (self.orderPadDetails != nil) { self.orderPadDetails = nil; }
    if (self.productCode != nil) { self.productCode = nil; }
    if (self.productSize != nil) { self.productSize = nil; }
    if (self.cellData != nil) { self.cellData = nil; }
            
    [super dealloc];
}

-(void)configCellWithData:(NSMutableDictionary*)theData {
    self.productImageView.layer.masksToBounds = YES;
    [self.productImageView.layer setCornerRadius:5.0f];
    self.cellData = theData;
    self.InStock.hidden = NO;
    if ([ArcosConfigDataManager sharedArcosConfigDataManager].recordInStockRBFlag) {
        if ([[ArcosConfigDataManager sharedArcosConfigDataManager] hideInStockRBFlag]) {
            self.InStock.hidden = YES;
        }
        NSNumber* myInStockNumber = [theData objectForKey:@"InStock"];
        if ([myInStockNumber intValue] == 0) {
            self.productImageView.image = [UIImage imageNamed:@"shelf_empty.png"];
        } else {
            self.productImageView.image = [UIImage imageNamed:@"shelf_full.png"];
        }
    } else {
        NSNumber* imageIur = [self.cellData objectForKey:@"ImageIUR"];
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
    }
    
    
    UITapGestureRecognizer* singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(drilldownTapGesture:)];
    [self.productImageView addGestureRecognizer:singleTap2];
    if ([ArcosConfigDataManager sharedArcosConfigDataManager].recordInStockRBFlag) {
        UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapGesture)];
        doubleTap.numberOfTapsRequired = 2;
        [self.productImageView addGestureRecognizer:doubleTap];
        [singleTap2 requireGestureRecognizerToFail:doubleTap];
        [doubleTap release];
    }    
    [singleTap2 release];
}

- (void)configMatImageWithLocationIUR:(NSNumber*)aLocationIUR productIUR:(NSNumber*)aProductIUR {
    if ([ArcosConfigDataManager sharedArcosConfigDataManager].recordInStockRBFlag) return;
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] retrieveLocationProductMATDataLocallyFlag] && [[ArcosConfigDataManager sharedArcosConfigDataManager] showMATImageFlag]) {
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"locationIUR = %@ and productIUR = %@", aLocationIUR, aProductIUR];
        NSNumber* locationProductMatCount = [[ArcosCoreData sharedArcosCoreData] recordQtyWithEntityName:@"LocationProductMAT" predicate:predicate];
        if ([locationProductMatCount intValue] > 0) {
            NSNumber* imageIur = [NSNumber numberWithInt:150];
            UIImage* anImage = nil;
            anImage = [[ArcosCoreData sharedArcosCoreData] thumbWithIUR:imageIur];
            if (anImage == nil) {
                anImage = [UIImage imageNamed:@"iArcos_72.png"];
            }
            self.productImageView.image = anImage;
            self.productImageView.alpha = 1.0;
        }
    }
}

- (void)drilldownTapGesture:(id)sender {
    if ([ArcosConfigDataManager sharedArcosConfigDataManager].recordInStockRBFlag) {
        [self.cellDelegate toggleShelfImageWithData:(NSMutableDictionary*)self.data];
    } else {
        NSNumber* tmpProductIUR = [self.cellData objectForKey:@"ProductIUR"];
        [self.cellDelegate displayProductDetailWithProductIUR:tmpProductIUR indexPath:self.theIndexPath];
    }
}

- (void)handleDoubleTapGesture {
//    NSString* tmpProductCode = [self.cellData objectForKey:@"ProductCode"];
//    [self.cellDelegate displayBigProductImageWithProductCode:tmpProductCode];
    NSNumber* tmpProductIUR = [self.cellData objectForKey:@"ProductIUR"];
    [self.cellDelegate displayProductDetailWithProductIUR:tmpProductIUR indexPath:self.theIndexPath];
}

@end
