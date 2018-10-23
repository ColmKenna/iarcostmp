//
//  CustomerWeeklyMainWrapperModalViewController.h
//  Arcos
//
//  Created by David Kilmartin on 08/03/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerWeeklyMainModalViewController.h"
#import "ModelViewDelegate.h"

@interface CustomerWeeklyMainWrapperModalViewController : UIViewController<ModelViewDelegate> {
    id<ModelViewDelegate> delegate;
    IBOutlet UIView* customiseContentView;
    IBOutlet UIScrollView* customiseScrollContentView;
    UINavigationController* _globalNavigationController;
}

@property (nonatomic,assign) id<ModelViewDelegate> delegate;
@property (nonatomic,retain) IBOutlet UIView* customiseContentView;
@property (nonatomic,retain) IBOutlet UIScrollView* customiseScrollContentView;
@property (nonatomic,retain) UINavigationController* globalNavigationController;

@end
