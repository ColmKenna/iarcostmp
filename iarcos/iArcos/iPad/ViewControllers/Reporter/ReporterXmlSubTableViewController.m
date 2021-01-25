//
//  ReporterXmlSubTableViewController.m
//  iArcos
//
//  Created by Richard on 21/01/2021.
//  Copyright © 2021 Strata IT Limited. All rights reserved.
//

#import "ReporterXmlSubTableViewController.h"

@interface ReporterXmlSubTableViewController ()

@end

@implementation ReporterXmlSubTableViewController
@synthesize reporterXmlSubTableHeaderView = _reporterXmlSubTableHeaderView;
@synthesize reporterXmlSubDataManager = _reporterXmlSubDataManager;

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.reporterXmlSubDataManager = [[[ReporterXmlSubDataManager alloc] init] autorelease];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)dealloc {
    self.reporterXmlSubTableHeaderView = nil;
    self.reporterXmlSubDataManager = nil;
    
    [super dealloc];
}

#pragma mark - Table view data source
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (!self.reporterXmlSubDataManager.qtyShowFlag) {
        self.reporterXmlSubTableHeaderView.qtyLabel.hidden = YES;
    }
    if (!self.reporterXmlSubDataManager.valueShowFlag) {
        self.reporterXmlSubTableHeaderView.valueLabel.hidden = YES;
    }
    return self.reporterXmlSubTableHeaderView;    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.reporterXmlSubDataManager.displayList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* CellIdentifier = @"IdReporterXmlSubTableViewCell";
    
    ReporterXmlSubTableViewCell* cell = (ReporterXmlSubTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"ReporterXmlSubTableViewCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[ReporterXmlSubTableViewCell class]] && [[(ReporterXmlSubTableViewCell *)nibItem reuseIdentifier] isEqualToString:CellIdentifier]) {
                cell = (ReporterXmlSubTableViewCell*)nibItem;
            }
        }
    }
    
    NSMutableDictionary* cellData = [self.reporterXmlSubDataManager.displayList objectAtIndex:indexPath.row];
    cell.countLabel.text = [cellData objectForKey:@"Count"];
    cell.descriptionLabel.text = [cellData objectForKey:@"Details"];
    cell.qtyLabel.text = [cellData objectForKey:@"Qty"];
    if (!self.reporterXmlSubDataManager.qtyShowFlag) {
        cell.qtyLabel.text = @"";
    }
    NSNumber* valueNumber = [ArcosUtils convertStringToFloatNumber:[cellData objectForKey:@"Value"]];
    cell.valueLabel.text = [NSString stringWithFormat:@"%.2f", [valueNumber floatValue]];
    if (!self.reporterXmlSubDataManager.valueShowFlag) {
        cell.valueLabel.text = @"";
    }
    
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
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
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

@end
