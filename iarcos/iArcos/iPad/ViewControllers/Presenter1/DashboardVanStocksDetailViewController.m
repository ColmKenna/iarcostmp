//
//  DashboardVanStocksDetailViewController.m
//  iArcos
//
//  Created by David Kilmartin on 05/09/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import "DashboardVanStocksDetailViewController.h"

@interface DashboardVanStocksDetailViewController ()
- (NSMutableDictionary*)createCellDataWithCellType:(NSNumber*)aCellType fieldName:(NSString*)aFieldName fieldData:(id)aFieldData;
- (void)processRawData;
@end

@implementation DashboardVanStocksDetailViewController
@synthesize myNavigationBar = _myNavigationBar;
@synthesize productCodeLabel = _productCodeLabel;
@synthesize descriptionLabel = _descriptionLabel;
@synthesize myTableView = _myTableView;
@synthesize presentDelegate = _presentDelegate;
@synthesize cellData = _cellData;
@synthesize dataTitle = _dataTitle;
@synthesize actionTitle = _actionTitle;
@synthesize sectionTitleList = _sectionTitleList;
@synthesize groupedDataDict = _groupedDataDict;
@synthesize tableCellFactory = _tableCellFactory;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.dataTitle = @"Data";
    self.actionTitle = @"Action";
    self.tableCellFactory = [DashboardVanStocksDetailTableCellFactory factory];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.myNavigationBar = nil;
    self.productCodeLabel = nil;
    self.descriptionLabel = nil;
    self.myTableView = nil;
    self.cellData = nil;
    self.dataTitle = nil;
    self.actionTitle = nil;
    self.sectionTitleList = nil;
    self.groupedDataDict = nil;
    self.tableCellFactory = nil;
    
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.productCodeLabel.text = [self.cellData objectForKey:@"ProductCode"];
    self.descriptionLabel.text = [self.cellData objectForKey:@"Description"];
    [self processRawData];
    [self.myTableView reloadData];
}
//1:current ideal 2:next ideal 3:update
- (void)processRawData {
    self.sectionTitleList = [NSMutableArray arrayWithObjects:self.dataTitle, self.actionTitle, nil];
    self.groupedDataDict = [NSMutableDictionary dictionaryWithCapacity:3];
    NSMutableArray* dataList = [NSMutableArray arrayWithCapacity:2];
    [dataList addObject:[self createCellDataWithCellType:[NSNumber numberWithInt:1] fieldName:@"Current" fieldData:[self.cellData objectForKey:@"StockonOrder"]]];
    [dataList addObject:[self createCellDataWithCellType:[NSNumber numberWithInt:2] fieldName:@"Next" fieldData:[NSNumber numberWithInt:[[self.cellData objectForKey:@"StockonOrder"] intValue]]]];
    NSMutableArray* actionList = [NSMutableArray arrayWithCapacity:1];
    [actionList addObject:[self createCellDataWithCellType:[NSNumber numberWithInt:3] fieldName:@"Update" fieldData:@""]];
    [self.groupedDataDict setObject:dataList forKey:self.dataTitle];
    [self.groupedDataDict setObject:actionList forKey:self.actionTitle];    
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sectionTitleList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString* tmpSectionTitle = [self.sectionTitleList objectAtIndex:section];
    NSMutableArray* tmpDataList = [self.groupedDataDict objectForKey:tmpSectionTitle];
    return [tmpDataList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* auxSectionTitle = [self.sectionTitleList objectAtIndex:indexPath.section];
    NSMutableArray* auxDataList = [self.groupedDataDict objectForKey:auxSectionTitle];
    NSMutableDictionary* auxCellData = [auxDataList objectAtIndex:indexPath.row];
    DashboardVanStocksDetailBaseTableCell* cell = (DashboardVanStocksDetailBaseTableCell*)[tableView dequeueReusableCellWithIdentifier:[self.tableCellFactory identifierWithData:auxCellData]];
    if (cell == nil) {
        cell = (DashboardVanStocksDetailBaseTableCell*)[self.tableCellFactory createVanStocksDetailBaseTableCellWithData:auxCellData];
        cell.actionDelegate = self;        
    }
    cell.indexPath = indexPath;
    [cell configCellWithData:auxCellData];
    return cell;
}

#pragma mark - DashboardVanStocksDetailTableCellDelegate
- (void)inputFinishedWithData:(NSString*)aData indexPath:(NSIndexPath*)anIndexPath {
    NSString* auxSectionTitle = [self.sectionTitleList objectAtIndex:anIndexPath.section];
    NSMutableArray* auxDataList = [self.groupedDataDict objectForKey:auxSectionTitle];
    NSMutableDictionary* auxCellData = [auxDataList objectAtIndex:anIndexPath.row];
    [auxCellData setObject:[ArcosUtils convertStringToNumber:[ArcosUtils convertBlankToZero:aData]] forKey:@"FieldData"];
}

- (void)updateButtonPressedDelegate {
    [self.view endEditing:YES];
    NSMutableArray* auxDataList = [self.groupedDataDict objectForKey:self.dataTitle];
    if ([auxDataList count] >= 2) {
        NSMutableDictionary* auxCellData = [auxDataList objectAtIndex:1];
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"ProductIUR = %@", [self.cellData objectForKey:@"ProductIUR"]];
        NSMutableArray* objectArray = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"Product" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
        if ([objectArray count] == 1) {
            Product* auxProduct = [objectArray objectAtIndex:0];
            auxProduct.StockonOrder = [auxCellData objectForKey:@"FieldData"];
            [[ArcosCoreData sharedArcosCoreData] saveContext:[ArcosCoreData sharedArcosCoreData].fetchManagedObjectContext];
        }
    }
    
    [self.presentDelegate didDismissDashboardVanStocksDetailTableViewController];
}

- (NSMutableDictionary*)createCellDataWithCellType:(NSNumber*)aCellType fieldName:(NSString*)aFieldName fieldData:(id)aFieldData {
    NSMutableDictionary* tmpDataDict = [NSMutableDictionary dictionaryWithCapacity:3];
    [tmpDataDict setObject:aCellType forKey:@"CellType"];
    [tmpDataDict setObject:aFieldName forKey:@"FieldName"];
    [tmpDataDict setObject:aFieldData forKey:@"FieldData"];
    return tmpDataDict;
}

@end
