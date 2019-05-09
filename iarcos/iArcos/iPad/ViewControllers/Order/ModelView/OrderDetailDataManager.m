//
//  OrderDetailDataManager.m
//  Arcos
//
//  Created by David Kilmartin on 21/02/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "OrderDetailDataManager.h"
@interface OrderDetailDataManager()
- (NSMutableDictionary*)createActionTableDataDict:(NSString*)aTitle actionType:(NSNumber*)anActionType imageFileName:(NSString*)anImageFileName;
@end

@implementation OrderDetailDataManager
@synthesize orderDetailBaseDataManager = _orderDetailBaseDataManager;
//@synthesize orderDetailOrderDataManager = _orderDetailOrderDataManager;
//@synthesize orderDetailCallDataManager = _orderDetailCallDataManager;
@synthesize orderNumber = _orderNumber;
@synthesize savedOrderDetailCellData = _savedOrderDetailCellData;
@synthesize orderHeader = _orderHeader;
@synthesize sectionTitleList = _sectionTitleList;
@synthesize groupedDataDict = _groupedDataDict;
@synthesize actionTableDataDictList = _actionTableDataDictList;
@synthesize locationSwitchedFlag = _locationSwitchedFlag;
@synthesize taskObjectList = _taskObjectList;
@synthesize selectedEmailRecipientDict = _selectedEmailRecipientDict;
//@synthesize titleKey = _titleKey;

- (id)init {
    self = [super init];
    if (self != nil) {
//        self.titleKey = @"Title";
        self.locationSwitchedFlag = NO;
    }
    return self;
}

- (void)dealloc {
    if (self.orderDetailBaseDataManager != nil) { self.orderDetailBaseDataManager = nil; }
//    if (self.orderDetailOrderDataManager != nil) { self.orderDetailOrderDataManager = nil; }
//    if (self.orderDetailCallDataManager != nil) { self.orderDetailCallDataManager = nil; }    
    if (self.orderNumber != nil) { self.orderNumber = nil; }
    if (self.savedOrderDetailCellData != nil) { self.savedOrderDetailCellData = nil; }
    if (self.orderHeader != nil) { self.orderHeader = nil; }
    if (self.sectionTitleList != nil) { self.sectionTitleList = nil; }
    if (self.groupedDataDict != nil) { self.groupedDataDict = nil; }
    self.actionTableDataDictList = nil;
    self.taskObjectList = nil;
    self.selectedEmailRecipientDict = nil;
//    if (self.titleKey != nil) { self.titleKey = nil; }    
    
    [super dealloc];
}

- (void)loadSavedOrderDetailCellData:(NSMutableDictionary*)aCellData {
    self.savedOrderDetailCellData = aCellData;
    self.orderNumber = [self.savedOrderDetailCellData objectForKey:@"OrderNumber"];
    self.orderHeader = [[ArcosCoreData sharedArcosCoreData] editingOrderHeaderWithOrderNumber:self.orderNumber];
    self.sectionTitleList = [NSMutableArray array];
    self.groupedDataDict = [NSMutableDictionary dictionary];
    if ([[self.orderHeader objectForKey:@"NumberOflines"] intValue] > 0) {
        self.orderDetailBaseDataManager = [[[OrderDetailOrderDataManager alloc] init] autorelease];
    } else {
        self.orderDetailBaseDataManager = [[[OrderDetailCallDataManager alloc] init] autorelease];
    }
    self.orderDetailBaseDataManager.orderHeader = self.orderHeader;
    self.orderDetailBaseDataManager.sectionTitleList = self.sectionTitleList;
    self.orderDetailBaseDataManager.groupedDataDict = self.groupedDataDict;
    [self.orderDetailBaseDataManager createAllSectionData];
}


- (NSMutableDictionary*)cellDataWithIndexPath:(NSIndexPath*)anIndexPath {
    NSString* sectionTitle = [self.sectionTitleList objectAtIndex:anIndexPath.section];
    NSMutableArray* tmpDisplayList = [self.groupedDataDict objectForKey:sectionTitle];
    return [tmpDisplayList objectAtIndex:anIndexPath.row];
}
- (void)inputFinishedWithData:(id)data forIndexpath:(NSIndexPath*)theIndexpath {
    NSMutableDictionary* cellData = [self cellDataWithIndexPath:theIndexpath];
    NSString* cellKey = [cellData objectForKey:@"CellKey"];
    [cellData setObject:data forKey:@"FieldData"];
    [self.orderHeader setObject:data forKey:cellKey];
//    NSLog(@"After amending, order header is: %@",self.orderHeader);
}

- (BOOL)saveTheOrderHeader {
    return [[ArcosCoreData sharedArcosCoreData] saveOrderHeader:self.orderHeader];
}

- (NSMutableArray*)createActionTableDataDictList:(NSMutableDictionary*)aCellData {
    NSMutableArray* auxActionTableDataDictList = [NSMutableArray arrayWithCapacity:2];
    [auxActionTableDataDictList addObject:[self createActionTableDataDict:@"Email" actionType:[NSNumber numberWithInt:1] imageFileName:@"Email.png"]];
    if ([[aCellData objectForKey:@"NumberOflines"] intValue] > 0) {
        [auxActionTableDataDictList addObject:[self createActionTableDataDict:@"Repeat" actionType:[NSNumber numberWithInt:2] imageFileName:@"Repeat.png"]];
    }    
    return auxActionTableDataDictList;
}

- (NSMutableDictionary*)createActionTableDataDict:(NSString*)aTitle actionType:(NSNumber*)anActionType imageFileName:(NSString*)anImageFileName {
    NSMutableDictionary* auxActionTableDataDict = [NSMutableDictionary dictionaryWithCapacity:3];
    [auxActionTableDataDict setObject:aTitle forKey:@"Title"];
    [auxActionTableDataDict setObject:anActionType forKey:@"ActionType"];
    [auxActionTableDataDict setObject:anImageFileName forKey:@"ImageFileName"];
    return auxActionTableDataDict;
}

- (void)locationInputFinishedWithData:(id)data forIndexpath:(NSIndexPath *)theIndexpath {
    [self.orderHeader setObject:[NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:0] forKey:@"IUR"]  forKey:@"contact"];
    [self.orderHeader setObject:[GlobalSharedClass shared].unassignedText forKey:@"contactText"];
    NSMutableDictionary* acctNoDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [acctNoDict setObject:@"0" forKey:@"acctNo"];
    [acctNoDict setObject:@"0" forKey:@"Title"];
    [self.orderHeader setObject:acctNoDict forKey:@"acctNo"];
    [self.orderHeader setObject:[GlobalSharedClass shared].unassignedText forKey:@"acctNoText"];
    [self.orderDetailBaseDataManager locationInputFinishedWithData:data forIndexpath:theIndexpath];
}

@end
