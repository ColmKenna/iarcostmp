//
//  NewPresenterViewController.h
//  Arcos
//
//  Created by David Kilmartin on 15/11/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PresenterTableViewCell.h"
#import "PresenterViewController.h"
#import "NewPresenterDataManager.h"
#import "ArcosAuxiliaryDataProcessor.h"
#import "ArcosMailWrapperViewController.h"

@interface NewPresenterViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UIPopoverControllerDelegate,MFMailComposeViewControllerDelegate, EmailRecipientDelegate, ArcosMailTableViewControllerDelegate>{
    PresenterRequestSource _parentPresenterRequestSource;
//    IBOutlet UINavigationBar* navbar;
    IBOutlet UITableView* myTableView;
    
//    NSMutableArray* testingData;
    NSIndexPath* currentSelectedCellIndexPath;
    
    NSMutableArray* presenterProducts;
    UIBarButtonItem* _typeButton;
    UIBarButtonItem* _emailButton;
    EmailRecipientTableViewController* _emailRecipientTableViewController;
    UIPopoverController* _emailPopover;
//    WidgetFactory* _factory;
//    UIPopoverController* _thePopover;
    NSString* _currentTypeTitle;
    NSNumber* _currentDescrDetailIUR;
    NSMutableArray* _dataList;
    NSString* _navigationBarTitle;
    NewPresenterDataManager* _myNewPresenterDataManager;
    BOOL _isNotFirstLoaded;
    UINavigationController* _globalNavigationController;
    UIViewController* _rootView;
}
@property(nonatomic,assign) PresenterRequestSource parentPresenterRequestSource;
//@property(nonatomic,retain)    IBOutlet UINavigationBar* navbar;
@property(nonatomic,retain) IBOutlet UITableView* myTableView;
@property(nonatomic,retain)     NSIndexPath* currentSelectedCellIndexPath;
@property(nonatomic,retain)     NSMutableArray* presenterProducts;
@property(nonatomic,retain) UIBarButtonItem* typeButton;
@property(nonatomic,retain) UIBarButtonItem* emailButton;
@property(nonatomic,retain) EmailRecipientTableViewController* emailRecipientTableViewController;
@property(nonatomic, retain) UIPopoverController* emailPopover;
//@property(nonatomic,retain) WidgetFactory* factory;
//@property(nonatomic,retain) UIPopoverController* thePopover;
@property(nonatomic,retain) NSString* currentTypeTitle;
@property(nonatomic,retain) NSNumber* currentDescrDetailIUR;
@property(nonatomic,retain) NSMutableArray* dataList;
@property(nonatomic,retain) NSString* navigationBarTitle;
@property(nonatomic,retain) NewPresenterDataManager* myNewPresenterDataManager;
@property(nonatomic,assign) BOOL isNotFirstLoaded;
@property (nonatomic, retain) UINavigationController* globalNavigationController;
@property (nonatomic, retain) UIViewController* rootView;

//- (void)cleanInactivePresenterSandbox;
- (void)cleanInactiveFilesInPresenterSandbox;
- (NSString*)getFilePathWithFileName:(NSString*)aFileName;
- (void)processSelectEmailRecipientRow:(NSDictionary*)cellData dataList:(NSMutableArray*)resultList groupName:(NSString*)aGroupName;
- (void)checkFileSizeWithIndex:(int)aRowPointer;
- (NSMutableDictionary*)retrievePresenterViewControllerResult:(NSMutableDictionary*)aPresenterDict;

@end
