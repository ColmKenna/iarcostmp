//
//  ArcosStackedViewController.h
//  iArcos
//
//  Created by David Kilmartin on 06/08/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
//@class GenericMasterTemplateViewController;
#import "GenericMasterTemplateViewController.h"
#import "GenericMasterTemplateDelegate.h"
#import "ArcosUtils.h"

@interface ArcosStackedViewController : UIViewController<GenericMasterTemplateDelegate> {
    
    UINavigationController* _topVisibleNavigationController;
    GenericMasterTemplateViewController* _myMasterViewController;
    UIScrollView* _myScrollView;
    UITableView* _myTableView;
    int _positionDiff;
}

@property(nonatomic, retain, readonly) NSArray* rcsViewControllers;
@property(nonatomic, retain) UINavigationController* topVisibleNavigationController;
@property(nonatomic, retain) GenericMasterTemplateViewController* myMasterViewController;
@property(nonatomic, retain) IBOutlet UIScrollView* myScrollView;
@property(nonatomic, retain) IBOutlet UITableView* myTableView;
@property(nonatomic, assign) int positionDiff;

- (id)initWithRootNavigationController:(UINavigationController *)rootNavigationController;
- (void)pushNavigationController:(UINavigationController *)navigationController fromNavigationController:(UINavigationController *)startNavigationController animated:(BOOL)animated;
- (void)popToRootNavigationController:(BOOL)animated;
- (void)popTopNavigationController:(BOOL)animated;
- (void)popToNavigationController:(UINavigationController *)navigationController animated:(BOOL)animated;
- (void)updateNavigationControllerContent:(UINavigationController *)navigationController viewController:(UIViewController*)viewController;
- (void)pushMasterViewController:(GenericMasterTemplateViewController *)viewController;
- (void)processMoveMasterViewController:(CGPoint)velocity;
- (int)indexOfMyNavigationController:(UINavigationController*)startNavigationController;
- (UINavigationController*)previousNavControllerWithCurrentIndex:(int)currentIndex step:(int)stepNum;

@end
