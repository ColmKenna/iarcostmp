//
//  ArcosAlertBoxViewController.h
//  iArcos
//
//  Created by Richard on 12/12/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArcosAlertBoxViewControllerDelegate.h"
#import "OrderSharedClass.h"
#import "ArcosUtils.h"
#import "ArcosConfigDataManager.h"
#import "ArcosAlertBoxDataManager.h"

@interface ArcosAlertBoxViewController : UIViewController {
    id<ArcosAlertBoxViewControllerDelegate> _actionDelegate;
    UIView* _templateView;
    UINavigationBar* _myNavigationBar;
    UILabel* _qtyDesc;
    UILabel* _qtyValue;
    UILabel* _bonusDesc;
    UILabel* _bonusValue;
    UILabel* _qtySplitDesc;
    UILabel* _qtySplitValue;
    UILabel* _bonusSplitDesc;
    UILabel* _bonusSplitValue;
    UILabel* _discDesc;
    UILabel* _discValue;
    UILabel* _totalDesc;
    UILabel* _totalValue;
    UILabel* _msgValue;
    UIButton* _amendButton;
    UIButton* _saveButton;
    BOOL _disableSaveButtonFlag;
    BOOL _checkWholesalerFlag;
    NSString* _messageContent;
    ArcosAlertBoxDataManager* _arcosAlertBoxDataManager;
}

@property(nonatomic, assign) id<ArcosAlertBoxViewControllerDelegate> actionDelegate;
@property(nonatomic, retain) IBOutlet UIView* templateView;
@property(nonatomic, retain) IBOutlet UINavigationBar* myNavigationBar;
@property(nonatomic, retain) IBOutlet UILabel* qtyDesc;
@property(nonatomic, retain) IBOutlet UILabel* qtyValue;
@property(nonatomic, retain) IBOutlet UILabel* bonusDesc;
@property(nonatomic, retain) IBOutlet UILabel* bonusValue;
@property(nonatomic, retain) IBOutlet UILabel* qtySplitDesc;
@property(nonatomic, retain) IBOutlet UILabel* qtySplitValue;
@property(nonatomic, retain) IBOutlet UILabel* bonusSplitDesc;
@property(nonatomic, retain) IBOutlet UILabel* bonusSplitValue;
@property(nonatomic, retain) IBOutlet UILabel* discDesc;
@property(nonatomic, retain) IBOutlet UILabel* discValue;
@property(nonatomic, retain) IBOutlet UILabel* totalDesc;
@property(nonatomic, retain) IBOutlet UILabel* totalValue;
@property(nonatomic, retain) IBOutlet UILabel* msgValue;
@property(nonatomic, retain) IBOutlet UIButton* amendButton;
@property(nonatomic, retain) IBOutlet UIButton* saveButton;
@property(nonatomic, assign) BOOL disableSaveButtonFlag;
@property(nonatomic, assign) BOOL checkWholesalerFlag;
@property(nonatomic, retain) NSString* messageContent;
@property(nonatomic, retain) ArcosAlertBoxDataManager* arcosAlertBoxDataManager;

- (IBAction)didAmendButtonPressed:(id)sender;
- (IBAction)didSaveButtonPressed:(id)sender;

@end

