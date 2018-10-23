//
//  CustomerCoverHomePageImageViewController.h
//  iArcos
//
//  Created by David Kilmartin on 26/11/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArcosCoreData.h"

@interface CustomerCoverHomePageImageViewController : UIViewController {
    UIButton* _myImageButton;
}

@property(nonatomic, retain) IBOutlet UIButton* myImageButton;

@end
