//
//  OrderEntryInputViewController.h
//  iArcos
//
//  Created by Apple on 06/03/2020.
//  Copyright © 2020 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WidgetViewController.h"
#import "OrderEntryInputDataManager.h"
#import "OrderInputPadDataManager.h"
#import "OrderEntryInputMatTableViewCell.h"
#import "OrderEntryInputMatHeaderView.h"

@interface OrderEntryInputViewController : WidgetViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource> {
    UINavigationBar* _myNavigationBar;
    UIButton* _sevenButton;
    UIButton* _eightButton;
    UIButton* _nineButton;
    UIButton* _fourButton;
    UIButton* _fiveButton;
    UIButton* _sixButton;
    UIButton* _oneButton;
    UIButton* _twoButton;
    UIButton* _threeButton;
    UIButton* _zeroButton;
    UIButton* _dotButton;
    UIButton* _deleteButton;
    UIButton* _clearButton;
    UIButton* _doneButton;
    
    UILabel* _qtyLabel;
    UITextField* _qtyTextField;
    UILabel* _bonusLabel;
    UITextField* _bonusTextField;
    UILabel* _focLabel;
    UITextField* _focTextField;
    UILabel* _inStockLabel;
    UITextField* _inStockTextField;
    UILabel* _testersLabel;
    UITextField* _testersTextField;
    UILabel* _valueLabel;
    UITextField* _valueTextField;
    UILabel* _unitPriceLabel;
    UITextField* _unitPriceTextField;
    UITextField* _currentTextField;
    
    OrderEntryInputDataManager* _orderEntryInputDataManager;
    NSArray* _textFieldList;
    UITableView* _matTableView;
    OrderInputPadDataManager* _orderInputPadDataManager;
    OrderEntryInputMatHeaderView* _orderEntryInputMatHeaderView;
    UIColor* _myTableBorderColor;
}

@property(nonatomic, retain) IBOutlet UINavigationBar* myNavigationBar;
@property(nonatomic, retain) IBOutlet UIButton* sevenButton;
@property(nonatomic, retain) IBOutlet UIButton* eightButton;
@property(nonatomic, retain) IBOutlet UIButton* nineButton;
@property(nonatomic, retain) IBOutlet UIButton* fourButton;
@property(nonatomic, retain) IBOutlet UIButton* fiveButton;
@property(nonatomic, retain) IBOutlet UIButton* sixButton;
@property(nonatomic, retain) IBOutlet UIButton* oneButton;
@property(nonatomic, retain) IBOutlet UIButton* twoButton;
@property(nonatomic, retain) IBOutlet UIButton* threeButton;
@property(nonatomic, retain) IBOutlet UIButton* zeroButton;
@property(nonatomic, retain) IBOutlet UIButton* dotButton;
@property(nonatomic, retain) IBOutlet UIButton* deleteButton;
@property(nonatomic, retain) IBOutlet UIButton* clearButton;
@property(nonatomic, retain) IBOutlet UIButton* doneButton;

@property(nonatomic, retain) IBOutlet UILabel* qtyLabel;
@property(nonatomic, retain) IBOutlet UITextField* qtyTextField;
@property(nonatomic, retain) IBOutlet UILabel* bonusLabel;
@property(nonatomic, retain) IBOutlet UITextField* bonusTextField;
@property(nonatomic, retain) IBOutlet UILabel* focLabel;
@property(nonatomic, retain) IBOutlet UITextField* focTextField;
@property(nonatomic, retain) IBOutlet UILabel* inStockLabel;
@property(nonatomic, retain) IBOutlet UITextField* inStockTextField;
@property(nonatomic, retain) IBOutlet UILabel* testersLabel;
@property(nonatomic, retain) IBOutlet UITextField* testersTextField;
@property(nonatomic, retain) IBOutlet UILabel* valueLabel;
@property(nonatomic, retain) IBOutlet UITextField* valueTextField;
@property(nonatomic, retain) IBOutlet UILabel* unitPriceLabel;
@property(nonatomic, retain) IBOutlet UITextField* unitPriceTextField;
@property(nonatomic,retain) UITextField* currentTextField;

@property(nonatomic, retain) OrderEntryInputDataManager* orderEntryInputDataManager;
@property(nonatomic, retain) NSArray* textFieldList;
@property(nonatomic, retain) IBOutlet UITableView* matTableView;
@property(nonatomic, retain) OrderInputPadDataManager* orderInputPadDataManager;
@property(nonatomic, retain) IBOutlet OrderEntryInputMatHeaderView* orderEntryInputMatHeaderView;
@property(nonatomic, retain) UIColor* myTableBorderColor;

- (IBAction)numberKeyTouched:(id)sender;
- (IBAction)functionKeyTouched:(id)sender;
- (void)highlightSelectTextField;
- (NSNumber*)resetTotalValue;

@end


