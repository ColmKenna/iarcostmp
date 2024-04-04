//
//  CustomerJourneyDetailDateViewController.h
//  iArcos
//
//  Created by Richard on 02/04/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerJourneyDetailDateViewControllerDelegate.h"
#import "ArcosUtils.h"
#import "CustomerJourneyDetailDateDataManager.h"
#import "CallGenericServices.h"

@interface CustomerJourneyDetailDateViewController : UIViewController <UIPickerViewDelegate, GetDataGenericDelegate>{
    id<CustomerJourneyDetailDateViewControllerDelegate> _actionDelegate;
    UIView* _templateView;
    UINavigationBar* _myNavigationBar;
    UIPickerView* _myPickerView;
    UIButton* _saveButton;
    UIButton* _cancelButton;
    CustomerJourneyDetailDateDataManager* _customerJourneyDetailDateDataManager;
    CallGenericServices* _callGenericServices;
}

@property(nonatomic, assign) id<CustomerJourneyDetailDateViewControllerDelegate> actionDelegate;
@property(nonatomic, retain) IBOutlet UIView* templateView;
@property(nonatomic, retain) IBOutlet UINavigationBar* myNavigationBar;
@property(nonatomic, retain) IBOutlet UIPickerView* myPickerView;
@property(nonatomic, retain) IBOutlet UIButton* saveButton;
@property(nonatomic, retain) IBOutlet UIButton* cancelButton;
@property(nonatomic, retain) CustomerJourneyDetailDateDataManager* customerJourneyDetailDateDataManager;
@property(nonatomic, retain) CallGenericServices* callGenericServices;

- (IBAction)saveButtonPressed:(id)sender;
- (IBAction)cancelButtonPressed:(id)sender;

@end


