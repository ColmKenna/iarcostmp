//
//  ActivateEnterpriseViewController.h
//  Arcos
//
//  Created by David Kilmartin on 22/04/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PresentViewControllerDelegate.h"
#import "ActivateEnterpriseActionDelegate.h"
#import "ArcosUtils.h"
#import "SettingManager.h"
#import "CallGenericServices.h"
#import "ActivateEnterpriseDataManager.h"
#import "ActivateAppStatusManager.h"
#import "ArcosCoreData.h"
#import "ArcosValidator.h"
#import "ActivateConfigurationDataManager.h"
typedef enum {
    EnterpriseRequestSourceRegister = 0,
    EnterpriseRequestSourceSwitch
} EnterpriseRequestSource;


@interface ActivateEnterpriseViewController : UIViewController <UITextFieldDelegate, AsyncWebConnectionDelegate, UIAlertViewDelegate> {
    id<ActivateEnterpriseActionDelegate> _actionDelegate;
    id<PresentViewControllerDelegate> _presentDelegate;
    EnterpriseRequestSource _enterpriseRequestSource;
    UITextField* _firstRegCode;
//    UITextField* _secondRegCode;
//    UITextField* _thirdRegCode;
    UITextField* _fourthRegCode;
    UITextField* _accessCode;
    UIButton* _activationBtn;
    UIButton* _validationBtn;
    UIImageView* _tickImageView;
    UILabel* _statusLabel;
    CallGenericServices* _callGenericServices;
    ActivateEnterpriseDataManager* _activateEnterpriseDataManager;
    
    UILabel* _regCodeTitleLabel;
    UILabel* _accessCodeTitleLabel;
    UILabel* _statusTitleLabel;
//    UILabel* _firstHyphenLabel;
//    UILabel* _secondHyphenLabel;
    UILabel* _thirdHyphenLabel;
    UIScrollView* _templateScrollView;
    UIView* _templateUIView;
    UIView* _boardView;
    UIImageView* _backgroundImageView;
    UIView* _backButtonTemplateView;
    UIActivityIndicatorView* _myActivityIndicatorView;
    UIActivityIndicatorView* _activateActivityIndicatorView;
    ActivateConfigurationDataManager* _activateConfigurationDataManager;
    ArcosService* _myArcosService;
}

@property(nonatomic, assign) id<ActivateEnterpriseActionDelegate> actionDelegate;
@property(nonatomic, assign) id<PresentViewControllerDelegate> presentDelegate;
@property(nonatomic, assign) EnterpriseRequestSource enterpriseRequestSource;
@property(nonatomic, retain) IBOutlet UITextField* firstRegCode;
//@property(nonatomic, retain) IBOutlet UITextField* secondRegCode;
//@property(nonatomic, retain) IBOutlet UITextField* thirdRegCode;
@property(nonatomic, retain) IBOutlet UITextField* fourthRegCode;
@property(nonatomic, retain) IBOutlet UITextField* accessCode;
@property(nonatomic, retain) IBOutlet UIButton* activationBtn;
@property(nonatomic, retain) IBOutlet UIButton* validationBtn;
@property(nonatomic, retain) IBOutlet UIImageView* tickImageView;
@property(nonatomic, retain) IBOutlet UILabel* statusLabel;
@property(nonatomic, retain) CallGenericServices* callGenericServices;
@property(nonatomic, retain) ActivateEnterpriseDataManager* activateEnterpriseDataManager;

@property(nonatomic, retain) IBOutlet UILabel* regCodeTitleLabel;
@property(nonatomic, retain) IBOutlet UILabel* accessCodeTitleLabel;
@property(nonatomic, retain) IBOutlet UILabel* statusTitleLabel;
//@property(nonatomic, retain) IBOutlet UILabel* firstHyphenLabel;
//@property(nonatomic, retain) IBOutlet UILabel* secondHyphenLabel;
@property(nonatomic, retain) IBOutlet UILabel* thirdHyphenLabel;

@property(nonatomic, retain) IBOutlet UIScrollView* templateScrollView;
@property(nonatomic, retain) IBOutlet UIView* templateUIView;
@property(nonatomic, retain) IBOutlet UIView* boardView;
@property(nonatomic, retain) IBOutlet UIImageView* backgroundImageView;
@property(nonatomic, retain) IBOutlet UIView* backButtonTemplateView;
@property(nonatomic, retain) IBOutlet UIActivityIndicatorView* myActivityIndicatorView;
@property(nonatomic, retain) IBOutlet UIActivityIndicatorView* activateActivityIndicatorView;
@property(nonatomic, retain) ActivateConfigurationDataManager* activateConfigurationDataManager;
@property(nonatomic, retain) ArcosService* myArcosService;

- (IBAction)validateRegCode:(id)sender;
- (IBAction)validateAccessCode:(id)sender;
- (IBAction)backPressed:(id)sender;
- (IBAction)enterPressed:(id)sender;
- (IBAction)createData:(id)sender;
- (IBAction)accessCodeData:(id)sender;

@end
