//
//  ArcosMailTableViewController.h
//  iArcos
//
//  Created by David Kilmartin on 01/02/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArcosMailDataManager.h"
//#import "CustomisePresentViewControllerDelegate.h"
#import "GlobalSharedClass.h"
#import "ArcosMailCellFactory.h"
#import "ArcosMailBaseTableViewCell.h"
#import "ArcosUtils.h"
#import "ArcosMailBodyTableViewCell.h"
#import "ArcosCoreData.h"
#import <MailCore/MailCore.h>
#import "MBProgressHUD.h"
#import "ArcosMailTableViewControllerDelegate.h"
#import "ArcosStoreExcInfoDataManager.h"
#import <MSAL/MSAL.h>
#import "ArcosConstantsDataManager.h"
#import "ArcosAttachmentContainer.h"
#import "ArcosMailFooterViewController.h"
#import "ArcosMailSubjectTableViewCell.h"

@interface ArcosMailTableViewController : UIViewController <ArcosMailTableViewCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
//    id<CustomisePresentViewControllerDelegate> _myDelegate;
    id<ArcosMailTableViewControllerDelegate> _mailDelegate;
    ArcosMailDataManager* _arcosMailDataManager;
    ArcosMailCellFactory* _arcosMailCellFactory;
    UIBarButtonItem* _sendButton;
    MCOSMTPSession* _smtpSession;
    MBProgressHUD* _HUD;
    ArcosStoreExcInfoDataManager* _arcosStoreExcInfoDataManager;
    ArcosMailFooterViewController* _arcosMailFooterViewController;
    UITableView* _myTableView;
    UIView* _signatureTemplateView;
    UIImageView* _myImageView;
    UIBarButtonItem* _cameraRollButton;
    UIImagePickerController* _imagePickerController;
}

//@property(nonatomic, assign) id<CustomisePresentViewControllerDelegate> myDelegate;
@property(nonatomic, assign) id<ArcosMailTableViewControllerDelegate> mailDelegate;
@property(nonatomic, retain) ArcosMailDataManager* arcosMailDataManager;
@property(nonatomic, retain) ArcosMailCellFactory* arcosMailCellFactory;
@property(nonatomic, retain) UIBarButtonItem* sendButton;
@property(nonatomic, retain) MCOSMTPSession* smtpSession;
@property(nonatomic, retain) MBProgressHUD* HUD;
@property(nonatomic, retain) ArcosStoreExcInfoDataManager* arcosStoreExcInfoDataManager;
@property(nonatomic, retain) ArcosMailFooterViewController* arcosMailFooterViewController;
@property(nonatomic, retain) IBOutlet UITableView* myTableView;
@property(nonatomic, retain) IBOutlet UIView* signatureTemplateView;
@property(nonatomic, retain) IBOutlet UIImageView* myImageView;
@property(nonatomic, retain) UIBarButtonItem* cameraRollButton;
@property(nonatomic, retain) UIImagePickerController* imagePickerController;

@end
