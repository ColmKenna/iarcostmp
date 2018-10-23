//
//  CustomerIURTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 09/01/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerBaseTableCell.h"
#import "WidgetFactory.h"
#import "CallGenericServices.h"

@interface CustomerIURTableCell : CustomerBaseTableCell <WidgetFactoryDelegate, UIPopoverControllerDelegate, UITextFieldDelegate> {
    IBOutlet UILabel* fieldDesc;
    IBOutlet UITextField* contentString;
    WidgetFactory* _factory;
    UIPopoverController* _thePopover;
    NSMutableArray* _masterLocationDisplayList;
    CallGenericServices* _callGenericService;
    NSString* _headQuarterTitle;
}

@property(nonatomic,retain) IBOutlet UILabel* fieldDesc;
@property(nonatomic,retain) IBOutlet UITextField* contentString;
@property(nonatomic,retain) WidgetFactory* factory;
@property(nonatomic,retain) UIPopoverController* thePopover;
@property(nonatomic,retain) NSMutableArray* masterLocationDisplayList;
@property(nonatomic, retain) CallGenericServices* callGenericServices;
@property(nonatomic, retain) NSString* headQuarterTitle;

-(void)handleSingleTapGesture:(id)sender;
-(void)processDescrSelectionPopover; 
-(void)processMasterLocationDescrSelectionPopover;
-(void)processDescrSelectionCenter:(NSString*)aNavBarTitle dataList:(NSMutableArray*)aDataList;

@end
