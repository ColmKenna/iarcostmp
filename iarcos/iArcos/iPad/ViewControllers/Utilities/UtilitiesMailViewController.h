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

@interface UtilitiesMailViewController : UIViewController <ModalPresentViewControllerDelegate>{
    id<CustomisePresentViewControllerDelegate> _presentDelegate;
    NSArray* _kScopes;
    MSALWebviewParameters* _webViewParameters;
    UITextView* _myTextView;
}

@property(nonatomic, assign) id<CustomisePresentViewControllerDelegate> presentDelegate;
@property(nonatomic, retain) NSArray* kScopes;
@property(nonatomic, retain) MSALWebviewParameters* webViewParameters;
@property(nonatomic, retain) IBOutlet UITextView* myTextView;

@end

