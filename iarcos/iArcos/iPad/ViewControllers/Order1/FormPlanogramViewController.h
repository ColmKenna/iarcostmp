//
//  FormPlanogramViewController.h
//  iArcos
//
//  Created by David Kilmartin on 11/12/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FormPlanogramViewController : UIViewController {
    UIWebView* _myWebView;
}

@property(nonatomic, retain) IBOutlet UIWebView* myWebView;

@end
