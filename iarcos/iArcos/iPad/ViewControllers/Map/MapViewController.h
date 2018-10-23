//
//  MapViewController.h
//  Arcos
//
//  Created by David Kilmartin on 24/06/2011.
//  Copyright 2011  Strata IT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressAnnotation.h"
//#import "CustomerInfoViewController.h"
#import "LocationCommon.h"
#import "MapPopoverViewController.h"
#import "GlobalSharedClass.h"
#import "ConnectivityCheck.h"
#import "CallGenericServices.h"
#import "ArcosGenericClass.h"
#import "OrderDateRangePicker.h"
#import "SettingManager.h"
#import "CustomerInfoTableViewController.h"
#import "StockistParentTableViewController.h"
#import "CustomerOrderDetailsModalViewController.h"
#import "CustomerCallDetailViewController.h"
#import "CoreLocationController.h"

@interface MapViewController : UIViewController<MKMapViewDelegate,MapPopoverDelegate,GetDataGenericDelegate,OrderDateRangePickerDelegate,ConnectivityDelegate,StockistChildTableViewDelegate,SlideAcrossViewAnimationDelegate,CoreLocationControllerDelegate> {
//    CustomerInfoViewController* myCustomerInfoViewController;
    CustomerInfoTableViewController* myCustomerInfoViewController;
    IBOutlet MKMapView *myMapView;
    BOOL isMyLocationCentered;
    UIPopoverController *annotationPopoverController;
    MapPopoverViewController* currentPopoverView;
    MKAnnotationView* popoverAnnotationView;
   
    NSMutableArray* annotations;
    //for testing
    NSString* locTrackString;
    
    //connectivity check
    ConnectivityCheck* connectivityCheck;
    
    //generic service
    CallGenericServices* callGenericServices;
    NSMutableArray* orders;
    
    //order view animation
    UINavigationController* _globalNavigationController;
    UIViewController* _rootView;
    ArcosCustomiseAnimation* arcosCustomiseAnimation;
    NSDate* orderStartDate;
    NSDate* orderEndDate;
    
    //loading indicator
    IBOutlet UIActivityIndicatorView* indicator;
    
    //date picker popover
    UIPopoverController* datePickerPopover;
    UIPopoverController* _stockistPopoverController;
    StockistParentTableViewController* _stockistParentTableViewController;
    CoreLocationController *CLController;
}
@property (nonatomic, retain) IBOutlet MKMapView *myMapView;
@property (nonatomic,retain)  UIPopoverController *annotationPopoverController;
@property (nonatomic,retain)     NSMutableArray* annotations;
@property (nonatomic,retain) NSMutableArray* orders;
@property (nonatomic,retain) UINavigationController* globalNavigationController;
@property (nonatomic,retain) UIViewController* rootView;

@property (nonatomic, retain) NSString* locTrackString;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView* indicator;
@property (nonatomic, retain) NSDate* orderStartDate;
@property (nonatomic, retain) NSDate* orderEndDate;
@property (nonatomic, retain) UIPopoverController* stockistPopoverController;
@property (nonatomic, retain) StockistParentTableViewController* stockistParentTableViewController;
@property (nonatomic, retain) CoreLocationController *CLController;
-(void)centerUserLocation;
-(void)addAnnotationToLocation:(CLLocationCoordinate2D)aLocation withLocation:(NSMutableDictionary*)aLocation withAnnoType:(AddressAnnotationType)type withObject:(NSObject*)anObject;
-(void)findLocationsAroundAnnotation:(AddressAnnotation*)anno withRadius:(NSInteger)radius;
-(void)removePinOnMap:(AddressAnnotation*)anno;
-(void)clearPins;
-(void)dissmissThePopoverView;
-(void)orderOption;

@end
