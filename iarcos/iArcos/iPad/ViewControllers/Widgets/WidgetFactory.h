//
//  WidgetFactory.h
//  Arcos
//
//  Created by David Kilmartin on 29/07/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PickerWidgetViewController.h"
#import "DatePickerWidgetViewController.h"
#import "TableWidgetViewController.h"
#import "NumberWidgetViewController.h"
#import "OrderInputPadViewController.h"
#import "TableMSWidgetViewController.h"
#import "ArcosConfigDataManager.h"
#import "DatePickerHourMinuteWidgetViewController.h"
#import "TableGenericMSWidgetViewController.h"
#import "OrderEntryInputViewController.h"
#import "OrderEntryInputRightHandSideGridViewController.h"
typedef enum {
    WidgetDataSourceDeliveryDate = 0,
    WidgetDataSourceOrderDate,
    WidgetDataSourceNormalDate,
    WidgetDataSourceOrderStatus,
    WidgetDataSourceOrderWholesaler,
    WidgetDataSourceOrderType,
    WidgetDataSourceCallType,
    WidgetDataSourceContact,
    WidgetDataSourceLocationType,
    WidgetDataSourceContactType,
    WidgetDataSourceFormType,
    WidgetDataSourceMemoType,
    WidgetDataSourceDetaillingQA,
    WidgetDataSourceDetaillingBatch,
    WidgetDataSourceTitleType,
    WidgetDataSourceCustomerSurvey,
    WidgetDataSourcePriceGroup
} WidgetDataSource;

@protocol WidgetFactoryDelegate 

-(void)operationDone:(id)data;
@optional
-(void)dismissPopoverController;
-(BOOL)allowToShowAddContactButton;
-(void)emailPressedFromTablePopoverRow:(NSDictionary*)cellData groupName:(NSString*)aGroupName;
-(BOOL)allowToShowAddAccountNoButton;
- (BOOL)allowToShowAddContactFlagButton;
@end

@interface WidgetFactory : NSObject <WidgetViewControllerDelegate>{
//    UIPopoverController* _popoverController;
    id <WidgetFactoryDelegate> delegate;
    id tempData;

}
//@property(nonatomic,retain)    UIPopoverController* popoverController;
@property(nonatomic,assign)id <WidgetFactoryDelegate> delegate;
@property(nonatomic,retain) id tempData;


+(WidgetFactory*)factory;
-(WidgetViewController*)CreateDateWidgetWithDataSource:(WidgetDataSource)dataSource;
-(WidgetViewController*)CreateDateWidgetWithDataSource:(WidgetDataSource)dataSource defaultPickerDate:(NSDate*)aDefaultPickerDate;
-(WidgetViewController*)CreateDateWidgetWithDataSource:(WidgetDataSource)dataSource pickerFormatType:(DatePickerFormatType)aPickerFormatType;
-(WidgetViewController*)CreateDateWidgetWithDataSource:(WidgetDataSource)dataSource pickerFormatType:(DatePickerFormatType)aPickerFormatType defaultPickerDate:(NSDate*)aDefaultPickerDate;
- (WidgetViewController*)createDateHourMinuteWidgetWithType:(DatePickerHourMinuteWidgetType)aType datePickerValue:(NSDate*)aDatePickerValue minDate:(NSDate*)aMinDate maxDate:(NSDate*)aMaxDate;

-(WidgetViewController*)CreateCategoryWidgetWithDataSource:(WidgetDataSource)dataSource;
//-(UIPopoverController*)CreateNumberWidgetWithType:(NumberWidgetType)type;
-(WidgetViewController*)CreateOrderInputPadWidgetWithLocationIUR:(NSNumber*)aLocationIUR;
-(WidgetViewController*)CreateOrderEntryInputWidgetWithLocationIUR:(NSNumber*)aLocationIUR;
-(WidgetViewController*)CreateOrderEntryInputRightHandSideWidgetWithLocationIUR:(NSNumber*)aLocationIUR;
-(WidgetViewController*)CreateDetaillingInputPadWidgetWithProductName:(NSString*)aProductName WithQty:(NSNumber*)aQty;
-(PickerWidgetViewController*)getSampleBatchesPickerWidget;

-(WidgetViewController*)CreateGenericCategoryWidgetWithDataSource:(WidgetDataSource)dataSource pickerDefaultValue:(NSNumber*)aDefaultIURValue;
//-(UIPopoverController*)CreateGenericCategoryWidgetWithPickerValue:(NSMutableArray*)aPickerValue;
-(WidgetViewController*)CreateGenericCategoryWidgetWithPickerValue:(NSMutableArray*)aPickerValue title:(NSString*)aTitle;
-(WidgetViewController*)CreateGenericDynamicCategoryWidgetWithPickerValue:(NSMutableArray*)aPickerValue title:(NSString*)aTitle maxTextLength:(int)aMaxTextLength;
-(WidgetViewController*)CreateTargetGenericCategoryWidgetWithPickerValue:(NSMutableArray*)aPickerValue miscDataDict:(NSMutableDictionary*)aDataDict;
-(WidgetViewController*)CreateTargetGenericCategoryWidgetWithUncheckedPickerValue:(NSMutableArray*)aPickerValue miscDataDict:(NSMutableDictionary*)aDataDict ignoreDataCheckFlag:(BOOL)anIgnoreDataCheckFlag;
-(WidgetViewController*)CreateTableWidgetWithData:(NSMutableArray*)aDataList withTitle:(NSString*)aTitle withParentContentString:(NSString*)aParentContentString;
-(WidgetViewController*)CreateTableWidgetWithData:(NSMutableArray*)aDataList withTitle:(NSString*)aTitle withParentContentString:(NSString*)aParentContentString requestSource:(TableWidgetRequestSource)aTableWidgetRequestSource;
-(WidgetViewController*)CreateTableMSWidgetWithData:(NSMutableArray*)aDataList withTitle:(NSString*)aTitle withParentItemList:(NSMutableArray*)aParentItemList requestSource:(TableMSWidgetRequestSource)aTableMSWidgetRequestSource;
-(WidgetViewController*)CreateGenericTableMSWidgetWithData:(NSMutableArray*)aDataList withTitle:(NSString*)aTitle withParentItemList:(NSMutableArray*)aParentItemList;

- (void)processPopoverController:(WidgetViewController*)wvc;
@end
