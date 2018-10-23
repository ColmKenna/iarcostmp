//
//  CustomerViewController.h
//  Arcos
//
//  Created by David Kilmartin on 20/06/2011.
//  Copyright 2011  Strata IT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerListingViewController.h"

@interface CustomerViewController : UINavigationController {
    CustomerListingViewController* myCustomerListingViewController;  
}

@end
