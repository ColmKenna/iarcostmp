//
//  ReporterGroupMainTableViewController.m
//  iArcos
//
//  Created by Richard on 18/01/2021.
//  Copyright © 2021 Strata IT Limited. All rights reserved.
//

#import "ReporterGroupMainTableViewController.h"

@interface ReporterGroupMainTableViewController ()

@end

@implementation ReporterGroupMainTableViewController
@synthesize reporterGroupMainDataManager = _reporterGroupMainDataManager;
@synthesize callGenericServices = _callGenericServices;
@synthesize isReportSet = _isReportSet;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.reporterGroupMainDataManager = [[[ReporterGroupMainDataManager alloc] init] autorelease];
        self.isReportSet = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.callGenericServices = [[[CallGenericServices alloc] initWithView:self.navigationController.view] autorelease];
    self.title = @"Reporter";
}

- (void)dealloc {
    self.reporterGroupMainDataManager = nil;
    self.callGenericServices = nil;
    
    [super dealloc];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.isReportSet) {
        [self.callGenericServices genericReporterOptionsWithAction:@selector(resultBackFromReporterOptions:) target:self];
    }
}

- (void)resultBackFromReporterOptions:(ArcosGenericReturnObject*)result {
    result = [self.callGenericServices handleResultErrorProcess:result];
    if (result == nil) {
        return;
    }
    if (result.ErrorModel.Code > 0) {
        [self.reporterGroupMainDataManager processRawData:result.ArrayOfData];
        [self.tableView reloadData];
        self.isReportSet = YES;
    } else if(result.ErrorModel.Code <= 0) {
        NSString* titleMsg = (result.ErrorModel.Code == 0) ? @"" : [GlobalSharedClass shared].errorTitle;
        [ArcosUtils showDialogBox:result.ErrorModel.Message title:titleMsg delegate:nil target:self tag:0 handler:nil];
        
    }
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 176;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.reporterGroupMainDataManager.displayList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* mainPresenterCellIdentifier = @"IdMainPresenterTableViewCell";
    
    MainPresenterTableViewCell* cell = (MainPresenterTableViewCell*)[tableView dequeueReusableCellWithIdentifier:mainPresenterCellIdentifier];
    if(cell == nil) {
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"MainPresenterTableViewCell" owner:self options:nil];
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[MainPresenterTableViewCell class]] && [[(MainPresenterTableViewCell *)nibItem reuseIdentifier] isEqualToString: mainPresenterCellIdentifier]) {
                cell = (MainPresenterTableViewCell*)nibItem;
                break;
            }
        }
    }
    cell.myDelegate = self;
    cell.indexPath = indexPath;
    [cell makeCellReadyToUse];
    
    NSMutableArray* subsetDisplayList = [self.reporterGroupMainDataManager.displayList objectAtIndex:indexPath.row];
    for (int i = 0; i < [subsetDisplayList count]; i++) {
        UILabel* tmpLabel = [cell.labelList objectAtIndex:i];
        tmpLabel.text = [subsetDisplayList objectAtIndex:i];
        
        UIImage* anImage = anImage = [UIImage imageNamed:@"Resources.png"];
        
        UIButton* tmpBtn = [cell.btnList objectAtIndex:i];
        tmpBtn.enabled = YES;
        [tmpBtn setImage:anImage forState:UIControlStateNormal];
        UIView* tmpView = [cell.viewList objectAtIndex:i];
        tmpView.userInteractionEnabled = YES;
    }
    
    return cell;
}

- (void)mainPresenterPressedWithView:(UIView*)aView indexPath:(NSIndexPath*)anIndexPath {
    NSMutableArray* subsetDisplayList = [self.reporterGroupMainDataManager.displayList objectAtIndex:anIndexPath.row];
    NSString* auxGroupDetail = [subsetDisplayList objectAtIndex:aView.tag];
    ReporterMainViewController* reporterMainViewController = [[ReporterMainViewController alloc] initWithStyle:UITableViewStylePlain];
    NSMutableArray* reporterList = [self.reporterGroupMainDataManager retrieveReporterListWithGroupDetail:auxGroupDetail];
    [reporterMainViewController.reporterMainDataManager processRawData:reporterList];
    [self.navigationController pushViewController:reporterMainViewController animated:YES];
    [reporterMainViewController release];
}



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



@end
