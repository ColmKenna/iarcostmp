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

@interface ArcosMailTableViewController : UITableViewController <ArcosMailTableViewCellDelegate>{
//    id<CustomisePresentViewControllerDelegate> _myDelegate;
    id<ArcosMailTableViewControllerDelegate> _mailDelegate;
    ArcosMailDataManager* _arcosMailDataManager;
    ArcosMailCellFactory* _arcosMailCellFactory;
    UIBarButtonItem* _sendButton;
    MCOSMTPSession* _smtpSession;
    MBProgressHUD* _HUD;
    ArcosStoreExcInfoDataManager* _arcosStoreExcInfoDataManager;
}

//@property(nonatomic, assign) id<CustomisePresentViewControllerDelegate> myDelegate;
@property(nonatomic, assign) id<ArcosMailTableViewControllerDelegate> mailDelegate;
@property(nonatomic, retain) ArcosMailDataManager* arcosMailDataManager;
@property(nonatomic, retain) ArcosMailCellFactory* arcosMailCellFactory;
@property(nonatomic, retain) UIBarButtonItem* sendButton;
@property(nonatomic, retain) MCOSMTPSession* smtpSession;
@property(nonatomic, retain) MBProgressHUD* HUD;
@property(nonatomic, retain) ArcosStoreExcInfoDataManager* arcosStoreExcInfoDataManager;

@end
