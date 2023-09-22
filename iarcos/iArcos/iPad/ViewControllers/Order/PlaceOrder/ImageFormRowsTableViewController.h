//
//  ImageFormRowsTableViewController.h
//  Arcos
//
//  Created by David Kilmartin on 22/10/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageFormRowsDataManager.h"
#import "ImageFormRowsTableCell.h"
#import "ArcosCustomiseAnimation.h"
#import "ImageL5FormRowsTableViewController.h"
#import "SlideAcrossViewAnimationDelegate.h"

@interface ImageFormRowsTableViewController : UITableViewController<ImageFormRowsDelegate, SlideAcrossViewAnimationDelegate, UISearchBarDelegate> {
    id<OrderFormNavigationControllerBackButtonDelegate> _backButtonDelegate;
    NSNumber* _locationIUR;
    id<SlideAcrossViewAnimationDelegate> _animateDelegate;
    ImageFormRowsDataManager* _imageFormRowsDataManager;
    
    ArcosCustomiseAnimation* _arcosCustomiseAnimation;
    UINavigationController* _globalNavigationController;
    UIViewController* _rootView;
    UISearchBar* _mySearchBar;
    BOOL _isNotFirstLoaded;
}

@property(nonatomic, assign) id<OrderFormNavigationControllerBackButtonDelegate> backButtonDelegate;
@property(nonatomic, retain) NSNumber* locationIUR;
@property(nonatomic, assign) id<SlideAcrossViewAnimationDelegate> animateDelegate;
@property(nonatomic, retain) ImageFormRowsDataManager* imageFormRowsDataManager;

@property(nonatomic, retain) ArcosCustomiseAnimation* arcosCustomiseAnimation;
@property(nonatomic, retain) UINavigationController* globalNavigationController;
@property(nonatomic, retain) UIViewController* rootView;
@property(nonatomic, retain) IBOutlet UISearchBar* mySearchBar;
@property (nonatomic, assign) BOOL isNotFirstLoaded;

- (void)reloadTableViewData;

@end
