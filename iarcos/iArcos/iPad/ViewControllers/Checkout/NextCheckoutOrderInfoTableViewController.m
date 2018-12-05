//
//  NextCheckoutOrderInfoTableViewController.m
//  iArcos
//
//  Created by David Kilmartin on 29/08/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "NextCheckoutOrderInfoTableViewController.h"

@interface NextCheckoutOrderInfoTableViewController()

- (NSMutableDictionary*)createCellDataWithCellType:(NSNumber*)aCellType cellKey:(NSString*)aCellKey writableType:(NSNumber*)aWritableType fieldName:(NSString*)aFieldName fieldData:(id)aFieldData;
- (NSMutableDictionary*)createCellDataWithCellType:(NSNumber*)aCellType cellKey:(NSString*)aCellKey writableType:(NSNumber*)aWritableType fieldName:(NSString*)aFieldName fieldData:(id)aFieldData titleKey:(NSString*)aTitleKey;
- (NSMutableDictionary*)createCellDataWithCellType:(NSNumber*)aCellType cellKey:(NSString*)aCellKey writableType:(NSNumber*)aWritableType fieldName:(NSString*)aFieldName fieldData:(id)aFieldData index:(int)anIndex;
- (NSMutableDictionary*)createCellDataWithCellType:(NSNumber*)aCellType cellKey:(NSString*)aCellKey writableType:(NSNumber*)aWritableType fieldName:(NSString*)aFieldName fieldData:(id)aFieldData bgColor:(NSNumber*)aBgColorFlag;
- (void)createOrderDetailsData;
- (void)createContactDetailsData;
- (void)createCommentsData;
- (void)createFollowUpData;
- (NSMutableDictionary*)cellDataWithIndexPath:(NSIndexPath*)anIndexPath;

@end


@implementation NextCheckoutOrderInfoTableViewController

@synthesize orderInfoDelegate = _orderInfoDelegate;
@synthesize orderHeader = _orderHeader;
@synthesize groupedDataDict = _groupedDataDict;
@synthesize sectionTitleList = _sectionTitleList;
@synthesize orderDetailsTitle = _orderDetailsTitle;
@synthesize contactDetailsTitle = _contactDetailsTitle;
@synthesize commentsTitle = _commentsTitle;
@synthesize followUpTitle = _followUpTitle;
@synthesize placeHolderNumber = _placeHolderNumber;
@synthesize tableCellFactory = _tableCellFactory;

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self != nil) {
        self.orderDetailsTitle = @"Order Details";
        self.contactDetailsTitle = @"Contact Details";
        self.commentsTitle = @"Comments";
        self.followUpTitle = @"Follow Up";
        self.placeHolderNumber = [NSNumber numberWithInt:0];
        self.tableCellFactory = [NextCheckoutTableViewCellFactory factory];
    }
    return self;
}

- (void)dealloc {
    self.orderHeader = nil;
    self.groupedDataDict = nil;
    self.sectionTitleList = nil;
    self.orderDetailsTitle = nil;
    self.contactDetailsTitle = nil;
    self.commentsTitle = nil;
    self.followUpTitle = nil;
    self.placeHolderNumber = nil;
    self.tableCellFactory = nil;
    
    [super dealloc];
}

- (NSMutableDictionary*)createCellDataWithCellType:(NSNumber*)aCellType cellKey:(NSString*)aCellKey writableType:(NSNumber*)aWritableType fieldName:(NSString*)aFieldName fieldData:(id)aFieldData {
    NSMutableDictionary* cellData = [NSMutableDictionary dictionaryWithCapacity:5];
    [cellData setObject:aCellType forKey:@"CellType"];
    [cellData setObject:aCellKey forKey:@"CellKey"];
    [cellData setObject:aWritableType forKey:@"WritableType"];
    [cellData setObject:aFieldName forKey:@"FieldName"];
    [cellData setObject:aFieldData forKey:@"FieldData"];
    
    return cellData;
}

- (NSMutableDictionary*)createCellDataWithCellType:(NSNumber*)aCellType cellKey:(NSString*)aCellKey writableType:(NSNumber*)aWritableType fieldName:(NSString*)aFieldName fieldData:(id)aFieldData titleKey:(NSString*)aTitleKey {
    NSMutableDictionary* cellData = [self createCellDataWithCellType:aCellType cellKey:aCellKey writableType:aWritableType fieldName:aFieldName fieldData:aFieldData];
    [cellData setObject:aTitleKey forKey:@"TitleKey"];
    return cellData;
}

- (NSMutableDictionary*)createCellDataWithCellType:(NSNumber*)aCellType cellKey:(NSString*)aCellKey writableType:(NSNumber*)aWritableType fieldName:(NSString*)aFieldName fieldData:(id)aFieldData index:(int)anIndex {
    NSMutableDictionary* cellData = [self createCellDataWithCellType:aCellType cellKey:aCellKey writableType:aWritableType fieldName:aFieldName fieldData:aFieldData];
    [cellData setObject:[NSNumber numberWithInt:anIndex] forKey:@"Index"];
    return cellData;
}

- (NSMutableDictionary*)createCellDataWithCellType:(NSNumber*)aCellType cellKey:(NSString*)aCellKey writableType:(NSNumber*)aWritableType fieldName:(NSString*)aFieldName fieldData:(id)aFieldData bgColor:(NSNumber*)aBgColorFlag {
    NSMutableDictionary* cellData = [self createCellDataWithCellType:aCellType cellKey:aCellKey writableType:aWritableType fieldName:aFieldName fieldData:aFieldData];
    [cellData setObject:aBgColorFlag forKey:@"BgColor"];
    return cellData;
}

- (void)createBasicDataWithOrderHeader:(NSMutableDictionary*)anOrderHeader {
    self.orderHeader = anOrderHeader;
    self.groupedDataDict = [NSMutableDictionary dictionaryWithCapacity:4];
    self.sectionTitleList = [NSMutableArray arrayWithObjects:self.orderDetailsTitle, self.contactDetailsTitle, nil];
    if (![[ArcosConfigDataManager sharedArcosConfigDataManager] disableMemoFlag]) {
        [self.sectionTitleList addObject:self.commentsTitle];
        [self createCommentsData];
    }
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] recordTasksFlag]) {
        [self.sectionTitleList addObject:self.followUpTitle];
        [self createFollowUpData];
    }
//    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] recordTasksFlag]) {
//        self.sectionTitleList = [NSMutableArray arrayWithObjects:self.orderDetailsTitle, self.contactDetailsTitle, self.commentsTitle, self.followUpTitle, nil];
//        [self createFollowUpData];
//    } else {
//        self.sectionTitleList = [NSMutableArray arrayWithObjects:self.orderDetailsTitle, self.contactDetailsTitle, self.commentsTitle, nil];
//    }
    [self createOrderDetailsData];
    [self createContactDetailsData];
//    [self createCommentsData];
}

- (void)createOrderDetailsData {
    NSMutableArray* orderDetailsList = [NSMutableArray arrayWithCapacity:7];
    [self.groupedDataDict setObject:orderDetailsList forKey:self.orderDetailsTitle];
    [orderDetailsList addObject:[self createCellDataWithCellType:[NSNumber numberWithInt:1] cellKey:@"orderDate" writableType:[NSNumber numberWithInt:1] fieldName:@"Order" fieldData:[self.orderHeader objectForKey:@"orderDate"]]];
    [orderDetailsList addObject:[self createCellDataWithCellType:[NSNumber numberWithInt:1] cellKey:@"deliveryDate" writableType:[NSNumber numberWithInt:0] fieldName:@"Delivery" fieldData:[self.orderHeader objectForKey:@"deliveryDate"] bgColor:[self.orderHeader objectForKey:@"deliveryDateYellowBG"]]];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showDeliveryInstructionsFlag]) {
        [orderDetailsList addObject:[self createCellDataWithCellType:[NSNumber numberWithInt:13] cellKey:@"DeliveryInstructions1" writableType:self.placeHolderNumber fieldName:@"Instructions" fieldData:[self.orderHeader objectForKey:@"DeliveryInstructions1"]]];
    }
    [orderDetailsList addObject:[self createCellDataWithCellType:[NSNumber numberWithInt:2] cellKey:@"totalGoodsText" writableType:self.placeHolderNumber fieldName:@"Value" fieldData:[ArcosUtils convertNilToEmpty:[self.orderHeader objectForKey:@"totalGoodsText"]]]];
    [orderDetailsList addObject:[self createCellDataWithCellType:[NSNumber numberWithInt:3] cellKey:@"status" writableType:[NSNumber numberWithInt:3] fieldName:@"Status" fieldData:[ArcosUtils addTitleToDict:self.orderHeader cellKey:@"status" titleKey:@"statusText"] titleKey:@"statusText"]];
    [orderDetailsList addObject:[self createCellDataWithCellType:[NSNumber numberWithInt:3] cellKey:@"type" writableType:[NSNumber numberWithInt:5] fieldName:@"Order Type" fieldData:[ArcosUtils addTitleToDict:self.orderHeader cellKey:@"type" titleKey:@"orderTypeText"] titleKey:@"orderTypeText"]];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showCallTypeFlag]) {
        [orderDetailsList addObject:[self createCellDataWithCellType:[NSNumber numberWithInt:3] cellKey:@"callType" writableType:[NSNumber numberWithInt:6] fieldName:@"Call Type" fieldData:[ArcosUtils addTitleToDict:self.orderHeader cellKey:@"callType" titleKey:@"callTypeText"] titleKey:@"callTypeText"]];
    }
    [orderDetailsList addObject:[self createCellDataWithCellType:[NSNumber numberWithInt:3] cellKey:@"wholesaler" writableType:[NSNumber numberWithInt:4] fieldName:@"Wholesaler" fieldData:[ArcosUtils addTitleToDict:self.orderHeader cellKey:@"wholesaler" titleKey:@"wholesalerText"] titleKey:@"wholesalerText"]];
    [orderDetailsList addObject:[self createCellDataWithCellType:[NSNumber numberWithInt:5] cellKey:@"acctNo" writableType:self.placeHolderNumber fieldName:@"Account" fieldData:[ArcosUtils addTitleToDict:self.orderHeader cellKey:@"acctNo" titleKey:@"acctNoText"] titleKey:@"acctNoText"]];
}

- (void)createContactDetailsData {
    NSMutableArray* contactDetailsList = [NSMutableArray arrayWithCapacity:3];
    [self.groupedDataDict setObject:contactDetailsList forKey:self.contactDetailsTitle];
    [contactDetailsList addObject:[self createCellDataWithCellType:[NSNumber numberWithInt:4] cellKey:@"contact" writableType:self.placeHolderNumber fieldName:@"Customer" fieldData:[ArcosUtils addTitleToDict:self.orderHeader cellKey:@"contact" titleKey:@"contactText"] titleKey:@"contactText"]];
    [contactDetailsList addObject:[self createCellDataWithCellType:[NSNumber numberWithInt:6] cellKey:@"employee" writableType:self.placeHolderNumber fieldName:@"Employee" fieldData:[ArcosUtils addTitleToDict:self.orderHeader cellKey:@"employee" titleKey:@"employeeText"] titleKey:@"employeeText"]];
    [contactDetailsList addObject:[self createCellDataWithCellType:[NSNumber numberWithInt:7] cellKey:@"custRef" writableType:self.placeHolderNumber fieldName:@"Reference" fieldData:[self.orderHeader objectForKey:@"custRef"]]];
}

- (void)createCommentsData {
    NSMutableArray* commentsList = [NSMutableArray arrayWithCapacity:1];
    [self.groupedDataDict setObject:commentsList forKey:self.commentsTitle];
    [commentsList addObject:[self createCellDataWithCellType:[NSNumber numberWithInt:8] cellKey:@"memo" writableType:self.placeHolderNumber fieldName:@"" fieldData:[self.orderHeader objectForKey:@"memo"]]];
}

- (void)createFollowUpData {
    NSMutableArray* followUpList = [NSMutableArray arrayWithCapacity:4];
    [self.groupedDataDict setObject:followUpList forKey:self.followUpTitle];
    [followUpList addObject:[self createCellDataWithCellType:[NSNumber numberWithInt:9] cellKey:@"invoiceRef" writableType:self.placeHolderNumber fieldName:@"" fieldData:[self.orderHeader objectForKey:@"invoiceRef"] index:0]];
    [followUpList addObject:[self createCellDataWithCellType:[NSNumber numberWithInt:10] cellKey:@"invoiceRef" writableType:self.placeHolderNumber fieldName:@"Employee" fieldData:[self.orderHeader objectForKey:@"invoiceRef"] index:1]];
    [followUpList addObject:[self createCellDataWithCellType:[NSNumber numberWithInt:11] cellKey:@"invoiceRef" writableType:self.placeHolderNumber fieldName:@"Type" fieldData:[self.orderHeader objectForKey:@"invoiceRef"] index:2]];
    [followUpList addObject:[self createCellDataWithCellType:[NSNumber numberWithInt:12] cellKey:@"invoiceRef" writableType:self.placeHolderNumber fieldName:@"Due Date" fieldData:[self.orderHeader objectForKey:@"invoiceRef"] index:3]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [self.sectionTitleList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSString* sectionTitle = [self.sectionTitleList objectAtIndex:section];
    return [[self.groupedDataDict objectForKey:sectionTitle] count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString* sectionTitle = [self.sectionTitleList objectAtIndex:section];
    NextCheckoutOrderInfoHeaderView* tmpOrderInfoHeaderView = (NextCheckoutOrderInfoHeaderView*)[self.orderInfoDelegate retrieveOrderInfoHeaderView:section];
    tmpOrderInfoHeaderView.myLabel.text = [sectionTitle uppercaseString];
    return tmpOrderInfoHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* sectionTitle = [self.sectionTitleList objectAtIndex:indexPath.section];
    NSMutableDictionary* cellData = [[self.groupedDataDict objectForKey:sectionTitle] objectAtIndex:indexPath.row];
    if ([[cellData objectForKey:@"CellType"] intValue] == 8 || [[cellData objectForKey:@"CellType"] intValue] == 9) {
        return 106.0;
    }
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* sectionTitle = [self.sectionTitleList objectAtIndex:indexPath.section];
    NSMutableDictionary* cellData = [[self.groupedDataDict objectForKey:sectionTitle] objectAtIndex:indexPath.row];
    NextCheckoutBaseTableViewCell* cell = (NextCheckoutBaseTableViewCell*)[tableView dequeueReusableCellWithIdentifier:[self.tableCellFactory identifierWithData:cellData]];
    if (cell == nil) {
        cell = (NextCheckoutBaseTableViewCell*)[self.tableCellFactory createNextCheckoutBaseTableViewCellWithData:cellData];
    }
    // Configure the cell...
    cell.baseDelegate = self;
    cell.indexPath = indexPath;
    [cell configCellWithData:cellData];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark NextCheckoutBaseTableViewCellDelegate
- (void)inputFinishedWithData:(id)data forIndexPath:(NSIndexPath *)anIndexPath {
    NSMutableDictionary* cellData = [self cellDataWithIndexPath:anIndexPath];
    NSString* cellKey = [cellData objectForKey:@"CellKey"];
    [cellData setObject:data forKey:@"FieldData"];
    [self.orderHeader setObject:data forKey:cellKey];
}

- (void)inputFinishedWithTitleKey:(NSString *)aTitleKey data:(id)aData {
    [self.orderHeader setObject:aData forKey:aTitleKey];
}

- (void)inputFinishedWithData:(id)data forIndexPath:(NSIndexPath *)anIndexPath index:(NSNumber *)anIndex {
    NSMutableDictionary* cellData = [self cellDataWithIndexPath:anIndexPath];
    NSMutableArray* dataList = [cellData objectForKey:@"FieldData"];
    [dataList replaceObjectAtIndex:[anIndex intValue] withObject:data];
    NSString* cellKey = [cellData objectForKey:@"CellKey"];
    [self.orderHeader setObject:dataList forKey:cellKey];
}

- (BOOL)checkWholesalerAppliedStatus {
    if ([self.orderHeader objectForKey:@"wholesaler"] == nil) {
        [ArcosUtils showDialogBox:@"Please select a wholesaler" title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
        return NO;
    }
    return YES;
}

- (NSMutableDictionary*)retrieveOrderHeaderData {
    return self.orderHeader;
}

- (UIViewController*)retrieveMainViewController {
    return self;
}

- (NSMutableDictionary*)cellDataWithIndexPath:(NSIndexPath*)anIndexPath {
    NSString* sectionTitle = [self.sectionTitleList objectAtIndex:anIndexPath.section];
    NSMutableArray* tmpDisplayList = [self.groupedDataDict objectForKey:sectionTitle];
    return [tmpDisplayList objectAtIndex:anIndexPath.row];
}

@end
