//
//  QueryOrderMemoIURTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 30/05/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QueryOrderTMBaseTableCell.h"
#import "WidgetFactory.h"

@interface QueryOrderMemoIURTableCell : QueryOrderTMBaseTableCell<UITextFieldDelegate, WidgetFactoryDelegate, UIPopoverControllerDelegate> {
    UILabel* _fieldDesc;
    UITextField* _contentString;
    WidgetFactory* _factory;
    UIPopoverController* _thePopover;
}

@property(nonatomic,retain) IBOutlet UILabel* fieldDesc;
@property(nonatomic,retain) IBOutlet UITextField* contentString;
@property(nonatomic,retain) WidgetFactory* factory;
@property(nonatomic,retain) UIPopoverController* thePopover;

- (void)processDescrSelectionPopover;
- (void)processDescrSelectionCenter:(NSString*)aNavBarTitle dataList:(NSMutableArray*)aDataList;
- (void)processContactDescrSelectionPopover;

@end
