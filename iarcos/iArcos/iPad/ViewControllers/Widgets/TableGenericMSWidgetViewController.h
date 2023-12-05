//
//  TableGenericMSWidgetViewController.h
//  iArcos
//
//  Created by David Kilmartin on 24/01/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WidgetViewController.h"
#import "GenericGroupedImageTableCell.h"
#import "ArcosCoreData.h"

@interface TableGenericMSWidgetViewController : WidgetViewController {
    id<WidgetViewControllerDelegate> _delegate;
    UITableView* _myTableView;
    UINavigationBar* _myNavigationBar;
    NSString* _myNavBarTitle;
    NSMutableArray* _displayList;
    NSMutableArray* _parentItemList;
    NSMutableDictionary* _tableItemCart;
}

@property(nonatomic, assign) id<WidgetViewControllerDelegate> delegate;
@property(nonatomic, retain) IBOutlet UITableView* myTableView;
@property(nonatomic, retain) IBOutlet UINavigationBar* myNavigationBar;
@property(nonatomic, retain) NSString* myNavBarTitle;
@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) NSMutableArray* parentItemList;
@property(nonatomic, retain) NSMutableDictionary* tableItemCart;

- (instancetype)initWithDataList:(NSMutableArray*)aDataList withTitle:(NSString*)aTitle withParentItemList:(NSMutableArray*)aParentItemList;

@end

