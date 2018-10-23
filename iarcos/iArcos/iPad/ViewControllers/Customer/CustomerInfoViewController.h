//
//  CustomerInfoViewController.h
//  Arcos
//
//  Created by David Kilmartin on 21/06/2011.
//  Copyright 2011  Strata IT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreLocationController.h"
#import "CustomerPopoverMenuViewController.h"
#import "LocationUM.h"
#import "ArcosCoreData.h"
#import "GlobalSharedClass.h"
#import "OrderProductViewController.h"
#import "OrderDetailModelViewController.h"
#import "DetailingTableViewController.h"
#import "OrderSharedClass.h"
#import "CustomerInvoiceModalViewController.h"
#import "CustomerOrderModalViewController.h"
#import "CustomerCallModalViewController.h"
#import "CustomerMemoModalViewController.h"
#import "CustomerNotBuyModalViewController.h"
#import "CustomerTyvLyModalViewController.h"
#import "CustomerAnalyzeModalViewController.h"
#import "CustomerDetailsModalViewController.h"
//#import "CustomerCreateContactModalViewController.h"
#import "ArcosCustomiseAnimation.h"
#import "CustomerSurveyViewController.h"
#import "ArcosUtils.h"
#import "CustomerDetailsWrapperModalViewController.h"
#import "CustomerContactWrapperModalViewController.h"
#import "CustomerWeeklyMainWrapperModalViewController.h"
#import "CustomerPresenterFilesViewController.h"

@interface CustomerInfoViewController : UIViewController<UIPopoverControllerDelegate,customerPopoverMenuDelegate,CoreLocationControllerDelegate,UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,ModelViewDelegate,SlideAcrossViewAnimationDelegate> {
    
    UIBarButtonItem *optionButtom;
    UIPopoverController *popoverController;
    CustomerPopoverMenuViewController* myCustomerPopoverMenuViewController;
    NSMutableDictionary* aCustDict;
    LocationUM *aCustLoc;
    
    CoreLocationController *CLController;
    NSMutableDictionary* orderHeader;
    
    IBOutlet UILabel * Name;
    IBOutlet UILabel * Email;
    IBOutlet UILabel * Fax;
    IBOutlet UILabel * PhoneNumber;
    IBOutlet UILabel * Address1;
    IBOutlet UILabel * Address2;
    IBOutlet UILabel * Address3;
    IBOutlet UILabel * Address4;
    IBOutlet UILabel * Address5;
    IBOutlet UILabel * CreditStatus;
    IBOutlet UILabel * LocationStatus;
    IBOutlet UILabel * LocationType;
    IBOutlet UILabel * LocationCode;
    IBOutlet UILabel * MemberOf;
    IBOutlet UILabel * LocationSet;
    IBOutlet UILabel * Latitude;
    IBOutlet UILabel * Longitude;
    IBOutlet UIButton * LocationStamp;
    IBOutlet UIImageView * shopImage;
    
    //Labels
    IBOutlet UILabel* label1;
    
    //order list
    IBOutlet UITableView* orderListView;
    NSMutableArray* orderList;
    IBOutlet UIView* tableHeader;
    NSMutableDictionary* currentSelectOrderHeader;

    //UIView animation
    UINavigationController* _globalNavigationController;
    UIViewController* _rootView;
    ArcosCustomiseAnimation* arcosCustomiseAnimation;
    
}
@property(nonatomic,retain) IBOutlet UILabel * Name;
@property(nonatomic,retain) IBOutlet UILabel * Email;
@property(nonatomic,retain) IBOutlet UILabel * Fax;
@property(nonatomic,retain) IBOutlet UILabel * PhoneNumber;
@property(nonatomic,retain) IBOutlet UILabel * Address1;
@property(nonatomic,retain) IBOutlet UILabel * Address2;
@property(nonatomic,retain) IBOutlet UILabel * Address3;
@property(nonatomic,retain) IBOutlet UILabel * Address4;
@property(nonatomic,retain) IBOutlet UILabel * Address5;
@property(nonatomic,retain) IBOutlet UILabel * CreditStatus;
@property(nonatomic,retain) IBOutlet UILabel * LocationStatus;
@property(nonatomic,retain) IBOutlet UILabel * LocationType;
@property(nonatomic,retain) IBOutlet UILabel * LocationCode;
@property(nonatomic,retain) IBOutlet UILabel * MemberOf;
@property(nonatomic,retain) IBOutlet UILabel * LocationSet;
@property(nonatomic,retain) IBOutlet UILabel * Latitude;
@property(nonatomic,retain) IBOutlet UILabel * Longitude;
@property(nonatomic,retain) IBOutlet UIButton * LocationStamp;
@property(nonatomic,retain) IBOutlet UIImageView * shopImage;

@property(nonatomic,retain)    IBOutlet UILabel* label1;




@property(nonatomic,retain) NSMutableDictionary* aCustDict;
@property(nonatomic,retain) LocationUM *aCustLoc;

@property (nonatomic, retain) CoreLocationController *CLController;
@property (nonatomic, retain) IBOutlet UITableView* orderListView;
@property (nonatomic, retain) NSMutableArray* orderList;
@property (nonatomic, retain) IBOutlet UIView* tableHeader;
@property (nonatomic, retain) NSMutableDictionary* currentSelectOrderHeader;

@property (nonatomic, retain) NSMutableDictionary* orderHeader;

@property (nonatomic, retain) UINavigationController* globalNavigationController;
@property (nonatomic, retain) UIViewController* rootView;


-(IBAction)optionSelected:(id)sender;
-(IBAction)stampLocation:(id)sender;
-(IBAction)takeOrder:(id)sender;
-(IBAction)recordCall:(id)sender;
-(IBAction)doSurvey;
-(UITableViewController*)leftMasterViewController;

-(void)resetContentWithDict:(NSMutableDictionary*)aDict;
-(void)resetContentWithObject:(LocationUM*)aObject;
-(IBAction)doTest;
-(IBAction)doPresenter;

@end
