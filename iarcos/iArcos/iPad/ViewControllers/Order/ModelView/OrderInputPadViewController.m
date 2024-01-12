//
//  OrderInputPadViewController.m
//  Arcos
//
//  Created by David Kilmartin on 28/07/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "OrderInputPadViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SettingManager.h"
#import "ArcosConfigDataManager.h"
@interface OrderInputPadViewController()
- (BOOL)isBonusGivenAndBonusRequiredExistent;
- (void)checkBonusWithGivenRequiredSellBy;
- (void)enableBonusFocWithFlag:(BOOL)aFlag;
- (void)checkFocusBonusWithGivenRequiredSellByMinimum;
- (void)showBonusFocusCheckMinimumMsg:(int)aBonusValue;
- (void)checkQtyVanStock;
@end

@implementation OrderInputPadViewController
@synthesize unitsTitleLabel = _unitsTitleLabel;
@synthesize  QTYField;
@synthesize  BonusField;
@synthesize  DiscountField;
@synthesize rebateField = _rebateField;

@synthesize sevenButton = _sevenButton;
@synthesize eightButton = _eightButton;
@synthesize nineButton = _nineButton;
@synthesize fourButton = _fourButton;
@synthesize fiveButton = _fiveButton;
@synthesize sixButton = _sixButton;
@synthesize oneButton = _oneButton;
@synthesize twoButton = _twoButton;
@synthesize threeButton = _threeButton;
@synthesize zeroButton = _zeroButton;
//@synthesize dotButton = _dotButton;
@synthesize deleteButton = _deleteButton;
@synthesize clearButton = _clearButton;
@synthesize doneButton = _doneButton;
@synthesize  dotButton;
@synthesize ValueField;
@synthesize currentTextField = _currentTextField;
@synthesize productName;
@synthesize bar;
@synthesize unitPriceTitleLabel = _unitPriceTitleLabel;
@synthesize unitPriceField = _unitPriceField;
@synthesize unitPrice;
@synthesize qtyLabel = _qtyLabel;
@synthesize BonusLabel;
@synthesize DiscountLabel;
@synthesize rebateLabel = _rebateLabel;
@synthesize valueLabel = _valueLabel;
@synthesize isDetaillingType;
@synthesize unitsField;
@synthesize FOCField;
@synthesize showSeparator = _showSeparator;
//@synthesize locationIUR = _locationIUR;
@synthesize orderInputPadDataManager = _orderInputPadDataManager;
@synthesize qtyHeader = _qtyHeader;
@synthesize bonHeader = _bonHeader;
@synthesize leftDivider = _leftDivider;
@synthesize sectionDivider = _sectionDivider;
@synthesize mon25 = _mon25;
@synthesize mon24 = _mon24;
@synthesize mon23 = _mon23;
@synthesize mon22 = _mon22;
@synthesize mon21 = _mon21;
@synthesize mon20 = _mon20;
@synthesize mon19 = _mon19;
@synthesize mon18 = _mon18;
@synthesize mon17 = _mon17;
@synthesize mon16 = _mon16;
@synthesize mon15 = _mon15;
@synthesize mon14 = _mon14;
@synthesize mon13 = _mon13;

@synthesize qty25 = _qty25;
@synthesize qty24 = _qty24;
@synthesize qty23 = _qty23;
@synthesize qty22 = _qty22;
@synthesize qty21 = _qty21;
@synthesize qty20 = _qty20;
@synthesize qty19 = _qty19;
@synthesize qty18 = _qty18;
@synthesize qty17 = _qty17;
@synthesize qty16 = _qty16;
@synthesize qty15 = _qty15;
@synthesize qty14 = _qty14;
@synthesize qty13 = _qty13;

@synthesize bonus25 = _bonus25;
@synthesize bonus24 = _bonus24;
@synthesize bonus23 = _bonus23;
@synthesize bonus22 = _bonus22;
@synthesize bonus21 = _bonus21;
@synthesize bonus20 = _bonus20;
@synthesize bonus19 = _bonus19;
@synthesize bonus18 = _bonus18;
@synthesize bonus17 = _bonus17;
@synthesize bonus16 = _bonus16;
@synthesize bonus15 = _bonus15;
@synthesize bonus14 = _bonus14;
@synthesize bonus13 = _bonus13;
@synthesize instockRBLabel = _instockRBLabel;
@synthesize instockRBTextField = _instockRBTextField;
@synthesize vansOrderHeader = _vansOrderHeader;
@synthesize priceChangeButton = _priceChangeButton;
@synthesize globalNavigationController = _globalNavigationController;

@synthesize bonusDealResultDict = _bonusDealResultDict;
@synthesize originalDiscountPercent = _originalDiscountPercent;
@synthesize bottomDivider = _bottomDivider;
@synthesize bonusDealContentInterpreter = _bonusDealContentInterpreter;
@synthesize relatedFormDetailDict = _relatedFormDetailDict;
@synthesize arcosMyResult = _arcosMyResult;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.orderInputPadDataManager = [[[OrderInputPadDataManager alloc] init] autorelease];
        
    }
    return self;
}

- (void)dealloc
{
    self.unitsTitleLabel = nil;
    if (self.QTYField != nil) { self.QTYField = nil; }
    if (self.BonusField != nil) { self.BonusField = nil; }   
    if (self.DiscountField != nil) { self.DiscountField = nil; }
    self.rebateField = nil;
    if (self.ValueField != nil) { self.ValueField = nil; }
    self.currentTextField = nil;
    if (self.productName != nil) { self.productName = nil; }
    if (self.bar != nil) { self.bar = nil; }
    self.unitPriceTitleLabel = nil;
    self.unitPriceField = nil;
    if (self.unitPrice != nil) { self.unitPrice = nil; }
    
    self.sevenButton = nil;
    self.eightButton = nil;
    self.nineButton = nil;
    self.fourButton = nil;
    self.fiveButton = nil;
    self.sixButton = nil;
    self.oneButton = nil;
    self.twoButton = nil;
    self.threeButton = nil;
    self.zeroButton = nil;
//    self.dotButton = nil;
    self.deleteButton = nil;
    self.clearButton = nil;
    self.doneButton = nil;
    if (self.dotButton != nil) { self.dotButton = nil; }
    self.qtyLabel = nil;
    if (self.BonusLabel != nil) { self.BonusLabel = nil; }    
    if (self.DiscountLabel != nil) { self.DiscountLabel = nil; }
    self.rebateLabel = nil;
    self.valueLabel = nil;
    if (self.unitsField != nil) { self.unitsField = nil; } 
    if (self.FOCField != nil) { self.FOCField = nil; }
//    self.locationIUR = nil;
    self.orderInputPadDataManager = nil;
    self.qtyHeader = nil;
    self.bonHeader = nil;
    self.leftDivider = nil;
    self.sectionDivider = nil;
    self.mon25 = nil;
    self.mon24 = nil;
    self.mon23 = nil;
    self.mon22 = nil;
    self.mon21 = nil;
    self.mon20 = nil;
    self.mon19 = nil;
    self.mon18 = nil;
    self.mon17 = nil;
    self.mon16 = nil;
    self.mon15 = nil;
    self.mon14 = nil;
    self.mon13 = nil;
    
    self.qty25 = nil;
    self.qty24 = nil;
    self.qty23 = nil;
    self.qty22 = nil;
    self.qty21 = nil;
    self.qty20 = nil;
    self.qty19 = nil;
    self.qty18 = nil;
    self.qty17 = nil;
    self.qty16 = nil;
    self.qty15 = nil;
    self.qty14 = nil;
    self.qty13 = nil;
    
    self.bonus25 = nil;
    self.bonus24 = nil;
    self.bonus23 = nil;
    self.bonus22 = nil;
    self.bonus21 = nil;
    self.bonus20 = nil;
    self.bonus19 = nil;
    self.bonus18 = nil;
    self.bonus17 = nil;
    self.bonus16 = nil;
    self.bonus15 = nil;
    self.bonus14 = nil;
    self.bonus13 = nil;
    
    self.instockRBLabel = nil;
    for (UIGestureRecognizer* recognizer in self.instockRBTextField.gestureRecognizers) {
        [self.instockRBTextField removeGestureRecognizer:recognizer];
    }
    self.instockRBTextField = nil;
    self.vansOrderHeader = nil;
    self.priceChangeButton = nil;
    self.globalNavigationController = nil;
    self.bonusDealResultDict = nil;
    self.originalDiscountPercent = nil;
    self.bottomDivider = nil;
    self.bonusDealContentInterpreter = nil;
    self.relatedFormDetailDict = nil;
    self.arcosMyResult = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    NSLog(@"self.data: %@", self.Data);
    //pre set the text feild
//    NSNumber* qtyNumber=[self.Data objectForKey:@"Qty"];
//    NSNumber* inStockNumber = [self.Data objectForKey:@"InStock"]; 
//    if (([qtyNumber intValue]>0 && qtyNumber !=nil) || ([inStockNumber intValue]>0 && inStockNumber != nil)) {
    self.showSeparator = NO;
    if (self.relatedFormDetailDict != nil) {
        self.showSeparator = [[self.relatedFormDetailDict objectForKey:@"ShowSeperators"] boolValue];
    }
    self.originalDiscountPercent = [NSNumber numberWithFloat:[[self.Data objectForKey:@"DiscountPercent"] floatValue]];
    self.bonusDealResultDict = [self interpretBonusDeal:[self.Data objectForKey:@"BonusDeal"]];
    if ([[self.bonusDealResultDict objectForKey:@"OkFlag"] boolValue]) {
        self.bottomDivider.hidden = NO;
        self.bonusDealContentInterpreter.hidden = NO;
        NSMutableString* contentInterpreter = [NSMutableString string];
        if ([[self.bonusDealResultDict objectForKey:@"QB1"] intValue] != 99999) {
            [contentInterpreter appendString:[NSString stringWithFormat:@"%@/%@", [self.bonusDealResultDict objectForKey:@"QB1"], [self.bonusDealResultDict objectForKey:@"QP1"]]];
        }
        if ([[self.bonusDealResultDict objectForKey:@"QB2"] intValue] != 99999) {
            [contentInterpreter appendString:[NSString stringWithFormat:@"  %@/%@", [self.bonusDealResultDict objectForKey:@"QB2"], [self.bonusDealResultDict objectForKey:@"QP2"]]];
        }
        if ([[self.bonusDealResultDict objectForKey:@"QB3"] intValue] != 99999) {
            [contentInterpreter appendString:[NSString stringWithFormat:@"  %@/%@", [self.bonusDealResultDict objectForKey:@"QB3"], [self.bonusDealResultDict objectForKey:@"QP3"]]];
        }
        if ([[self.bonusDealResultDict objectForKey:@"QB4"] intValue] != 99999) {
            [contentInterpreter appendString:[NSString stringWithFormat:@"  %@/%@", [self.bonusDealResultDict objectForKey:@"QB4"], [self.bonusDealResultDict objectForKey:@"QP4"]]];
        }
        if ([[self.bonusDealResultDict objectForKey:@"QB5"] intValue] != 99999) {
            [contentInterpreter appendString:[NSString stringWithFormat:@"  %@/%@", [self.bonusDealResultDict objectForKey:@"QB5"], [self.bonusDealResultDict objectForKey:@"QP5"]]];
        }
        self.bonusDealContentInterpreter.text = contentInterpreter;
    } else {
        self.bottomDivider.hidden = YES;
        self.bonusDealContentInterpreter.hidden = YES;
    }
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showMATWithQtyPopoverFlag] && self.locationIUR != nil) {
        NSDate* dateLastModified = [NSDate date];
        NSMutableArray* objectList = [self.orderInputPadDataManager retrieveLocationProductMATWithLocationIUR:self.locationIUR productIUR:[self.Data objectForKey:@"ProductIUR"]];
        if ([objectList count] > 0) {
            NSDictionary* locationProductMATDict = [objectList objectAtIndex:0];
            NSDate* auxDateLastModified = [locationProductMATDict objectForKey:@"dateLastModified"];
            if (auxDateLastModified != nil) {
                dateLastModified = auxDateLastModified;
            }
        }
        [self.orderInputPadDataManager processMonthListWithDate:dateLastModified];
        int monthNum = 26;
        NSString* valueField = [NSString stringWithFormat:@"setText:"];
        SEL valueSelector = NSSelectorFromString(valueField);
        for (int i = 0; i < [self.orderInputPadDataManager.monthList count]; i++) {
            monthNum--;
            NSString* tmpMonthStr = [self.orderInputPadDataManager.monthList objectAtIndex:i];
            NSString* monthField = [NSString stringWithFormat:@"mon%d",monthNum];
            SEL monthSelector = NSSelectorFromString(monthField);
            [[self performSelector:monthSelector] performSelector:valueSelector withObject:tmpMonthStr];
        }
        if ([objectList count] > 0) {
            NSDictionary* locationProductMATDict = [objectList objectAtIndex:0];
            SEL methodSelector = NSSelectorFromString(@"objectForKey:");
            int qbNum = 26;
            for (int i = 0; i < 13; i++) {
                qbNum--;
                NSString* qtyValueParameter = [NSString stringWithFormat:@"qty%d", qbNum];
                NSNumber* qtyNumber = [locationProductMATDict performSelector:methodSelector withObject:qtyValueParameter];
                NSString* qtyField = [NSString stringWithFormat:@"qty%d",qbNum];
                SEL qtySelector = NSSelectorFromString(qtyField);
                [[self performSelector:qtySelector] performSelector:valueSelector withObject:[ArcosUtils convertZeroToBlank:[ArcosUtils convertNumberToIntString:qtyNumber]]];
                
                NSString* bonusValueParameter = [NSString stringWithFormat:@"bonus%d", qbNum];
                NSNumber* bonusNumber = [locationProductMATDict performSelector:methodSelector withObject:bonusValueParameter];
                NSString* bonusField = [NSString stringWithFormat:@"bonus%d",qbNum];
                SEL bonusSelector = NSSelectorFromString(bonusField);
                [[self performSelector:bonusSelector] performSelector:valueSelector withObject:[ArcosUtils convertZeroToBlank:[ArcosUtils convertNumberToIntString:bonusNumber]]];
            }
        } else {
            int qbNum = 26;
            for (int i = 0; i < 13; i++) {
                qbNum--;
                NSString* qtyField = [NSString stringWithFormat:@"qty%d",qbNum];
                SEL qtySelector = NSSelectorFromString(qtyField);
                [[self performSelector:qtySelector] performSelector:valueSelector withObject:@""];
                NSString* bonusField = [NSString stringWithFormat:@"bonus%d",qbNum];
                SEL bonusSelector = NSSelectorFromString(bonusField);
                [[self performSelector:bonusSelector] performSelector:valueSelector withObject:@""];
            }
        }
    }
    if ([ProductFormRowConverter isSelectedWithFormRowDict:self.Data]) {
        self.QTYField.text=[[self.Data objectForKey:@"Qty"]stringValue];
        self.BonusField.text=[[self.Data objectForKey:@"Bonus"]stringValue];
//        self.DiscountField.text=[[[self.Data objectForKey:@"DiscountPercent"]stringValue]stringByAppendingString:@"%"];
        self.ValueField.text=[NSString stringWithFormat:@"%1.2f" ,[[self.Data objectForKey:@"LineValue"]floatValue]];
        self.unitsField.text=[[self.Data objectForKey:@"units"] stringValue];
        self.FOCField.text=[[self.Data objectForKey:@"FOC"]stringValue];
        self.instockRBTextField.text = [[self.Data objectForKey:@"InStock"] stringValue];
        self.rebateField.text = [[[self.Data objectForKey:@"RebatePercent"] stringValue] stringByAppendingString:@"%"];
    }else{
        self.QTYField.text=@"0";
        self.BonusField.text=@"0";
//        self.DiscountField.text=@"0%";
        self.ValueField.text=@"0.00";
        self.unitsField.text=@"0";
        self.FOCField.text=@"0";
        self.instockRBTextField.text = @"0";
        self.rebateField.text = @"0%";
    }
    self.DiscountField.text=[[[self.Data objectForKey:@"DiscountPercent"]stringValue]stringByAppendingString:@"%"];
    self.bar.topItem.title=[self.Data objectForKey:@"Details"];
    NSString* orderFormDetails = [ArcosUtils convertNilToEmpty:[self.relatedFormDetailDict objectForKey:@"Details"]];
    if ([[SettingManager databaseName] isEqualToString:[GlobalSharedClass shared].myDbName] && [orderFormDetails containsString:@"[NB]"]) {
        if ([self.QTYField.text isEqualToString:@"0"]) {
            self.DiscountField.text=@"0%";
        }
        self.arcosMyResult = [[[ArcosMyResult alloc] init] autorelease];
        [self.arcosMyResult processRawData:[self.Data objectForKey:@"ProductColour"]];
        self.bar.topItem.title = [NSString stringWithFormat:@"%@ [Max:%@]", [self.Data objectForKey:@"Details"], [NSString stringWithFormat:@"%.2f", [self.arcosMyResult.max floatValue]]];
    }
    self.productName.text=[self.Data objectForKey:@"Details"];
    self.unitPriceField.text=[NSString stringWithFormat:@"%1.2f",[[self.Data objectForKey:@"UnitPrice"]floatValue]];
    if ([[self.Data objectForKey:@"PriceFlag"] intValue] == 1) {
        self.unitPriceField.textColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
        self.unitPriceField.font = [UIFont boldSystemFontOfSize:24.0];
        self.unitPriceField.backgroundColor = [UIColor yellowColor];
    } else if ([[self.Data objectForKey:@"PriceFlag"] intValue] == 2) {
        self.unitPriceField.textColor = [UIColor colorWithRed:0.0 green:128.0/255.0 blue:1.0 alpha:1.0];
        self.unitPriceField.font = [UIFont boldSystemFontOfSize:24.0];
        self.unitPriceField.backgroundColor = [UIColor colorWithRed:152.0/255.0 green:251.0/255.0 blue:152.0/255.0 alpha:1.0];
    } else {
        self.unitPriceField.textColor = [UIColor colorWithRed:0.0 green:128.0/255.0 blue:1.0 alpha:1.0];
        self.unitPriceField.font = [UIFont systemFontOfSize:24.0];
        self.unitPriceField.backgroundColor = [UIColor whiteColor];
    }
    //set the default text feild
    self.currentTextField=self.QTYField;
    [self highlightSelectField];
    //check split pack field
    if (self.showSeparator || [[self.Data objectForKey:@"SamplesAvailable"] intValue] == -1) {
        self.qtyLabel.text = @"Cases";
        self.unitsTitleLabel.hidden = NO;
        self.unitsField.hidden = NO;
        self.FOCField.hidden = NO;
    } else {
        self.qtyLabel.text = @"Qty";
        self.unitsTitleLabel.hidden = YES;
        self.unitsField.hidden = YES;
        self.FOCField.hidden = YES;
    }
    
    //disable the bunous and discount label depend on the setting
    NSNumber* allowDiscount = [SettingManager SettingForKeypath:@"CompanySetting.Order Processing" atIndex:1];
    if ([allowDiscount boolValue]) {
        self.DiscountLabel.hidden=NO;
        self.DiscountField.hidden=NO;
        self.BonusLabel.hidden=YES;
        self.BonusField.hidden=YES;
        self.FOCField.hidden = YES;
    }
    
    //bd
    SettingManager* sm = [SettingManager setting];
    NSMutableDictionary* presenterPwdDict = [sm getSettingForKeypath:@"CompanySetting.Connection" atIndex:8];
    NSString* presenterPwd = [[presenterPwdDict objectForKey:@"Value"] uppercaseString];
//    NSLog(@"presenterPwd:%@", presenterPwd);
    NSRange aBDRange = [presenterPwd rangeOfString:@"[BD]"];
//    NSLog(@"aBDRange:%@",NSStringFromRange(aBDRange));
    if (aBDRange.location != NSNotFound) {
        self.DiscountLabel.hidden=NO;
        self.DiscountField.hidden=NO;
        self.BonusLabel.hidden=NO;
        self.BonusField.hidden=NO;
        if (self.showSeparator || [[self.Data objectForKey:@"SamplesAvailable"] intValue] == -1) {
            self.unitsField.hidden = NO;
            self.FOCField.hidden = NO;
        } else {
            self.unitsField.hidden = YES;
            self.FOCField.hidden = YES;
        }
    }
    
    if ([ArcosConfigDataManager sharedArcosConfigDataManager].recordInStockRBFlag) {
        self.instockRBLabel.hidden = NO;
        self.instockRBTextField.hidden = NO;
        self.DiscountLabel.hidden = YES;
        self.DiscountField.hidden = YES;
//        self.unitsTitleLabel.hidden = YES;
//        self.InStockField.hidden = YES;
//        self.FOCField.hidden = YES;
    } else {
        self.instockRBLabel.hidden = YES;
        self.instockRBTextField.hidden = YES;
    }
    
    //BonusGiven BonusRequired SellBy
    switch ([[self.Data objectForKey:@"SellBy"] intValue]) {
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
    
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] enablePriceChangeFlag]) {
        self.priceChangeButton.hidden = NO;
    } else {
        self.priceChangeButton.hidden = YES;
    }
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] disableBonusBoxWithPriceRecordFlag] && ([[self.Data objectForKey:@"PriceFlag"] intValue] == 1 || [[self.Data objectForKey:@"PriceFlag"] intValue] == 2)) {
        self.BonusField.backgroundColor = [UIColor blackColor];
        self.BonusField.text=@"0";
    } else {
        self.BonusField.backgroundColor = [UIColor whiteColor];
    }
    //check the detailing
    if(self.isDetaillingType || ([[ArcosConfigDataManager sharedArcosConfigDataManager] showRRPInOrderPadFlag] && ![orderFormDetails containsString:@"[BD]"])){
        self.BonusField.hidden=YES;
        self.DiscountField.hidden=YES;
        self.BonusLabel.hidden=YES;
        self.DiscountLabel.hidden=YES;
        self.FOCField.hidden = YES;
        self.instockRBLabel.hidden = YES;
        self.instockRBTextField.hidden = YES;
        self.priceChangeButton.hidden = YES;
    }
    if (self.isDetaillingType) {
        self.sectionDivider.hidden = YES;
        self.bonHeader.hidden = YES;
        int bonNum = 26;
        NSString* hiddenField = [NSString stringWithFormat:@"setHidden:"];
        SEL hiddenSelector = NSSelectorFromString(hiddenField);
        for (int i = 0; i < 13; i++) {
            bonNum--;
            NSString* bonusField = [NSString stringWithFormat:@"bonus%d", bonNum];
            SEL bonusSelector = NSSelectorFromString(bonusField);
//            [[self performSelector:bonusSelector] performSelector:hiddenSelector withObject:@YES];
            BOOL myBoolValue = YES;
            NSMethodSignature* signature = [[[self performSelector:bonusSelector] class] instanceMethodSignatureForSelector:hiddenSelector];
            NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:signature];
            [invocation setTarget:[self performSelector:bonusSelector]];
            [invocation setSelector:hiddenSelector];
            [invocation setArgument:&myBoolValue atIndex:2];
            [invocation invoke];
        }
    }
//    NSString* orderFormDetails = [ArcosUtils convertNilToEmpty:[self.relatedFormDetailDict objectForKey:@"Details"]];
    if ([orderFormDetails containsString:@"[NB]"]) {
        [self showBonusFocWithFlag:NO];
    }
    if ([orderFormDetails containsString:@"[ND]"]) {
        [self showDiscountWithFlag:NO];
    }
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showPackageFlag]) {
        self.DiscountField.enabled = NO;
    }
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showInputPadRebateFlag]) {
        self.rebateLabel.hidden = NO;
        self.rebateField.hidden = NO;
        if (![self.orderInputPadDataManager.rebateTitle isEqualToString:@""]) {
            self.rebateLabel.text = self.orderInputPadDataManager.rebateTitle;
        }
    } else {
        self.rebateLabel.hidden = YES;
        self.rebateField.hidden = YES;
    }
    [self checkQtyByBonusDeal];
    [self resetTotalValue];
}

- (ArcosErrorResult*)productCheckProcedure {
    ArcosErrorResult* arcosErrorResult = [[[ArcosErrorResult alloc] init] autorelease];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] enableProductCheckFlag]) {
        NSMutableArray* locationDictList = [[ArcosCoreData sharedArcosCoreData] locationWithIURWithoutCheck:self.locationIUR];
        if (locationDictList != nil) {
            NSDictionary* locationDict = [locationDictList objectAtIndex:0];
            NSNumber* tmpLTiur = [locationDict objectForKey:@"LTiur"];
            NSDictionary* tmpDescrDetailDict = [[ArcosCoreData sharedArcosCoreData] descriptionWithIUR:tmpLTiur];
            NSString* tmpTooltip = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:[tmpDescrDetailDict objectForKey:@"Tooltip"]]];
            if (![tmpTooltip isEqualToString:@""]) {
                NSMutableArray* tmpProductDictList = [[ArcosCoreData sharedArcosCoreData] productWithIUR:[self.Data objectForKey:@"ProductIUR"] withResultType:NSDictionaryResultType];
                if (tmpProductDictList != nil) {
                    NSDictionary* tmpProductDict = [tmpProductDictList objectAtIndex:0];
                    NSString* tmpL1Code = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:[tmpProductDict objectForKey:@"L1Code"]]];
                    NSString* tmpWrappedL1Code = [NSString stringWithFormat:@"[%@]", tmpL1Code];
                    NSRange tmpL1CodeRange = [tmpTooltip rangeOfString:tmpWrappedL1Code options:NSCaseInsensitiveSearch];
                    if (tmpL1CodeRange.location == NSNotFound) {
                        arcosErrorResult.successFlag = NO;
                        arcosErrorResult.errorDesc = [NSString stringWithFormat:@"Selected Product is not available for %@", [tmpDescrDetailDict objectForKey:@"Detail"]];
                    }
                }
            }            
        }
    }    
    return arcosErrorResult;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.currentTextField=QTYField;
    [self highlightSelectField];
    //add taps
    /*
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];

    [self.QTYField addGestureRecognizer:singleTap1];
    
    UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];

    [self.BonusField addGestureRecognizer:singleTap2];
    
    UITapGestureRecognizer *singleTap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.DiscountField addGestureRecognizer:singleTap3];
    
    UITapGestureRecognizer *singleTap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];    
    [self.InStockField addGestureRecognizer:singleTap4];
    
    UITapGestureRecognizer *singleTap5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.FOCField addGestureRecognizer:singleTap5];
    
    [singleTap1 release];
    [singleTap2 release];
    [singleTap3 release];
    [singleTap4 release];
    [singleTap5 release];
    */
    UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapGesture:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.instockRBTextField addGestureRecognizer:doubleTap];
    [doubleTap release];
}

- (void)handleDoubleTapGesture:(id)sender {
    self.instockRBTextField.text = @"-1";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    if (self.QTYField != nil) { self.QTYField = nil; }
    if (self.BonusField != nil) { self.BonusField = nil; }   
    if (self.DiscountField != nil) { self.DiscountField = nil; }    
    if (self.ValueField != nil) { self.ValueField = nil; }
    if (self.productName != nil) { self.productName = nil; }
    if (self.bar != nil) { self.bar = nil; }
    if (self.unitPrice != nil) { self.unitPrice = nil; }
    if (self.dotButton != nil) { self.dotButton = nil; }
    if (self.BonusLabel != nil) { self.BonusLabel = nil; }    
    if (self.DiscountLabel != nil) { self.DiscountLabel = nil; }
    if (self.unitsField != nil) { self.unitsField = nil; }
    if (self.FOCField != nil) { self.FOCField = nil; }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField { 
    // Make a new view, or do what you want here
    if (textField.tag == 1 && !self.BonusField.hidden && self.BonusField.enabled && [[ArcosConfigDataManager sharedArcosConfigDataManager] disableBonusBoxWithPriceRecordFlag] && ([[self.Data objectForKey:@"PriceFlag"] intValue] == 1 || [[self.Data objectForKey:@"PriceFlag"] intValue] == 2)) {
        [ArcosUtils showDialogBox:@"Bonus Disabled on Discounted Prices" title:@"" delegate:nil target:self tag:0 handler:nil];
        return NO;
    }
    if (textField.tag == 7) return NO;
    if (textField.tag == 6 && self.DiscountField.hidden == YES) return NO;
    self.currentTextField = textField;
    [self highlightSelectField];
    return NO;
}
-(NSNumber*)resetTotalValue{
    NSNumber* total=[NSNumber numberWithFloat:[self.QTYField.text intValue]*[[self.Data objectForKey:@"UnitPrice"]floatValue]];
    
    NSNumber* unitsPerPack = [self.Data objectForKey:@"UnitsPerPack"];
    if ([unitsPerPack intValue] != 0) {// && ![ArcosConfigDataManager sharedArcosConfigDataManager].recordInStockRBFlag
        float splitPackValue = [[self.Data objectForKey:@"UnitPrice"] floatValue] / [unitsPerPack intValue] * [self.unitsField.text intValue];
        total = [NSNumber numberWithFloat:[total floatValue]+splitPackValue];
    }
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] useWeightToCalculatePriceFlag]) {
        int minUnitPrice = [[self.Data objectForKey:@"MinimumUnitPrice"] intValue];
        if (minUnitPrice != 0) {
            total = [NSNumber numberWithFloat:([total floatValue] * minUnitPrice / 100)];
        }
    }
    total = [NSNumber numberWithFloat:[ArcosUtils roundFloatThreeDecimal:[total floatValue] * (1.0 - ([self.DiscountField.text floatValue] / 100))]];
    self.ValueField.text=[NSString stringWithFormat:@"%1.2f" ,[total floatValue]];
    return total;    
}
//input validation
-(BOOL)QTYBonusCheck:(NSInteger)input{
    NSString* qtyString=self.currentTextField.text;
    NSString* firstChar=[qtyString substringToIndex:1];
    //not over 8 digits
    if([qtyString length]>=8){
        return NO;
    }
    
    //dot input
    if (input==10) {
        return NO;
    }
    //0 input
    if (input==0) {
        if ([firstChar isEqualToString:@"0"]) {
            return NO;
        }
    }
    //current value is 0
    if ([firstChar isEqualToString:@"0"]) {
        qtyString=@"";
    }
    if ([firstChar isEqualToString:@"-"] && [qtyString isEqualToString:@"-0"]) {
        qtyString=@"-";
    }
    
    //append the qty value
    qtyString=[qtyString stringByAppendingFormat:@"%d",[ArcosUtils convertNSIntegerToInt:input]];
    self.currentTextField.text=qtyString;
    [self checkQtyByBonusDeal];
    [self checkBonusWithGivenRequiredSellBy];
    [self checkFocusBonusWithGivenRequiredSellByMinimum];
    //reset the total value
    [self resetTotalValue];
    return YES;
}

-(BOOL)QTYBonusSplitPacksCheck:(NSInteger)input {
    NSString* splitPacksString=self.currentTextField.text;
    NSString* firstChar=[splitPacksString substringToIndex:1];
    //not over 3 digits
    if([splitPacksString length]>2){
        return NO;
    }
    
    //dot input
    if (input==10) {
        return NO;
    }
    //0 input
    if (input==0) {
        if ([firstChar isEqualToString:@"0"]) {
            return NO;
        }
    }
    //current value is 0
    if ([firstChar isEqualToString:@"0"]) {
        splitPacksString=@"";
    }
    
    //append the qty value
    splitPacksString=[splitPacksString stringByAppendingFormat:@"%d",[ArcosUtils convertNSIntegerToInt:input]];
    NSNumber* splitPacksStringNumberValue = [ArcosUtils convertStringToNumber:splitPacksString];
    NSNumber* unitsPerPack = [self.Data objectForKey:@"UnitsPerPack"];
//    NSLog(@"unitsPerPack: %d", [unitsPerPack intValue]);
    if ([splitPacksStringNumberValue intValue] >= [unitsPerPack intValue]) {
//        [ArcosUtils showMsg:[NSString stringWithFormat:@"The value can not be greater or equal to %d.", [unitsPerPack intValue]] delegate:nil];
        [ArcosUtils showDialogBox:[NSString stringWithFormat:@"The value can not be greater or equal to %d.", [unitsPerPack intValue]] title:@"" target:self handler:nil];
        return NO;
    }
    
    self.currentTextField.text=splitPacksString;
    
    //reset the total value
    [self resetTotalValue];
    return YES;
}

-(BOOL)DiscountCheck:(NSInteger)input{
    //string with no presentage sign
    NSString* aString=[self.currentTextField.text substringToIndex:[self.currentTextField.text length]-1];
    NSString* firstChar=[aString substringToIndex:1];
    NSString* lastChar=[aString substringWithRange:NSMakeRange([aString length]-1, 1)];
    float aFloat=[aString floatValue];

    //check any dot
    NSRange aRangeName = [aString rangeOfString:@"." options:NSCaseInsensitiveSearch];
    BOOL anyDot=NO;
    if (aRangeName.location !=NSNotFound) {
        anyDot=YES;
    }
    
    //dot input but we have one
    if (input==10&&anyDot) {
        return NO;
    }
    if (input==10){
        //append the qty value
        aString=[aString stringByAppendingString:@".%"];
        self.currentTextField.text=aString;
        return YES;
    }
    
    //0 input but we are 0 now
    if (input==0&&aFloat==0.0) {
            return NO;
    }
    
    //0 input but last digit after dot already 0
    if(input==0&&[lastChar isEqualToString:@"0"]&&anyDot){
        return NO;
    }
    
    //current value is 0
    if ([firstChar isEqualToString:@"0"]&&!anyDot) {
        aString=@"";
    }
    
    //append the qty value
    aString=[aString stringByAppendingFormat:@"%d",[ArcosUtils convertNSIntegerToInt:input]];

    //value greater than 100
    aFloat=[aString floatValue];
    if (aFloat>100.0f) {
        return NO;
    }
    
    //only 2 decimal number allowed
    NSString* formattedNumber = [NSString stringWithFormat:@"%.2f", aFloat];
    float formattedFloat=[formattedNumber floatValue];
    if (aFloat!=formattedFloat) {
        return NO;
    }
    if (aFloat!=formattedFloat&&input==10) {
        return NO;
    }
    
    //final string
    aString=[aString stringByAppendingString:@"%"];
    self.currentTextField.text=aString;
    [self resetTotalValue];
    return YES;
}

-(BOOL)UnitPriceCheck:(NSInteger)input{
    NSString* aString=self.currentTextField.text;
    NSString* firstChar=[aString substringToIndex:1];
    float aFloat=[aString floatValue];
    
    //check any dot
    NSRange aRangeName = [aString rangeOfString:@"." options:NSCaseInsensitiveSearch];
    BOOL anyDot=NO;
    if (aRangeName.location !=NSNotFound) {
        anyDot=YES;
    }
    
    //dot input but we have one
    if (input==10&&anyDot) {
        return NO;
    }
    if (input==10){
        //append the qty value
        aString=[aString stringByAppendingString:@"."];
        self.currentTextField.text=aString;
        return YES;
    }
    
    //0 input but we are 0 now
    if (input==0 && aFloat == 0) {
        return NO;
    }
    
    //current value is 0
    if ([firstChar isEqualToString:@"0"]&&!anyDot) {
        aString=@"";
    }
    
    //append the qty value
    aString=[aString stringByAppendingFormat:@"%d",[ArcosUtils convertNSIntegerToInt:input]];
    
    //value greater than unitprice
    aFloat=[aString floatValue];
    if (aFloat > [[self.Data objectForKey:@"UnitPrice"] floatValue]) {
        return NO;
    }
    
    //only 2 decimal number allowed
    if (anyDot) {
        NSString* tmpString = [aString substringFromIndex:aRangeName.location];
        if (tmpString.length >= 4) {
            return NO;
        }        
    }
    
    //final string
    self.currentTextField.text=aString;
    if ([[self.Data objectForKey:@"UnitPrice"] floatValue] != 0) {
        self.DiscountField.text = [NSString stringWithFormat:@"%.2f%%", (1 - aFloat / [[self.Data objectForKey:@"UnitPrice"] floatValue]) * 100];
    }
     
    [self resetTotalValue];
    return YES;
}

-(void)clearCurrentFeild{
    
    
    switch (self.currentTextField.tag) {
        case 0:
        case 1:
        case 3:
        case 4:
        case 5:
            self.currentTextField.text=@"0";
            [self checkQtyByBonusDeal];
            break;
        case 2:
        case 8:
            self.currentTextField.text=@"0%";
            break;
        case 6:
            self.currentTextField.text=@"0";
            if ([[self.Data objectForKey:@"UnitPrice"] floatValue] != 0) {
                self.DiscountField.text = [NSString stringWithFormat:@"%.2f%%", (1 - [self.currentTextField.text floatValue] / [[self.Data objectForKey:@"UnitPrice"] floatValue]) * 100];
            }            
            break;
        default:
            break;
    }
    [self checkBonusWithGivenRequiredSellBy];
    //reset the total value
    [self resetTotalValue];
    NSNumber* discount=[NSNumber numberWithFloat:[self.DiscountField.text floatValue]];
    if (self.currentTextField.tag == 0 && [discount floatValue] != 0 && ![[ArcosConfigDataManager sharedArcosConfigDataManager] showPackageFlag]) {
        [self submitInput];
    }
}
-(void)deleteOneDigitFromCurrentFeild{
    NSString* fieldString=self.currentTextField.text;
    
    switch (self.currentTextField.tag) {
        case 0:
        case 1:
        case 3:
        case 4:
        case 5:
            fieldString=[fieldString substringToIndex:[fieldString length]-1];
            self.currentTextField.text=fieldString;
            [self checkQtyByBonusDeal];
            if ([fieldString isEqualToString:@""]) {
                [self clearCurrentFeild];
            }
            break;
        case 2:
        case 8:
            fieldString=[fieldString substringToIndex:[fieldString length]-2];
            self.currentTextField.text=[fieldString stringByAppendingString:@"%"];
            if ([fieldString isEqualToString:@"%"]||[fieldString isEqualToString:@""]||fieldString==nil) {
                [self clearCurrentFeild];
            }
            break;
        case 6:
            fieldString=[fieldString substringToIndex:[fieldString length]-1];
            self.currentTextField.text=fieldString;
            if ([fieldString isEqualToString:@""]) {
                [self clearCurrentFeild];
            }
            if ([[self.Data objectForKey:@"UnitPrice"] floatValue] != 0) {
                self.DiscountField.text = [NSString stringWithFormat:@"%.2f%%", (1 - [self.currentTextField.text floatValue] / [[self.Data objectForKey:@"UnitPrice"] floatValue]) * 100];
            }            
            break;
        default:
            break;
    }
    [self checkBonusWithGivenRequiredSellBy];
    //reset the total value
    [self resetTotalValue];
}

- (void)checkQtyVanStock {
    NSNumber* tmpQty = [NSNumber numberWithInt:[QTYField.text intValue]];
    NSNumber* tmpStockonHand = [self.Data objectForKey:@"StockonHand"];    
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] enableVanSaleFlag] && [tmpQty intValue] > [tmpStockonHand intValue] && ((self.vansOrderHeader != nil && [[[self.vansOrderHeader objectForKey:@"type"] objectForKey:@"DescrDetailCode"] isEqualToString:[GlobalSharedClass shared].vansCode]) || self.vansOrderHeader == nil)) {
        void (^yesActionHandler)(UIAlertAction *) = ^(UIAlertAction *action){
            [self submitInput];
        };
        void (^noActionHandler)(UIAlertAction *) = ^(UIAlertAction *action){
            [self clearCurrentFeild];
        };
        [ArcosUtils showTwoBtnsDialogBox:[NSString stringWithFormat:@"The quantity you entered is greater than the available van stock of %@, are you sure you want to continue", tmpStockonHand] title:@"" delegate:nil target:self tag:0 lBtnText:@"YES" rBtnText:@"NO" lBtnHandler:yesActionHandler rBtnHandler:noActionHandler];
    } else {
        [self submitInput];
    }
}

-(void)submitInput{
    NSMutableDictionary* values=[NSMutableDictionary dictionary];
    BOOL orderFormRestrictedFlag = NO;
    NSString* orderFormDetails = [ArcosUtils convertNilToEmpty:[self.relatedFormDetailDict objectForKey:@"Details"]];
    if ([orderFormDetails containsString:@"RESTRICTED"]) {
        orderFormRestrictedFlag = YES;
    }
    NSNumber* qty=[NSNumber numberWithInt:[QTYField.text intValue]];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] checkMultiplesOfUnitsPerPackFlag] || orderFormRestrictedFlag) {
        int unitsPerPackInteger = [[self.Data objectForKey:@"UnitsPerPack"] intValue];
        if (unitsPerPackInteger > 1) {
            int qtyInteger = [qty intValue];
            if (qtyInteger % unitsPerPackInteger != 0) {
//                [ArcosUtils showMsg:[NSString stringWithFormat:@"Stock can only be ordered in multiples of %d", unitsPerPackInteger] delegate:nil];
                [ArcosUtils showDialogBox:[NSString stringWithFormat:@"Stock can only be ordered in multiples of %d", unitsPerPackInteger] title:@"" target:self handler:nil];
                return;
            }
        }
    }
    NSNumber* bonus=[NSNumber numberWithInt:[BonusField.text intValue]];
    NSNumber* discount=[NSNumber numberWithFloat:[DiscountField.text floatValue]];
    NSNumber* rebate = [NSNumber numberWithFloat:[self.rebateField.text floatValue]];
//    NSNumber* inStock = [NSNumber numberWithInt:[InStockField.text intValue]];
    NSNumber* inStock = [NSNumber numberWithInt:[self.instockRBTextField.text intValue]];
    NSNumber* units = [NSNumber numberWithInt:[unitsField.text intValue]];
    NSNumber* foc = [NSNumber numberWithInt:[FOCField.text intValue]];
    
    [values setObject:qty forKey:@"qty"];
    [values setObject:bonus forKey:@"bonus"];
    [values setObject:discount forKey:@"discount"];
    
//    if ([ArcosConfigDataManager sharedArcosConfigDataManager].recordInStockRBFlag) {
//        inStock = [NSNumber numberWithInt:[self.instockRBTextField.text intValue]];
//    }
    if ([[SettingManager databaseName] isEqualToString:[GlobalSharedClass shared].myDbName] && [orderFormDetails containsString:@"[NB]"]) {
//        float maxDisc = self.arcosMyResult.max;
//        self.arcosMyResult.uni > self.arcosMyResult.ud ? self.arcosMyResult.uni : self.arcosMyResult.ud;
        if ([discount compare:self.arcosMyResult.max] == NSOrderedDescending) {
            [ArcosUtils showDialogBox:[NSString stringWithFormat:@"Discount cannot exceed %.2f%%", [self.arcosMyResult.max floatValue]] title:@"" delegate:nil target:self tag:0 handler:nil];
            return;
        }
    }
    
    //[self.delegate orderInputDone:values];
    
    
    
    //reset data
    if (([qty intValue]<=0 || qty ==nil) && ([bonus intValue]<=0 || bonus==nil) 
        && ([inStock intValue] == 0 || inStock == nil) && ([units intValue] == 0 || units == nil) && ([foc intValue] <= 0 || foc == nil)){
        [self.Data setObject:[NSNumber numberWithInt:0]  forKey:@"Qty"];
        [self.Data setObject:[NSNumber numberWithInt:0] forKey:@"Bonus"];
//        [self.Data setObject:[NSNumber numberWithInt:0] forKey:@"DiscountPercent"];
        [self.Data setObject:[NSNumber numberWithInt:0] forKey:@"LineValue"];
        [self.Data setObject:[NSNumber numberWithInt:0] forKey:@"vatAmount"];
        [self.Data setObject:[NSNumber numberWithFloat:0] forKey:@"RebatePercent"];
        [self.Data setObject:[NSNumber numberWithInt:0] forKey:@"InStock"];
        [self.Data setObject:[NSNumber numberWithInt:0] forKey:@"units"];
        [self.Data setObject:[NSNumber numberWithInt:0] forKey:@"FOC"];
        [self.Data setObject:[NSNumber numberWithBool:NO] forKey: @"IsSelected"];
        
    } else{
        [self.Data setObject:qty forKey:@"Qty"];
        [self.Data setObject:bonus forKey:@"Bonus"];
        [self.Data setObject:discount forKey:@"DiscountPercent"];
        [self.Data setObject:rebate forKey:@"RebatePercent"];
        [self.Data setObject:inStock forKey:@"InStock"];
        [self.Data setObject:units forKey:@"units"];
        [self.Data setObject:foc forKey:@"FOC"];
        
        //        NSNumber* total=[NSNumber numberWithFloat:[qty intValue]*[[self.Data objectForKey:@"UnitPrice"]floatValue]];
        NSNumber* total = [self resetTotalValue];
        [self.Data setObject:total forKey:@"LineValue"];
        if (![[ArcosConfigDataManager sharedArcosConfigDataManager] showTotalVATInvoiceFlag]) {
            [self.Data setObject:[NSNumber numberWithInt:0] forKey:@"vatAmount"];
        } else {
            NSDictionary* auxDescrDetailDict = [[ArcosCoreData sharedArcosCoreData] descriptionWithIUR:[self.Data objectForKey:@"VCIUR"]];
            [self.Data setObject:[NSNumber numberWithFloat:[ArcosUtils roundFloatTwoDecimal:[total floatValue] / 100 * [[auxDescrDetailDict objectForKey:@"Dec1"] floatValue]]] forKey:@"vatAmount"];
        }
        [self.Data setObject:[NSNumber numberWithBool:YES] forKey: @"IsSelected"];
    }
    if ([[ArcosUtils convertNilToZero:[self.Data objectForKey:@"PriceFlag"]] intValue] == 1 && [[ArcosConfigDataManager sharedArcosConfigDataManager] useDiscountFromPriceFlag]) {
        NSNumber* allowDiscount = [SettingManager SettingForKeypath:@"CompanySetting.Order Processing" atIndex:1];
        SettingManager* sm = [SettingManager setting];
        NSMutableDictionary* presenterPwdDict = [sm getSettingForKeypath:@"CompanySetting.Connection" atIndex:8];
        NSString* presenterPwd = [[presenterPwdDict objectForKey:@"Value"] uppercaseString];
        NSRange aBDRange = [presenterPwd rangeOfString:@"[BD]"];
        if (([allowDiscount boolValue] || aBDRange.location != NSNotFound) && ![ArcosConfigDataManager sharedArcosConfigDataManager].recordInStockRBFlag && !([[ArcosConfigDataManager sharedArcosConfigDataManager] showRRPInOrderPadFlag] && ![orderFormDetails containsString:@"[BD]"]) && [self.originalDiscountPercent floatValue] != [[self.Data objectForKey:@"DiscountPercent"] floatValue]) {            
            [self.Data setObject:[NSNumber numberWithInt:-2] forKey:@"RRIUR"];
        }
    }
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] retrieveLocationProductMATDataLocallyFlag] && [[ArcosConfigDataManager sharedArcosConfigDataManager] showMATImageFlag] &&
        [[self.Data objectForKey:@"Qty"] intValue] > 0) {
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"locationIUR = %@ and productIUR = %@", self.locationIUR, [self.Data objectForKey:@"ProductIUR"]];
        NSNumber* locationProductMatCount = [[ArcosCoreData sharedArcosCoreData] recordQtyWithEntityName:@"LocationProductMAT" predicate:predicate];
        if ([locationProductMatCount intValue] == 0) {
            [self.Data setObject:[NSNumber numberWithInt:-3] forKey:@"RRIUR"];
        }
    }
    //clear all fields
    QTYField.text=@"0";
    BonusField.text=@"0";
//    DiscountField.text=@"0%";
    unitsField.text=@"0";
    FOCField.text=@"0";
    self.instockRBTextField.text=@"0";
    [self.delegate operationDone:self.Data ];
}

//actions
-(IBAction)textFieldTouched:(id)sender{
//    UITextField* aTextField= (UITextField*)sender;
//    NSLog(@"text field %d pressed!",aTextField.tag);
}
-(IBAction)numberKeyTouched:(id)sender{
    UIButton* theButton=(UIButton*)sender;
    BOOL isCheckPass=NO;
    
    switch (self.currentTextField.tag) {
        case 0:
        case 1:
        case 5:
            isCheckPass=[self QTYBonusCheck:theButton.tag];
            break;
        case 2:
        case 8:
            isCheckPass=[self DiscountCheck:theButton.tag];
            break;
        case 6:
            isCheckPass = [self UnitPriceCheck:theButton.tag];
            break;
        case 3:
        case 4:
            isCheckPass=[self QTYBonusSplitPacksCheck:theButton.tag];
            break;
        default:
            break;
    }
    
    if (isCheckPass) {
        
    }else{
        
    }
}
-(IBAction)functionKeyTouched:(id)sender{
    UIButton* theButton=(UIButton*)sender;

    switch (theButton.tag) {
        case 0:
            [self deleteOneDigitFromCurrentFeild];
            break;
        case 1:
            [self clearCurrentFeild];
            break;
        case 2:
//            [self submitInput];
            [self checkQtyVanStock];
            break;
        default:
            break;
    }
}
- (IBAction)priceChangeButtonPressed:(id)sender {    
    PriceChangeTableViewController* pctvc = [[PriceChangeTableViewController alloc] initWithNibName:@"PriceChangeTableViewController" bundle:nil];
    pctvc.delegate = self;
    pctvc.priceChangeDataManager.dataDict = self.Data;
    self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:pctvc] autorelease];
    self.globalNavigationController.modalPresentationStyle = UIModalPresentationPopover;
    self.globalNavigationController.popoverPresentationController.sourceView = self.priceChangeButton;
    self.globalNavigationController.popoverPresentationController.delegate = self;
    self.globalNavigationController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionDown;
    self.globalNavigationController.preferredContentSize = CGSizeMake(376.0, 165.0);
    [self presentViewController:self.globalNavigationController animated:YES completion:nil];
    [pctvc release];    
}

#pragma mark PriceChangeTableViewControllerDelegate
- (void)didDismissPriceChangeView {
    [self dismissViewControllerAnimated:YES completion:^{
        self.globalNavigationController = nil;
    }];
}

- (void)saveButtonWithNewPrice:(NSDecimalNumber *)aNewPrice {
    [self.Data setObject:aNewPrice forKey:@"UnitPrice"];
    [self.Data setObject:[NSNumber numberWithInt:-1] forKey:@"RRIUR"];
    self.unitPriceField.text = [NSString stringWithFormat:@"%1.2f",[[self.Data objectForKey:@"UnitPrice"]floatValue]];
    [self resetTotalValue];
    [self dismissViewControllerAnimated:YES completion:^{
        self.globalNavigationController = nil;
    }];
}

#pragma mark UIPopoverPresentationControllerDelegate
- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    self.globalNavigationController = nil;
}
//tap action
/*
-(void)handleSingleTapGesture:(id)sender{
    UITapGestureRecognizer* reconizer=(UITapGestureRecognizer*)sender;
    UITextField* aField=(UITextField*)reconizer.view;
    currentTextField=aField;
    NSLog(@"text feild %d tap",aField.tag);
    
    [self highlightSelectField];
}
*/

-(void)highlightSelectField{ 
    QTYField.layer.cornerRadius=5.5f;
    BonusField.layer.cornerRadius=5.5f;
    DiscountField.layer.cornerRadius=5.5f;
    unitsField.layer.cornerRadius=5.5f;
    FOCField.layer.cornerRadius = 5.5f;
    self.instockRBTextField.layer.cornerRadius = 5.5f;
    self.rebateField.layer.cornerRadius = 5.5f;
    
    QTYField.layer.borderWidth=0.5f;
    BonusField.layer.borderWidth=0.5f;
    DiscountField.layer.borderWidth=0.5f;
    unitsField.layer.borderWidth=0.5f;
    FOCField.layer.borderWidth = 0.5f;
    self.instockRBTextField.layer.borderWidth = 0.5f;
    self.unitPriceField.layer.borderWidth = 0.5f;
    self.rebateField.layer.borderWidth = 0.5f;
    
    QTYField.layer.borderColor=[[UIColor blackColor]CGColor];
    BonusField.layer.borderColor=[[UIColor blackColor]CGColor];
    DiscountField.layer.borderColor=[[UIColor blackColor]CGColor];
    unitsField.layer.borderColor=[[UIColor blackColor]CGColor];
    FOCField.layer.borderColor=[[UIColor blackColor]CGColor];
    self.instockRBTextField.layer.borderColor = [[UIColor blackColor]CGColor];
    self.unitPriceField.layer.borderColor=[[UIColor blackColor]CGColor];
    self.rebateField.layer.borderColor = [[UIColor blackColor] CGColor];
    
    self.currentTextField.layer.borderWidth=3.0f;
    self.currentTextField.layer.borderColor=[[UIColor redColor]CGColor];
}

- (BOOL)isBonusGivenAndBonusRequiredExistent {
    return [[self.Data objectForKey:@"BonusGiven"] intValue] != 0 && [[self.Data objectForKey:@"BonusRequired"] intValue] != 0;
}
- (void)checkBonusWithGivenRequiredSellBy {
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] disableBonusBoxWithPriceRecordFlag] && ([[self.Data objectForKey:@"PriceFlag"] intValue] == 1 || [[self.Data objectForKey:@"PriceFlag"] intValue] == 2)) {
        return;
    }
    if (![self isBonusGivenAndBonusRequiredExistent] || self.currentTextField.tag != 0) return;
    
    switch ([[self.Data objectForKey:@"SellBy"] intValue]) {
        case 1:
        case 2: {
            BonusField.text = [NSString stringWithFormat:@"%d", [QTYField.text intValue] / [[self.Data objectForKey:@"BonusRequired"] intValue] * [[self.Data objectForKey:@"BonusGiven"] intValue]];
        }
            break;
        case 4: {
            if ([QTYField.text intValue] < [[self.Data objectForKey:@"BonusMinimum"] intValue]) {
                BonusField.text = @"0";
                return;
            }
            int bonusValue = [QTYField.text intValue] / [[self.Data objectForKey:@"BonusRequired"] intValue] * [[self.Data objectForKey:@"BonusGiven"] intValue];
            if ([BonusField.text intValue] > bonusValue) {
                BonusField.text = @"0";
            }
        }
            break;
            
        default:
            break;
    }
}
- (void)checkFocusBonusWithGivenRequiredSellByMinimum {
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] disableBonusBoxWithPriceRecordFlag] && ([[self.Data objectForKey:@"PriceFlag"] intValue] == 1 || [[self.Data objectForKey:@"PriceFlag"] intValue] == 2)) {
        return;
    }
    if (![self isBonusGivenAndBonusRequiredExistent] || self.currentTextField.tag != 1) return;
    switch ([[self.Data objectForKey:@"SellBy"] intValue]) {
        case 4: {
            if ([QTYField.text intValue] < [[self.Data objectForKey:@"BonusMinimum"] intValue]) {
                [self showBonusFocusCheckMinimumMsg:0];
                BonusField.text = @"0";
                return;
            }
            int bonusValue = [QTYField.text intValue] / [[self.Data objectForKey:@"BonusRequired"] intValue] * [[self.Data objectForKey:@"BonusGiven"] intValue];
            if ([BonusField.text intValue] > bonusValue) {
                [self showBonusFocusCheckMinimumMsg:bonusValue];
                BonusField.text = @"0";
            }
        }
            break;
            
        default:
            break;
    }
}
- (void)enableBonusFocWithFlag:(BOOL)aFlag {
    self.BonusField.enabled = aFlag;
    self.FOCField.enabled = aFlag;
}
- (void)showBonusFocWithFlag:(BOOL)aFlag {
    self.BonusLabel.hidden = !aFlag;
    self.BonusField.hidden = !aFlag;
    self.FOCField.hidden = !aFlag;
}
- (void)showDiscountWithFlag:(BOOL)aFlag {
    self.DiscountLabel.hidden = !aFlag;
    self.DiscountField.hidden = !aFlag;
}
- (void)showBonusFocusCheckMinimumMsg:(int)aBonusValue {
//    [ArcosUtils showMsg:[NSString stringWithFormat:@"Bonus is restricted to %d for %d\n Minimum order qty of %d\nBonus allowed %d", [[self.Data objectForKey:@"BonusGiven"] intValue], [[self.Data objectForKey:@"BonusRequired"] intValue], [[self.Data objectForKey:@"BonusMinimum"] intValue], aBonusValue] delegate:nil];
    [ArcosUtils showDialogBox:[NSString stringWithFormat:@"Bonus is restricted to %d for %d\n Minimum order qty of %d\nBonus allowed %d", [[self.Data objectForKey:@"BonusGiven"] intValue], [[self.Data objectForKey:@"BonusRequired"] intValue], [[self.Data objectForKey:@"BonusMinimum"] intValue], aBonusValue] title:@"" target:self handler:nil];
}

- (NSMutableDictionary*)interpretBonusDeal:(NSString*)aBonusDeal {
    NSMutableDictionary* resultDict = [NSMutableDictionary dictionary];
    [resultDict setObject:[NSNumber numberWithBool:NO] forKey:@"OkFlag"];
    if (aBonusDeal == nil || [aBonusDeal isEqualToString:@""]) {
        return resultDict;
    }
    NSArray* bonusDealChildren = [aBonusDeal componentsSeparatedByString:[GlobalSharedClass shared].tildeDelimiter];
    if ([bonusDealChildren count] != 10) {
        return resultDict;
    }
    @try {
        [resultDict setObject:[ArcosUtils convertStringToNumber:[bonusDealChildren objectAtIndex:0]] forKey:@"QB1"];
        [resultDict setObject:[ArcosUtils convertStringToNumber:[bonusDealChildren objectAtIndex:1]] forKey:@"QB2"];
        [resultDict setObject:[ArcosUtils convertStringToNumber:[bonusDealChildren objectAtIndex:2]] forKey:@"QB3"];
        [resultDict setObject:[ArcosUtils convertStringToNumber:[bonusDealChildren objectAtIndex:3]] forKey:@"QB4"];
        [resultDict setObject:[ArcosUtils convertStringToNumber:[bonusDealChildren objectAtIndex:4]] forKey:@"QB5"];
        [resultDict setObject:[ArcosUtils convertStringToDecimalNumber:[bonusDealChildren objectAtIndex:5]] forKey:@"QP1"];
        [resultDict setObject:[ArcosUtils convertStringToDecimalNumber:[bonusDealChildren objectAtIndex:6]] forKey:@"QP2"];
        [resultDict setObject:[ArcosUtils convertStringToDecimalNumber:[bonusDealChildren objectAtIndex:7]] forKey:@"QP3"];
        [resultDict setObject:[ArcosUtils convertStringToDecimalNumber:[bonusDealChildren objectAtIndex:8]] forKey:@"QP4"];
        [resultDict setObject:[ArcosUtils convertStringToDecimalNumber:[bonusDealChildren objectAtIndex:9]] forKey:@"QP5"];
        [resultDict setObject:[NSNumber numberWithBool:YES] forKey:@"OkFlag"];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    return resultDict;
}

- (void)checkQtyByBonusDeal {
    if ([[self.Data objectForKey:@"PriceFlag"] intValue] != 1) return;
    if (![[self.bonusDealResultDict objectForKey:@"OkFlag"] boolValue]) return;
    if (self.currentTextField.tag != 0) return;
    BOOL resEnterQtyFound = NO;
    int tmpQuantity = [self.QTYField.text intValue];
    resEnterQtyFound = [self enterQtyFoundProcessor:tmpQuantity];
    if (resEnterQtyFound) {
        self.unitPriceField.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        self.unitPriceField.font = [UIFont boldSystemFontOfSize:24.0];
        self.unitPriceField.backgroundColor = [UIColor blackColor];
    } else {
        self.unitPriceField.textColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
        self.unitPriceField.font = [UIFont boldSystemFontOfSize:24.0];
        self.unitPriceField.backgroundColor = [UIColor yellowColor];
    }
    self.unitPriceField.text=[NSString stringWithFormat:@"%1.2f",[[self.Data objectForKey:@"UnitPrice"]floatValue]];
}

- (BOOL)enterQtyFoundProcessor:(int)auxQuantity {
    BOOL enterQtyFound = NO;
    if (auxQuantity >= [[self.bonusDealResultDict objectForKey:@"QB1"] intValue] && auxQuantity < [[self.bonusDealResultDict objectForKey:@"QB2"] intValue]) {
        [self.Data setObject:[self.bonusDealResultDict objectForKey:@"QP1"] forKey:@"UnitPrice"];
        enterQtyFound = YES;
    } else if (auxQuantity >= [[self.bonusDealResultDict objectForKey:@"QB2"] intValue] && auxQuantity < [[self.bonusDealResultDict objectForKey:@"QB3"] intValue]) {
        [self.Data setObject:[self.bonusDealResultDict objectForKey:@"QP2"] forKey:@"UnitPrice"];
        enterQtyFound = YES;
    } else if (auxQuantity >= [[self.bonusDealResultDict objectForKey:@"QB3"] intValue] && auxQuantity < [[self.bonusDealResultDict objectForKey:@"QB4"] intValue]) {
        [self.Data setObject:[self.bonusDealResultDict objectForKey:@"QP3"] forKey:@"UnitPrice"];
        enterQtyFound = YES;
    } else if (auxQuantity >= [[self.bonusDealResultDict objectForKey:@"QB4"] intValue] && auxQuantity < [[self.bonusDealResultDict objectForKey:@"QB5"] intValue]) {
        [self.Data setObject:[self.bonusDealResultDict objectForKey:@"QP4"] forKey:@"UnitPrice"];
        enterQtyFound = YES;
    } else if (auxQuantity >= [[self.bonusDealResultDict objectForKey:@"QB5"] intValue]) {
        [self.Data setObject:[self.bonusDealResultDict objectForKey:@"QP5"] forKey:@"UnitPrice"];
        enterQtyFound = YES;
    } else {
        NSMutableArray* locationDictList = [[ArcosCoreData sharedArcosCoreData] locationWithIURWithoutCheck:self.locationIUR];
        if (![[ArcosConfigDataManager sharedArcosConfigDataManager] enableUsePriceProductGroupFlag]) {
            NSMutableDictionary* priceHashMap = [[ArcosCoreData sharedArcosCoreData] retrievePriceWithLocationIUR:self.locationIUR productIURList:[NSMutableArray arrayWithObject:[self.Data objectForKey:@"ProductIUR"]]];
            
//            NSDecimalNumber* auxUnitPriceFromPrice = [priceHashMap objectForKey:[self.Data objectForKey:@"ProductIUR"]];
            NSDictionary* auxPriceDict = [priceHashMap objectForKey:[self.Data objectForKey:@"ProductIUR"]];
            if (auxPriceDict != nil) {
                NSDecimalNumber* auxUnitPriceFromPrice = [auxPriceDict objectForKey:@"RebatePercent"];
                [self.Data setObject:auxUnitPriceFromPrice forKey:@"UnitPrice"];
            } else {
                if (locationDictList != nil) {
                    NSDictionary* locationDict = [locationDictList objectAtIndex:0];
                    NSMutableDictionary* masterPriceHashMap = [[ArcosCoreData sharedArcosCoreData] retrievePriceWithLocationIUR:[locationDict objectForKey:@"MasterLocationIUR"] productIURList:[NSMutableArray arrayWithObject:[self.Data objectForKey:@"ProductIUR"]]];
                    NSDictionary* auxMasterPriceDict = [masterPriceHashMap objectForKey:[self.Data objectForKey:@"ProductIUR"]];
//                    NSDecimalNumber* auxUnitPriceFromMasterPrice = [masterPriceHashMap objectForKey:[self.Data objectForKey:@"ProductIUR"]];
                    if (auxMasterPriceDict != nil) {
                        NSDecimalNumber* auxUnitPriceFromMasterPrice = [auxMasterPriceDict objectForKey:@"RebatePercent"];
                        [self.Data setObject:auxUnitPriceFromMasterPrice forKey:@"UnitPrice"];
                    }
                }
            }
        } else {
            if (locationDictList != nil) {
                NSDictionary* locationDict = [locationDictList objectAtIndex:0];
                NSMutableDictionary* pgPriceHashMap = [[ArcosCoreData sharedArcosCoreData] retrievePriceWithLocationIUR:[locationDict objectForKey:@"PGiur"] productIURList:[NSMutableArray arrayWithObject:[self.Data objectForKey:@"ProductIUR"]]];
//                NSDecimalNumber* auxUnitPriceFromPrice = [pgPriceHashMap objectForKey:[self.Data objectForKey:@"ProductIUR"]];
                NSDictionary* auxPgPriceDict = [pgPriceHashMap objectForKey:[self.Data objectForKey:@"ProductIUR"]];
                if (auxPgPriceDict != nil) {
                    NSDecimalNumber* auxUnitPriceFromPrice = [auxPgPriceDict objectForKey:@"RebatePercent"];
                    [self.Data setObject:auxUnitPriceFromPrice forKey:@"UnitPrice"];
                }
            }
        }
    }
    return enterQtyFound;
}

@end
