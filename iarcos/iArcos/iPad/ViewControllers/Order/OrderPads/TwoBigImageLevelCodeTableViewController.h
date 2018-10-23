//
//  TwoBigImageLevelCodeTableViewController.h
//  Arcos
//
//  Created by David Kilmartin on 07/11/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BranchLeafProductGridViewController.h"
#import "TwoBigImageLevelCodeDataManager.h"
#import "TwoBigImageLevelCodeTableViewCell.h"

@interface TwoBigImageLevelCodeTableViewController : UITableViewController<TwoBigImageLevelCodeDelegate, BranchLeafProductNavigationTitleDelegate> {
    TwoBigImageLevelCodeDataManager* _twoBigImageLevelCodeDataManager;
    NSString* _formType;
    BOOL _isNotFirstLoaded;
    id<OrderFormNavigationControllerBackButtonDelegate> _backButtonDelegate;
    id<BranchLeafProductNavigationTitleDelegate> _navigationTitleDelegate;
    
}

@property(nonatomic, retain) TwoBigImageLevelCodeDataManager* twoBigImageLevelCodeDataManager;
@property(nonatomic, retain) NSString* formType;
@property (nonatomic, assign) BOOL isNotFirstLoaded;
@property (nonatomic, assign) id<OrderFormNavigationControllerBackButtonDelegate> backButtonDelegate;
@property (nonatomic, assign) id<BranchLeafProductNavigationTitleDelegate> navigationTitleDelegate;

@end
