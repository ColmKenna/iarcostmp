//
//  TableWidgetViewController.h
//  Arcos
//
//  Created by David Kilmartin on 29/07/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WidgetViewController.h"
#import "GenericGroupedImageTableCell.h"
#import "EmailRecipientTableViewController.h"
#import "ArcosEmailValidator.h"
typedef enum {
    TableOrderStatusType = 0,
    TableOrderWholesalerType =1,
    TableOrderType = 2
} TableWidgetType;

typedef enum {
    TableWidgetRequestSourceDefault = 0,
    TableWidgetRequestSourcePresenter = 1,
    TableWidgetRequestSourceListing = 2,
    TableWidgetRequestSourceMasterContact = 3
} TableWidgetRequestSource;

@interface TableWidgetViewController : WidgetViewController <UITableViewDelegate,UITableViewDataSource,EmailRecipientDelegate,UIPopoverControllerDelegate> {
    id<WidgetViewControllerDelegate> _delegate;
    TableWidgetRequestSource _tableWidgetRequestSource;
    NSMutableArray* _displayList;
    NSString* _tableNavigationBarTitle;
    NSString* _parentContentString;
    IBOutlet UINavigationBar* tableNavigationBar;
    IBOutlet UINavigationItem* tableNavigationItem;
    EmailRecipientTableViewController* _emailRecipientTableViewController;
    UIPopoverController* _emailPopover;
    UIBarButtonItem* _emailButton;
    NSIndexPath* _currentIndexPath;
    UITableView* _myTableView;
}
@property(nonatomic, assign) id<WidgetViewControllerDelegate> delegate;
@property(nonatomic, assign) TableWidgetRequestSource tableWidgetRequestSource;
@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) NSString* tableNavigationBarTitle;
@property(nonatomic, retain) NSString* parentContentString;
@property(nonatomic, retain) IBOutlet UINavigationBar* tableNavigationBar;
@property(nonatomic, retain) IBOutlet UINavigationItem* tableNavigationItem;
@property(nonatomic,retain) EmailRecipientTableViewController* emailRecipientTableViewController;
@property(nonatomic, retain) UIPopoverController* emailPopover;
@property(nonatomic, retain) UIBarButtonItem* emailButton;
@property(nonatomic, retain) NSIndexPath* currentIndexPath;
@property(nonatomic, retain) IBOutlet UITableView* myTableView;

- (id)initWithDataList:(NSMutableArray*)aDataList withTitle:(NSString*)aTitle withParentContentString:(NSString*)aParentContentString;
- (id)initWithDataList:(NSMutableArray*)aDataList withTitle:(NSString*)aTitle withParentContentString:(NSString*)aParentContentString requestSource:(TableWidgetRequestSource)aTableWidgetRequestSource;

@end
