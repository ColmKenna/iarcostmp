//
//  GenericWrapperUITableViewController.h
//  Arcos
//
//  Created by David Kilmartin on 16/04/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GenericUITableViewController.h"
#import "ArcosCustomiseAnimation.h"

@interface GenericWrapperUITableViewController : UIViewController<UITableViewDelegate, SlideAcrossViewAnimationDelegate> {
    id<SlideAcrossViewAnimationDelegate> _animateDelegate;
    UIScrollView* _customiseScrollContentView;
    
    UINavigationController* _globalNavigationController;
    UIViewController* _rootView;
    ArcosCustomiseAnimation* arcosCustomiseAnimation;
    NSArray* _attrNameList;
    NSArray* _attrNameTypeList;
    NSMutableArray* _displayList;
    GenericUITableViewController* _genericUITableViewController;
    
}

@property (nonatomic, assign) id<SlideAcrossViewAnimationDelegate> animateDelegate;
@property (nonatomic, retain) IBOutlet UIScrollView* customiseScrollContentView;
@property(nonatomic, retain) UINavigationController* globalNavigationController;
@property(nonatomic, retain) UIViewController* rootView;

@property(nonatomic, retain) NSArray* attrNameList;
@property(nonatomic, retain) NSArray* attrNameTypeList;
@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) GenericUITableViewController* genericUITableViewController;

@end
