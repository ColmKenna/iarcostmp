//
//  OrderEntryInputViewController.m
//  iArcos
//
//  Created by Apple on 06/03/2020.
//  Copyright © 2020 Strata IT Limited. All rights reserved.
//

#import "OrderEntryInputViewController.h"

@interface OrderEntryInputViewController ()

@end

@implementation OrderEntryInputViewController
@synthesize myNavigationBar = _myNavigationBar;
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
@synthesize dotButton = _dotButton;
@synthesize deleteButton = _deleteButton;
@synthesize clearButton = _clearButton;
@synthesize doneButton = _doneButton;

@synthesize qtyLabel = _qtyLabel;
@synthesize qtyTextField = _qtyTextField;
@synthesize bonusLabel = _bonusLabel;
@synthesize bonusTextField = _bonusTextField;
@synthesize focLabel = _focLabel;
@synthesize focTextField = _focTextField;
@synthesize inStockLabel = _inStockLabel;
@synthesize inStockTextField = _inStockTextField;
@synthesize testersLabel = _testersLabel;
@synthesize testersTextField = _testersTextField;
@synthesize valueLabel = _valueLabel;
@synthesize valueTextField = _valueTextField;
@synthesize unitPriceLabel = _unitPriceLabel;
@synthesize unitPriceTextField = _unitPriceTextField;
@synthesize currentTextField = _currentTextField;

@synthesize orderEntryInputDataManager = _orderEntryInputDataManager;
@synthesize textFieldList = _textFieldList;
@synthesize matTableView = _matTableView;
@synthesize orderInputPadDataManager = _orderInputPadDataManager;
@synthesize orderEntryInputMatHeaderView = _orderEntryInputMatHeaderView;
@synthesize myTableBorderColor = _myTableBorderColor;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.orderEntryInputDataManager = [[[OrderEntryInputDataManager alloc] init] autorelease];
        self.orderInputPadDataManager = [[[OrderInputPadDataManager alloc] init] autorelease];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.textFieldList = [NSArray arrayWithObjects:self.qtyTextField, self.bonusTextField, self.focTextField, self.inStockTextField, self.testersTextField, self.valueTextField, self.unitPriceTextField, nil];
    self.myTableBorderColor = [UIColor colorWithRed:135.0/255.0f green:206.0/255.0f blue:250.0/255.0f alpha:1.0f];
    [self.matTableView.layer setBorderColor:[self.myTableBorderColor CGColor]];
    [self.matTableView.layer setBorderWidth:1.0];
    if ([self.matTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.matTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.matTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.matTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    [self.matTableView setSeparatorColor:self.myTableBorderColor];
}

- (void)dealloc {
    self.myNavigationBar = nil;
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
    self.dotButton = nil;
    self.deleteButton = nil;
    self.clearButton = nil;
    self.doneButton = nil;
    
    self.qtyLabel = nil;
    self.qtyTextField = nil;
    self.bonusLabel = nil;
    self.bonusTextField = nil;
    self.focLabel = nil;
    self.focTextField = nil;
    self.inStockLabel = nil;
    self.inStockTextField = nil;
    self.testersLabel = nil;
    self.testersTextField = nil;
    self.valueLabel = nil;
    self.valueTextField = nil;
    self.unitPriceLabel = nil;
    self.unitPriceTextField = nil;
    self.currentTextField = nil;
    
    self.orderEntryInputDataManager = nil;
    self.textFieldList = nil;
    self.matTableView = nil;
    self.orderInputPadDataManager = nil;
    self.orderEntryInputMatHeaderView = nil;
    self.myTableBorderColor = nil;
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.isWidgetEditable) {
        self.view.alpha = 1.0;
    } else {
        self.view.alpha = 0.5;
    }
    [self.orderEntryInputDataManager retrieveColumnDescriptionInfo];
    NSString* bonValue = [self.orderEntryInputDataManager.columnDescDataDict objectForKey:self.orderEntryInputDataManager.bonKey];
    if (bonValue == nil) {
        self.bonusLabel.hidden = YES;
        self.bonusTextField.hidden = YES;
    } else {
        self.bonusLabel.text = bonValue;
        self.bonusLabel.hidden = NO;
        self.bonusTextField.hidden = NO;
    }
    NSString* focValue = [self.orderEntryInputDataManager.columnDescDataDict objectForKey:self.orderEntryInputDataManager.focKey];
    if (focValue == nil) {
        self.focLabel.hidden = YES;
        self.focTextField.hidden = YES;
    } else {
        self.focLabel.text = focValue;
        self.focLabel.hidden = NO;
        self.focTextField.hidden = NO;
    }
    NSString* instValue = [self.orderEntryInputDataManager.columnDescDataDict objectForKey:self.orderEntryInputDataManager.instKey];
    if (instValue == nil) {
        self.inStockLabel.hidden = YES;
        self.inStockTextField.hidden = YES;
    } else {
        self.inStockLabel.text = instValue;
        self.inStockLabel.hidden = NO;
        self.inStockTextField.hidden = NO;
    }
    NSString* testValue = [self.orderEntryInputDataManager.columnDescDataDict objectForKey:self.orderEntryInputDataManager.testKey];
    if (testValue == nil) {
        self.testersLabel.hidden = YES;
        self.testersTextField.hidden = YES;
    } else {
        self.testersLabel.text = testValue;
        self.testersLabel.hidden = NO;
        self.testersTextField.hidden = NO;
    }
    NSDictionary* productFormRowDict = [[ArcosCoreData sharedArcosCoreData] formRowWithFormIUR:[self.orderEntryInputDataManager.relatedFormDetailDict objectForKey:@"IUR"] productIUR:[self.Data objectForKey:@"ProductIUR"]];
    self.bonusTextField.enabled = YES;
    self.bonusTextField.textColor = [UIColor blackColor];
    self.focTextField.enabled = YES;
    self.focTextField.textColor = [UIColor blackColor];
    self.testersTextField.enabled = YES;
    self.testersTextField.textColor = [UIColor blackColor];
    if (productFormRowDict != nil) {
        NSNumber* bon1ROFlag = [productFormRowDict objectForKey:@"Bon1RO"];
        if ([bon1ROFlag boolValue]) {
            self.bonusTextField.enabled = NO;
            self.bonusTextField.textColor = [UIColor lightGrayColor];
        }
        NSNumber* fOCROFlag = [productFormRowDict objectForKey:@"FOCRO"];
        if ([fOCROFlag boolValue]) {
            self.focTextField.enabled = NO;
            self.focTextField.textColor = [UIColor lightGrayColor];
        }
        NSNumber* testerROFlag = [productFormRowDict objectForKey:@"TesterRO"];
        if ([testerROFlag boolValue]) {
            self.testersTextField.enabled = NO;
            self.testersTextField.textColor = [UIColor lightGrayColor];
        }
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
//        int monthNum = 26;
//        NSString* valueField = [NSString stringWithFormat:@"setText:"];
//        SEL valueSelector = NSSelectorFromString(valueField);
//        for (int i = 0; i < [self.orderInputPadDataManager.monthList count]; i++) {
//            monthNum--;
//            NSString* tmpMonthStr = [self.orderInputPadDataManager.monthList objectAtIndex:i];
//            NSString* monthField = [NSString stringWithFormat:@"mon%d",monthNum];
//            SEL monthSelector = NSSelectorFromString(monthField);
//            [[self performSelector:monthSelector] performSelector:valueSelector withObject:tmpMonthStr];
//        }
        self.orderEntryInputDataManager.qtyList = [NSMutableArray arrayWithCapacity:13];
        self.orderEntryInputDataManager.bonList = [NSMutableArray arrayWithCapacity:13];
        if ([objectList count] > 0) {
            NSDictionary* locationProductMATDict = [objectList objectAtIndex:0];
            SEL methodSelector = NSSelectorFromString(@"objectForKey:");
            int qbNum = 26;
            for (int i = 0; i < 13; i++) {
                qbNum--;
                NSString* qtyValueParameter = [NSString stringWithFormat:@"qty%d", qbNum];
                NSNumber* qtyNumber = [locationProductMATDict performSelector:methodSelector withObject:qtyValueParameter];
                [self.orderEntryInputDataManager.qtyList addObject:[ArcosUtils convertZeroToBlank:[ArcosUtils convertNumberToIntString:qtyNumber]]];
//                NSString* qtyField = [NSString stringWithFormat:@"qty%d",qbNum];
//                SEL qtySelector = NSSelectorFromString(qtyField);
//                [[self performSelector:qtySelector] performSelector:valueSelector withObject:[ArcosUtils convertZeroToBlank:[ArcosUtils convertNumberToIntString:qtyNumber]]];
                
                NSString* bonusValueParameter = [NSString stringWithFormat:@"bonus%d", qbNum];
                NSNumber* bonusNumber = [locationProductMATDict performSelector:methodSelector withObject:bonusValueParameter];
                [self.orderEntryInputDataManager.bonList addObject:[ArcosUtils convertZeroToBlank:[ArcosUtils convertNumberToIntString:bonusNumber]]];
                
//                NSString* bonusField = [NSString stringWithFormat:@"bonus%d",qbNum];
//                SEL bonusSelector = NSSelectorFromString(bonusField);
//                [[self performSelector:bonusSelector] performSelector:valueSelector withObject:[ArcosUtils convertZeroToBlank:[ArcosUtils convertNumberToIntString:bonusNumber]]];
            }
        } else {
//            int qbNum = 26;
            for (int i = 0; i < 13; i++) {
                [self.orderEntryInputDataManager.qtyList addObject:@""];
                [self.orderEntryInputDataManager.bonList addObject:@""];
//                qbNum--;
//                NSString* qtyField = [NSString stringWithFormat:@"qty%d",qbNum];
//                SEL qtySelector = NSSelectorFromString(qtyField);
//                [[self performSelector:qtySelector] performSelector:valueSelector withObject:@""];
//                NSString* bonusField = [NSString stringWithFormat:@"bonus%d",qbNum];
//                SEL bonusSelector = NSSelectorFromString(bonusField);
//                [[self performSelector:bonusSelector] performSelector:valueSelector withObject:@""];
            }
        }
    }
    
    if ([ProductFormRowConverter isSelectedWithFormRowDict:self.Data]) {
        self.qtyTextField.text = [[self.Data objectForKey:@"Qty"] stringValue];
        self.bonusTextField.text = [[self.Data objectForKey:@"Bonus"] stringValue];
        self.valueTextField.text = [NSString stringWithFormat:@"%1.2f", [[self.Data objectForKey:@"LineValue"] floatValue]];
        self.inStockTextField.text = [[self.Data objectForKey:@"InStock"] stringValue];
        self.focTextField.text = [[self.Data objectForKey:@"FOC"] stringValue];
        self.testersTextField.text = [[self.Data objectForKey:@"Testers"] stringValue];
    } else {
        self.qtyTextField.text = @"0";
        self.bonusTextField.text = @"0";
        self.valueTextField.text = @"0.00";
        self.inStockTextField.text = @"0";
        self.focTextField.text = @"0";
        self.testersTextField.text = @"0";
    }
    self.myNavigationBar.topItem.title = [self.Data objectForKey:@"Details"];
    self.unitPriceTextField.text = [NSString stringWithFormat:@"%1.2f", [[self.Data objectForKey:@"UnitPrice"] floatValue]];
    
    self.currentTextField = self.qtyTextField;
    [self highlightSelectTextField];
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField.tag == 7) return NO;
    if (textField.tag == 6) return NO;
    self.currentTextField = textField;
    [self highlightSelectTextField];
    return NO;
}

- (void)highlightSelectTextField {
    for (UITextField* tmpTextField in self.textFieldList) {
        tmpTextField.layer.cornerRadius = 5.5f;
        tmpTextField.layer.borderWidth = 0.5f;
        tmpTextField.layer.borderColor = [[UIColor blackColor] CGColor];
    }
    
    self.currentTextField.layer.borderWidth = 3.0f;
    self.currentTextField.layer.borderColor = [[UIColor redColor] CGColor];
}

- (IBAction)numberKeyTouched:(id)sender {
    if (!self.isWidgetEditable) return;
    UIButton* theButton = (UIButton*)sender;
    [self qtyBonusCheck:theButton.tag];
}

- (IBAction)functionKeyTouched:(id)sender {
    if (!self.isWidgetEditable) return;
    UIButton* theButton = (UIButton*)sender;

    switch (theButton.tag) {
        case 0:
            [self deleteOneDigitFromCurrentTextField];
            break;
        case 1:
            [self clearCurrentTextField];
            break;
        case 2:
            [self submitInput];
            break;
        default:
            break;
    }
}

- (NSNumber*)resetTotalValue {
    NSNumber* total = [NSNumber numberWithFloat:[self.qtyTextField.text intValue] * [[self.Data objectForKey:@"UnitPrice"] floatValue]];
    
//    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] useWeightToCalculatePriceFlag]) {
//        int minUnitPrice = [[self.Data objectForKey:@"MinimumUnitPrice"] intValue];
//        if (minUnitPrice != 0) {
//            total = [NSNumber numberWithFloat:([total floatValue] * minUnitPrice / 100)];
//        }
//    }
    self.valueTextField.text = [NSString stringWithFormat:@"%1.2f", [total floatValue]];
    return total;
}

- (BOOL)qtyBonusCheck:(NSInteger)input {
    NSString* qtyString = self.currentTextField.text;
    NSString* firstChar = [qtyString substringToIndex:1];
    //not over 8 digits
    if([qtyString length] >= 8){
        return NO;
    }
    
    //dot input
    if (input == 10) {
        return NO;
    }
    //0 input
    if (input == 0) {
        if ([firstChar isEqualToString:@"0"]) {
            return NO;
        }
    }
    //current value is 0
    if ([firstChar isEqualToString:@"0"]) {
        qtyString = @"";
    }
    
    //append the qty value
    qtyString = [qtyString stringByAppendingFormat:@"%d",[ArcosUtils convertNSIntegerToInt:input]];
    self.currentTextField.text = qtyString;
    [self resetTotalValue];
    return YES;
}

- (void)deleteOneDigitFromCurrentTextField{
    NSString* textFieldString = self.currentTextField.text;
    textFieldString = [textFieldString substringToIndex:[textFieldString length] - 1];
    self.currentTextField.text = textFieldString;
    if ([textFieldString isEqualToString:@""]) {
        [self clearCurrentTextField];
    }
    [self resetTotalValue];
}

- (void)clearCurrentTextField {
    self.currentTextField.text = @"0";
    [self resetTotalValue];
}

- (void)submitInput {
    
    NSNumber* qty = [NSNumber numberWithInt:[self.qtyTextField.text intValue]];
    NSNumber* bonus = [NSNumber numberWithInt:[self.bonusTextField.text intValue]];
    NSNumber* foc = [NSNumber numberWithInt:[self.focTextField.text intValue]];
    NSNumber* inStock = [NSNumber numberWithInt:[self.inStockTextField.text intValue]];
    NSNumber* testers = [NSNumber numberWithInt:[self.testersTextField.text intValue]];
    

    if (([qty intValue]<=0 || qty ==nil) && ([bonus intValue]<=0 || bonus==nil)
        && ([inStock intValue] == 0 || inStock == nil) && ([foc intValue] <= 0 || foc == nil) && ([testers intValue] <= 0 || testers == nil)) {
        [self.Data setObject:[NSNumber numberWithInt:0]  forKey:@"Qty"];
        [self.Data setObject:[NSNumber numberWithInt:0] forKey:@"Bonus"];
        [self.Data setObject:[NSNumber numberWithInt:0] forKey:@"LineValue"];
        [self.Data setObject:[NSNumber numberWithInt:0] forKey:@"vatAmount"];
        [self.Data setObject:[NSNumber numberWithInt:0] forKey:@"InStock"];
        [self.Data setObject:[NSNumber numberWithInt:0] forKey:@"FOC"];
        [self.Data setObject:[NSNumber numberWithInt:0] forKey:@"Testers"];
        [self.Data setObject:[NSNumber numberWithBool:NO] forKey: @"IsSelected"];
        
    } else {
        [self.Data setObject:qty forKey:@"Qty"];
        [self.Data setObject:bonus forKey:@"Bonus"];
        [self.Data setObject:inStock forKey:@"InStock"];
        [self.Data setObject:foc forKey:@"FOC"];
        [self.Data setObject:testers forKey:@"Testers"];
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
    [self.delegate operationDone:self.Data];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.orderInputPadDataManager.monthList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 22.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 22.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.orderEntryInputMatHeaderView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* orderEntryInputMatTableViewCellIdentifier = @"IdOrderEntryInputMatTableViewCell";
    
    OrderEntryInputMatTableViewCell* cell = (OrderEntryInputMatTableViewCell*) [tableView dequeueReusableCellWithIdentifier:orderEntryInputMatTableViewCellIdentifier];
    if(cell == nil) {
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"OrderEntryInputMatTableViewCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[OrderEntryInputMatTableViewCell class]] && [[(OrderEntryInputMatTableViewCell*)nibItem reuseIdentifier] isEqualToString:orderEntryInputMatTableViewCellIdentifier]) {
                cell = (OrderEntryInputMatTableViewCell*) nibItem;
            }
        }
    }
    
    // Configure the cell...
    cell.monthDesc.text = [self.orderInputPadDataManager.monthList objectAtIndex:indexPath.row];
    cell.qty.text = [self.orderEntryInputDataManager.qtyList objectAtIndex:indexPath.row];
    cell.bon.text = [self.orderEntryInputDataManager.bonList objectAtIndex:indexPath.row];
    return cell;
}

@end
