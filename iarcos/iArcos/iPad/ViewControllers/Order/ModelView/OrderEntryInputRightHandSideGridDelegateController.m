//
//  OrderEntryInputRightHandSideGridDelegateController.m
//  iArcos
//
//  Created by Apple on 15/04/2020.
//  Copyright © 2020 Strata IT Limited. All rights reserved.
//

#import "OrderEntryInputRightHandSideGridDelegateController.h"
#import "ArcosCoreData.h"

@interface OrderEntryInputRightHandSideGridDelegateController ()

@end

@implementation OrderEntryInputRightHandSideGridDelegateController
@synthesize myDelegate = _myDelegate;
@synthesize orderLineDictList = _orderLineDictList;
@synthesize cumulativeBal = _cumulativeBal;
@synthesize totalInStock = _totalInStock;
@synthesize totalFoc = _totalFoc;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)dealloc {
    self.orderLineDictList = nil;
    
    [super dealloc];
}

#pragma mark - Table view data source
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    // custom view for header. will be adjusted to default or specified header height    
    return [self.myDelegate retrieveRightHandSideGridHeaderView];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    OrderEntryInputRightHandSideFooterView* orderEntryInputRightHandSideFooterView = (OrderEntryInputRightHandSideFooterView*)[self.myDelegate retrieveRightHandSideGridFooterView];
    orderEntryInputRightHandSideFooterView.totalInStock.text = [ArcosUtils convertZeroToBlank:[NSString stringWithFormat:@"%d", self.totalInStock]];
    orderEntryInputRightHandSideFooterView.totalFoc.text = [ArcosUtils convertZeroToBlank:[NSString stringWithFormat:@"%d", self.totalFoc]];
    
    return orderEntryInputRightHandSideFooterView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.orderLineDictList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 22.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 22.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 22.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* orderEntryInputRightHandSideTableViewCellIdentifier = @"IdOrderEntryInputRightHandSideTableViewCell";
    
    OrderEntryInputRightHandSideTableViewCell* cell = (OrderEntryInputRightHandSideTableViewCell*) [tableView dequeueReusableCellWithIdentifier:orderEntryInputRightHandSideTableViewCellIdentifier];
    if(cell == nil) {
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"OrderEntryInputRightHandSideTableViewCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[OrderEntryInputRightHandSideTableViewCell class]] && [[(OrderEntryInputRightHandSideTableViewCell*)nibItem reuseIdentifier] isEqualToString:orderEntryInputRightHandSideTableViewCellIdentifier]) {
                cell = (OrderEntryInputRightHandSideTableViewCell*) nibItem;
            }
        }
    }
    
    // Configure the cell...
    NSMutableDictionary* cellData = [self.orderLineDictList objectAtIndex:indexPath.row];
    cell.orderDate.text = [ArcosUtils stringFromDate:[cellData objectForKey:@"OrderDate"] format:[GlobalSharedClass shared].dateFormat];    
    cell.inStock.text = [[cellData objectForKey:@"InStock"] stringValue];
    cell.foc.text = [[cellData objectForKey:@"FOC"] stringValue];
    cell.balance.text = [[cellData objectForKey:@"Bal"] stringValue];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)retrieveRightHandSideGridData {
    self.cumulativeBal = 0;
    self.orderLineDictList = [NSMutableArray array];
    self.totalInStock = 0;
    self.totalFoc = 0;
    NSNumber* auxLocationIUR = [self.myDelegate retrieveLocationIUR];
    id auxCellData = [self.myDelegate retrieveCellData];
    NSNumber* auxProductIUR = [auxCellData objectForKey:@"ProductIUR"];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"LocationIUR = %@ and ProductIUR = %@ and (FOC != 0 or InStock != 0)", auxLocationIUR, auxProductIUR];
    NSArray* sortDescNames = [NSArray arrayWithObjects:@"OrderDate",nil];
    NSArray* properties = [NSArray arrayWithObjects:@"OrderDate", @"FOC", @"InStock", nil];
    NSMutableArray* objectArray = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"OrderLine" withPropertiesToFetch:properties  withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:[NSNumber numberWithBool:YES]];
    if ([objectArray count] > 0) {
        for (NSDictionary* tmpOrderLineDict in objectArray) {
            NSMutableDictionary* resOrderLineDict = [NSMutableDictionary dictionaryWithDictionary:tmpOrderLineDict];
            NSNumber* resFOC = [tmpOrderLineDict objectForKey:@"FOC"];
            NSNumber* resInStock = [tmpOrderLineDict objectForKey:@"InStock"];
            self.totalInStock = self.totalInStock + [resInStock intValue];
            self.totalFoc = self.totalFoc + [resFOC intValue];
//            self.cumulativeBal = self.cumulativeBal + [resFOC intValue] - [resInStock intValue];
//            [resOrderLineDict setObject:[NSNumber numberWithInt:self.cumulativeBal] forKey:@"Bal"];
            [self.orderLineDictList addObject:resOrderLineDict];
        }
    }
}

@end
