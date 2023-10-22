//
//  FlagsSelectedContactTableViewController.h
//  iArcos
//
//  Created by Richard on 05/10/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlagsSelectedContactDataManager.h"
#import "ArcosUtils.h"
#import "FlagsSelectedContactTableViewControllerDelegate.h"
#import "WidgetViewController.h"
#import "WidgetFactory.h"

@interface FlagsSelectedContactTableViewController : UITableViewController <WidgetFactoryDelegate, UIPopoverPresentationControllerDelegate>{
    id<FlagsSelectedContactTableViewControllerDelegate> _actionDelegate;
    FlagsSelectedContactDataManager* _flagsSelectedContactDataManager;
    WidgetViewController* _globalWidgetViewController;
    WidgetFactory* _widgetFactory;
    UIBarButtonItem* _flagsButton;
    ArcosService* _arcosService;
}

@property(nonatomic,assign) id<FlagsSelectedContactTableViewControllerDelegate> actionDelegate;
@property(nonatomic,retain) FlagsSelectedContactDataManager* flagsSelectedContactDataManager;
@property(nonatomic,retain) WidgetViewController* globalWidgetViewController;
@property(nonatomic,retain) WidgetFactory* widgetFactory;
@property(nonatomic,retain) IBOutlet UIBarButtonItem* flagsButton;
@property(nonatomic,retain) ArcosService* arcosService;

- (void)resetSelectedContact:(NSMutableArray*)aContactList;

@end

