//
//  CustomerSurveyDetailsTableViewController.h
//  iArcos
//
//  Created by David Kilmartin on 21/06/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CallGenericServices.h"
#import "CustomerSurveyDetailsDataManager.h"
#import "CustomerSurveyDetailsResponseBaseTableCell.h"
#import "CustomerSurveyDetailsTableCellFactory.h"
#import "CustomerSurveyDetailsSectionHeader.h"
#import "EmailRecipientTableViewController.h"
#import "ArcosEmailValidator.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "ArcosMailWrapperViewController.h"

@interface CustomerSurveyDetailsTableViewController : UITableViewController <EmailRecipientDelegate, MFMailComposeViewControllerDelegate, CustomerSurveyDetailsResponseTableCellDelegate,ArcosMailTableViewControllerDelegate> {
    CallGenericServices* _callGenericServices;
    ArcosGenericClass* _summaryCellData;
    CustomerSurveyDetailsDataManager* _customerSurveyDetailsDataManager;
    CustomerSurveyDetailsTableCellFactory* _cellFactory;
    UIBarButtonItem* _emailButton;
    UIPopoverController* _emailPopover;
    UINavigationController* _emailNavigationController;
    NSMutableArray* _rightBarButtonItemList;
    MFMailComposeViewController* _mailController;
    UINavigationController* _globalNavigationController;
    UIViewController* _myRootViewController;
    NSString* _subjectTitle;
}

@property(nonatomic, retain) CallGenericServices* callGenericServices;
@property(nonatomic, retain) ArcosGenericClass* summaryCellData;
@property(nonatomic, retain) CustomerSurveyDetailsDataManager* customerSurveyDetailsDataManager;
@property(nonatomic, retain) CustomerSurveyDetailsTableCellFactory* cellFactory;
@property(nonatomic, retain) UIBarButtonItem* emailButton;
@property(nonatomic, retain) UIPopoverController* emailPopover;
@property(nonatomic, retain) UINavigationController* emailNavigationController;
@property(nonatomic, retain) NSMutableArray* rightBarButtonItemList;
@property(nonatomic,retain) MFMailComposeViewController* mailController;
@property(nonatomic, retain) UINavigationController* globalNavigationController;
@property(nonatomic, retain) UIViewController* myRootViewController;
@property(nonatomic, retain) NSString* subjectTitle;

@end
