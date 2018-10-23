//
//  TableMSWidgetViewController.h
//  Arcos
//
//  Created by David Kilmartin on 30/09/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WidgetViewController.h"
#import "GenericGroupedImageTableCell.h"
#import "ArcosCoreData.h"
typedef enum {
    TableMSWidgetRequestSourceDefault = 0
} TableMSWidgetRequestSource;

@interface TableMSWidgetViewController : WidgetViewController<UITableViewDelegate,UITableViewDataSource> {
    id<WidgetViewControllerDelegate> _delegate;
    TableMSWidgetRequestSource _tableMSWidgetRequestSource;
    UITableView* _myTableView;
    UINavigationBar* _myNavigationBar;
    NSString* _myNavBarTitle;
    NSMutableArray* _displayList;
    NSMutableArray* _parentItemList;
}

@property(nonatomic, assign) id<WidgetViewControllerDelegate> delegate;
@property(nonatomic, assign) TableMSWidgetRequestSource tableMSWidgetRequestSource;
@property(nonatomic, retain) IBOutlet UITableView* myTableView;
@property(nonatomic, retain) IBOutlet UINavigationBar* myNavigationBar;
@property(nonatomic, retain) NSString* myNavBarTitle;
@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) NSMutableArray* parentItemList;

- (id)initWithDataList:(NSMutableArray*)aDataList withTitle:(NSString*)aTitle withParentItemList:(NSMutableArray*)aParentItemList requestSource:(TableMSWidgetRequestSource)aTableMSWidgetRequestSource;

@end
