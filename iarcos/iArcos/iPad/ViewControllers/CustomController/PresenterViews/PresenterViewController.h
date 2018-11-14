//
//  PresenterViewController.h
//  Arcos
//
//  Created by David Kilmartin on 18/01/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileCommon.h"
#import "FileDownloadCenter.h"
#import "OrderInputPadViewController.h"
#import "FormRowsTableViewController.h"
#import "EmailRecipientTableViewController.h"
#import "ArcosEmailValidator.h"
#import "HumanReadableDataSizeHelper.h"
#import "ArcosConfigDataManager.h"
#import "PresenterBaseDataManager.h"
#import "ArcosMailWrapperViewController.h"
#import "FormRowsWrapperViewController.h"
@class ArcosRootViewController;
#import "EmailButtonAddressSelectDelegate.h"

typedef enum {
    PresenterRequestSourceSubMenu = 0,
    PresenterRequestSourceMainMenu
} PresenterRequestSource;
@interface PresenterViewController : UIViewController<FileDownloadCenterDelegate,UIActionSheetDelegate,WidgetFactoryDelegate, EmailRecipientDelegate, MFMailComposeViewControllerDelegate,UIAlertViewDelegate,ArcosMailTableViewControllerDelegate,CustomisePartialPresentViewControllerDelegate, FormRowsTableViewControllerDelegate, UIPopoverControllerDelegate>{
    PresenterRequestSource _presenterRequestSource;
    FileDownloadCenter* fileDownloadCenter;
    NSMutableArray* files;
    NSNumber* _fileType;
    NSMutableDictionary* currentFile;
    
    //order input popover
    UIPopoverController* _inputPopover;
    WidgetFactory* _factory;
    EmailRecipientTableViewController* _emailRecipientTableViewController;
    UIPopoverController* _emailPopover;
    UIBarButtonItem* _emailButton;
    
    int _rowPointer;
    NSMutableArray* _candidateRemovedFileList;
    NSMutableArray* _removedFileList;
    NSDictionary* _auxEmailCellData;
//    UIDocumentInteractionController* documentInteractionController;
    NSDate* _recordBeginDate;
    NSDate* _recordEndDate;
//    ArcosConfigDataManager* _arcosConfigDataManager;
    PresenterBaseDataManager* _presenterBaseDataManager;
    UINavigationController* _globalNavigationController;
    ArcosRootViewController* _rootView;
    FormRowsWrapperViewController* frwvc;
    UINavigationController* _formRowsNavigationController;
    id<EmailButtonAddressSelectDelegate> _emailButtonAddressSelectDelegate;
}
@property(nonatomic, assign) PresenterRequestSource presenterRequestSource;
@property(nonatomic,retain)    NSMutableArray* files;
@property(nonatomic,retain) NSNumber* fileType;
@property(nonatomic,retain)     NSMutableDictionary* currentFile;
@property(nonatomic,retain) UIPopoverController* inputPopover;
@property(nonatomic,retain) WidgetFactory* factory;
@property(nonatomic,retain) EmailRecipientTableViewController* emailRecipientTableViewController;
@property(nonatomic, retain) UIPopoverController* emailPopover;
@property(nonatomic, retain) UIBarButtonItem* emailButton;
@property(nonatomic, assign) int rowPointer;
@property(nonatomic, retain) NSMutableArray* candidateRemovedFileList;
@property(nonatomic, retain) NSMutableArray* removedFileList;
@property(nonatomic, retain) NSDictionary* auxEmailCellData;
//@property(nonatomic, retain) UIDocumentInteractionController* documentInteractionController;
@property(nonatomic, retain) NSDate* recordBeginDate;
@property(nonatomic, retain) NSDate* recordEndDate;
//@property(nonatomic, retain) ArcosConfigDataManager* arcosConfigDataManager;
@property(nonatomic, retain) PresenterBaseDataManager* presenterBaseDataManager;
@property (nonatomic, retain) UINavigationController* globalNavigationController;
@property (nonatomic, retain) UIViewController* rootView;
@property (nonatomic, retain) FormRowsWrapperViewController* frwvc;
@property (nonatomic, retain) UINavigationController* formRowsNavigationController;
@property (nonatomic, retain) id<EmailButtonAddressSelectDelegate> emailButtonAddressSelectDelegate;

-(int)indexForFile:(NSString*)fileName;
-(void)resetBarTitle:(NSString*)title;
-(void)oneOrderFormBranch:(NSString*)Lxcode orderLevel:(NSNumber*)anOrderLevel productIUR:(NSNumber*)ProductIUR button:(UIBarButtonItem*)button;
-(void)multipleOrderFormBranch:(NSString*)Lxcode orderLevel:(NSNumber*)anOrderLevel productIUR:(NSNumber*)ProductIUR button:(UIBarButtonItem*)button;
-(BOOL)isProductInFormRowWithFormIUR:(NSNumber*)aFormIUR productIUR:(NSNumber*)aProductIUR;
- (NSString*)getMimeTypeWithFileName:(NSString*)aFileName;
- (void)getOverSizeFileListFromDataList:(NSMutableArray*)aDataList;
- (void)checkFileSizeWithIndex:(int)aRowPointer;
- (void)processSelectEmailRecipientRow:(NSDictionary*)cellData dataList:(NSMutableArray*)aDataList;
- (BOOL)isFileInRemovedList:(NSString*)fileName;
- (void)processPtranRecord:(NSDictionary*)cellData;
- (int)retrieveStatusBarHeight;
- (BOOL)emailButtonPressed:(id)sender;
- (BOOL)validateHiddenPopovers;
- (void)createEmailPopoverProcessor;

@end
