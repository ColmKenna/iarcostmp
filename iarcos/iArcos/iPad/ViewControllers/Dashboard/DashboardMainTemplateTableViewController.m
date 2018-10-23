//
//  DashboardMainTemplateTableViewController.m
//  iArcos
//
//  Created by David Kilmartin on 11/04/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "DashboardMainTemplateTableViewController.h"

@interface DashboardMainTemplateTableViewController ()

@end

@implementation DashboardMainTemplateTableViewController
@synthesize dashboardMainTemplateDataManager = _dashboardMainTemplateDataManager;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.dashboardMainTemplateDataManager = [[[DashboardMainTemplateDataManager alloc] init] autorelease];
        [self.dashboardMainTemplateDataManager createBasicData];
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
    self.dashboardMainTemplateDataManager = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray* dataDictList = [self.dashboardMainTemplateDataManager.displayList objectAtIndex:indexPath.row];
    float maxHeight = 0;
    for (int i = 0; i < [dataDictList count]; i++) {
        DashboardMainTemplateDataObject* dashboardMainTemplateDataObject = [dataDictList objectAtIndex:i];
        float currentHeight = dashboardMainTemplateDataObject.yPos + dashboardMainTemplateDataObject.height;
        if (currentHeight > maxHeight) {
            maxHeight = currentHeight;
        }
    }
    return maxHeight + 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dashboardMainTemplateDataManager.displayList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* CellIdentifier = @"IdDashboardMainTemplateTableViewCell";
    DashboardMainTemplateTableViewCell* cell = (DashboardMainTemplateTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"DashboardMainTemplateTableViewCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[DashboardMainTemplateTableViewCell class]] && [[(DashboardMainTemplateTableViewCell*)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell = (DashboardMainTemplateTableViewCell*) nibItem;
                cell.cellDelegate = self;
            }
        }
    }
    // Configure the cell...
    NSMutableArray* dataDictList = [self.dashboardMainTemplateDataManager.displayList objectAtIndex:indexPath.row];
    [cell configCellWithData:dataDictList];
    
    
    return cell;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self.tableView reloadData];
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
    }];
}

#pragma mark DashboardMainTemplateTableViewCell
- (void)dashboardBoxPressedWithIUR:(int)anIUR {
    NSLog(@"dashboardBoxPressedWithIUR %d", anIUR);
    switch (anIUR) {
        case 10: {
            DashboardPdfViewController* dpvc = [[DashboardPdfViewController alloc] initWithNibName:@"DashboardPdfViewController" bundle:nil];
            [self.navigationController pushViewController:dpvc animated:YES];
            [dpvc release];            
        }    
            break;
        case 30: {
            DashboardGenericTableViewController* dgtvc = [[DashboardGenericTableViewController alloc] initWithNibName:@"DashboardGenericTableViewController" bundle:nil];
            [self.navigationController pushViewController:dgtvc animated:YES];
            [dgtvc release];
        }    
            break;
        case 50: {
            TwoBarViewController* tbvc = [[TwoBarViewController alloc] initWithNibName:@"TwoBarViewController" bundle:nil];
            [self.navigationController pushViewController:tbvc animated:YES];
            [tbvc release];
        }            
            break;
            
        default:
            break;
    }
}






@end
