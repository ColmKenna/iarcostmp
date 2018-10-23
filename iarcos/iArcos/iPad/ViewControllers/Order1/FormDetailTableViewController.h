//
//  FormDetailTableViewController.h
//  Arcos
//
//  Created by David Kilmartin on 05/11/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormDetailDataManager.h"
#import "FormRowDividerTableViewController.h"
#import "FormDetailDelegate.h"
#import "OrderSharedClass.h"
#import "FormDetailTableCell.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "ArcosEmailValidator.h"
#import "ArcosMailWrapperViewController.h"

@interface FormDetailTableViewController : UIViewController <UITableViewDelegate,UITableViewDataSource, FormRowDividerDelegate, UIActionSheetDelegate, UIAlertViewDelegate, MFMailComposeViewControllerDelegate,ArcosMailTableViewControllerDelegate>{
    FormDetailDataManager* _formDetailDataManager;
    id<FormDetailDelegate> _delegate;
    id<FormRowDividerDelegate> _dividerDelegate;
    UIActionSheet* _theActionSheet;
    NSIndexPath* _currentIndexPath;
    UITableView* _formDetailTableView;
    FormRowDividerTableViewController* _frdtvc;
    UIAlertView* _theAlertView;
    UIBarButtonItem* _emailButton;
    UIBarButtonItem* _standardOrderFormEmailButton;
    BOOL _isBusy;
    NSString* _filePath;
    UINavigationController* _globalNavigationController;
    NSString* _fieldDelimiter;
    NSString* _rowDelimiter;
}

@property(nonatomic, retain) FormDetailDataManager* formDetailDataManager;
@property(nonatomic, assign) id<FormDetailDelegate> delegate;
@property(nonatomic, assign) id<FormRowDividerDelegate> dividerDelegate;
@property(nonatomic, retain) UIActionSheet* theActionSheet;
@property(nonatomic, retain) NSIndexPath* currentIndexPath;
@property(nonatomic, retain) IBOutlet UITableView* formDetailTableView;
@property(nonatomic, retain) FormRowDividerTableViewController* frdtvc;
@property(nonatomic, retain) UIAlertView* theAlertView;
@property(nonatomic, retain) UIBarButtonItem* emailButton;
@property(nonatomic, retain) UIBarButtonItem* standardOrderFormEmailButton;
@property(nonatomic, assign) BOOL isBusy;
@property(nonatomic,retain) NSString* filePath;
@property(nonatomic,retain) UINavigationController* globalNavigationController;
@property(nonatomic,retain) NSString* fieldDelimiter;
@property(nonatomic,retain) NSString* rowDelimiter;

- (BOOL)isKeywordExistedInFormName:(NSString*)aFormName keyword:(NSString*)aKeyword;
- (NSNumber*)formRowDividerRecordQty:(NSDictionary*)aCellData;
- (BOOL)isFormDetailRowAllowToSelect:(NSDictionary*)aCellData;
- (void)selectFormDetailRowAction:(NSDictionary*)aCellData;
- (void)processFirstHalfMatContent:(NSMutableString*)aMatContent;
- (void)processSecondHalfMatContent:(NSMutableString*)aMatContent;

@end
