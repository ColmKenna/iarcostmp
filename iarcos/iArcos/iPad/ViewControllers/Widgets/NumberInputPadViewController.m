//
//  NumberInputPadViewController.m
//  Arcos
//
//  Created by David Kilmartin on 03/09/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "NumberInputPadViewController.h"

@implementation NumberInputPadViewController
@synthesize qtyBtn = _qtyBtn;
@synthesize bonBtn = _bonBtn;
@synthesize spQtyBtn = _spQtyBtn;
@synthesize spBonBtn = _spBonBtn;
@synthesize discBtn = _discBtn;
@synthesize otherBtn = _otherBtn;
@synthesize funcDelegate = _funcDelegate;
@synthesize selectedFuncBtn = _selectedFuncBtn;
@synthesize funcBtnList = _funcBtnList;
@synthesize selectedFuncBtnColor = _selectedFuncBtnColor;
@synthesize showSeparator = _showSeparator;
@synthesize discountAllowedNumber = _discountAllowedNumber;

@synthesize numBtn1;
@synthesize numBtn2;
@synthesize numBtn3;
@synthesize numBtn4;
@synthesize numBtn5;
@synthesize numBtn6;
@synthesize numBtn7;
@synthesize numBtn8;
@synthesize numBtn9;
@synthesize numBtn10;
@synthesize numBtn12;
@synthesize numBtn15;
@synthesize numBtn20;
@synthesize numBtn24;
@synthesize numBtn36;
@synthesize productCodeTextField = _productCodeTextField;
@synthesize productCodeBtn = _productCodeBtn;
@synthesize inStockTitle = _inStockTitle;
@synthesize inStockValue = _inStockValue;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    if (self.qtyBtn != nil) { self.qtyBtn = nil; }
    if (self.bonBtn != nil) { self.bonBtn = nil; }
    if (self.spQtyBtn != nil) { self.spQtyBtn = nil; }
    if (self.spBonBtn != nil) { self.spBonBtn = nil; }
    if (self.discBtn != nil) { self.discBtn = nil; }
    if (self.otherBtn != nil) { self.otherBtn = nil; }
    if (self.selectedFuncBtn != nil) { self.selectedFuncBtn = nil; }
    if (self.funcBtnList != nil) { self.funcBtnList = nil; }
    if (self.discountAllowedNumber != nil) { self.discountAllowedNumber = nil; }
    
    if (self.numBtn1 != nil) { self.numBtn1 = nil; }
    if (self.numBtn2 != nil) { self.numBtn2 = nil; }    
    if (self.numBtn3 != nil) { self.numBtn3 = nil; }
    if (self.numBtn4 != nil) { self.numBtn4 = nil; }
    if (self.numBtn5 != nil) { self.numBtn5 = nil; }
    if (self.numBtn6 != nil) { self.numBtn6 = nil; }    
    if (self.numBtn7 != nil) { self.numBtn7 = nil; }
    if (self.numBtn8 != nil) { self.numBtn8 = nil; }
    if (self.numBtn9 != nil) { self.numBtn9 = nil; }
    if (self.numBtn10 != nil) { self.numBtn10 = nil; }
    if (self.numBtn12 != nil) { self.numBtn12 = nil; }
    if (self.numBtn15 != nil) { self.numBtn15 = nil; }
    if (self.numBtn20 != nil) { self.numBtn20 = nil; }
    if (self.numBtn24 != nil) { self.numBtn24 = nil; }
    if (self.numBtn36 != nil) { self.numBtn36 = nil; }
    if (self.productCodeTextField != nil) { self.productCodeTextField = nil; }
    if (self.productCodeBtn != nil) { self.productCodeBtn = nil; }
    self.inStockTitle = nil;
    self.inStockValue = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.selectedFuncBtn = self.qtyBtn;
    self.selectedFuncBtn.backgroundColor = [UIColor blueColor];
    self.funcBtnList = [NSMutableArray arrayWithCapacity:5];
    [self.funcBtnList addObject:self.qtyBtn];
    [self.funcBtnList addObject:self.bonBtn];
    [self.funcBtnList addObject:self.spQtyBtn];
    [self.funcBtnList addObject:self.spBonBtn];
    [self.funcBtnList addObject:self.discBtn];
    self.selectedFuncBtnColor = [UIColor blueColor];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    NSLog(@"number input pad view will appear %d %d",self.showSeparator, [self.discountAllowedNumber boolValue]);
    [self configSplitPackBtnStatus:self.showSeparator];
    [self configDiscountBonusStatus:[self.discountAllowedNumber boolValue]];
    [self configToShowInStock];
    [self configSplitPackBtnByRecordInStockRB];
}

- (void)configDiscountBonusStatus:(BOOL)aDiscountAllowedFlag {
    if (aDiscountAllowedFlag) {
        self.discBtn.hidden = !aDiscountAllowedFlag;
        self.bonBtn.hidden = aDiscountAllowedFlag;
        self.spBonBtn.hidden = aDiscountAllowedFlag;
    }
}

- (void)configSplitPackBtnStatus:(BOOL)aShowSeparator {
    self.spQtyBtn.hidden = !aShowSeparator;
    self.spBonBtn.hidden = !aShowSeparator;
}

- (void)configToShowInStock {
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showInStockFlag]) {
        self.inStockTitle.hidden = NO;
        self.inStockValue.hidden = NO;
    } else {
        self.inStockTitle.hidden = YES;
        self.inStockValue.hidden = YES;
    }
}

//check to put at last 
- (void)configSplitPackBtnByRecordInStockRB {
    if ([ArcosConfigDataManager sharedArcosConfigDataManager].recordInStockRBFlag) {
        self.spQtyBtn.hidden = YES;
        self.spBonBtn.hidden = YES;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (IBAction)pressFuncBtn:(id)sender {
    UIButton* btn = (UIButton*)sender;
    self.selectedFuncBtn = btn;
    [self.funcDelegate numberInputPadWithFuncBtn:btn];
    for (int i = 0; i < [self.funcBtnList count]; i++) {
        UIButton* tmpFuncBtn = [self.funcBtnList objectAtIndex:i];
        tmpFuncBtn.backgroundColor = [UIColor clearColor];
    }
    btn.backgroundColor = [UIColor blueColor];
}

- (IBAction)pressNumberBtn:(id)sender {
    UIButton* btn = (UIButton*)sender;
    [self.funcDelegate numberInputPadWithNumberBtn:btn funcBtn:self.selectedFuncBtn];
}

- (void)resetFuncBtn {
    for (int i = 0; i < [self.funcBtnList count]; i++) {
        UIButton* tmpFuncBtn = [self.funcBtnList objectAtIndex:i];
        tmpFuncBtn.backgroundColor = [UIColor clearColor];
    }
    self.selectedFuncBtn = self.qtyBtn;
    self.qtyBtn.backgroundColor = self.selectedFuncBtnColor;
}

- (IBAction)pressOtherBtn:(id)sender {
    [self.funcDelegate numberInputPadWithOtherBtn];
}

- (IBAction)pressSearchBtn:(id)sender {
//    NSLog(@"abc");
    [self.productCodeTextField resignFirstResponder];
    [self.funcDelegate numberInputPadWithSearchBtn:self.productCodeTextField.text];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self.funcDelegate numberInputPadWithSearchBtn:self.productCodeTextField.text];
    return YES;
}

@end
