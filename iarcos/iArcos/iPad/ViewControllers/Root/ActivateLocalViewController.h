//
//  ActivateLocalViewController.h
//  Arcos
//
//  Created by David Kilmartin on 16/04/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PresentViewControllerDelegate.h"
#import "FileCommon.h"
#import "ActivateLocalDataManager.h"
#import "ActivateEnterpriseViewController.h"
#import "ActivateLocalActionDelegate.h"
#import "ArcosUtils.h"
#import "ActivateAppStatusManager.h"
#import "ArcosXMLParser.h"

@interface ActivateLocalViewController : UIViewController <ActivateProgressViewUpdateDelegate> {
    id<PresentViewControllerDelegate> _presentDelegate;
    id<ActivateLocalActionDelegate> _actionDelegate;
    UILabel* _headerDescLabel;
    UIButton* _localButton;
    UIButton* _enterpriseButton;
    UILabel* _statusLabel;
    UIProgressView* _tableProgressView;
    UIProgressView* _myProgressView;
    UIView* _boardView;
    UIImageView* _backgroundImageView;
    ActivateLocalDataManager* _activateLocalDataManager;
    ActivateAppStatusManager* _activateAppStatusManager;
    ActivateConfigurationDataManager* _activateConfigurationDataManager;
}

@property(nonatomic, assign) id<PresentViewControllerDelegate> presentDelegate;
@property(nonatomic, assign) id<ActivateLocalActionDelegate> actionDelegate;
@property(nonatomic, retain) IBOutlet UILabel* headerDescLabel;
@property(nonatomic, retain) IBOutlet UIButton* localButton;
@property(nonatomic, retain) IBOutlet UIButton* enterpriseButton;
@property(nonatomic, retain) IBOutlet UILabel* statusLabel;
@property(nonatomic, retain) IBOutlet UIProgressView* tableProgressView;
@property(nonatomic, retain) IBOutlet UIProgressView* myProgressView;
@property(nonatomic, retain) IBOutlet UIView* boardView;
@property(nonatomic, retain) IBOutlet UIImageView* backgroundImageView;
@property(nonatomic, retain) ActivateLocalDataManager* activateLocalDataManager;
@property(nonatomic, retain) ActivateAppStatusManager* activateAppStatusManager;
@property(nonatomic, retain) ActivateConfigurationDataManager* activateConfigurationDataManager;

- (IBAction)useLocalData:(id)sender;
- (IBAction)useEnterpriseEdition:(id)sender;
- (IBAction)exitAction:(id)sender;

@end
