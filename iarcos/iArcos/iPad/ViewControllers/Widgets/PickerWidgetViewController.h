//
//  PickerWidgetViewController.h
//  Arcos
//
//  Created by David Kilmartin on 29/07/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WidgetViewController.h"
#import "ArcosCoreData.h"
#import "GenericRefreshParentContentDelegate.h"
#import "ModelViewDelegate.h"
#import "AccountNumberWrapperViewController.h"
#import "CustomisePresentViewControllerDelegate.h"
typedef enum {
    PickerOrderStatusType=0,
    PickerOrderWholesalerType,
    PickerOrderType,
    PickerCallType,
    PickerContactType,
    PickerLocationType,
    PickerSettingContactType,
    PickerFormType,
    PickerMemoType,
    PickerDetailingType,
    PickerDetailingBatchType,
    PickerTitleType,
    PickerCustomerSurvey,
    PickerExpenseType
} PickerWidgetType;

@interface PickerWidgetViewController : WidgetViewController<UIPickerViewDelegate, ModelViewDelegate, GenericRefreshParentContentDelegate, CustomisePresentViewControllerDelegate> {
    PickerWidgetType type;
    IBOutlet UIPickerView* picker;
    
    NSMutableArray* pickerData;
    
    id tempData;
    NSNumber* _defaultIURValue;
    NSString* _customiseNavigationBarTitle;
    UINavigationItem* _customiseNavagationItem;
    NSMutableDictionary* _miscDataDict;
    UIButton* _bottomButton;
    UINavigationBar* _myNavigationBar;
    
    UINavigationController* _globalNavigationController;
    UIViewController* _myRootViewController;
    BOOL _dynamicWidthFlag;
    int _maxTextLength;
}
@property(nonatomic,assign) PickerWidgetType type;
@property(nonatomic,retain) IBOutlet  UIPickerView* picker;
@property(nonatomic,retain) NSMutableArray* pickerData;
@property(nonatomic,retain)    id tempData;
@property(nonatomic,retain) NSNumber* defaultIURValue;
@property(nonatomic,retain) NSString* customiseNavigationBarTitle;
@property(nonatomic,retain) IBOutlet UINavigationItem* customiseNavagationItem;
@property(nonatomic,retain) NSMutableDictionary* miscDataDict;
@property(nonatomic,retain) IBOutlet UIButton* bottomButton;
@property(nonatomic,retain) IBOutlet UINavigationBar* myNavigationBar;

@property(nonatomic,retain) UINavigationController* globalNavigationController;
@property(nonatomic,retain) UIViewController* myRootViewController;
@property(nonatomic,assign) BOOL dynamicWidthFlag;
@property(nonatomic,assign) int maxTextLength;

-(id)initWithType:(PickerWidgetType)aType;
-(void)resetPickerData;
-(id)initWithType:(PickerWidgetType)aType pickerDefaultValue:(NSNumber*)aDefaultIURValue;
-(id)initWithPickerValue:(NSMutableArray*)aPickerValue;
-(id)initWithPickerValue:(NSMutableArray*)aPickerValue title:(NSString*)aTitle;
-(id)initWithPickerValue:(NSMutableArray*)aPickerValue miscDataDict:(NSMutableDictionary*)aDataDict delegate:(id<WidgetViewControllerDelegate>)aDelegate;
@end
