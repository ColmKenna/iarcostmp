//
//  OrderProductDetailModelViewController.h
//  Arcos
//
//  Created by David Kilmartin on 20/07/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelViewDelegate.h"

@interface OrderProductDetailModelViewController : UIViewController<UIPickerViewDelegate> {
    IBOutlet UILabel* name;
    IBOutlet UILabel* price;
    IBOutlet UILabel* value;
    IBOutlet UILabel* qty;
    IBOutlet UILabel* discount;
    IBOutlet UILabel* bonus;
    IBOutlet UILabel* point;
    
    IBOutlet UITextField* qtyInput;
    IBOutlet UITextField* discountInput;
    IBOutlet UITextField* bonusInput;
    IBOutlet UITextField* pointInput;
    
    IBOutlet UIButton* save;
    IBOutlet UIButton* dismiss;

    BOOL isViewEditable;
    NSMutableDictionary* theData;
    
    id<ModelViewDelegate> delegate;
    
    //picker
    IBOutlet UIView* pickerParentView;
    IBOutlet UIPickerView* picker;
    NSMutableDictionary* pickerData;
    BOOL needPicker;
    IBOutlet UIButton* showPickerBut;
}
@property(nonatomic,retain)IBOutlet UILabel* name;
@property(nonatomic,retain)IBOutlet UILabel* price;
@property(nonatomic,retain)IBOutlet UILabel* value;
@property(nonatomic,retain)IBOutlet UILabel* qty;
@property(nonatomic,retain)IBOutlet UILabel* discount;
@property(nonatomic,retain)IBOutlet UILabel* bonus;
@property(nonatomic,retain)IBOutlet UILabel* point;

@property(nonatomic,retain)IBOutlet UITextField* qtyInput;
@property(nonatomic,retain)IBOutlet UITextField* discountInput;
@property(nonatomic,retain)IBOutlet UITextField* bonusInput;
@property(nonatomic,retain)IBOutlet UITextField* pointInput;

@property(nonatomic,retain)IBOutlet UIButton* save;
@property(nonatomic,retain)IBOutlet UIButton* dismiss;

@property(nonatomic,assign) BOOL isViewEditable;
@property(nonatomic,retain)    NSMutableDictionary* theData;

@property (nonatomic, assign) id<ModelViewDelegate> delegate;

//picker
@property (nonatomic, retain) IBOutlet UIView* pickerParentView;
@property (nonatomic, retain) IBOutlet UIPickerView* picker;
@property (nonatomic, retain) NSMutableDictionary* pickerData;
@property (nonatomic, retain) IBOutlet UIButton* showPickerBut;


-(IBAction)saveLine:(id)sender;
-(IBAction)dismissView:(id)sender;
-(IBAction)showPicker:(id)sender;
-(void)needShowPicker:(BOOL)need;
-(void)showEditInput:(BOOL)show;

@end
