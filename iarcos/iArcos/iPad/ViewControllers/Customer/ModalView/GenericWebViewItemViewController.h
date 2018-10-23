//
//  GenericWebViewItemViewController.h
//  iArcos
//
//  Created by David Kilmartin on 18/01/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GenericWebViewItemViewController : UIViewController {
    UIWebView* _myWebView;
}

@property(nonatomic, retain) IBOutlet UIWebView* myWebView;

- (void)loadContentWithPath:(NSString*)aPath;

@end
