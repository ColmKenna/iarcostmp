//
//  OrderDetailModelViewController.h
//  Arcos
//
//  Created by David Kilmartin on 19/07/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelViewDelegate.h"
#import "WidgetFactory.h"
#import "CoreLocationController.h"
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
//#import "OrderEmailProcessCenter.h"
#import "OrderDetailCallEmailActionDataManager.h"
#import "OrderDetailOrderEmailActionDataManager.h"
#import "ArcosEmailValidator.h"

@interface OrderDetailModelViewController : UIViewController<UITextViewDelegate,WidgetFactoryDelegate,CoreLocationControllerDelegate,UIPopoverControllerDelegate,MFMailComposeViewControllerDelegate> {
    IBOutlet UIScrollView* contentView;
    WidgetFactory* widgetFactory;
    IBOutlet UILabel* TheOrderNumber;
    IBOutlet UILabel* OrderValue;
    IBOutlet UILabel* Name;
    IBOutlet UILabel* Address;
    IBOutlet UILabel* OrderDate;
    IBOutlet UILabel* DeliveryDate;
    IBOutlet UILabel* Wholesaler;
    IBOutlet UILabel* Status;
    IBOutlet UILabel* Type;
    IBOutlet UILabel* CallType;
    IBOutlet UILabel* Contact;
    IBOutlet UITextField* CustomerRef;
    IBOutlet UITextView* Memo;
    IBOutlet UITableView* orders;
    IBOutlet UIButton* widgetPopPoint;
    UILabel* currentLabel;
    UIPopoverController* thePopover;
    NSMutableDictionary* orderHeader;
    int currentControlTag;
    //location controller
    CoreLocationController *CLController;
    IBOutlet UILabel * Latitude;
    IBOutlet UILabel * Longitude;
    
    
    id<ModelViewDelegate> delegate;
    NSMutableDictionary* theData;
    
    NSNumber* orderNumber;
    
    //editable
    BOOL isEditable;
    

    IBOutlet UIButton* emailButton;
    IBOutlet UIButton* wholesalerEmailButton;
    IBOutlet UIButton* contactEmailButton;
    int emailAction;//1:location; 2:wholesaler; 3:contact
//    OrderEmailProcessCenter* orderEmailProcessCenter;
    MFMailComposeViewController* _mailController;
    OrderDetailCallEmailActionDataManager* _callEmailActionDataManager;
    OrderDetailOrderEmailActionDataManager* _orderEmailActionDataManager;
    id<OrderDetailEmailActionDelegate> _emailActionDelegate;
}
@property(nonatomic,retain) IBOutlet UILabel* TheOrderNumber;
@property(nonatomic,retain) IBOutlet UILabel* OrderValue;
@property(nonatomic,retain) IBOutlet UIScrollView* contentView;
@property(nonatomic,retain) WidgetFactory* widgetFactory;
@property(nonatomic,retain) IBOutlet UILabel* Name;
@property(nonatomic,retain) IBOutlet UILabel* Address;
@property(nonatomic,retain) IBOutlet UILabel* OrderDate;
@property(nonatomic,retain) IBOutlet UILabel* DeliveryDate;
@property(nonatomic,retain) IBOutlet UILabel* Wholesaler;
@property(nonatomic,retain) IBOutlet UILabel* Status;
@property(nonatomic,retain) IBOutlet UILabel* Type;
@property(nonatomic,retain) IBOutlet UILabel* CallType;
@property(nonatomic,retain) IBOutlet UILabel* Contact;
@property(nonatomic,retain) IBOutlet UITextField* CustomerRef;
@property(nonatomic,retain) IBOutlet UITextView* Memo;
@property(nonatomic,retain) IBOutlet UITableView* orders;
@property(nonatomic,retain) IBOutlet UIButton* widgetPopPoint;
@property(nonatomic,retain) NSMutableDictionary* orderHeader;
@property (nonatomic, retain) CoreLocationController *CLController;
@property(nonatomic,retain) IBOutlet UILabel * Latitude;
@property(nonatomic,retain) IBOutlet UILabel * Longitude;

@property (nonatomic, assign) id<ModelViewDelegate> delegate;
@property(nonatomic,retain)     NSMutableDictionary* theData;

@property(nonatomic,retain) NSNumber* orderNumber;

@property(nonatomic,assign) BOOL isEditable;


@property(nonatomic,retain) IBOutlet UIButton* emailButton;
@property(nonatomic,retain) IBOutlet UIButton* wholesalerEmailButton;
@property(nonatomic,retain) IBOutlet UIButton* contactEmailButton;
@property(nonatomic,retain) MFMailComposeViewController* mailController;
@property(nonatomic,retain) OrderDetailCallEmailActionDataManager* callEmailActionDataManager;
@property(nonatomic,retain) OrderDetailOrderEmailActionDataManager* orderEmailActionDataManager;
@property(nonatomic,retain) id<OrderDetailEmailActionDelegate> emailActionDelegate;

-(IBAction)donePressed:(id)sender;
-(void)loadOrderHeader:(NSMutableDictionary*)anOrderHeader;


-(IBAction)emailButtonPressed:(id)sender;
-(IBAction)wholesalerEmailButtonPressed:(id)sender;
-(IBAction)contactEmailButtonPressed:(id)sender;
-(void)checkOrderStatusForWholesaler;


@end
