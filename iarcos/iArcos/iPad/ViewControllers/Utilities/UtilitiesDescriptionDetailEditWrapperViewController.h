//
//  UtilitiesDescriptionDetailEditWrapperViewController.h
//  Arcos
//
//  Created by David Kilmartin on 25/04/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelViewDelegate.h"
#import "UtilitiesDescriptionDetailEditViewController.h"
#import "GenericRefreshParentContentDelegate.h"
#import "ControllNavigationBarDelegate.h"

@interface UtilitiesDescriptionDetailEditWrapperViewController : UIViewController<ModelViewDelegate, GenericRefreshParentContentDelegate, CustomisePresentViewControllerDelegate> {
    id<CustomisePresentViewControllerDelegate> _myDelegate;
    id<GenericRefreshParentContentDelegate> _refreshDelegate;
    id<ModelViewDelegate> _delegate;
    id<ControllNavigationBarDelegate> _navigationDelegate;
    UIView* customiseContentView;
    UIScrollView* customiseScrollContentView;
    UINavigationController* _globalNavigationController;
    NSString* _navgationBarTitle;
    NSMutableDictionary* _tableCellData;
    NSString* _actionType;
    NSString* _descrTypeCode;
}

@property(nonatomic, assign) id<CustomisePresentViewControllerDelegate> myDelegate;
@property(nonatomic, assign) id<GenericRefreshParentContentDelegate> refreshDelegate;
@property (nonatomic,assign) id<ModelViewDelegate> delegate;
@property (nonatomic,assign) id<ControllNavigationBarDelegate> navigationDelegate;
@property (nonatomic,retain) IBOutlet UIView* customiseContentView;
@property (nonatomic,retain) IBOutlet UIScrollView* customiseScrollContentView;
@property (nonatomic,retain) UINavigationController* globalNavigationController;
@property (nonatomic,retain) NSString* navgationBarTitle;
@property (nonatomic,retain) NSMutableDictionary* tableCellData;
@property (nonatomic,retain) NSString* actionType;
@property (nonatomic,retain) NSString* descrTypeCode;

@end
