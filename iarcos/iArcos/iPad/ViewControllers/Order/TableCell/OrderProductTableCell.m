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
//@synthesize uniLabel = _uniLabel;
//@synthesize udLabel = _udLabel;
@synthesize maxLabel = _maxLabel;
@synthesize prevLabel = _prevLabel;
@synthesize prevNormalLabel = _prevNormalLabel;
@synthesize qtyTextField = _qtyTextField;
@synthesize bonusTextField = _bonusTextField;
@synthesize discTextField = _discTextField;
@synthesize textFieldList = _textFieldList;
@synthesize textFieldTagIndexDict = _textFieldTagIndexDict;
@synthesize bonusBorderLabel = _bonusBorderLabel;
@synthesize discountBorderLabel = _discountBorderLabel;

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
//    self.uniLabel = nil;
//    self.udLabel = nil;
    self.maxLabel = nil;
    self.prevLabel = nil;
    self.prevNormalLabel = nil;
    self.qtyTextField = nil;
    self.bonusTextField = nil;
    self.discTextField = nil;
    self.textFieldList = nil;
    self.textFieldTagIndexDict = nil;
    self.bonusBorderLabel = nil;
    self.discountBorderLabel = nil;
            
    [super dealloc];
}

-(void)configCellWithData:(NSMutableDictionary*)theData {
    self.productImageView.layer.masksToBounds = YES;
    [self.productImageView.layer setCornerRadius:5.0f];
    self.cellData = theData;
    self.InStock.hidden = NO;
    if ([ArcosConfigDataManager sharedArcosConfigDataManager].recordInStockRBFlag) {
        if ([[ArcosConfigDataManager sharedArcosConfigDataManager] hideInStockRBFlag]) {
//            self.InStock.hidden = YES;
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
        if ([locationProductMatCount intValue] == 0) {
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

- (void)configPreviousWithLocationIUR:(NSNumber*)aLocationIUR productIUR:(NSNumber*)aProductIUR previousNumber:(NSNumber*)aPreviousNumber prevFlag:(BOOL)aPrevFlag prevLabel:(UILabel*)aPrevLable {
    aPrevLable.text = @"";
    if ([aPreviousNumber intValue] == 0) return;
    if (!aPrevFlag) return;
    NSArray* properties = [NSArray arrayWithObjects:@"qty01",@"qty02",@"qty03",@"qty04",@"qty05",@"qty06",@"qty07",@"qty08",@"qty09",@"qty10",@"qty11",@"qty12",@"qty13",@"qty14",@"qty15",@"qty16",@"qty17",@"qty18",@"qty19",@"qty20",@"qty21",@"qty22",@"qty23",@"qty24",@"qty25",nil];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"locationIUR = %@ and productIUR = %@", aLocationIUR, aProductIUR];
    NSMutableArray* objectArray = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"LocationProductMAT" withPropertiesToFetch:properties withPredicate:predicate withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:NO ascending:[NSNumber numberWithBool:NO]];
    if ([objectArray count] > 0) {
        NSDictionary* locationProductMATDict = [objectArray objectAtIndex:0];
        NSMutableArray* qtyList = [NSMutableArray arrayWithCapacity:25];
        for (int i = [ArcosUtils convertNSUIntegerToUnsignedInt:[properties count]] - 1; i >= 0; i--) {
            NSString* tmpKey = [properties objectAtIndex:i];
            [qtyList addObject:[ArcosUtils convertNilToZero:[locationProductMATDict objectForKey:tmpKey]]];
        }
        int prevSum = 0;
        for (int i = 0; i < [aPreviousNumber intValue]; i++) {
            prevSum += [[qtyList objectAtIndex:i] intValue];
        }
        aPrevLable.text = [ArcosUtils convertZeroToBlank:[NSString stringWithFormat:@"%d", prevSum]];
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

- (void)configTextFieldListWithKbFlag:(BOOL)aKbFlag data:(NSMutableDictionary*)aDataDict relatedFormDetailDict:(NSDictionary*)aRelatedFormDetailDict {
    @try {
        if (!aKbFlag) return;
        NSString* orderFormDetails = [ArcosUtils convertNilToEmpty:[aRelatedFormDetailDict objectForKey:@"Details"]];
        self.qtyTextField.text = [ArcosUtils convertZeroToBlank:[[aDataDict objectForKey:@"Qty"] stringValue]];
        self.bonusTextField.text = [ArcosUtils convertZeroToBlank:[[aDataDict objectForKey:@"Bonus"] stringValue]];
//        self.discTextField.text = [ArcosUtils convertZeroToBlank:[[aDataDict objectForKey:@"DiscountPercent"] stringValue]];
        float discountPercentValue = [[aDataDict objectForKey:@"DiscountPercent"] floatValue];
        if (discountPercentValue != 0) {
            self.discTextField.text = [NSString stringWithFormat:@"%1.2f", discountPercentValue];
        } else {
            self.discTextField.text = @"";
        }
        if ([[SettingManager databaseName] isEqualToString:[GlobalSharedClass shared].myDbName] && [orderFormDetails containsString:@"[NB]"]) {
            if ([self.qtyTextField.text isEqualToString:@""]) {
                self.discTextField.text = @"";
            }
        }
        NSNumber* allowDiscount = [SettingManager SettingForKeypath:@"CompanySetting.Order Processing" atIndex:1];
        if ([allowDiscount boolValue]) {
            self.discTextField.hidden = NO;
            self.bonusTextField.hidden = YES;
        } else {
            self.discTextField.hidden = YES;
            self.bonusTextField.hidden = NO;
        }
        SettingManager* sm = [SettingManager setting];
        NSMutableDictionary* presenterPwdDict = [sm getSettingForKeypath:@"CompanySetting.Connection" atIndex:8];
        NSString* presenterPwd = [[presenterPwdDict objectForKey:@"Value"] uppercaseString];
        NSRange aBDRange = [presenterPwd rangeOfString:@"[BD]"];
        if (aBDRange.location != NSNotFound) {
            self.discTextField.hidden = NO;
            self.bonusTextField.hidden = NO;
        }
        if ([ArcosConfigDataManager sharedArcosConfigDataManager].recordInStockRBFlag) {
            self.discTextField.hidden = YES;
        }
        //BonusGiven BonusRequired SellBy
        //disableBonusBoxWithPriceRecordFlag
        if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showRRPInOrderPadFlag] && ![orderFormDetails containsString:@"[BD]"]) {
            self.bonusTextField.hidden = YES;
            self.discTextField.hidden = YES;
        }
        if ([orderFormDetails containsString:@"[NB]"]) {
            self.bonusTextField.hidden = YES;
        }
        if ([orderFormDetails containsString:@"[ND]"]) {
            self.discTextField.hidden = YES;
        }
        if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showPackageFlag]) {
            self.discTextField.enabled = NO;
        } else {
            self.discTextField.enabled = YES;
        }
        if ([[ArcosConfigDataManager sharedArcosConfigDataManager] disableBonusBoxWithPriceRecordFlag] && ([[aDataDict objectForKey:@"PriceFlag"] intValue] == 1 || [[aDataDict objectForKey:@"PriceFlag"] intValue] == 2)) {
            self.bonusTextField.backgroundColor = [UIColor blackColor];
            self.bonusTextField.text = @"0";
        } else {
            self.bonusTextField.backgroundColor = [UIColor whiteColor];
        }
        [self configBonusStateWithData:aDataDict];
        
        self.textFieldList = [NSMutableArray arrayWithObjects:self.qtyTextField, nil];
        if (!self.bonusTextField.hidden) {
            [self.textFieldList addObject:self.bonusTextField];
        }
        if (!self.discTextField.hidden) {
            [self.textFieldList addObject:self.discTextField];
        }
        self.textFieldTagIndexDict = [NSMutableDictionary dictionary];
        for (int i = 0; i < [self.textFieldList count]; i++) {
            UITextField* tmpTextField = [self.textFieldList objectAtIndex:i];
            [self.textFieldTagIndexDict setObject:[NSNumber numberWithInt:i] forKey:[NSNumber numberWithInt:[ArcosUtils convertNSIntegerToInt:tmpTextField.tag]]];
        }
        for (int i = 0; i < [self.textFieldList count]; i++) {
            UITextField* tmpTextField = [self.textFieldList objectAtIndex:i];
    //        NSLog(@"innter tag %d", [ArcosUtils convertNSIntegerToInt:tmpTextField.tag]);
            tmpTextField.textColor = [UIColor blackColor];
        }
        if ([self.cellDelegate retrieveCurrentIndexPath] != nil && self.theIndexPath.row == [self.cellDelegate retrieveCurrentIndexPath].row && self.theIndexPath.row == [self.cellDelegate retrieveFirstProductRowIndex]) {
            NSLog(@"same myIndexPath first row");
            UITextField* tmpTextField = [self.textFieldList objectAtIndex:[self.cellDelegate retrieveCurrentTextFieldIndex]];
//            if ([self.cellDelegate retrieveCurrentTextFieldHighlightedFlag]) {
//                tmpTextField.textColor = [UIColor redColor];
//                NSLog(@"textfield highlighted");
//            }
            if (![self.cellDelegate retrieveFirstProductRowHasBeenShowedFlag]) {
                NSLog(@"tmpTextField becomeFirstResponder");
                [self.cellDelegate configFirstProductRowHasBeenShowedFlag:YES];
                [tmpTextField becomeFirstResponder];
            }
        }
        if ([self.cellDelegate retrieveCurrentIndexPath] != nil && self.theIndexPath.row == [self.cellDelegate retrieveCurrentIndexPath].row) {
            self.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.0 alpha:0.2];
        }
        
    } @catch (NSException *exception) {
        NSLog(@"configTextFieldListWithKbFlag %@", [exception reason]);
    }
}

- (void)configBonusStateWithData:(NSMutableDictionary*)aDataDict {
    switch ([[aDataDict objectForKey:@"SellBy"] intValue]) {
        case 0: {
            [self enableBonusFocWithFlag:YES];
        }
            break;
        case 1: {
            [self enableBonusFocWithFlag:NO];
        }
            break;
        case 2: {
            [self enableBonusFocWithFlag:YES];
        }
            break;
        case 3: {
            [self enableBonusFocWithFlag:NO];
        }
            break;
        case 4: {
            [self enableBonusFocWithFlag:YES];
        }
            break;
        default: {
            [self enableBonusFocWithFlag:YES];
        }
            break;
    }
}

- (void)enableBonusFocWithFlag:(BOOL)aFlag {
    self.bonusTextField.enabled = aFlag;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    NSMutableDictionary* currentData = (NSMutableDictionary*)self.data;
    if (textField.tag == 1 && !self.bonusTextField.hidden && self.bonusTextField.enabled && [[ArcosConfigDataManager sharedArcosConfigDataManager] disableBonusBoxWithPriceRecordFlag] && ([[currentData objectForKey:@"PriceFlag"] intValue] == 1 || [[currentData objectForKey:@"PriceFlag"] intValue] == 2)) {
        [ArcosUtils showDialogBox:@"Bonus Disabled on Discounted Prices" title:@"" target:[self.cellDelegate retrieveOrderProductParentViewController] handler:nil];
        return NO;
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    @try {
//        NSLog(@"currentData 0 %@",self.data);
        NSLog(@"textFieldDidBeginEditing %d - %@ - %ld", [ArcosUtils convertNSIntegerToInt:textField.tag], textField.text, self.theIndexPath.row);
    //    self.currentTextFieldIndex = [ArcosUtils convertNSIntegerToInt:textField.tag];
        NSNumber* tmpIndex = [self.textFieldTagIndexDict objectForKey:[NSNumber numberWithInt:[ArcosUtils convertNSIntegerToInt:textField.tag]]];
        [self.cellDelegate configCurrentTextFieldIndex:[tmpIndex intValue]];
        [self.cellDelegate configCurrentIndexPath:self.theIndexPath];
        [self.cellDelegate showFooterMatDataWithIndexPath:self.theIndexPath];
        NSLog(@"cc %d", [[self.cellDelegate retrieveCurrentTextFieldValueWithTag:[ArcosUtils convertNSIntegerToInt:textField.tag] forIndexPath:self.theIndexPath] intValue]);
        if (textField.tag != 2 && [[self.cellDelegate retrieveCurrentTextFieldValueWithTag:[ArcosUtils convertNSIntegerToInt:textField.tag] forIndexPath:self.theIndexPath] intValue] > 0) {
    //        self.currentTextFieldHighlightedFlag = YES;
            [self.cellDelegate configCurrentTextFieldHighlightedFlag:YES];
            textField.textColor = [UIColor redColor];
        } else if (textField.tag == 2 && [[self.cellDelegate retrieveCurrentTextFieldValueWithTag:[ArcosUtils convertNSIntegerToInt:textField.tag] forIndexPath:self.theIndexPath] floatValue] > 0) {
            [self.cellDelegate configCurrentTextFieldHighlightedFlag:YES];
            textField.textColor = [UIColor redColor];
        } else {
    //        self.currentTextFieldHighlightedFlag = NO;
            [self.cellDelegate configCurrentTextFieldHighlightedFlag:NO];
            textField.textColor = [UIColor blackColor];
        }
        NSLog(@"highlighted flag %d", [self.cellDelegate retrieveCurrentTextFieldHighlightedFlag]);
        self.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.0 alpha:0.2];
    } @catch (NSException *exception) {
        NSLog(@"textFieldDidBeginEditing %@", [exception reason]);
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    @try {
        NSLog(@"shouldChangeCharactersInRange %d - %@ - %@", [ArcosUtils convertNSIntegerToInt:textField.tag], textField.text, string);
        NSString* assembledString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSLog(@"assembledString %@", assembledString);
        if (textField.tag == 2) {// discount
            BOOL decimalFlag = [ArcosValidator isInputDecimalWithTwoPlaces:assembledString];
            BOOL replacementStringDecimalFlag = [ArcosValidator isInputDecimalWithTwoPlaces:string];
            if (replacementStringDecimalFlag && [self.cellDelegate retrieveCurrentTextFieldHighlightedFlag] && ![string isEqualToString:@""]) {
                NSLog(@"discount entered key 2 %@", string);
                textField.text = @"";
                [self.cellDelegate configCurrentTextFieldHighlightedFlag:NO];
                textField.textColor = [UIColor blackColor];
                return YES;
            } else if ([textField.text isEqualToString:@"0"] && [ArcosValidator isInteger:string]) {
                NSLog(@"discount entered key 3 %@", string);
                textField.text = @"";
                return YES;
            }
            return (decimalFlag || [assembledString isEqualToString:@""]);
        }
        
        BOOL integerFlag = [ArcosValidator isInteger:assembledString];
        
        BOOL enteredKey2Flag = NO;
        if ((integerFlag && [self.cellDelegate retrieveCurrentTextFieldHighlightedFlag] && ![string isEqualToString:@""])) {
            NSLog(@"entered key 2 %@", string);
            enteredKey2Flag = YES;
            [self.cellDelegate configCurrentTextFieldHighlightedFlag:NO];
            textField.textColor = [UIColor blackColor];
            /*
            if (textField.tag == 1 && [self bonusGivenAndBonusRequiredExistentFlag]) {
                NSMutableDictionary* currentData = (NSMutableDictionary*)self.data;
                int bonusMax = [self.qtyTextField.text intValue] / [[currentData objectForKey:@"BonusRequired"] intValue] * [[currentData objectForKey:@"BonusGiven"] intValue];
                int potentialBonus = [[ArcosUtils convertStringToNumber:string] intValue];
                int sellBy = [[currentData objectForKey:@"SellBy"] intValue];
                if (sellBy == 1) {
                    if (potentialBonus > bonusMax) {
                        textField.text = [NSString stringWithFormat:@"%d", bonusMax];
                        return NO;
                    }
                }
                if (sellBy == 3) {
                    textField.text = @"";
                    return NO;
                }
            }
             */
            if (textField.tag == 1 && [self bonusGivenAndBonusRequiredExistentFlag]) {
                int potentialBonus = [[ArcosUtils convertStringToNumber:string] intValue];
                if (![self checkFocusBonusWithGivenRequiredSellByMinimum:textField bonus:potentialBonus]) {
                    return NO;
                }
            }            
            if (textField.tag == 0) {//qty
                int potentialQty = [[ArcosUtils convertStringToNumber:string] intValue];
                [self checkBonusWithGivenRequiredSellBy:textField qty:potentialQty];
            }
            textField.text = @"";
        } else if ([textField.text isEqualToString:@"0"] && [ArcosValidator isInteger:string]) {
            NSLog(@"entered key 3 %@", string);
            /*
            if (textField.tag == 1 && [self bonusGivenAndBonusRequiredExistentFlag]) {
                NSMutableDictionary* currentData = (NSMutableDictionary*)self.data;
                int bonusMax = [self.qtyTextField.text intValue] / [[currentData objectForKey:@"BonusRequired"] intValue] * [[currentData objectForKey:@"BonusGiven"] intValue];
                int potentialBonus = [[ArcosUtils convertStringToNumber:string] intValue];
                int sellBy = [[currentData objectForKey:@"SellBy"] intValue];
                if (sellBy == 1) {
                    if (potentialBonus > bonusMax) {
                        textField.text = [NSString stringWithFormat:@"%d", bonusMax];
                        return NO;
                    }
                }
                if (sellBy == 3) {
                    textField.text = @"";
                    return NO;
                }
            }
             */
            if (textField.tag == 1 && [self bonusGivenAndBonusRequiredExistentFlag]) {
                int potentialBonus = [[ArcosUtils convertStringToNumber:string] intValue];
                if (![self checkFocusBonusWithGivenRequiredSellByMinimum:textField bonus:potentialBonus]) {
                    return NO;
                }
            }
            if (textField.tag == 0) {//qty
                int potentialQty = [[ArcosUtils convertStringToNumber:string] intValue];
                [self checkBonusWithGivenRequiredSellBy:textField qty:potentialQty];
            }
            textField.text = @"";
            return YES;
        }
        /*
        if (integerFlag && textField.tag == 1 && [self bonusGivenAndBonusRequiredExistentFlag] && !enteredKey2Flag) {
            NSMutableDictionary* currentData = (NSMutableDictionary*)self.data;
            int bonusMax = [self.qtyTextField.text intValue] / [[currentData objectForKey:@"BonusRequired"] intValue] * [[currentData objectForKey:@"BonusGiven"] intValue];
            int potentialBonus = [[ArcosUtils convertStringToNumber:assembledString] intValue];
            int sellBy = [[currentData objectForKey:@"SellBy"] intValue];
            if (sellBy == 1) {
                if (potentialBonus > bonusMax) {
                    textField.text = [NSString stringWithFormat:@"%d", bonusMax];
                    return NO;
                }
            }
            if (sellBy == 3) {
                textField.text = @"";
                return NO;
            }
        }
         */
        if (integerFlag && textField.tag == 1 && [self bonusGivenAndBonusRequiredExistentFlag] && !enteredKey2Flag) {
            int potentialBonus = [[ArcosUtils convertStringToNumber:assembledString] intValue];
            if (![self checkFocusBonusWithGivenRequiredSellByMinimum:textField bonus:potentialBonus]) {
                return NO;
            }
        }
        if (integerFlag && textField.tag == 0 && !enteredKey2Flag) {
            int potentialQty = [[ArcosUtils convertStringToNumber:assembledString] intValue];
            [self checkBonusWithGivenRequiredSellBy:textField qty:potentialQty];
        }
        return (integerFlag || [assembledString isEqualToString:@""]);
    } @catch (NSException *exception) {
        NSLog(@"shouldChangeCharactersInRange %@", [exception reason]);
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    @try {
        NSLog(@"textFieldDidEndEditing - %d - %@", [ArcosUtils convertNSIntegerToInt:textField.tag], textField.text);
        NSMutableDictionary* currentData = (NSMutableDictionary*)self.data;
        NSNumber* qtyValue = [NSNumber numberWithInt:[self.qtyTextField.text intValue]];
        NSNumber* bonusValue = [NSNumber numberWithInt:[self.bonusTextField.text intValue]];
        NSNumber* discountValue = [NSNumber numberWithFloat:[self.discTextField.text floatValue]];
//        NSLog(@"currentData x %@ -- %d -- %@" , self.bonusTextField.text, [bonusValue intValue], textField.text);
        
        
        if ([qtyValue intValue] <= 0 && [bonusValue intValue] <= 0) {
            [currentData setObject:[NSNumber numberWithInt:0] forKey:@"Qty"];
            [currentData setObject:[NSNumber numberWithInt:0] forKey:@"Bonus"];
            [currentData setObject:[NSNumber numberWithInt:0] forKey:@"LineValue"];
            [currentData setObject:[NSNumber numberWithBool:NO] forKey:@"IsSelected"];
        } else {
            [currentData setObject:qtyValue forKey:@"Qty"];
            [currentData setObject:bonusValue forKey:@"Bonus"];
            [currentData setObject:discountValue forKey:@"DiscountPercent"];
            [currentData setObject:[self resetTotalValue] forKey:@"LineValue"];
            [currentData setObject:[NSNumber numberWithBool:YES] forKey:@"IsSelected"];
        }
        [self.cellDelegate inputFinishedWithData:currentData forIndexPath:self.theIndexPath];
        [self.cellDelegate configCurrentTextFieldHighlightedFlag:NO];
        textField.textColor = [UIColor blackColor];
        if ([[currentData objectForKey:@"IsSelected"] boolValue]) {
            self.backgroundColor = [UIColor colorWithRed:144.0/255.0 green:238.0/255.0 blue:144.0/255.0 alpha:.2];
        } else {
            self.backgroundColor = [UIColor whiteColor];
        }
//        NSLog(@"currentData 1 %@",currentData);
    } @catch (NSException *exception) {
        NSLog(@"textFieldDidEndEditing %@", [exception reason]);
    }
}

- (void)checkBonusWithGivenRequiredSellBy:(UITextField*)aTextField qty:(int)aQtyValue {
    NSMutableDictionary* currentData = (NSMutableDictionary*)self.data;
//    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] disableBonusBoxWithPriceRecordFlag] && ([[currentData objectForKey:@"PriceFlag"] intValue] == 1 || [[currentData objectForKey:@"PriceFlag"] intValue] == 2)) {
//        return;
//    }
    if (![self bonusGivenAndBonusRequiredExistentFlag] || aTextField.tag != 0) return;
    
    switch ([[currentData objectForKey:@"SellBy"] intValue]) {
        case 1:
        case 2: {
            self.bonusTextField.text = [NSString stringWithFormat:@"%d", aQtyValue / [[currentData objectForKey:@"BonusRequired"] intValue] * [[currentData objectForKey:@"BonusGiven"] intValue]];
        }
            break;
        case 4: {
            if (aQtyValue < [[currentData objectForKey:@"BonusMinimum"] intValue]) {
                self.bonusTextField.text = @"0";
                return;
            }
            int bonusValue = aQtyValue / [[currentData objectForKey:@"BonusRequired"] intValue] * [[currentData objectForKey:@"BonusGiven"] intValue];
            if ([self.bonusTextField.text intValue] > bonusValue) {
                self.bonusTextField.text = @"0";
            }
        }
            break;
        default:
            break;
    }
}
- (BOOL)checkFocusBonusWithGivenRequiredSellByMinimum:(UITextField*)aTextField bonus:(int)aBonusValue {
    NSMutableDictionary* currentData = (NSMutableDictionary*)self.data;
//    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] disableBonusBoxWithPriceRecordFlag] && ([[currentData objectForKey:@"PriceFlag"] intValue] == 1 || [[currentData objectForKey:@"PriceFlag"] intValue] == 2)) {
//        return NO;
//    }
//    if (![self bonusGivenAndBonusRequiredExistentFlag] || aTextField.tag != 1) return NO;
    switch ([[currentData objectForKey:@"SellBy"] intValue]) {
        case 4: {
            if ([self.qtyTextField.text intValue] < [[currentData objectForKey:@"BonusMinimum"] intValue]) {
                [self showBonusFocusCheckMinimumMsg:0];
                self.bonusTextField.text = @"0";
                return NO;
            }
            int bonusValue = [self.qtyTextField.text intValue] / [[currentData objectForKey:@"BonusRequired"] intValue] * [[currentData objectForKey:@"BonusGiven"] intValue];
            if (aBonusValue > bonusValue) {
                [self showBonusFocusCheckMinimumMsg:bonusValue];
                self.bonusTextField.text = @"0";
                return NO;
            }
        }
            break;
            
        default:
            break;
    }
    return YES;
}

- (void)showBonusFocusCheckMinimumMsg:(int)aBonusValue {
    NSMutableDictionary* tmpData = (NSMutableDictionary*)self.data;
    [ArcosUtils showDialogBox:[NSString stringWithFormat:@"Bonus is restricted to %d for %d\n Minimum order qty of %d\nBonus allowed %d", [[tmpData objectForKey:@"BonusGiven"] intValue], [[tmpData objectForKey:@"BonusRequired"] intValue], [[tmpData objectForKey:@"BonusMinimum"] intValue], aBonusValue] title:@"" target:[self.cellDelegate retrieveOrderProductParentViewController] handler:nil];
}

- (BOOL)bonusGivenAndBonusRequiredExistentFlag {
    NSMutableDictionary* tmpData = (NSMutableDictionary*)self.data;
    return [[tmpData objectForKey:@"BonusGiven"] intValue] != 0 && [[tmpData objectForKey:@"BonusRequired"] intValue] != 0;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return YES;
}

-(NSNumber*)resetTotalValue {
    NSMutableDictionary* tmpData = (NSMutableDictionary*)self.data;
    NSNumber* total = [NSNumber numberWithFloat:[self.qtyTextField.text intValue] * [[tmpData objectForKey:@"UnitPrice"] floatValue]];
    
//    NSNumber* unitsPerPack = [self.Data objectForKey:@"UnitsPerPack"];
//    if ([unitsPerPack intValue] != 0) {// && ![ArcosConfigDataManager sharedArcosConfigDataManager].recordInStockRBFlag
//        float splitPackValue = [[self.Data objectForKey:@"UnitPrice"] floatValue] / [unitsPerPack intValue] * [self.unitsField.text intValue];
//        total = [NSNumber numberWithFloat:[total floatValue]+splitPackValue];
//    }
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] useWeightToCalculatePriceFlag]) {
        int minUnitPrice = [[tmpData objectForKey:@"MinimumUnitPrice"] intValue];
        if (minUnitPrice != 0) {
            total = [NSNumber numberWithFloat:([total floatValue] * minUnitPrice / 100)];
        }
    }
    total = [NSNumber numberWithFloat:[ArcosUtils roundFloatThreeDecimal:[total floatValue] * (1.0 - ([self.discTextField.text floatValue] / 100))]];
    return total;
}

@end
