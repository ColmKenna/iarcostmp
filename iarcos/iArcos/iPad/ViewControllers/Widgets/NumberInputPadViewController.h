//
//  NumberInputPadViewController.h
//  Arcos
//
//  Created by David Kilmartin on 03/09/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArcosConfigDataManager.h"
@protocol NumberInputPadViewDelegate;

@interface NumberInputPadViewController : UIViewController <UITextFieldDelegate> {
    UIButton* _qtyBtn;
    UIButton* _bonBtn;
    UIButton* _spQtyBtn;
    UIButton* _spBonBtn;
    UIButton* _discBtn;
    UIButton* _otherBtn;
    id<NumberInputPadViewDelegate> _funcDelegate;
    UIButton* _selectedFuncBtn;
    NSMutableArray* _funcBtnList;
    UIColor* _selectedFuncBtnColor;
    BOOL _showSeparator;
    NSNumber* _discountAllowedNumber;
    
    UIButton* numBtn1;
    UIButton* numBtn2;
    UIButton* numBtn3;
    UIButton* numBtn4;
    UIButton* numBtn5;
    UIButton* numBtn6;
    UIButton* numBtn7;
    UIButton* numBtn8;
    UIButton* numBtn9;
    UIButton* numBtn10;
    UIButton* numBtn12;
    UIButton* numBtn15;
    UIButton* numBtn20;
    UIButton* numBtn24;
    UIButton* numBtn36;
    UITextField* _productCodeTextField;
    UIButton* _productCodeBtn;
    UILabel* _inStockTitle;
    UILabel* _inStockValue;
}

@property(nonatomic, retain) IBOutlet UIButton* qtyBtn;
@property(nonatomic, retain) IBOutlet UIButton* bonBtn;
@property(nonatomic, retain) IBOutlet UIButton* spQtyBtn;
@property(nonatomic, retain) IBOutlet UIButton* spBonBtn;
@property(nonatomic, retain) IBOutlet UIButton* discBtn;
@property(nonatomic, retain) IBOutlet UIButton* otherBtn;
@property(nonatomic, assign) id<NumberInputPadViewDelegate> funcDelegate;
@property(nonatomic, retain) UIButton* selectedFuncBtn;
@property(nonatomic, retain) NSMutableArray* funcBtnList;
@property(nonatomic, retain) UIColor* selectedFuncBtnColor;
@property(nonatomic,assign) BOOL showSeparator;
@property(nonatomic, retain) NSNumber* discountAllowedNumber;

@property(nonatomic, retain) IBOutlet UIButton* numBtn1;
@property(nonatomic, retain) IBOutlet UIButton* numBtn2;
@property(nonatomic, retain) IBOutlet UIButton* numBtn3;
@property(nonatomic, retain) IBOutlet UIButton* numBtn4;
@property(nonatomic, retain) IBOutlet UIButton* numBtn5;
@property(nonatomic, retain) IBOutlet UIButton* numBtn6;
@property(nonatomic, retain) IBOutlet UIButton* numBtn7;
@property(nonatomic, retain) IBOutlet UIButton* numBtn8;
@property(nonatomic, retain) IBOutlet UIButton* numBtn9;
@property(nonatomic, retain) IBOutlet UIButton* numBtn10;
@property(nonatomic, retain) IBOutlet UIButton* numBtn12;
@property(nonatomic, retain) IBOutlet UIButton* numBtn15;
@property(nonatomic, retain) IBOutlet UIButton* numBtn20;
@property(nonatomic, retain) IBOutlet UIButton* numBtn24;
@property(nonatomic, retain) IBOutlet UIButton* numBtn36;

@property(nonatomic, retain) IBOutlet UITextField* productCodeTextField;
@property(nonatomic, retain) IBOutlet UIButton* productCodeBtn;
@property(nonatomic, retain) IBOutlet UILabel* inStockTitle;
@property(nonatomic, retain) IBOutlet UILabel* inStockValue;

- (IBAction)pressFuncBtn:(id)sender;
- (IBAction)pressNumberBtn:(id)sender;
- (void)resetFuncBtn;
- (IBAction)pressOtherBtn:(id)sender;
- (void)configDiscountBonusStatus:(BOOL)aDiscountAllowedFlag;
- (void)configSplitPackBtnStatus:(BOOL)aShowSeparator;
- (void)configToShowInStock;
- (void)configSplitPackBtnByRecordInStockRB;
- (IBAction)pressSearchBtn:(id)sender;

@end

@protocol NumberInputPadViewDelegate <NSObject>

- (void)numberInputPadWithFuncBtn:(UIButton*)aFuncBtn;
- (void)numberInputPadWithNumberBtn:(UIButton*)aNumberBtn funcBtn:(UIButton*)aFuncBtn;
- (void)numberInputPadWithOtherBtn;
- (void)numberInputPadWithSearchBtn:(NSString*)aKeyword;

@end
