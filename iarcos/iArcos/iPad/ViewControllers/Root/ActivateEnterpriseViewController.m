//
//  ActivateEnterpriseViewController.m
//  Arcos
//
//  Created by David Kilmartin on 22/04/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "ActivateEnterpriseViewController.h"
#import "ArcosRootViewController.h"

@interface ActivateEnterpriseViewController ()
- (void)layoutMySubviews;
@end

@implementation ActivateEnterpriseViewController
@synthesize actionDelegate = _actionDelegate;
@synthesize presentDelegate = _presentDelegate;
@synthesize enterpriseRequestSource = _enterpriseRequestSource;
@synthesize firstRegCode = _firstRegCode;
//@synthesize secondRegCode = _secondRegCode;
//@synthesize thirdRegCode = _thirdRegCode;
@synthesize fourthRegCode = _fourthRegCode;
@synthesize accessCode = _accessCode;
@synthesize activationBtn = _activationBtn;
@synthesize validationBtn = _validationBtn;
@synthesize tickImageView = _tickImageView;
@synthesize statusLabel = _statusLabel;
@synthesize callGenericServices = _callGenericServices;

@synthesize activateEnterpriseDataManager = _activateEnterpriseDataManager;

@synthesize regCodeTitleLabel = _regCodeTitleLabel;
@synthesize accessCodeTitleLabel = _accessCodeTitleLabel;
@synthesize statusTitleLabel = _statusTitleLabel;
//@synthesize firstHyphenLabel = _firstHyphenLabel;
//@synthesize secondHyphenLabel = _secondHyphenLabel;
@synthesize thirdHyphenLabel = _thirdHyphenLabel;
@synthesize templateScrollView = _templateScrollView;
@synthesize templateUIView = _templateUIView;
@synthesize boardView = _boardView;
@synthesize backgroundImageView = _backgroundImageView;
@synthesize backButtonTemplateView = _backButtonTemplateView;
@synthesize myActivityIndicatorView = _myActivityIndicatorView;
@synthesize activateActivityIndicatorView = _activateActivityIndicatorView;
@synthesize activateConfigurationDataManager = _activateConfigurationDataManager;
@synthesize myArcosService = _myArcosService;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.enterpriseRequestSource = EnterpriseRequestSourceRegister;
    }
    return self;
}

- (void)dealloc {
    self.firstRegCode = nil;
//    self.secondRegCode = nil;
//    self.thirdRegCode = nil;
    self.fourthRegCode = nil;
    self.accessCode = nil;
    self.activationBtn = nil;
    self.validationBtn = nil;
    self.tickImageView = nil;
    self.statusLabel = nil;
    self.callGenericServices = nil;

    self.activateEnterpriseDataManager = nil;
    
    self.regCodeTitleLabel = nil;
    self.accessCodeTitleLabel = nil;
    self.statusTitleLabel = nil;
//    self.firstHyphenLabel = nil;
//    self.secondHyphenLabel = nil;
    self.thirdHyphenLabel = nil;
    self.templateScrollView = nil;
    self.templateUIView = nil;
    self.boardView = nil;
    self.backgroundImageView = nil;
    self.backButtonTemplateView = nil;
    self.myActivityIndicatorView = nil;
    self.activateActivityIndicatorView = nil;
    self.activateConfigurationDataManager = nil;
    self.myArcosService = nil;
    for (UIGestureRecognizer* recognizer in self.firstRegCode.gestureRecognizers) {
        [self.firstRegCode removeGestureRecognizer:recognizer];
    }
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [ArcosUtils configEdgesForExtendedLayout:self];
    self.navigationController.navigationBar.hidden = YES;
    self.activateEnterpriseDataManager = [[[ActivateEnterpriseDataManager alloc] init] autorelease];
    self.activateEnterpriseDataManager.asyncDelegate = self;
    self.accessCode.enabled = NO;
    self.activationBtn.enabled = NO;
    self.activateConfigurationDataManager = [ActivateConfigurationDataManager configInstance];
    UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapGesture:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.firstRegCode addGestureRecognizer:doubleTap];
    [doubleTap release];
}

- (void)handleDoubleTapGesture:(id)aSender {
    UITapGestureRecognizer* recognizer = (UITapGestureRecognizer*)aSender;
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        self.firstRegCode.text = @"https://arcosaws.iarcos.com";
        self.fourthRegCode.text = @"1060";
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.templateUIView.center = self.boardView.center;
    [self layoutMySubviews];
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        self.backgroundImageView.image = [UIImage imageNamed:@"ArcosLandscape.png"];
    } else {
        self.backgroundImageView.image = [UIImage imageNamed:@"ArcosPortrait.png"];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    self.templateUIView.center = self.boardView.center;
    [self layoutMySubviews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
//    self.templateUIView.center = self.boardView.center;
    [self layoutMySubviews];
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        self.backgroundImageView.image = [UIImage imageNamed:@"ArcosLandscape.png"];
    } else {
        self.backgroundImageView.image = [UIImage imageNamed:@"ArcosPortrait.png"];
    }
}

- (IBAction)validateRegCode:(id)sender {
//    self.statusLabel.text = @"Start the validation process...";
    [self.view endEditing:YES];
    self.tickImageView.hidden = YES;
    self.validationBtn.enabled = NO;
    NSString* firstRegCodeText = self.firstRegCode.text;
//    NSString* secondRegCodeText = self.secondRegCode.text;
//    NSString* thirdRegCodeText = self.thirdRegCode.text;
    NSString* fourthRegCodeText = self.fourthRegCode.text;
//    if (firstRegCodeText.length <= 0) {
//        NSString* errorMsg = @"The first part of the registration code should not be blank";
//        [ArcosUtils showDialogBox:errorMsg title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
//            
//        }];
//        self.validationBtn.enabled = YES;
//        return;
//    }
    if (fourthRegCodeText.length != 4) {
        NSString* errorMsg = @"The second part of the URL should be four digit numbers";
        [ArcosUtils showDialogBox:errorMsg title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
        self.validationBtn.enabled = YES;
        return;
    }
    self.myActivityIndicatorView.hidden = NO;
    [self.myActivityIndicatorView startAnimating];
//    NSString* regCodeText = [NSString stringWithFormat:@"%@%@%@%@",firstRegCodeText, secondRegCodeText, thirdRegCodeText, fourthRegCodeText];
//    NSNumber* firstIPCode = [ArcosUtils convertStringToNumber:[regCodeText substringWithRange:NSMakeRange(0, 3)]];
//    NSNumber* secondIPCode = [ArcosUtils convertStringToNumber:[regCodeText substringWithRange:NSMakeRange(3, 3)]];
//    NSNumber* thirdIPCode = [ArcosUtils convertStringToNumber:[regCodeText substringWithRange:NSMakeRange(6, 3)]];
//    NSNumber* fourthIPCode = [ArcosUtils convertStringToNumber:[regCodeText substringWithRange:NSMakeRange(9, 3)]];
//    NSNumber* portIPCode = [ArcosUtils convertStringToNumber:[regCodeText substringWithRange:NSMakeRange(12, 4)]];
    NSString* serviceAddress = [NSString stringWithFormat:@"%@:%@/service.asmx", firstRegCodeText, fourthRegCodeText];
    self.activateEnterpriseDataManager.serviceAddress = serviceAddress;
    [self.activateEnterpriseDataManager validateRegCode:serviceAddress];
}

- (IBAction)validateAccessCode:(id)sender {
    self.activationBtn.enabled = NO;
//    self.statusLabel.text = @"Start the activation process...";
    [self.view endEditing:YES];
    NSString* accessCodeText = self.accessCode.text;
    NSNumber* employeeIURNumber = nil;
    NSRange rng = [accessCodeText rangeOfString:@"-"];
    NSString* errorMsg = @"Invalid Code";
    if (rng.location == NSNotFound) {
        [ArcosUtils showDialogBox:errorMsg title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
//        self.statusLabel.text = errorMsg;
        self.activationBtn.enabled = YES;
        return;
    }
    NSArray* accessCodeArray = [accessCodeText componentsSeparatedByString:@"-"];
    NSString* sqlName = [ArcosUtils trim:[accessCodeArray objectAtIndex:0]];
    NSString* employeeIUR = [ArcosUtils trim:[accessCodeArray objectAtIndex:1]];
    if (sqlName.length == 0 || employeeIUR.length == 0 || ![ArcosValidator isInteger:employeeIUR]) {
        [ArcosUtils showDialogBox:errorMsg title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
//        self.statusLabel.text = errorMsg;
        self.activationBtn.enabled = YES;
        return;
    }
    employeeIURNumber = [ArcosUtils convertStringToNumber:employeeIUR];
//    NSLog(@"employeeIURNumber: %@",employeeIURNumber);
    [self.activateActivityIndicatorView startAnimating];
    self.activateEnterpriseDataManager.sqlName = sqlName;
    self.activateEnterpriseDataManager.employeeIURNumber = employeeIURNumber;
    SettingManager* settingManager = [SettingManager setting];
    NSString* keyPath = @"CompanySetting.Connection";
    [settingManager updateSettingForKeypath:keyPath atIndex:3 withData:sqlName];
    
    NSString* secondKeyPath = @"PersonalSetting.Personal";
    [settingManager updateSettingForKeypath:secondKeyPath atIndex:0 withData:employeeIURNumber];
    [settingManager saveSetting];
    
    
    NSString* sqlStatement = [NSString stringWithFormat:@"select * from Employee where IUR = %@", employeeIURNumber];

    self.myArcosService = [ArcosService serviceWithUsername:@"u1103395_Support" andPassword:@"Strata411325"];
    [self.myArcosService GetData:self action:@selector(setGenericGetDataResult:) stateMent:sqlStatement];
}

#pragma mark - setGenericGetDataResult
-(void)setGenericGetDataResult:(ArcosGenericReturnObject*)result {
//    [self.callGenericServices.HUD hide:YES];
    BOOL callAvailable = NO;
    NSString* errorString = @"Code could not be validated";
    if (result != nil) {
        if ([result isKindOfClass:[NSError class]]) {
            callAvailable = NO;
        } else if([result isKindOfClass:[SoapFault class]]){
            callAvailable = NO;
        }else  {
            ArcosGenericReturnObject* objects = (ArcosGenericReturnObject*)result;
            if(objects.ErrorModel != nil) {
                if (objects.ErrorModel.Code < 0) {
                    callAvailable = NO;
                } else if(objects.ErrorModel.Code == 0) {
                    callAvailable = NO;
                }else {
                    callAvailable = YES;
                }
            }
        }
    }else{
        callAvailable = NO;
    }
    if (!callAvailable) {
        [self.activateActivityIndicatorView stopAnimating];
        [ArcosUtils showDialogBox:errorString title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
//        self.statusLabel.text = errorString;
        self.activationBtn.enabled = YES;
    } else {
//        self.statusLabel.text = @"Activation has completed.";
        [self.activateConfigurationDataManager createConfigurationPlist];
        NSString* sqlStatement = @"select Details, DescrDetailCode, Toggle1 from DescrDetail where DescrTypeCode = 'IO' and Active = 1 order by Details";
        [self.myArcosService GetData:self action:@selector(configurationGetDataResult:) stateMent:sqlStatement];
    }
}

- (IBAction)backPressed:(id)sender {
    if (self.enterpriseRequestSource == EnterpriseRequestSourceRegister) {
        [self.actionDelegate backActionDelegate];
    } else {
        [self.presentDelegate didDismissPresentView];
    }
}

- (IBAction)enterPressed:(id)sender {
    [self.presentDelegate didDismissPresentView];
}

- (IBAction)createData:(id)sender {
//    self.firstRegCode.text = @"0542";
//    self.secondRegCode.text = @"1724";
//    self.thirdRegCode.text = @"3161";
//    self.fourthRegCode.text = @"1056";
}

- (IBAction)accessCodeData:(id)sender {
    self.accessCode.text = @"lb99-1";
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    NSLog(@"%@, %@, %d, %d", textField.text, string, range.location, range.length);
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    NSCharacterSet *nonNumberSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
//    NSLog(@"newLength:%d", newLength);
    
    BOOL stringFlag = ([string stringByTrimmingCharactersInSet:nonNumberSet].length > 0) || [string isEqualToString:@""];
//    if (stringFlag && newLength == 4) {
//        [self performSelector:@selector(textFieldShouldReturn:) withObject:textField afterDelay:0.2];
//    }
    
    return stringFlag && newLength <= 4;
}

//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    if ([textField isEqual:self.firstRegCode]) {
//        [textField resignFirstResponder];
//        [self.secondRegCode becomeFirstResponder];
//    } else if ([textField isEqual:self.secondRegCode]) {
//        [textField resignFirstResponder];
//        [self.thirdRegCode becomeFirstResponder];
//    } else if ([textField isEqual:self.thirdRegCode]) {
//        [textField resignFirstResponder];
//        [self.fourthRegCode becomeFirstResponder];
//    }
//    return YES;
//}



#pragma mark AsyncWebConnectionDelegate
- (void)asyncConnectionResult:(BOOL)result {
    if (result) {
        self.myArcosService = [ArcosService serviceWithUsername:@"u1103395_Support" andPassword:@"Strata411325"];
        NSString* sqlStatement =@"select";
        [self.myArcosService GetData:self action:@selector(validateServiceResult:) stateMent:sqlStatement];
    }
}

- (void)asyncFailWithError:(NSError *)anError {
    [ArcosUtils showDialogBox:[anError localizedDescription] title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
        
    }];
    self.validationBtn.enabled = YES;
    [self.myActivityIndicatorView stopAnimating];
//    self.statusLabel.text = [anError localizedDescription];
}

- (void)validateServiceResult:(id)result {
    BOOL callAvailable = NO;
    NSString* errorString = @"";
    if (result != nil) {
        if ([result isKindOfClass:[NSError class]]) {
            NSError* anError = (NSError*)result;
            callAvailable = NO;
            errorString = [anError description];
        } else if([result isKindOfClass:[SoapFault class]]){
            SoapFault* anFault = (SoapFault*) result;
            callAvailable = NO;
            errorString = [anFault faultString];
        }else  {
            ArcosGenericReturnObject* objects = (ArcosGenericReturnObject*)result;
            if(objects.ErrorModel != nil){
                callAvailable = YES;
            } else {
                callAvailable = NO;
            }
        }
    } else {
        callAvailable = NO;
    }
    [self.myActivityIndicatorView stopAnimating];
    if (callAvailable) {
//        self.statusLabel.text = @"Validation has completed.";
        self.tickImageView.hidden = NO;
        self.activationBtn.enabled = YES;
        self.accessCode.enabled = YES;
        self.validationBtn.enabled = NO;
    } else {
        [ArcosUtils showDialogBox:errorString title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
        self.validationBtn.enabled = YES;
//        self.statusLabel.text = errorString;
    }
}

- (void)configurationGetDataResult:(id)result {
    BOOL configAvailable = NO;
    NSString* errorString = @"Configuration could not be validated";
    if (result != nil) {
        if ([result isKindOfClass:[NSError class]]) {
            configAvailable = NO;
        } else if([result isKindOfClass:[SoapFault class]]){
            configAvailable = NO;
        } else {
            ArcosGenericReturnObject* objects = (ArcosGenericReturnObject*)result;
            if(objects.ErrorModel != nil) {
                if (objects.ErrorModel.Code < 0) {
                    configAvailable = NO;
                } else {
                    configAvailable = YES;
                    [self.activateConfigurationDataManager populateConfigurationPlistWithData:[objects ArrayOfData]];
                }
            }
        }
    } else {
        configAvailable = NO;
    }
    if (!configAvailable) {
        [ArcosUtils showDialogBox:errorString title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
        self.activationBtn.enabled = YES;
    } else {
        ActivateAppStatusManager* activateAppStatusManager = [ActivateAppStatusManager appStatusInstance];
        
        switch (self.enterpriseRequestSource) {
            case EnterpriseRequestSourceRegister: {
                [activateAppStatusManager saveActivateAppStatus];
                ArcosRootViewController* myArcosRootViewController = (ArcosRootViewController*)[ArcosUtils getRootView];
                int itemIndex = [myArcosRootViewController.customerMasterViewController.customerMasterDataManager retrieveIndexByTitle:myArcosRootViewController.customerMasterViewController.customerMasterDataManager.utilitiesText];
                [myArcosRootViewController.customerMasterViewController selectCustomerMasterTopViewWithIndexPath:[NSIndexPath indexPathForRow:itemIndex inSection:0]];
                [myArcosRootViewController.customerMasterViewController createScanApiRelevantObject];
                NSString* myTmpMessage = @"Activation has completed. Please go to UpdateCenter to download data.";
                [ArcosUtils showDialogBox:myTmpMessage title:@"" delegate:self target:self tag:0 handler:^(UIAlertAction *action) {
                    [self.presentDelegate didDismissPresentView];
                }];
            }
                break;
            case EnterpriseRequestSourceSwitch: {
                self.backgroundImageView.alpha = 0.6;
                [[ArcosCoreData sharedArcosCoreData] clearAllTables];
                NSString* updateCenterSrcPath = [[NSBundle mainBundle] pathForResource:@"UpdateCenter" ofType:@"plist"];
                NSString* updateCenterDestPath = [FileCommon updateCenterPlistPath];
//                NSError* anError = nil;
                CompositeErrorResult* tmpCompositeErrorResult = [FileCommon testCopyItemAtPath:updateCenterSrcPath toPath:updateCenterDestPath];
                if (!tmpCompositeErrorResult.successFlag) {
                    [ArcosUtils showDialogBox:tmpCompositeErrorResult.errorMsg title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
                        
                    }];
                    return;
                }
                NSString* extendDefaultSettingDestPath = [[FileCommon documentsPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", @"setting/ExtendedDefaultSetting.plist"]];
                if ([FileCommon fileExistAtPath:extendDefaultSettingDestPath]) {
//                    NSError* tmpError = nil;
                    NSString* extendDefaultSettingSrcPath = [[NSBundle mainBundle] pathForResource:@"ExtendedDefaultSetting" ofType:@"plist"];
                    CompositeErrorResult* auxCompositeErrorResult = [FileCommon testCopyItemAtPath:extendDefaultSettingSrcPath toPath:extendDefaultSettingDestPath];
                    if (!auxCompositeErrorResult.successFlag) {
                        [ArcosUtils showDialogBox:auxCompositeErrorResult.errorMsg title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
                            
                        }];
                        return;
                    }
                }
                NSString* settingSrcPath = [[NSBundle mainBundle] pathForResource:@"defaultSetting" ofType:@"plist"];
                NSString* settingDescPath = [FileCommon settingFilePath];
//                NSError* settingError = nil;
                CompositeErrorResult* settingCompositeErrorResult  = [FileCommon testCopyItemAtPath:settingSrcPath toPath:settingDescPath];
                if (!settingCompositeErrorResult.successFlag) {
                    [ArcosUtils showDialogBox:settingCompositeErrorResult.errorMsg title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
                        
                    }];
                    return;
                }
                [self.activateEnterpriseDataManager updateServiceAddress];
                [self.activateEnterpriseDataManager updateSqlName];
                [self.activateEnterpriseDataManager updateEmployeeIURNumber];
                
                [FileCommon removeAllFileUnderPresenterPath];
                [activateAppStatusManager saveActivateAppStatus];
                NSString* message = @"Activation has completed. Please reboot the app and go to Utilities->UpdateCenter to download data.";
                if ([UIAlertController class]) {
                    UIAlertController* tmpDialogBox = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
                    [[ArcosUtils getRootView] presentViewController:tmpDialogBox animated:YES completion:nil];
                } else {
                    UIAlertView* myAlertView = [[[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles: nil, nil] autorelease];
                    [myAlertView show];
                }
            }
                break;
                
            default:
                break;
        }
    }
    [self.activateActivityIndicatorView stopAnimating];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.presentDelegate didDismissPresentView];
}

- (void)layoutMySubviews {
//    self.templateUIView.frame = CGRectMake(0.0, self.templateScrollView.frame.size.height / 2.0 - self.templateUIView.frame.size.height / 2.0, self.templateUIView.frame.size.width, self.templateUIView.frame.size.height);
}

@end
