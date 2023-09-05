//
//  QueryOrderTaskIURTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 28/05/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QueryOrderTMBaseTableCell.h"
#import "WidgetFactory.h"

@interface QueryOrderTaskIURTableCell : QueryOrderTMBaseTableCell<UITextFieldDelegate, WidgetFactoryDelegate, UIPopoverPresentationControllerDelegate> {
    UILabel* _fieldDesc;
    UITextField* _contentString;
    WidgetFactory* _factory;
//    UIPopoverController* _thePopover;
    WidgetViewController* _globalWidgetViewController;
}

@property(nonatomic,retain) IBOutlet UILabel* fieldDesc;
@property(nonatomic,retain) IBOutlet UITextField* contentString;
@property(nonatomic,retain) WidgetFactory* factory;
//@property(nonatomic,retain) UIPopoverController* thePopover;
@property(nonatomic,retain) WidgetViewController* globalWidgetViewController;

- (void)processDescrSelectionPopover;
- (void)processDescrSelectionCenter:(NSString*)aNavBarTitle dataList:(NSMutableArray*)aDataList;
- (void)processContactDescrSelectionPopover;

@end
