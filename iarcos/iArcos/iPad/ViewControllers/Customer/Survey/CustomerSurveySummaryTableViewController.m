//
//  CustomerSurveySummaryTableViewController.m
//  iArcos
//
//  Created by David Kilmartin on 20/06/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import "CustomerSurveySummaryTableViewController.h"
#import "ArcosStackedViewController.h"

@interface CustomerSurveySummaryTableViewController ()

@end

@implementation CustomerSurveySummaryTableViewController
@synthesize customerSurveySummaryDataManager = _customerSurveySummaryDataManager;
@synthesize callGenericServices = _callGenericServices;
@synthesize locationIUR = _locationIUR;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.customerSurveySummaryDataManager = [[[CustomerSurveySummaryDataManager alloc] init] autorelease];
    self.callGenericServices = [[[CallGenericServices alloc] initWithView:self.navigationController.view] autorelease];
    [self.callGenericServices genericGetSurveySummaryByLocation:[self.locationIUR intValue] action:@selector(resultBackFromGetSurveySummaryByLocation:) target:self];
}

- (void)dealloc {
    self.customerSurveySummaryDataManager = nil;
    self.callGenericServices = nil;
    self.locationIUR = nil;
    
    [super dealloc];
}

- (void)resultBackFromGetSurveySummaryByLocation:(ArcosGenericReturnObject*)result {
    [self.callGenericServices.HUD hide:YES];
    result = [self.callGenericServices handleResultErrorProcess:result];
    if (result == nil) {
        return;
    }
    if (result.ErrorModel.Code > 0) {
        self.customerSurveySummaryDataManager.displayList = result.ArrayOfData;
        [self.tableView reloadData];
    } else if(result.ErrorModel.Code <= 0) {
        NSString* titleMsg = (result.ErrorModel.Code == 0) ? @"" : [GlobalSharedClass shared].errorTitle;
        [ArcosUtils showDialogBox:result.ErrorModel.Message title:titleMsg delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 59;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.customerSurveySummaryDataManager.displayList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* CellIdentifier = @"IdCustomerSurveySummaryTableViewCell";
    
    CustomerSurveySummaryTableViewCell* cell = (CustomerSurveySummaryTableViewCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"CustomerSurveySummaryTableViewCell" owner:self options:nil];
        
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[CustomerSurveySummaryTableViewCell class]] && [[(CustomerSurveySummaryTableViewCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell = (CustomerSurveySummaryTableViewCell *) nibItem;
                UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
                [cell.contentView addGestureRecognizer:singleTap];
                [singleTap release];
                
            }
        }
    }        
    
    // Configure the cell...
    
    ArcosGenericClass* cellData = [self.customerSurveySummaryDataManager.displayList objectAtIndex:indexPath.row];
    cell.dateLabel.text = [cellData Field2];
    cell.surveyTitleLabel.text = [cellData Field3];
    cell.contactNameLabel.text = [cellData Field7];
    cell.employeeNameLabel.text = [cellData Field4];
    NSString* scoreString = [ArcosUtils convertBlankToZero:[ArcosUtils trim:[cellData Field9]]];
    float alphaRatio = [[ArcosUtils convertStringToNumber:[ArcosUtils convertBlankToZero:scoreString]] floatValue] / 99.0;
    if (alphaRatio <= 0.3) {
        alphaRatio = 0.3;
    }
    cell.scoreLabel.alpha = 1.0 * alphaRatio;
    cell.scoreLabel.text = scoreString;
    
    return cell;
}

-(void)handleSingleTapGesture:(UITapGestureRecognizer*)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        NSIndexPath* swipedIndexPath = [ArcosUtils indexPathWithRecognizer:sender tableview:self.tableView];
        ArcosGenericClass* cellData = [self.customerSurveySummaryDataManager.displayList objectAtIndex:swipedIndexPath.row];        
        CustomerSurveyDetailsTableViewController* CSDTVC = [[CustomerSurveyDetailsTableViewController alloc] initWithStyle:UITableViewStylePlain];
        CSDTVC.summaryCellData = cellData;
        CSDTVC.subjectTitle = [NSString stringWithFormat:@"Total Score of %@ for %@", [ArcosUtils convertBlankToZero:[ArcosUtils trim:[cellData Field9]]], [cellData Field3]];
        UINavigationController* tmpNavigationController = [[UINavigationController alloc] initWithRootViewController:CSDTVC];
        [self.rcsStackedController pushNavigationController:tmpNavigationController fromNavigationController:(UINavigationController*)self.parentViewController animated:YES];
        [CSDTVC release];
        [tmpNavigationController release];        
    }
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
