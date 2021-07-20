//
//  OrderInputPadViewController.h
//  Arcos
//
//  Created by David Kilmartin on 28/07/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WidgetViewController.h"
#import "ArcosUtils.h"
#import "ProductFormRowConverter.h"
#import "OrderInputPadDataManager.h"
#import "LeftBorderUILabel.h"
#import "LeftBoldColorBorderUILabel.h"
#import "BottomBorderUILabel.h"
#import "ArcosErrorResult.h"
#import "PriceChangeTableViewController.h"
#import "TopBorderUILabel.h"
#import "ArcosMyResult.h"
@protocol OrderInputPadViewControllerDelegate 

@optional
-(void)orderInputDone:(NSMutableDictionary*)values;
@end

@interface OrderInputPadViewController : WidgetViewController<UITextFieldDelegate, UIPopoverPresentationControllerDelegate, PriceChangeTableViewControllerDelegate> {
    IBOutlet UITextField* QTYField;
    IBOutlet UITextField* BonusField;
    IBOutlet UITextField* DiscountField;
    IBOutlet UITextField* ValueField;
    UITextField* _currentTextField;
    IBOutlet UILabel* productName;
    IBOutlet UINavigationBar* bar;
    UILabel* _unitPriceTitleLabel;
    UITextField* _unitPriceField;
    IBOutlet UILabel* unitPrice;
    
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
//    UIButton* _dotButton;
    UIButton* _deleteButton;
    UIButton* _clearButton;
    UIButton* _doneButton;
    IBOutlet UIButton* dotButton;
    
    //labels
    UILabel* _qtyLabel;
    IBOutlet UILabel* BonusLabel;
    IBOutlet UILabel* DiscountLabel;
    UILabel* _valueLabel;
    
    BOOL isDetaillingType;
    IBOutlet UITextField* InStockField;//Qty SplitPack UnitPerPack
    IBOutlet UITextField* FOCField;//Bonus SplitPack UnitPerPack 
    BOOL _showSeparator;
//    NSNumber* _locationIUR;
    OrderInputPadDataManager* _orderInputPadDataManager;
    UILabel* _qtyHeader;
    UILabel* _bonHeader;
    LeftBorderUILabel* _leftDivider;
    LeftBoldColorBorderUILabel* _sectionDivider;
    
    UILabel* _mon25;
    UILabel* _mon24;
    UILabel* _mon23;
    UILabel* _mon22;
    UILabel* _mon21;
    UILabel* _mon20;
    UILabel* _mon19;
    UILabel* _mon18;
    UILabel* _mon17;
    UILabel* _mon16;
    UILabel* _mon15;
    UILabel* _mon14;
    UILabel* _mon13;
    
    BottomBorderUILabel* _qty25;
    BottomBorderUILabel* _qty24;
    BottomBorderUILabel* _qty23;
    BottomBorderUILabel* _qty22;
    BottomBorderUILabel* _qty21;
    BottomBorderUILabel* _qty20;
    BottomBorderUILabel* _qty19;
    BottomBorderUILabel* _qty18;
    BottomBorderUILabel* _qty17;
    BottomBorderUILabel* _qty16;
    BottomBorderUILabel* _qty15;
    BottomBorderUILabel* _qty14;
    BottomBorderUILabel* _qty13;
    
    BottomBorderUILabel* _bonus25;
    BottomBorderUILabel* _bonus24;
    BottomBorderUILabel* _bonus23;
    BottomBorderUILabel* _bonus22;
    BottomBorderUILabel* _bonus21;
    BottomBorderUILabel* _bonus20;
    BottomBorderUILabel* _bonus19;
    BottomBorderUILabel* _bonus18;
    BottomBorderUILabel* _bonus17;
    BottomBorderUILabel* _bonus16;
    BottomBorderUILabel* _bonus15;
    BottomBorderUILabel* _bonus14;
    BottomBorderUILabel* _bonus13;
    
    UILabel* _instockRBLabel;
    UITextField* _instockRBTextField;
    NSMutableDictionary* _vansOrderHeader;
    UIButton* _priceChangeButton;
    UINavigationController* _globalNavigationController;
    NSMutableDictionary* _bonusDealResultDict;
    NSNumber* _originalDiscountPercent;
    BottomBorderUILabel* _bottomDivider;
    UILabel* _bonusDealContentInterpreter;
    NSDictionary* _relatedFormDetailDict;
    ArcosMyResult* _arcosMyResult;
}
@property(nonatomic,retain) IBOutlet UITextField* QTYField;
@property(nonatomic,retain) IBOutlet UITextField* BonusField;
@property(nonatomic,retain) IBOutlet UITextField* DiscountField;

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
//@property(nonatomic, retain) IBOutlet UIButton* dotButton;
@property(nonatomic, retain) IBOutlet UIButton* deleteButton;
@property(nonatomic, retain) IBOutlet UIButton* clearButton;
@property(nonatomic, retain) IBOutlet UIButton* doneButton;
@property(nonatomic,retain) IBOutlet UIButton* dotButton;

@property(nonatomic,retain)     IBOutlet UITextField* ValueField;
@property(nonatomic,retain) UITextField* currentTextField;
@property(nonatomic,retain)     IBOutlet UILabel* productName;
@property(nonatomic,retain)     IBOutlet UINavigationBar* bar;
@property(nonatomic,retain) IBOutlet UILabel* unitPriceTitleLabel;
@property(nonatomic,retain) IBOutlet UITextField* unitPriceField;
@property(nonatomic,retain)    IBOutlet UILabel* unitPrice;

//labels
@property(nonatomic,retain) IBOutlet UILabel* qtyLabel;
@property(nonatomic,retain) IBOutlet UILabel* BonusLabel;
@property(nonatomic,retain) IBOutlet UILabel* DiscountLabel;
@property(nonatomic,retain) IBOutlet UILabel* valueLabel;

@property(nonatomic,assign)  BOOL isDetaillingType;
@property(nonatomic,retain) IBOutlet UITextField* InStockField;
@property(nonatomic,retain) IBOutlet UITextField* FOCField;
@property(nonatomic,assign) BOOL showSeparator;
//@property(nonatomic,retain) NSNumber* locationIUR;
@property(nonatomic,retain) OrderInputPadDataManager* orderInputPadDataManager;
@property(nonatomic,retain) IBOutlet UILabel* qtyHeader;
@property(nonatomic,retain) IBOutlet UILabel* bonHeader;
@property(nonatomic,retain) IBOutlet LeftBorderUILabel* leftDivider;
@property(nonatomic,retain) IBOutlet LeftBoldColorBorderUILabel* sectionDivider;
@property(nonatomic,retain) IBOutlet UILabel* mon25;
@property(nonatomic,retain) IBOutlet UILabel* mon24;
@property(nonatomic,retain) IBOutlet UILabel* mon23;
@property(nonatomic,retain) IBOutlet UILabel* mon22;
@property(nonatomic,retain) IBOutlet UILabel* mon21;
@property(nonatomic,retain) IBOutlet UILabel* mon20;
@property(nonatomic,retain) IBOutlet UILabel* mon19;
@property(nonatomic,retain) IBOutlet UILabel* mon18;
@property(nonatomic,retain) IBOutlet UILabel* mon17;
@property(nonatomic,retain) IBOutlet UILabel* mon16;
@property(nonatomic,retain) IBOutlet UILabel* mon15;
@property(nonatomic,retain) IBOutlet UILabel* mon14;
@property(nonatomic,retain) IBOutlet UILabel* mon13;

@property(nonatomic,retain) IBOutlet BottomBorderUILabel* qty25;
@property(nonatomic,retain) IBOutlet BottomBorderUILabel* qty24;
@property(nonatomic,retain) IBOutlet BottomBorderUILabel* qty23;
@property(nonatomic,retain) IBOutlet BottomBorderUILabel* qty22;
@property(nonatomic,retain) IBOutlet BottomBorderUILabel* qty21;
@property(nonatomic,retain) IBOutlet BottomBorderUILabel* qty20;
@property(nonatomic,retain) IBOutlet BottomBorderUILabel* qty19;
@property(nonatomic,retain) IBOutlet BottomBorderUILabel* qty18;
@property(nonatomic,retain) IBOutlet BottomBorderUILabel* qty17;
@property(nonatomic,retain) IBOutlet BottomBorderUILabel* qty16;
@property(nonatomic,retain) IBOutlet BottomBorderUILabel* qty15;
@property(nonatomic,retain) IBOutlet BottomBorderUILabel* qty14;
@property(nonatomic,retain) IBOutlet BottomBorderUILabel* qty13;

@property(nonatomic,retain) IBOutlet BottomBorderUILabel* bonus25;
@property(nonatomic,retain) IBOutlet BottomBorderUILabel* bonus24;
@property(nonatomic,retain) IBOutlet BottomBorderUILabel* bonus23;
@property(nonatomic,retain) IBOutlet BottomBorderUILabel* bonus22;
@property(nonatomic,retain) IBOutlet BottomBorderUILabel* bonus21;
@property(nonatomic,retain) IBOutlet BottomBorderUILabel* bonus20;
@property(nonatomic,retain) IBOutlet BottomBorderUILabel* bonus19;
@property(nonatomic,retain) IBOutlet BottomBorderUILabel* bonus18;
@property(nonatomic,retain) IBOutlet BottomBorderUILabel* bonus17;
@property(nonatomic,retain) IBOutlet BottomBorderUILabel* bonus16;
@property(nonatomic,retain) IBOutlet BottomBorderUILabel* bonus15;
@property(nonatomic,retain) IBOutlet BottomBorderUILabel* bonus14;
@property(nonatomic,retain) IBOutlet BottomBorderUILabel* bonus13;

@property(nonatomic,retain) IBOutlet UILabel* instockRBLabel;
@property(nonatomic,retain) IBOutlet UITextField* instockRBTextField;
@property(nonatomic,retain) NSMutableDictionary* vansOrderHeader;
@property(nonatomic,retain) IBOutlet UIButton* priceChangeButton;
@property(nonatomic,retain) UINavigationController* globalNavigationController;
@property(nonatomic,retain) NSMutableDictionary* bonusDealResultDict;
@property(nonatomic,retain) NSNumber* originalDiscountPercent;
@property(nonatomic,retain) IBOutlet BottomBorderUILabel* bottomDivider;
@property(nonatomic,retain) IBOutlet UILabel* bonusDealContentInterpreter;
@property(nonatomic,retain) NSDictionary* relatedFormDetailDict;
@property(nonatomic,retain) ArcosMyResult* arcosMyResult;

-(IBAction)textFieldTouched:(id)sender;
-(IBAction)numberKeyTouched:(id)sender;
-(IBAction)functionKeyTouched:(id)sender;
- (IBAction)priceChangeButtonPressed:(id)sender;

-(void)highlightSelectField;
- (ArcosErrorResult*)productCheckProcedure;
- (NSMutableDictionary*)interpretBonusDeal:(NSString*)aBonusDeal;
- (void)checkQtyByBonusDeal;
- (BOOL)enterQtyFoundProcessor:(int)auxQuantity;
@end
