//
//  WidgetFactory.m
//  Arcos
//
//  Created by David Kilmartin on 29/07/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "WidgetFactory.h"


@interface WidgetFactory (Private)
//need to be private
-(NSMutableDictionary*)getDataWithType:(WidgetDataSource)datasource;
-(PickerWidgetViewController*)getPickerWidgetWithType:(PickerWidgetType)type;
-(TableWidgetViewController*)getTableWidgetWithType:(TableWidgetType)type;
-(DatePickerWidgetViewController*)getDatePickerWidgetWithType:(DatePickerWidgetType)type;
-(NumberWidgetViewController*)getNumberWidgetWithTyp:(NumberWidgetType*)type;
@end

@implementation WidgetFactory

//@synthesize popoverController = _popoverController;
@synthesize delegate;
@synthesize tempData;

-(id)init{
    self=[super init];
    if (self!=nil) {
        
    }
    return self;
}

+(WidgetFactory*)factory{
    return [[[WidgetFactory alloc]init]autorelease];
}
-(WidgetViewController*)CreateDateWidgetWithDataSource:(WidgetDataSource)dataSource{
    WidgetViewController* wvc = nil;
    switch (dataSource) {
        case WidgetDataSourceNormalDate:
            wvc=[self getDatePickerWidgetWithType:DatePickerNormalDateType];
            break;
        case WidgetDataSourceDeliveryDate:
            wvc=[self getDatePickerWidgetWithType:DatePickerDeliveryDateType];
            break;
        case WidgetDataSourceOrderDate:
            wvc=[self getDatePickerWidgetWithType:DatePickerOrderDateType];
            break;
        default:
            break;
    }
    
//    self.popoverController = [[[UIPopoverController alloc]initWithContentViewController:wvc] autorelease];
//    self.popoverController.popoverContentSize=wvc.view.frame.size;
    wvc.preferredContentSize = wvc.view.frame.size;
    wvc.delegate=self;
//    return self.popoverController;
    return wvc;
}
-(WidgetViewController*)CreateDateWidgetWithDataSource:(WidgetDataSource)dataSource defaultPickerDate:(NSDate*)aDefaultPickerDate {
    WidgetViewController* wvc = nil;
    switch (dataSource) {
        case WidgetDataSourceNormalDate:
            wvc=[[[DatePickerWidgetViewController alloc]initWithType:DatePickerNormalDateType defaultPickerDate:aDefaultPickerDate]autorelease];
            break;
        case WidgetDataSourceOrderDate:
            wvc=[[[DatePickerWidgetViewController alloc]initWithType:DatePickerOrderDateType defaultPickerDate:aDefaultPickerDate]autorelease];
            break;
        case WidgetDataSourceDeliveryDate:
            wvc=[[[DatePickerWidgetViewController alloc]initWithType:DatePickerDeliveryDateType defaultPickerDate:aDefaultPickerDate]autorelease];
            break;
        default:
            break;
    }
    
//    self.popoverController = [[[UIPopoverController alloc]initWithContentViewController:wvc] autorelease];
//    self.popoverController.popoverContentSize=wvc.view.frame.size;
    wvc.preferredContentSize = wvc.view.frame.size;
    wvc.delegate=self;
//    return self.popoverController;
    return wvc;
}

-(WidgetViewController*)CreateDateWidgetWithDataSource:(WidgetDataSource)dataSource pickerFormatType:(DatePickerFormatType)aPickerFormatType {
    WidgetViewController* wvc = nil;
    switch (dataSource) {
        case WidgetDataSourceOrderDate:
            wvc=[[[DatePickerWidgetViewController alloc]initWithType:DatePickerOrderDateType pickerFormatType:aPickerFormatType]autorelease];
            break;
        case WidgetDataSourceNormalDate:
            wvc=[[[DatePickerWidgetViewController alloc]initWithType:DatePickerNormalDateType pickerFormatType:aPickerFormatType]autorelease];
            break;
        default:
            break;
    }
    
//    self.popoverController = [[[UIPopoverController alloc]initWithContentViewController:wvc] autorelease];
//    self.popoverController.popoverContentSize=wvc.view.frame.size;
    wvc.preferredContentSize = wvc.view.frame.size;
    wvc.delegate=self;
//    return self.popoverController;
    return wvc;
}

-(WidgetViewController*)CreateDateWidgetWithDataSource:(WidgetDataSource)dataSource pickerFormatType:(DatePickerFormatType)aPickerFormatType defaultPickerDate:(NSDate*)aDefaultPickerDate {
    WidgetViewController* wvc = nil;
    switch (dataSource) {
        case WidgetDataSourceOrderDate:
            wvc=[[[DatePickerWidgetViewController alloc]initWithType:DatePickerOrderDateType pickerFormatType:aPickerFormatType defaultPickerDate:aDefaultPickerDate]autorelease];
            break;
        case WidgetDataSourceNormalDate:
            wvc=[[[DatePickerWidgetViewController alloc]initWithType:DatePickerNormalDateType pickerFormatType:aPickerFormatType defaultPickerDate:aDefaultPickerDate]autorelease];
            break;
        case WidgetDataSourceDeliveryDate:
            wvc=[[[DatePickerWidgetViewController alloc]initWithType:DatePickerDeliveryDateType pickerFormatType:aPickerFormatType defaultPickerDate:aDefaultPickerDate]autorelease];
            break;
        default:
            break;
    }
    
//    self.popoverController = [[[UIPopoverController alloc]initWithContentViewController:wvc] autorelease];
//    self.popoverController.popoverContentSize=wvc.view.frame.size;
    wvc.preferredContentSize = wvc.view.frame.size;
    wvc.delegate=self;
//    return self.popoverController;
    return wvc;
}

- (WidgetViewController*)createDateHourMinuteWidgetWithType:(DatePickerHourMinuteWidgetType)aType datePickerValue:(NSDate*)aDatePickerValue minDate:(NSDate*)aMinDate maxDate:(NSDate*)aMaxDate {
    WidgetViewController* wvc = [[[DatePickerHourMinuteWidgetViewController alloc] initWithType:aType datePickerValue:aDatePickerValue minDate:aMinDate maxDate:aMaxDate] autorelease];
//    self.popoverController = [[[UIPopoverController alloc]initWithContentViewController:wvc] autorelease];
//    self.popoverController.popoverContentSize = wvc.view.frame.size;
    wvc.preferredContentSize = wvc.view.frame.size;
    wvc.delegate = self;
//    return self.popoverController;
    return wvc;
}

-(WidgetViewController*)CreateCategoryWidgetWithDataSource:(WidgetDataSource)dataSource{
    WidgetViewController*wvc = nil;
    switch (dataSource) {
        case WidgetDataSourceOrderStatus:
            wvc=[self getPickerWidgetWithType:PickerOrderStatusType];
            break;
        case WidgetDataSourceOrderType:
            wvc=[self getPickerWidgetWithType:PickerOrderType];
            break;
        case WidgetDataSourceCallType:
            wvc=[self getPickerWidgetWithType:PickerCallType];
            break;
        case WidgetDataSourceOrderWholesaler:
            wvc=[self getPickerWidgetWithType:PickerOrderWholesalerType];
            break;
        case WidgetDataSourceContact:
            wvc=[self getPickerWidgetWithType:PickerContactType];
            break;
        case WidgetDataSourceLocationType:
            wvc=[self getPickerWidgetWithType:PickerLocationType];
            break;
        case WidgetDataSourceContactType:
            wvc=[self getPickerWidgetWithType:PickerSettingContactType];
            break;
        case WidgetDataSourceFormType:
            wvc=[self getPickerWidgetWithType:PickerFormType];
            break;
        case WidgetDataSourceMemoType:
            wvc=[self getPickerWidgetWithType:PickerMemoType];
            break;
//        case WidgetDataSourceDeliveryDate:
//            wvc=[self getPickerWidgetWithType:WidgetDataSourceDeliveryDate];
//            break;
        case WidgetDataSourceDetaillingQA:
            wvc=[self getPickerWidgetWithType:PickerDetailingType];
            break;
        case WidgetDataSourceDetaillingBatch:
            wvc=[self getSampleBatchesPickerWidget];
            break;
        case WidgetDataSourceTitleType:
            wvc=[self getPickerWidgetWithType:PickerTitleType];
            break;
        case WidgetDataSourceCustomerSurvey:
            wvc = [self getPickerWidgetWithType:PickerCustomerSurvey];
            break;
        case WidgetDataSourcePriceGroup:
            wvc = [self getPickerWidgetWithType:PickerPriceGroup];
            break;
        default:
            break;
    }
    
//    self.popoverController = [[[UIPopoverController alloc]initWithContentViewController:wvc] autorelease];
//    self.popoverController.popoverContentSize=wvc.view.frame.size;
    wvc.preferredContentSize = wvc.view.frame.size;
    wvc.delegate=self;
    
    //no data  return nil
    if (!wvc.anyDataSource) {
        return nil;
    }
//    return self.popoverController;
    return wvc;
}
//-(UIPopoverController*)CreateNumberWidgetWithType:(NumberWidgetType)type{
//    return self.popoverController;
//}

-(WidgetViewController*)CreateOrderInputPadWidgetWithLocationIUR:(NSNumber*)aLocationIUR{
    WidgetViewController* wvc = [[[OrderInputPadViewController alloc]initWithNibName:@"OrderInputPadViewController" bundle:nil]autorelease];
    wvc.locationIUR = aLocationIUR;
//    self.popoverController = [[[UIPopoverController alloc]initWithContentViewController:wvc] autorelease];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showMATWithQtyPopoverFlag]) {
//        self.popoverController.popoverContentSize = wvc.view.frame.size;
        wvc.preferredContentSize = wvc.view.frame.size;
    } else {
//        self.popoverController.popoverContentSize = [GlobalSharedClass shared].numberPadSize;
//        self.popoverController.popoverContentSize = CGSizeMake(470.0, wvc.view.frame.size.height);
        wvc.preferredContentSize = CGSizeMake(470.0, wvc.view.frame.size.height);
    }
    
    wvc.delegate=self;
//    return self.popoverController;
    return wvc;
}
-(WidgetViewController*)CreateOrderEntryInputWidgetWithLocationIUR:(NSNumber*)aLocationIUR {
    WidgetViewController* wvc = [[[OrderEntryInputViewController alloc] initWithNibName:@"OrderEntryInputViewController" bundle:nil] autorelease];
    wvc.locationIUR = aLocationIUR;
//    self.popoverController = [[[UIPopoverController alloc]initWithContentViewController:wvc] autorelease];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showMATWithQtyPopoverFlag]) {
//        self.popoverController.popoverContentSize = wvc.view.frame.size;
        wvc.preferredContentSize = wvc.view.frame.size;
    } else {
//        self.popoverController.popoverContentSize = CGSizeMake(470.0, wvc.view.frame.size.height);
        wvc.preferredContentSize = CGSizeMake(470.0, wvc.view.frame.size.height);
    }
    
    wvc.delegate=self;
//    return self.popoverController;
    return wvc;
}
-(WidgetViewController*)CreateOrderEntryInputRightHandSideWidgetWithLocationIUR:(NSNumber*)aLocationIUR {
    WidgetViewController* wvc = [[[OrderEntryInputRightHandSideGridViewController alloc] initWithNibName:@"OrderEntryInputRightHandSideGridViewController" bundle:nil] autorelease];
    wvc.locationIUR = aLocationIUR;
//    self.popoverController = [[[UIPopoverController alloc]initWithContentViewController:wvc] autorelease];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showMATWithQtyPopoverFlag]) {
//        self.popoverController.popoverContentSize = wvc.view.frame.size;
        wvc.preferredContentSize = wvc.view.frame.size;
    } else {
//        self.popoverController.popoverContentSize = CGSizeMake(598.0, wvc.view.frame.size.height);
        wvc.preferredContentSize = CGSizeMake(598.0, wvc.view.frame.size.height);
    }
    
    wvc.delegate=self;
//    return self.popoverController;
    return wvc;
}

-(WidgetViewController*)CreateDetaillingInputPadWidgetWithProductName:(NSString*)aProductName WithQty:(NSNumber*)aQty{
    OrderInputPadViewController* oipvc=[[[OrderInputPadViewController alloc]initWithNibName:@"OrderInputPadViewController" bundle:nil]autorelease];
    
    oipvc.isDetaillingType=YES;
    NSMutableDictionary* dummyData=[NSMutableDictionary dictionary];
    [dummyData setObject:aQty forKey:@"Qty"];
    [dummyData setObject:[NSNumber numberWithInt:0] forKey:@"Bonus"];
    [dummyData setObject:[NSNumber numberWithFloat:0.0f] forKey:@"DiscountPercent"];
    [dummyData setObject:aProductName forKey:@"Details"];
    oipvc.Data=dummyData;
    
//    WidgetViewController*wvc=(WidgetViewController*)oipvc;
    
//    self.popoverController = [[[UIPopoverController alloc]initWithContentViewController:wvc] autorelease];
//    self.popoverController.popoverContentSize=wvc.view.frame.size;
//    self.popoverController.popoverContentSize = CGSizeMake(470.0, oipvc.view.frame.size.height);//[GlobalSharedClass shared].numberPadSize;
    oipvc.preferredContentSize = CGSizeMake(470.0, oipvc.view.frame.size.height);
    oipvc.delegate=self;
//    return self.popoverController;
    return oipvc;
}
#pragma mark Private methods
-(NSMutableDictionary*)getDataWithType:(WidgetDataSource)datasource{
    return [NSMutableDictionary dictionary];
}
-(DatePickerWidgetViewController*)getDatePickerWidgetWithType:(DatePickerWidgetType)type{
    DatePickerWidgetViewController* dpwvc=[[[DatePickerWidgetViewController alloc]initWithType:type]autorelease];
    return dpwvc;
}
-(PickerWidgetViewController*)getPickerWidgetWithType:(PickerWidgetType)type{
    PickerWidgetViewController* pwvc=[[[PickerWidgetViewController alloc]initWithType:type]autorelease];
    return pwvc;
}
-(PickerWidgetViewController*)getSampleBatchesPickerWidget{
    PickerWidgetViewController* pwvc=[[[PickerWidgetViewController alloc]initWithType:PickerDetailingBatchType]autorelease];
    pwvc.tempData=self.tempData;
    [pwvc resetPickerData];
//    NSLog(@"temp data in factory is %@",self.tempData);
    return pwvc;
}

-(WidgetViewController*)CreateGenericCategoryWidgetWithDataSource:(WidgetDataSource)dataSource pickerDefaultValue:(NSNumber*)aDefaultIURValue {
    WidgetViewController* wvc = nil;
    switch (dataSource) {
        case WidgetDataSourceOrderStatus:            
            wvc = [[[PickerWidgetViewController alloc] initWithType:PickerOrderStatusType pickerDefaultValue:aDefaultIURValue] autorelease];
            break;
        
        default:
            break;
    }
    
//    self.popoverController = [[[UIPopoverController alloc]initWithContentViewController:wvc] autorelease];
//    self.popoverController.popoverContentSize=wvc.view.frame.size;
    wvc.preferredContentSize = wvc.view.frame.size;
    wvc.delegate=self;
    
    //no data  return nil
    if (!wvc.anyDataSource) {
        return nil;
    }
//    return self.popoverController;
    return wvc;
}
/*
-(UIPopoverController*)CreateGenericCategoryWidgetWithPickerValue:(NSMutableArray*)aPickerValue {
    WidgetViewController* wvc = [[[PickerWidgetViewController alloc] initWithPickerValue:aPickerValue] autorelease];
    
    self.popoverController = [[[UIPopoverController alloc]initWithContentViewController:wvc] autorelease];
    self.popoverController.popoverContentSize=wvc.view.frame.size;
//    wvc.preferredContentSize = wvc.view.frame.size;
    wvc.delegate=self;
    
    //no data  return nil
    if (!wvc.anyDataSource) {
        return nil;
    }
    return self.popoverController;
//    return wvc;
}*/

-(WidgetViewController*)CreateGenericCategoryWidgetWithPickerValue:(NSMutableArray*)aPickerValue title:(NSString*)aTitle {
    WidgetViewController* wvc = [[[PickerWidgetViewController alloc] initWithPickerValue:aPickerValue title:aTitle] autorelease];
    
//    self.popoverController = [[[UIPopoverController alloc]initWithContentViewController:wvc] autorelease];
//    self.popoverController.popoverContentSize=wvc.view.frame.size;
    wvc.preferredContentSize = wvc.view.frame.size;
    wvc.delegate=self;
    
    //no data  return nil
    if (!wvc.anyDataSource) {
        return nil;
    }
//    return self.popoverController;
    return wvc;
}

-(WidgetViewController*)CreateGenericDynamicCategoryWidgetWithPickerValue:(NSMutableArray*)aPickerValue title:(NSString*)aTitle maxTextLength:(int)aMaxTextLength {
    PickerWidgetViewController* wvc = [[[PickerWidgetViewController alloc] initWithPickerValue:aPickerValue title:aTitle] autorelease];
    wvc.dynamicWidthFlag = YES;
    wvc.maxTextLength = aMaxTextLength;
//    self.popoverController = [[[UIPopoverController alloc]initWithContentViewController:wvc] autorelease];
//    self.popoverController.popoverContentSize=wvc.view.frame.size;
    wvc.preferredContentSize = wvc.view.frame.size;
    wvc.delegate=self;
    
    //no data  return nil
    if (!wvc.anyDataSource) {
        return nil;
    }
//    return self.popoverController;
    return wvc;
}

-(WidgetViewController*)CreateTargetGenericCategoryWidgetWithPickerValue:(NSMutableArray*)aPickerValue miscDataDict:(NSMutableDictionary*)aDataDict{
    WidgetViewController* wvc = [[[PickerWidgetViewController alloc] initWithPickerValue:aPickerValue miscDataDict:aDataDict delegate:self] autorelease];
    
    //no data  return nil
//    self.popoverController = [[[UIPopoverController alloc]initWithContentViewController:wvc] autorelease];
//    self.popoverController.popoverContentSize=wvc.view.frame.size;
    wvc.preferredContentSize = wvc.view.frame.size;
    if (!wvc.anyDataSource) {
        return nil;
    }
//    return self.popoverController;
    return wvc;
}

-(WidgetViewController*)CreateTargetGenericCategoryWidgetWithUncheckedPickerValue:(NSMutableArray*)aPickerValue miscDataDict:(NSMutableDictionary*)aDataDict {
    //no data still return
    WidgetViewController* wvc = [[[PickerWidgetViewController alloc] initWithPickerValue:aPickerValue miscDataDict:aDataDict delegate:self] autorelease];
//    self.popoverController = [[[UIPopoverController alloc]initWithContentViewController:wvc] autorelease];
//    self.popoverController.popoverContentSize=wvc.view.frame.size;
    wvc.preferredContentSize = wvc.view.frame.size;
    //no data  return nil
    if (!wvc.anyDataSource) {
        return nil;
    }
//    return self.popoverController;
    return wvc;
}

-(TableWidgetViewController*)getTableWidgetWithType:(TableWidgetType)type{
    
    return nil;

}
-(NumberWidgetViewController*)getNumberWidgetWithType:(NumberWidgetType*)type{
    return nil;

}
-(WidgetViewController*)CreateTableWidgetWithData:(NSMutableArray*)aDataList withTitle:(NSString*)aTitle withParentContentString:(NSString*)aParentContentString {
    
    WidgetViewController* wvc = [[[TableWidgetViewController alloc] initWithDataList:aDataList withTitle:aTitle withParentContentString:aParentContentString] autorelease];
    
//    self.popoverController=[[[UIPopoverController alloc]initWithContentViewController:wvc] autorelease];
    CGSize size = CGSizeMake(320, 748);
    if ([aTitle isEqualToString:@"Head Quarter"]) {
        size = CGSizeMake(640, 748);
    }
//    self.popoverController.popoverContentSize = size;
    wvc.preferredContentSize = size;
    
    wvc.delegate=self;
    
    //no data  return nil
    if (!wvc.anyDataSource) {
        return nil;
    }
//    return self.popoverController;
    return wvc;
}

-(WidgetViewController*)CreateTableWidgetWithData:(NSMutableArray*)aDataList withTitle:(NSString*)aTitle withParentContentString:(NSString*)aParentContentString requestSource:(TableWidgetRequestSource)aTableWidgetRequestSource {
    WidgetViewController* wvc = [[[TableWidgetViewController alloc] initWithDataList:aDataList withTitle:aTitle withParentContentString:aParentContentString requestSource:aTableWidgetRequestSource] autorelease];
    
//    self.popoverController=[[[UIPopoverController alloc]initWithContentViewController:wvc] autorelease];
    CGSize size = CGSizeMake(320, 748);
    if ([aTitle isEqualToString:@"Head Quarter"]) {
        size = CGSizeMake(640, 748);
    }
    if (aTableWidgetRequestSource == TableWidgetRequestSourceListing) {
        size = CGSizeMake(320.0, 240.0);
    }
//    self.popoverController.popoverContentSize = size;
    wvc.preferredContentSize = size;
    wvc.delegate=self;
    
    //no data  return nil
    if (!wvc.anyDataSource) {
        return nil;
    }
//    return self.popoverController;
    return wvc;
}

-(WidgetViewController*)CreateTableMSWidgetWithData:(NSMutableArray*)aDataList withTitle:(NSString*)aTitle withParentItemList:(NSMutableArray*)aParentItemList requestSource:(TableMSWidgetRequestSource)aTableMSWidgetRequestSource {
    WidgetViewController* wvc = [[[TableMSWidgetViewController alloc] initWithDataList:aDataList withTitle:aTitle withParentItemList:aParentItemList requestSource:aTableMSWidgetRequestSource] autorelease];
    
//    self.popoverController=[[[UIPopoverController alloc]initWithContentViewController:wvc] autorelease];
    CGSize size = CGSizeMake(320, 748);
//    self.popoverController.popoverContentSize = size;
    wvc.preferredContentSize = size;
    
    wvc.delegate=self;
    
    //no data  return nil
    if (!wvc.anyDataSource) {
        return nil;
    }
//    return self.popoverController;
    return wvc;
}

-(WidgetViewController*)CreateGenericTableMSWidgetWithData:(NSMutableArray*)aDataList withTitle:(NSString*)aTitle withParentItemList:(NSMutableArray*)aParentItemList {
    WidgetViewController* wvc = [[[TableGenericMSWidgetViewController alloc] initWithDataList:aDataList withTitle:aTitle withParentItemList:aParentItemList] autorelease];
    
//    self.popoverController=[[[UIPopoverController alloc]initWithContentViewController:wvc] autorelease];
    CGSize size = CGSizeMake(320, 748);
//    self.popoverController.popoverContentSize = size;
    wvc.preferredContentSize = size;
    
    wvc.delegate=self;
    
    //no data  return nil
    if (!wvc.anyDataSource) {
        return nil;
    }
//    return self.popoverController;
    return wvc;
}

- (void)processPopoverController:(WidgetViewController*)wvc {
    
}

#pragma mark widget delegate
-(void)operationDone:(id)data{
    [self.delegate operationDone:data];
}
-(void)dismissPopoverController {
    [self.delegate dismissPopoverController];
}
-(BOOL)allowToShowAddContactButton {
    return [self.delegate allowToShowAddContactButton];
}
-(void)emailPressedFromTablePopoverRow:(NSDictionary*)cellData groupName:(NSString *)aGroupName {
    [self.delegate emailPressedFromTablePopoverRow:cellData groupName:aGroupName];
}
-(BOOL)allowToShowAddAccountNoButton {
    return [self.delegate allowToShowAddAccountNoButton];
}


-(void)dealloc{
//    if (self.popoverController != nil) { self.popoverController = nil;}
//    if (self.delegate != nil) { self.delegate = nil; }
    if (self.tempData != nil) { self.tempData = nil; }
    
    
    [super dealloc];    
}
@end
