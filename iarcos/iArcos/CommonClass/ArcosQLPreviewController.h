//
//  ArcosQLPreviewController.h
//  Arcos
//
//  Created by David Kilmartin on 12/04/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <QuickLook/QuickLook.h>
#import "EmailRecipientTableViewController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "ArcosEmailValidator.h"
#import "ArcosQLPreviewItem.h"

@protocol ArcosQLPreviewControllerDelegate <NSObject>

- (BOOL)downloadPdfFileDelegate;

@end

@interface ArcosQLPreviewController : QLPreviewController <EmailRecipientDelegate, MFMailComposeViewControllerDelegate, QLPreviewControllerDelegate> {
//    UIPopoverController* _emailPopover;
    UINavigationController* _emailNavigationController;
    MFMailComposeViewController* _mailController;
    UIBarButtonItem* _emailButton;
    UIBarButtonItem* _previewButton;
    id<ArcosQLPreviewControllerDelegate> _arcosPreviewDelegate;
    BOOL _isDownloadPdfFileClicked;
    BOOL _isNotNeedToShowPdfButton;
}

//@property(nonatomic, retain) UIPopoverController* emailPopover;
@property(nonatomic, retain) UINavigationController* emailNavigationController;
@property(nonatomic,retain) MFMailComposeViewController* mailController;
@property(nonatomic,retain) UIBarButtonItem* emailButton;
@property(nonatomic,retain) UIBarButtonItem* previewButton;
@property(nonatomic,retain) id<ArcosQLPreviewControllerDelegate> arcosPreviewDelegate;
@property(nonatomic,assign) BOOL isDownloadPdfFileClicked;
@property(nonatomic,assign) BOOL isNotNeedToShowPdfButton;

@end
