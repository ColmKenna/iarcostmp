//
//  ImageL5FormRowsTableViewController.m
//  Arcos
//
//  Created by David Kilmartin on 23/10/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "ImageL5FormRowsTableViewController.h"

@implementation ImageL5FormRowsTableViewController
@synthesize animateDelegate = _animateDelegate;
@synthesize descrDetailCode = _descrDetailCode;
@synthesize imageL5FormRowsDataManager = _imageL5FormRowsDataManager;
@synthesize arcosCustomiseAnimation = _arcosCustomiseAnimation;
@synthesize globalNavigationController = _globalNavigationController;
@synthesize rootView = _rootView;
@synthesize mySearchBar = _mySearchBar;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.imageL5FormRowsDataManager = [[[ImageL5FormRowsDataManager alloc] init] autorelease];
    }
    return self;
}

- (void)dealloc {
    if (self.descrDetailCode != nil) { self.descrDetailCode = nil; }    
    if (self.imageL5FormRowsDataManager != nil) { self.imageL5FormRowsDataManager = nil; }
    if (self.arcosCustomiseAnimation != nil) { self.arcosCustomiseAnimation = nil; }
    if (self.globalNavigationController != nil) { self.globalNavigationController = nil; }
    if (self.rootView != nil) { self.rootView = nil; }    
    if (self.mySearchBar != nil) { self.mySearchBar = nil; }    
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;    
//    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(backPressed:)];
//    [self.navigationItem setLeftBarButtonItem:backButton];
//    [backButton release];
    
//    UIBarButtonItem* testButton = [[UIBarButtonItem alloc] initWithTitle:@"Test" style:UIBarButtonItemStyleBordered target:self action:@selector(testPressed:)];
//    [self.navigationItem setRightBarButtonItem:testButton];
//    [testButton release];
    
//    self.imageL5FormRowsDataManager = [[[ImageL5FormRowsDataManager alloc] init] autorelease];  
//    self.arcosCustomiseAnimation = [[[ArcosCustomiseAnimation alloc] init] autorelease];
//    self.rootView = [ArcosUtils getRootView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];  
//    [self.imageL5FormRowsDataManager getLevel5DescrDetail:self.descrDetailCode];
//    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {    
    self.mySearchBar.frame = CGRectMake(0, MAX(0,self.tableView.contentOffset.y), self.tableView.bounds.size.width, 44);
}


#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 176;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    // Return the number of rows in the section.
    if (self.imageL5FormRowsDataManager.descrDetailList != nil) {
        return [self.imageL5FormRowsDataManager.descrDetailList count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"IdImageFormRowsTableCell";
    
    ImageFormRowsTableCell *cell=(ImageFormRowsTableCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil) {
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"ImageFormRowsTableCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            //swith between editable and none editable order product cell
            if ([nibItem isKindOfClass:[ImageFormRowsTableCell class]] && [[(ImageFormRowsTableCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell = (ImageFormRowsTableCell *) nibItem;                
            }    
            
        }
        
	}
    
    //fill the data for cell
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.indexPath = indexPath;
    [cell getCellReadyToUse];
//    [cell createPopulatedLists];
//    [cell clearAllInfo];
    NSMutableArray* tmpDisplayList = [self.imageL5FormRowsDataManager.descrDetailList objectAtIndex:indexPath.row];
    for (int i = 0; i < [tmpDisplayList count]; i++) {
        NSMutableDictionary* descrDetailDict = [tmpDisplayList objectAtIndex:i];
        UILabel* tmpLabel = [cell.labelList objectAtIndex:i];
        tmpLabel.text = [descrDetailDict objectForKey:@"Detail"];
        
        NSNumber* imageIur = [descrDetailDict objectForKey:@"ImageIUR"];
        UIImage* anImage = nil;
        BOOL isCompanyImage = NO;
        if ([imageIur intValue] > 0) {
            anImage= [[ArcosCoreData sharedArcosCoreData]thumbWithIUR:imageIur];
        }else{
            anImage= [[ArcosCoreData sharedArcosCoreData]thumbWithIUR:[NSNumber numberWithInt:1]];
            isCompanyImage = YES;
        }
        if (anImage == nil) {
            anImage = [UIImage imageNamed:@"iArcos_72.png"];
        }
        UIButton* tmpBtn = [cell.btnList objectAtIndex:i];
        tmpBtn.enabled = YES;
        [tmpBtn setImage:anImage forState:UIControlStateNormal];
        if (isCompanyImage) {
            tmpBtn.alpha = [GlobalSharedClass shared].imageCellAlpha;
        } else {
            tmpBtn.alpha = 1.0;            
        }
    }    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

-(void)backPressed:(id)sender {
    [self.animateDelegate dismissSlideAcrossViewAnimation];
}

-(void)testPressed:(id)sender {
     
    
}

-(void)imageFormRowsWithButton:(UIButton*)aBtn indexPath:(NSIndexPath*)anIndexPath {
    NSLog(@"ImageFormRowsDelegate is executed.");
    NSMutableArray* tmpDisplayList = [self.imageL5FormRowsDataManager.descrDetailList objectAtIndex:anIndexPath.row];
    NSMutableDictionary* descrDetailDict = [tmpDisplayList objectAtIndex:aBtn.tag];
    NSString* descrDetailCode = [descrDetailDict objectForKey:@"DescrDetailCode"];
    NSMutableArray* unsortFormRows = [NSMutableArray array];
    NSMutableArray* products = [[ArcosCoreData sharedArcosCoreData] activeProductWithL5Code:descrDetailCode];
    if (products != nil && [products count] > 0) {
        NSDictionary* currentFormDetailDict = [[ArcosCoreData sharedArcosCoreData] formDetailWithFormIUR:[[OrderSharedClass sharedOrderSharedClass] currentFormIUR]];
        NSString* orderFormDetails = [ArcosUtils convertNilToEmpty:[currentFormDetailDict objectForKey:@"Details"]];
        for (NSMutableDictionary* product in products) {
//            NSMutableDictionary* formRow = [self createFormRowWithProduct:product];
            NSMutableDictionary* formRow = [ProductFormRowConverter createFormRowWithProduct:product orderFormDetails:orderFormDetails];
            //sync the row with current cart
            formRow = [[OrderSharedClass sharedOrderSharedClass] syncRowWithCurrentCart:formRow];
            
            [unsortFormRows addObject:formRow];
        }
//        NSLog(@"%d form rows created from L5 code %@", [unsortFormRows count], descrDetailCode);
        //push the form row view if there are some rows
        if ([unsortFormRows count] > 0) {
            FormRowsTableViewController* formRowsView = [[FormRowsTableViewController alloc] initWithNibName:@"FormRowsTableViewController" bundle:nil];
            formRowsView.dividerIUR = [NSNumber numberWithInt:-2];//dirty fit the form row
            formRowsView.isRequestSourceFromImageForm = YES;
//            formRowsView.isShowingTableHeaderView = YES;
            formRowsView.isShowingSearchBar = YES;
            formRowsView.title = [descrDetailDict objectForKey:@"Detail"];
            formRowsView.unsortedFormrows = unsortFormRows;
            [formRowsView syncUnsortedFormRowsWithOriginal];
            self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:formRowsView] autorelease];
            self.globalNavigationController.view.tag = [[GlobalSharedClass shared] tag4RemovedRootSubview];
            
            [self.navigationController pushViewController:formRowsView animated:YES];
            [formRowsView release];
        }else{
//            UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"No product found in the current selected form." delegate:nil cancelButtonTitle:nil destructiveButtonTitle:@"OK" otherButtonTitles:nil];
//            actionSheet.tag = 0;
//            actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
//            [actionSheet showInView:self.parentViewController.view];
//            [actionSheet release];
            [ArcosUtils showDialogBox:@"No product found in the current selected form." title:@"" target:self handler:nil];
            return;
        }
    } else {
//        [ArcosUtils showMsg:@"No data found" delegate:nil];
        [ArcosUtils showDialogBox:@"No data found" title:@"" target:self handler:nil];
    }
    
}

#pragma mark SlideAcrossViewAnimationDelegate
-(void)dismissSlideAcrossViewAnimation {
    [self.arcosCustomiseAnimation dismissPushViewAnimation:self.rootView withController:self.globalNavigationController];
}

- (NSMutableDictionary*)createFormRowWithProduct:(NSMutableDictionary*) product {
    NSMutableDictionary* formRow=[NSMutableDictionary dictionary];
    NSString* combinationKey=[NSString stringWithFormat:@"%@->%d",[product objectForKey:@"Description"], [[product objectForKey:@"ProductIUR"]intValue]];
    
    [formRow setObject:combinationKey forKey:@"CombinationKey"];
    [formRow setObject:[product objectForKey:@"ProductIUR"] forKey:@"ProductIUR"];
    [formRow setObject:[product objectForKey:@"UnitTradePrice"] forKey:@"UnitPrice"];
    [formRow setObject:[product objectForKey:@"Description"] forKey:@"Details"];
    
    [formRow setObject:[NSNumber numberWithInt:0] forKey:@"Bonus"];
    [formRow setObject:[NSNumber numberWithInt:0]  forKey:@"Qty"];
    [formRow setObject:[NSNumber numberWithFloat:0]  forKey:@"LineValue"];
    [formRow setObject:[NSNumber numberWithFloat:0]  forKey:@"DiscountPercent"];
    
    return formRow;
}

#pragma mark - search bar delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.mySearchBar.showsCancelButton = YES;
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    self.mySearchBar.showsCancelButton = NO;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if(searchText == nil || [searchText isEqualToString:@""]) {
        [self.imageL5FormRowsDataManager getAllDescrDetailList];
        [self reloadTableViewData];
        return;
    }
    [self.imageL5FormRowsDataManager searchDescrDetailWithKeyword:searchText];
    //    [self.tableView reloadData];
    //    self.mySearchBar.frame = CGRectMake(0,MAX(0,self.tableView.contentOffset.y),self.tableView.bounds.size.width,44);
    [self reloadTableViewData];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {    
    [self.mySearchBar resignFirstResponder];
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    [self.mySearchBar resignFirstResponder];
    self.mySearchBar.text = @"";
    [self.imageL5FormRowsDataManager getAllDescrDetailList];
    [self reloadTableViewData];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.mySearchBar.frame = CGRectMake(0, MAX(0,scrollView.contentOffset.y), scrollView.bounds.size.width, 44);
}

- (void)reloadTableViewData {
    [self.tableView reloadData];
    self.mySearchBar.frame = CGRectMake(0,MAX(0, self.tableView.contentOffset.y), self.tableView.bounds.size.width, 44);
}

@end
