//
//  CustomerPhotoSlideViewController.h
//  Arcos
//
//  Created by David Kilmartin on 13/02/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PresentViewControllerDelegate.h"
#import "CustomerPhotoSlideDataManager.h"
#import "EmailRecipientTableViewController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "CustomerPhotoDeleteActionViewController.h"
#import "ArcosEmailValidator.h"
#import "SlideAcrossViewAnimationDelegate.h"
#import "CustomisePresentViewControllerDelegate.h"
#import "ArcosMailTableViewControllerDelegate.h"

@interface CustomerPhotoSlideViewController : UIViewController<UIScrollViewDelegate, EmailRecipientDelegate, MFMailComposeViewControllerDelegate, CustomerPhotoDeleteActionViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ArcosMailTableViewControllerDelegate> {
    id<PresentViewControllerDelegate> _delegate;
    id<SlideAcrossViewAnimationDelegate> _animateDelegate;
    CustomerPhotoSlideDataManager* _customerPhotoSlideDataManager;
    NSNumber* _locationIUR;
    UIScrollView* _myScrollView;
    UIBarButtonItem* _emailButton;
    UIBarButtonItem* _trashButton;
    UIPopoverController* _emailPopover;
    UINavigationController* _emailNavigationController;
    MFMailComposeViewController* _mailController;
    UIPopoverController* _trashPopover;
    UIBarButtonItem* _cameraRollButton;
    UIPopoverController* _cameraRollPopover;
    UINavigationController* _globalNavigationController;
    UIViewController* _rootView;
}

@property(nonatomic, assign) id<PresentViewControllerDelegate> delegate;
@property (nonatomic, assign) id<SlideAcrossViewAnimationDelegate> animateDelegate;
@property(nonatomic, retain) CustomerPhotoSlideDataManager* customerPhotoSlideDataManager;
@property(nonatomic, retain) NSNumber* locationIUR;
@property(nonatomic, retain) IBOutlet UIScrollView* myScrollView;
@property(nonatomic, retain) UIBarButtonItem* emailButton;
@property(nonatomic, retain) UIBarButtonItem* trashButton;
@property(nonatomic, retain) UIPopoverController* emailPopover;
@property(nonatomic, retain) UINavigationController* emailNavigationController;
@property(nonatomic,retain) MFMailComposeViewController* mailController;
@property(nonatomic,retain) UIPopoverController* trashPopover;
@property(nonatomic,retain) UIBarButtonItem* cameraRollButton;
@property(nonatomic,retain) UIPopoverController* cameraRollPopover;
@property(nonatomic,retain) UINavigationController* globalNavigationController;
@property(nonatomic,retain) UIViewController* rootView;

@end
