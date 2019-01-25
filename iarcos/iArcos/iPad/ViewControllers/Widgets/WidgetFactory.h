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
    WidgetDataSourceCustomerSurvey
} WidgetDataSource;

@protocol WidgetFactoryDelegate 

-(void)operationDone:(id)data;
@optional
-(void)dismissPopoverController;
-(BOOL)allowToShowAddContactButton;
-(void)emailPressedFromTablePopoverRow:(NSDictionary*)cellData groupName:(NSString*)aGroupName;
-(BOOL)allowToShowAddAccountNoButton;
@end

@interface WidgetFactory : NSObject <WidgetViewControllerDelegate>{
    UIPopoverController* _popoverController;
    id <WidgetFactoryDelegate> delegate;
    id tempData;

}
@property(nonatomic,retain)    UIPopoverController* popoverController;
@property(nonatomic,assign)id <WidgetFactoryDelegate> delegate;
@property(nonatomic,retain) id tempData;


+(WidgetFactory*)factory;
-(UIPopoverController*)CreateDateWidgetWithDataSource:(WidgetDataSource)dataSource;
-(UIPopoverController*)CreateDateWidgetWithDataSource:(WidgetDataSource)dataSource defaultPickerDate:(NSDate*)aDefaultPickerDate;
-(UIPopoverController*)CreateDateWidgetWithDataSource:(WidgetDataSource)dataSource pickerFormatType:(DatePickerFormatType)aPickerFormatType;
-(UIPopoverController*)CreateDateWidgetWithDataSource:(WidgetDataSource)dataSource pickerFormatType:(DatePickerFormatType)aPickerFormatType defaultPickerDate:(NSDate*)aDefaultPickerDate;
- (UIPopoverController*)createDateHourMinuteWidgetWithType:(DatePickerHourMinuteWidgetType)aType datePickerValue:(NSDate*)aDatePickerValue minDate:(NSDate*)aMinDate maxDate:(NSDate*)aMaxDate;

-(UIPopoverController*)CreateCategoryWidgetWithDataSource:(WidgetDataSource)dataSource;
-(UIPopoverController*)CreateNumberWidgetWithType:(NumberWidgetType)type;
-(UIPopoverController*)CreateOrderInputPadWidgetWithLocationIUR:(NSNumber*)aLocationIUR;
-(UIPopoverController*)CreateDetaillingInputPadWidgetWithProductName:(NSString*)aProductName WithQty:(NSNumber*)aQty;
-(PickerWidgetViewController*)getSampleBatchesPickerWidget;

-(UIPopoverController*)CreateGenericCategoryWidgetWithDataSource:(WidgetDataSource)dataSource pickerDefaultValue:(NSNumber*)aDefaultIURValue;
-(UIPopoverController*)CreateGenericCategoryWidgetWithPickerValue:(NSMutableArray*)aPickerValue;
-(UIPopoverController*)CreateGenericCategoryWidgetWithPickerValue:(NSMutableArray*)aPickerValue title:(NSString*)aTitle;
-(UIPopoverController*)CreateGenericDynamicCategoryWidgetWithPickerValue:(NSMutableArray*)aPickerValue title:(NSString*)aTitle maxTextLength:(int)aMaxTextLength;
-(UIPopoverController*)CreateTargetGenericCategoryWidgetWithPickerValue:(NSMutableArray*)aPickerValue miscDataDict:(NSMutableDictionary*)aDataDict;
-(UIPopoverController*)CreateTargetGenericCategoryWidgetWithUncheckedPickerValue:(NSMutableArray*)aPickerValue miscDataDict:(NSMutableDictionary*)aDataDict;
-(UIPopoverController*)CreateTableWidgetWithData:(NSMutableArray*)aDataList withTitle:(NSString*)aTitle withParentContentString:(NSString*)aParentContentString;
-(UIPopoverController*)CreateTableWidgetWithData:(NSMutableArray*)aDataList withTitle:(NSString*)aTitle withParentContentString:(NSString*)aParentContentString requestSource:(TableWidgetRequestSource)aTableWidgetRequestSource;
-(UIPopoverController*)CreateTableMSWidgetWithData:(NSMutableArray*)aDataList withTitle:(NSString*)aTitle withParentItemList:(NSMutableArray*)aParentItemList requestSource:(TableMSWidgetRequestSource)aTableMSWidgetRequestSource;
-(UIPopoverController*)CreateGenericTableMSWidgetWithData:(NSMutableArray*)aDataList withTitle:(NSString*)aTitle withParentItemList:(NSMutableArray*)aParentItemList;

- (void)processPopoverController:(WidgetViewController*)wvc;
@end
