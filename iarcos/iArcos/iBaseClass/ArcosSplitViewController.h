//
//  ArcosSplitViewController.h
//  iArcos
//
//  Created by David Kilmartin on 07/10/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArcosSplitViewController : UIViewController {
    NSArray* _rcsViewControllers;
    UIScrollView* _myScrollView;
    UITableView* _myTableView;
}

@property(nonatomic, retain) NSArray* rcsViewControllers;
@property(nonatomic, retain) IBOutlet UIScrollView* myScrollView;
@property(nonatomic, retain) IBOutlet UITableView* myTableView;

- (void)rightMoveMasterViewController;
- (void)leftMoveMasterViewController;
- (void)processMoveMasterViewController:(CGPoint)velocity;

- (void)shrinkUtilitiesOptions;
- (void)growUtilitiesOptions;
- (void)layoutMySubviews;
- (void)layoutLandscapeSubviews;
- (void)layoutPortraitSubviews;
- (void)resizeMasterViewToWidth:(CGFloat)desiredWidth;
- (void)resizeMasterViewToPercentage:(CGFloat)percentage;

@end
