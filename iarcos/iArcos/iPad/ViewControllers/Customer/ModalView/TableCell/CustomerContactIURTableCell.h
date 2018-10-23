//
//  CustomerContactIURTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 26/06/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerBaseTableCell.h"
#import "WidgetFactory.h"

@interface CustomerContactIURTableCell : CustomerBaseTableCell<WidgetFactoryDelegate, UIPopoverControllerDelegate, UITextFieldDelegate> {
    UILabel* fieldDesc;
    UITextField* contentString;
    WidgetFactory* _factory;
    UIPopoverController* _thePopover;
}

@property(nonatomic,retain) IBOutlet UILabel* fieldDesc;
@property(nonatomic,retain) IBOutlet UITextField* contentString;
@property(nonatomic,retain) WidgetFactory* factory;
@property(nonatomic,retain) UIPopoverController* thePopover;

-(void)handleSingleTapGesture:(id)sender;
-(void)processDescrSelectionPopover;
-(void)processDescrSelectionCenter:(NSString*)aNavBarTitle dataList:(NSMutableArray*)aDataList;

@end
