//
//  TargetTableViewController.m
//  iArcos
//
//  Created by David Kilmartin on 30/08/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "TargetTableViewController.h"

@interface TargetTableViewController ()

@end

@implementation TargetTableViewController
@synthesize targetDataManager = _targetDataManager;
@synthesize callGenericServices = _callGenericServices;
@synthesize tableCellFactory = _tableCellFactory;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.targetDataManager = [[[TargetDataManager alloc] init] autorelease];
        self.tableCellFactory = [[[TargetTableCellFactory alloc] init] autorelease];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"Target";
    UIBarButtonItem* lockTableButton = [[UIBarButtonItem alloc] initWithTitle:@"Lock Table" style:UIBarButtonItemStylePlain target:self action:@selector(lockTableAction)];
    self.navigationItem.rightBarButtonItem = lockTableButton;
    [lockTableButton release];
}

- (void)lockTableAction {
    if (self.tableView.scrollEnabled) {
        [self.navigationItem.rightBarButtonItem setTitle:@"Unlock Table"];
    } else {
        [self.navigationItem.rightBarButtonItem setTitle:@"Lock Table"];
    }
    self.tableView.scrollEnabled = !self.tableView.scrollEnabled;
}

- (void)testBarButtonPressed:(id)sender {
    self.tableView = nil;
}

- (void)dealloc {
    self.targetDataManager = nil;
    self.callGenericServices = nil;
    self.tableCellFactory = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.callGenericServices = [[[CallGenericServices alloc] initWithView:self.navigationController.view] autorelease];
    self.callGenericServices.isNotRecursion = NO;
    [self.callGenericServices genericGetTargetByEmployee:[[SettingManager employeeIUR] intValue] action:@selector(resultBackFromGetTargetByEmployee:) target:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.targetDataManager removeData];
    self.tableView = nil;
    self.callGenericServices = nil;
}

- (void)resultBackFromGetTargetByEmployee:(id)result {
    result = [self.callGenericServices handleResultErrorProcess:result];
    if (result == nil) {
        return;
    }
    ArcosArrayOfEmployeeTargets* employeeTargetList = (ArcosArrayOfEmployeeTargets*)result;
    if ([employeeTargetList count] > 0) {
        [self.targetDataManager processRawData:employeeTargetList];
        NSNumber* employeeTargetSQLiur = [NSNumber numberWithInt:0];
        NSMutableArray* descrDetailDictList = [[ArcosCoreData sharedArcosCoreData] descrDetailAllFieldsWithDescrTypeCode:@"SQ" descrDetailCode:@"EMTA"];
        if ([descrDetailDictList count] == 1) {
            NSDictionary* descrDetailDict = [descrDetailDictList objectAtIndex:0];
            employeeTargetSQLiur = [descrDetailDict objectForKey:@"DescrDetailIUR"];
        }
        if ([employeeTargetSQLiur intValue] != 0) {
            [self.callGenericServices genericProcessDashboardQueryWithDashboardiur:[employeeTargetSQLiur intValue] Employeeiur:0 Locationiur:0 action:@selector(resultBackFromProcessDashboardQuery:) target:self];
        } else {
            [self.callGenericServices.HUD hide:YES];
            [self.tableView reloadData];
        }
    } else if ([employeeTargetList count] <= 0) {
        [ArcosUtils showDialogBox:[GlobalSharedClass shared].noDataFoundMsg title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
    }
}

- (void)resultBackFromProcessDashboardQuery:(id)result {
//    NSLog(@"result %@", result);
    [self.callGenericServices.HUD hide:YES];
    result = [self.callGenericServices handleResultErrorProcess:result];
    if (result == nil) {
        [self.tableView reloadData];
        return;
    }
    ArcosDashBoardData* resArcosDashBoardData = (ArcosDashBoardData*)result;
    [self.targetDataManager processG1RawData:resArcosDashBoardData];
    [self.tableView reloadData];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self.tableView reloadData];
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
    }];
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary* auxCellData = [self.targetDataManager.displayList objectAtIndex:indexPath.row];
    NSNumber* cellType = [auxCellData objectForKey:@"CellType"];
    if ([cellType intValue] == 3) {
        return 170 * 4;
    }
    return 170;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.targetDataManager.displayList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //fill the data for cell
    NSMutableDictionary* cellData = [self.targetDataManager.displayList objectAtIndex:indexPath.row];
    TargetBaseTableViewCell* cell = (TargetBaseTableViewCell*)[tableView dequeueReusableCellWithIdentifier:[self.tableCellFactory identifierWithData:cellData]];
    if (cell == nil) {
        cell = (TargetBaseTableViewCell*)[self.tableCellFactory createTargetBaseTableCellWithData:cellData];
    }
    [cell configCellWithData:cellData];
    
    UIImage* bgImage = [UIImage imageNamed:@"presenterTableCell_stretchable.png"];    
    cell.bgImageView.image = [bgImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30, 0, 30)];    
    
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
