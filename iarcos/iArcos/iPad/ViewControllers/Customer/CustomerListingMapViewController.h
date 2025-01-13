//
//  CustomerListingMapViewController.h
//  iArcos
//
//  Created by Richard on 07/01/2025.
//  Copyright © 2025 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomisePresentViewControllerDelegate.h"
#import "GlobalSharedClass.h"
#import "CustomerListingMapDataManager.h"
#import "ArcosUtils.h"
#import "AddressAnnotation.h"

@interface CustomerListingMapViewController : UIViewController <MKMapViewDelegate>{
    id<CustomisePresentViewControllerDelegate> _presentDelegate;
    MKMapView* _myMapView;
    CustomerListingMapDataManager* _customerListingMapDataManager;
}

@property (nonatomic, assign) id<CustomisePresentViewControllerDelegate> presentDelegate;
@property (nonatomic, retain) IBOutlet MKMapView* myMapView;
@property (nonatomic, retain) CustomerListingMapDataManager* customerListingMapDataManager;

@end


