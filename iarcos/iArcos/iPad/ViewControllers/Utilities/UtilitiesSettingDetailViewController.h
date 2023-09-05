//
//  UtilitiesSettingDetailViewController.h
//  Arcos
//
//  Created by David Kilmartin on 05/09/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UtilitiesDetailViewController.h"
#import "SettingManager.h"
#import "SettingTableCellFactory.h"
#import "AlertPrompt.h"
#import "GlobalSharedClass.h"
#import "ArcosUtils.h"
@interface UtilitiesSettingDetailViewController : UtilitiesDetailViewController<SettingTableViewCellDelegate,UITextFieldDelegate> {
    SettingManager* settingManager;
    NSArray* settingGroups;
    SettingTableCellFactory* cellFactory;
//    UIPopoverController* _tablecellPopover;
    UIBarButtonItem* _saveButton;
    
    //manager password
    BOOL isAuthorized;
    UITextField *passwordField;
    NSString* managerPass;
    BOOL isAdvanceSettingChanged;
}
@property(nonatomic,retain) SettingManager* settingManager;
@property(nonatomic,retain) NSArray* settingGroups;
@property(nonatomic,retain)    SettingTableCellFactory* cellFactory;
//@property(nonatomic,retain) UIPopoverController* tablecellPopover;
@property(nonatomic,retain) UIBarButtonItem* saveButton;
-(void)updateValue:(id)data ForIndexpath:(NSIndexPath*)indexPath;
@end
