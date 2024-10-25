//
//  UtilitiesMailViewController.h
//  iArcos
//
//  Created by Apple on 27/12/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModalPresentViewControllerDelegate.h"
#import "ArcosConstantsDataManager.h"
#import "GlobalSharedClass.h"
#import "UtilitiesSignOutViewController.h"
#import "CustomisePresentViewControllerDelegate.h"
//#import "UtilitiesDetailViewController.h"
#import "ArcosBorderUIButton.h"

@interface UtilitiesMailViewController : UIViewController <ModalPresentViewControllerDelegate>{
    id<CustomisePresentViewControllerDelegate> _presentDelegate;
//    NSArray* _kScopes;
    MSALWebviewParameters* _webViewParameters;
    ArcosBorderUIButton* _signInButton;
    ArcosBorderUIButton* _signOutButton;
//    UITextView* _myTextView;
    UILabel* _myLabel;
    ArcosBorderUIButton* _renewButton;
}

@property(nonatomic, assign) id<CustomisePresentViewControllerDelegate> presentDelegate;
//@property(nonatomic, retain) NSArray* kScopes;
@property(nonatomic, retain) MSALWebviewParameters* webViewParameters;
@property(nonatomic, retain) IBOutlet ArcosBorderUIButton* signInButton;
@property(nonatomic, retain) IBOutlet ArcosBorderUIButton* signOutButton;
//@property(nonatomic, retain) IBOutlet UITextView* myTextView;
@property(nonatomic, retain) IBOutlet UILabel* myLabel;
@property(nonatomic, retain) IBOutlet ArcosBorderUIButton* renewButton;

- (IBAction)signOutPressed:(id)sender;
- (IBAction)signInPressed:(id)sender;
- (IBAction)renewPressed:(id)sender;

@end

