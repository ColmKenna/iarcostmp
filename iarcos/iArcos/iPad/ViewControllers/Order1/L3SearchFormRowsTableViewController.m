//
//  L3SearchFormRowsTableViewController.m
//  Arcos
//
//  Created by David Kilmartin on 21/11/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "L3SearchFormRowsTableViewController.h"
@interface L3SearchFormRowsTableViewController ()
- (void)productListImageFormRowsWithButton:(UIButton*)aBtn indexPath:(NSIndexPath*)anIndexPath;
- (void)productGridImageFormRowsWithButton:(UIButton*)aBtn indexPath:(NSIndexPath*)anIndexPath;
@end

@implementation L3SearchFormRowsTableViewController
@synthesize mySearchBar = _mySearchBar;
@synthesize myTableView = _myTableView;
@synthesize l3SearchDataManager = _l3SearchDataManager;
@synthesize formType = _formType;
@synthesize isNotFirstLoaded = _isNotFirstLoaded;
@synthesize backButtonDelegate = _backButtonDelegate;
@synthesize navigationTitleDelegate = _navigationTitleDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    if (self.mySearchBar != nil) { self.mySearchBar = nil; }
    if (self.myTableView != nil) { self.myTableView = nil; }
    if (self.l3SearchDataManager != nil) { self.l3SearchDataManager = nil; }
    if (self.formType != nil) { self.formType = nil; }    
    
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
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = YES;
    self.l3SearchDataManager = [[[L3SearchDataManager alloc] init] autorelease];
    self.l3SearchDataManager.formType = self.formType;
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
//    NSLog(@"l3SearchFormRows will appear.");
    if (self.isNotFirstLoaded) return;
//    NSDate* startDate = [NSDate date];    
//check later    [self.l3SearchDataManager getLevel3DescrDetail];
    [self.l3SearchDataManager getBranchLeafData];
//    self.mySearchBar.autocorrectionType = UITextAutocorrectionTypeNo;
//    self.mySearchBar.delegate = self;  
//    NSLog(@"l3SearchFormRows Done");
//    NSDate* endDate = [NSDate date];  
//    NSTimeInterval executeTime = [endDate timeIntervalSinceDate:startDate];
//    NSLog(@"executetime %f", executeTime);
    self.isNotFirstLoaded = YES;
//    [self.myTableView reloadData];
//    [self.mySearchBar becomeFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    NSLog(@"l3SearchFormRows DidAppear.");
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
//    NSLog(@"l3search didRotateFromInterfaceOrientation");
//    self.mySearchBar.frame = CGRectMake(0, MAX(0,self.myTableView.contentOffset.y), self.myTableView.bounds.size.width, 44);
}    

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 176;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
//    return 1;
    return [self.l3SearchDataManager.descrDetailSectionDict count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    /*
    if (self.l3SearchDataManager.descrDetailList != nil) {
        return [self.l3SearchDataManager.descrDetailList count];
    }
    return 0;
    */
    NSString* aKey = [self.l3SearchDataManager.sortKeyList objectAtIndex:section];
    NSMutableArray* aSectionArray = [self.l3SearchDataManager.descrDetailSectionDict objectForKey:aKey];    
    return [aSectionArray count];    
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
    NSString* aKey=[self.l3SearchDataManager.sortKeyList objectAtIndex:indexPath.section];
    NSMutableArray* aSectionArray = [self.l3SearchDataManager.descrDetailSectionDict objectForKey:aKey];
    NSMutableArray* tmpDisplayList = [aSectionArray objectAtIndex:indexPath.row];
//    NSMutableArray* tmpDisplayList = [self.l3SearchDataManager.descrDetailList objectAtIndex:indexPath.row];
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

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.l3SearchDataManager.sortKeyList;
}

-(void)backPressed:(id)sender {
//    [self.animateDelegate dismissUIViewAnimation];
}

#pragma mark - ImageFormRowsDelegate
-(void)imageFormRowsWithButton:(UIButton*)aBtn indexPath:(NSIndexPath*)anIndexPath {
    switch ([self.l3SearchDataManager.formTypeId intValue]) {
        case 6:
            [self productListImageFormRowsWithButton:aBtn indexPath:anIndexPath];
            break;
        case 7:
            [self productGridImageFormRowsWithButton:aBtn indexPath:anIndexPath];
            break;
        default:
            break;
    }
    [self.backButtonDelegate controlOrderFormBackButtonEvent];
}

- (void)productListImageFormRowsWithButton:(UIButton*)aBtn indexPath:(NSIndexPath*)anIndexPath {
    NSString* aKey = [self.l3SearchDataManager.sortKeyList objectAtIndex:anIndexPath.section];
    NSMutableArray* aSectionArray = [self.l3SearchDataManager.descrDetailSectionDict objectForKey:aKey];
    NSMutableArray* tmpDisplayList = [aSectionArray objectAtIndex:anIndexPath.row];
    //    NSMutableArray* tmpDisplayList = [self.l3SearchDataManager.descrDetailList objectAtIndex:anIndexPath.row];
    NSMutableDictionary* l3DescrDetailDict = [tmpDisplayList objectAtIndex:aBtn.tag];
    //    NSLog(@"descrDetailDict DescrDetailCode is %@", [l3DescrDetailDict objectForKey:@"DescrDetailCode"]);
    NSString* l3DescrDetailCode = [l3DescrDetailDict objectForKey:@"DescrDetailCode"];
    NSMutableArray* l5ChildrenList = [l3DescrDetailDict objectForKey:@"LeafChildren"];
    if ([l5ChildrenList count] > 1) {
        L5L3SearchFormRowsTableViewController* l5l3sfrtvc = [[L5L3SearchFormRowsTableViewController alloc] initWithNibName:@"L5L3SearchFormRowsTableViewController" bundle:nil];
        l5l3sfrtvc.l3SearchDataManager = self.l3SearchDataManager;
        l5l3sfrtvc.title = [l3DescrDetailDict objectForKey:@"Detail"];
        //    l5l3sfrtvc.animateDelegate = self;
        l5l3sfrtvc.l3DescrDetailCode = l3DescrDetailCode;
        l5l3sfrtvc.l5L3SearchDataManager.displayList = [l3DescrDetailDict objectForKey:@"LeafChildren"];
        [l5l3sfrtvc.l5L3SearchDataManager processRawData4DisplayList];
        [self.navigationController pushViewController:l5l3sfrtvc animated:YES];
        [l5l3sfrtvc release];
    }
    if ([l5ChildrenList count] == 1) {        
        NSMutableDictionary* l5DescrDetailDict = [l5ChildrenList objectAtIndex:0];
        NSString* l5DescrDetailCode = [l5DescrDetailDict objectForKey:@"DescrDetailCode"];
        [self.navigationController pushViewController:[self.l3SearchDataManager.branchLeafProductBaseDataManager showProductTableViewController:l3DescrDetailCode branchLxCode:self.l3SearchDataManager.branchLxCode leafLxCodeContent:l5DescrDetailCode leafLxCode:self.l3SearchDataManager.leafLxCode] animated:YES];
        /*
         NSMutableArray* unsortFormRows = [NSMutableArray array];
         NSMutableArray* products = [[ArcosCoreData sharedArcosCoreData] activeProductWithL3Code:l3DescrDetailCode l5Code:l5DescrDetailCode];
         if (products != nil && [products count] > 0) {
         for (NSMutableDictionary* product in products) {            
         //            NSMutableDictionary* formRow = [self createFormRowWithProduct:product];
         NSMutableDictionary* formRow = [ProductFormRowConverter createFormRowWithProduct:product];
         //sync the row with current cart
         formRow = [[OrderSharedClass sharedOrderSharedClass] syncRowWithCurrentCart:formRow];            
         [unsortFormRows addObject:formRow];
         }
         //            NSLog(@"%d form rows created from L5 code %@", [unsortFormRows count], l5DescrDetailCode);
         //push the form row view if there are some rows
         if ([unsortFormRows count] > 0) {
         FormRowsTableViewController* formRowsView = [[FormRowsTableViewController alloc] initWithNibName:@"FormRowsTableViewController" bundle:nil];
         formRowsView.dividerIUR = [NSNumber numberWithInt:-2];//dirty fit the form row
         //            formRowsView.animateDelegate = self;
         formRowsView.isRequestSourceFromImageForm = YES;
         //            formRowsView.isShowingTableHeaderView = YES;
         formRowsView.isShowingSearchBar = YES;
         formRowsView.title = [l3DescrDetailDict objectForKey:@"Detail"];
         formRowsView.unsortedFormrows = unsortFormRows;
         [formRowsView syncUnsortedFormRowsWithOriginal];
         
         [self.navigationController pushViewController:formRowsView animated:YES];
         [formRowsView release];
         }
         } else {
         [ArcosUtils showMsg:@"No data found" delegate:nil];
         }
         */
    }
}

- (void)productGridImageFormRowsWithButton:(UIButton*)aBtn indexPath:(NSIndexPath*)anIndexPath {
    NSString* aKey = [self.l3SearchDataManager.sortKeyList objectAtIndex:anIndexPath.section];
    NSMutableArray* aSectionArray = [self.l3SearchDataManager.descrDetailSectionDict objectForKey:aKey];
    NSMutableArray* tmpDisplayList = [aSectionArray objectAtIndex:anIndexPath.row];
    //    NSMutableArray* tmpDisplayList = [self.l3SearchDataManager.descrDetailList objectAtIndex:anIndexPath.row];
    NSMutableDictionary* l3DescrDetailDict = [tmpDisplayList objectAtIndex:aBtn.tag];
    //    NSLog(@"descrDetailDict DescrDetailCode is %@", [l3DescrDetailDict objectForKey:@"DescrDetailCode"]);
    NSString* l3DescrDetailCode = [l3DescrDetailDict objectForKey:@"DescrDetailCode"];
    NSMutableArray* l5ChildrenList = [l3DescrDetailDict objectForKey:@"LeafChildren"];
    BranchLeafProductGridViewController* BLPGVC = [[BranchLeafProductGridViewController alloc] initWithNibName:@"BranchLeafProductGridViewController" bundle:nil];
    BLPGVC.navigationTitleDelegate = self;
    BLPGVC.title = [NSString stringWithFormat:@"%@", [l3DescrDetailDict objectForKey:@"Detail"]];
    BLPGVC.leafSmallTemplateViewController.leafSmallTemplateDataManager.branchDetail = [NSString stringWithFormat:@"%@", [l3DescrDetailDict objectForKey:@"Detail"]];
    BLPGVC.leafSmallTemplateViewController.leafSmallTemplateDataManager.branchDescrDetailCode = [NSString stringWithFormat:@"%@", l3DescrDetailCode];
    BLPGVC.leafSmallTemplateViewController.leafSmallTemplateDataManager.branchLxCode = [NSString stringWithFormat:@"%@", self.l3SearchDataManager.branchLxCode];
    BLPGVC.leafSmallTemplateViewController.leafSmallTemplateDataManager.leafLxCode = [NSString stringWithFormat:@"%@", self.l3SearchDataManager.leafLxCode];
    BLPGVC.leafSmallTemplateViewController.leafSmallTemplateDataManager.displayList = [NSMutableArray arrayWithArray:l5ChildrenList];
    [self.navigationController pushViewController:BLPGVC animated:YES];
    [BLPGVC release];
}

#pragma mark - search bar delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.mySearchBar.showsCancelButton = YES;
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    self.mySearchBar.showsCancelButton = NO;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {    
    if ([self.l3SearchDataManager.displayList count] <= self.l3SearchDataManager.maxCount) {
        if(searchText == nil || [searchText isEqualToString:@""]) {
            [self.l3SearchDataManager getAllDescrDetailList];
            [self reloadTableViewData];
            return;
        }
        [self.l3SearchDataManager searchDescrDetailWithKeyword:searchText];
        [self reloadTableViewData];
        
    } else {
        if(searchText == nil || [searchText isEqualToString:@""]) {
            [self.l3SearchDataManager clearDescrDetailList];
            [self reloadTableViewData];
            return;
        }
        [self.l3SearchDataManager searchDescrDetailWithKeyword:searchText];
        [self reloadTableViewData];
    }
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {    
    [self.mySearchBar resignFirstResponder];
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    [self.mySearchBar resignFirstResponder];
    self.mySearchBar.text = @"";
    if ([self.l3SearchDataManager.displayList count] <= self.l3SearchDataManager.maxCount) {
        [self.l3SearchDataManager getAllDescrDetailList];
        [self reloadTableViewData];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"scrollView.contentOffset.y: %f", scrollView.contentOffset.y);
//    self.mySearchBar.frame = CGRectMake(0,MAX(0,scrollView.contentOffset.y),scrollView.bounds.size.width,44);
} 

- (void)reloadTableViewData {
    [self.myTableView reloadData];
//    self.mySearchBar.frame = CGRectMake(0,MAX(0, self.myTableView.contentOffset.y), self.myTableView.bounds.size.width, 44);
}

#pragma mark BranchLeafProductNavigationTitleDelegate
- (void)resetTopBranchLeafProductNavigationTitle:(NSString*)aDetail {
    [self.navigationTitleDelegate resetTopBranchLeafProductNavigationTitle:aDetail];
}

@end
