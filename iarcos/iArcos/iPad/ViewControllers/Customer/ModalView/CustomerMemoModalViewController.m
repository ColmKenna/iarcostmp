//
//  CustomerMemoModalViewController.m
//  Arcos
//
//  Created by David Kilmartin on 05/12/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "CustomerMemoModalViewController.h"
#import "ArcosStackedViewController.h"

@implementation CustomerMemoModalViewController
@synthesize animateDelegate = _animateDelegate;
@synthesize memoListView;
@synthesize displayList;
@synthesize locationIUR;
@synthesize changedDataList = _changedDataList;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{    
    [memoListView release];
    self.displayList = nil;    
    self.locationIUR = nil;
    callGenericServices.delegate = nil;
    [callGenericServices release];
    if (customerMemoDataManager != nil) { [customerMemoDataManager release]; }
    if (self.changedDataList != nil) { self.changedDataList = nil; }    
            
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
    self.memoListView.backgroundColor=[UIColor colorWithRed:239/256.0f green:235/256.0f blue:229/256.0f alpha:1.0f];
//    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(closePressed:)];
//    
//    [self.navigationItem setLeftBarButtonItem:closeButton];  
//    
//    [closeButton release];
    
    UIBarButtonItem* saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(savePressed:)];
    [self.navigationItem setRightBarButtonItem:saveButton];
    [saveButton release];   
    

    callGenericServices = [[CallGenericServices alloc] initWithView:self.navigationController.view];
    callGenericServices.delegate = self;
    
    //set the notification  
    NSString* prefixSqlStatement = [NSString stringWithFormat:@"select CONVERT(VARCHAR(10),dateentered,103),contact,employee,details,memoType,IUR,LocationIUR from memoview where LocationIUR = %@", self.locationIUR];
    NSString* employeeSqlStatement = @"";
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] allowDownloadByEmployeeFlag]) {
        int employeeIur = [[SettingManager employeeIUR] intValue];
        employeeSqlStatement = [NSString stringWithFormat:@"AND EmployeeIUR = %d", employeeIur];
    }
    NSString* suffixSqlStatement = @"order by dateentered desc";
    NSString* sqlStatement = [NSString stringWithFormat:@"%@ %@ %@", prefixSqlStatement, employeeSqlStatement, suffixSqlStatement];
    
    [callGenericServices getData: sqlStatement];

    customerMemoDataManager = [[CustomerMemoDataManager alloc] init];
    customerMemoDataManager.locationIUR = self.locationIUR;
    self.changedDataList = [[[NSMutableArray alloc] init] autorelease];
    rowPointer = 0;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.memoListView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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

#pragma mark - Table view data source



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 128;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.    
    if (customerMemoDataManager.displayList != nil) {
        return [customerMemoDataManager.displayList count];
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"IdCustomerIarcosMemoTableCell";
    
    CustomerIarcosMemoTableCell *cell=(CustomerIarcosMemoTableCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil) {
        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"CustomerIarcosMemoTableCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[CustomerIarcosMemoTableCell class]] && [[(CustomerIarcosMemoTableCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell= (CustomerIarcosMemoTableCell *) nibItem;
                [cell configCellWithIndexPath:indexPath];
                cell.delegate = self;                
            }
        }
	}
    
    // Configure the cell...    
//    cell.verticalImageView.backgroundColor = [UIColor lightGrayColor];
//    cell.horizontalImageView.backgroundColor = [UIColor lightGrayColor];
    
    
    
    //    cell.text = [self.displayList objectAtIndex:indexPath.row];
    ArcosGenericClass* cellData = [customerMemoDataManager.displayList objectAtIndex:indexPath.row];
    @try {
        cell.date.text = ([cellData Field1] == nil) ? @"" : [[cellData Field1] substringToIndex:10];
    }
    @catch (NSException *exception) {
        [ArcosUtils showMsg:[exception reason] delegate:nil];
    }
    
    cell.contact.text = [cellData Field2];
    cell.employee.text = [cellData Field3];
    cell.memo.text = [cellData Field4];
    cell.memoType.text = [cellData Field5];
    
    if ([cell.date.text isEqualToString:customerMemoDataManager.locationMemoDateString]) {        
        cell.date.hidden = YES;
//        UIImage* anImage = [UIImage imageNamed:@"presenterTableCell_yellow_stretchable.png"];
//        cell.bgImageView.image = [anImage stretchableImageWithLeftCapWidth:30 topCapHeight:0];
        cell.contentView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:153.0/255.0 alpha:1.0f];
    } else {
        cell.date.hidden = NO;
//        UIImage* anImage = [UIImage imageNamed:@"presenterTableCell_stretchable.png"];
//        cell.bgImageView.image = [anImage stretchableImageWithLeftCapWidth:30 topCapHeight:0];
        cell.contentView.backgroundColor = [UIColor whiteColor];
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
//    CustomerIarcosMemoTableCell* cell = (CustomerIarcosMemoTableCell*)[tableView cellForRowAtIndexPath:indexPath];
//    cell.verticalImageView.backgroundColor = [UIColor lightGrayColor];
//    cell.horizontalImageView.backgroundColor = [UIColor lightGrayColor];
}

-(void)closePressed:(id)sender {
//    NSLog(@"closePressed is pressed");
//    [self.animateDelegate dismissSlideAcrossViewAnimation];
    [self.rcsStackedController popTopNavigationController:YES];
}


#pragma mark - GetDataGenericDelegate
-(void)setGetDataResult:(ArcosGenericReturnObject*) result {
//    NSLog(@"set result happens in customer memo");
    if (result == nil) {
        return;
    }
    if (result.ErrorModel.Code >= 0) {
        self.displayList = result.ArrayOfData;
        [customerMemoDataManager processRawData:result.ArrayOfData];
        
        [self.tableView reloadData];        
    } else if(result.ErrorModel.Code < 0) {
        [ArcosUtils showMsg:result.ErrorModel.Code message:result.ErrorModel.Message delegate:nil];
        
    }
}

-(void)savePressed:(id)sender {
    [self.view endEditing:YES];
    callGenericServices.isNotRecursion = NO;
    rowPointer = 0;
    if (customerMemoDataManager.isLocationMemoExistent) {//All with update action        
        self.changedDataList = [customerMemoDataManager getAllChangedDataList];
        if ([self.changedDataList count] == 0) {
            [ArcosUtils showDialogBox:@"There is no change." title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
                
            }];
            return;
        }
        [self saveChangedDataList:self.changedDataList];
    } else {//create mix with update
        self.changedDataList = [customerMemoDataManager getChangedDataList];
        [customerMemoDataManager getLocationMemoChangedDataList];
        if ([self.changedDataList count] == 0 && [customerMemoDataManager.locationMemoChangedDataList count] == 0) {
            [ArcosUtils showDialogBox:@"There is no change." title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
                
            }];
            return;
        }
        if ([self.changedDataList count] == 0) {
            [callGenericServices createRecord:@"Memo" fields:customerMemoDataManager.locationMemoArcosCreateRecordObject];
        } else {
            [self saveChangedDataList:self.changedDataList];
        }
    }
}

-(void)saveChangedDataList:(NSMutableArray*)aChangedDataList {
    if (rowPointer == [aChangedDataList count]) return;
    ArcosGenericClass* arcosGenericClass = [aChangedDataList objectAtIndex:rowPointer];
    NSNumber* iur = [ArcosUtils convertStringToNumber:[arcosGenericClass Field6]];
    
    [callGenericServices updateRecord:@"Memo" iur:[iur intValue] fieldName:@"details" newContent:[arcosGenericClass Field4]];
}

#pragma mark - CustomerMemoInputDelegate
-(void)inputFinishedWithData:(id)data forIndexpath:(NSIndexPath*)theIndexpath {
    [customerMemoDataManager updateChangedData:data withIndexPath:theIndexpath];
}

-(UIViewController*)retrieveParentViewController {
    return self;
}

-(void)setUpdateRecordResult:(ArcosGenericReturnObject*) result {
    if (result == nil) {
        [callGenericServices.HUD hide:YES];
        return;
    }
    if (result.ErrorModel.Code > 0) {
        //we don't think we need to amend the information in core data
//        [[ArcosCoreData sharedArcosCoreData] insertMemoWithData:[self.changedDataList objectAtIndex:rowPointer]];
        rowPointer++;
        if (rowPointer == [self.changedDataList count]) {
            if ([customerMemoDataManager.locationMemoChangedDataList count] > 0) {
                [callGenericServices createRecord:@"Memo" fields:customerMemoDataManager.locationMemoArcosCreateRecordObject];
            } else {
                [callGenericServices.HUD hide:YES];
                [ArcosUtils showDialogBox:@"The memo has been edited." title:@"" delegate:self target:self tag:0 handler:^(UIAlertAction *action) {
                    [self closePressed:nil];
                }];
            }            
        }
        [self saveChangedDataList:self.changedDataList];
    } else if(result.ErrorModel.Code <= 0) {
        [callGenericServices.HUD hide:YES];
        NSString* titleMsg = (result.ErrorModel.Code == 0) ? @"" : [GlobalSharedClass shared].errorTitle;
        [ArcosUtils showDialogBox:result.ErrorModel.Message title:titleMsg delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
    }
}

#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0){
        //Code that will run after you press ok button 
        [self closePressed:nil];
    }
}

-(void)setCreateRecordResult:(ArcosGenericClass*) result {
    callGenericServices.isNotRecursion = YES;
    [callGenericServices.HUD hide:YES];
    if (result == nil) {
        return;
    }
    if (result.Field1 != nil && ![result.Field1 isEqualToString:@""]
        && ![result.Field1 isEqualToString:@"0"]) {
        [ArcosUtils showDialogBox:@"The memo against the location has been created." title:@"" delegate:self target:self tag:0 handler:^(UIAlertAction *action) {
            [self closePressed:nil];
        }];
    } else {
        NSMutableArray* subObjects = result.SubObjects;
        if (subObjects != nil && [subObjects count] > 0) {
            ArcosGenericClass* errorArcosGenericClass = [subObjects objectAtIndex:0];
            [ArcosUtils showDialogBox:[errorArcosGenericClass Field2] title:[GlobalSharedClass shared].errorTitle delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
                
            }];
        } else {
            [ArcosUtils showDialogBox:@"The operation could not be completed." title:[GlobalSharedClass shared].errorTitle delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
                
            }];
        }
    }    
}

@end
