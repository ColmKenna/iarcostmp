//
//  UtilitiesSettingDetailViewController.m
//  Arcos
//
//  Created by David Kilmartin on 05/09/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "UtilitiesSettingDetailViewController.h"
@interface UtilitiesSettingDetailViewController (Private)
-(void)showAuthorizeWarning;
- (void)processTextFieldPassword:(NSString*)aTextFieldPassword;
@end

@implementation UtilitiesSettingDetailViewController
@synthesize  settingManager;
@synthesize  settingGroups;
@synthesize cellFactory;
@synthesize tablecellPopover = _tablecellPopover;
@synthesize saveButton = _saveButton;
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
    self.settingManager = nil;
    self.settingGroups = nil;
    self.saveButton = nil;
    self.cellFactory = nil;
    self.tablecellPopover = nil;
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
    self.title=@"Setting";

    //set the save button
    //add save button to the navigation bar
    self.saveButton = [[[UIBarButtonItem alloc]
                                   initWithTitle: @"Save"
                                   style:UIBarButtonItemStylePlain
                                   target: self
                                   action:@selector(saveSetting)] autorelease];
    self.navigationItem.rightBarButtonItem = self.saveButton;
    
    self.tableView.allowsSelection=NO;
    self.settingGroups=[NSArray arrayWithObjects:@"Personal",@"Connection",@"Download",@"Default Types",@"Order Processing",@"Display", nil];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
//    self.settingManager = [SettingManager setting];
    self.cellFactory=[SettingTableCellFactory factory];
    
    //authorization
    isAuthorized=NO;
    managerPass=@"";
    isAdvanceSettingChanged=NO;


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
    self.settingManager = [SettingManager setting];
    [self.tableView reloadData];

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
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
										 duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];
        if(self.tablecellPopover!=nil)
            [self.tablecellPopover dismissPopoverAnimated:NO];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.settingGroups count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{    
    return [self.settingGroups objectAtIndex:section];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSString* groupName=[self.settingGroups objectAtIndex:section];
    NSUInteger itemsCount=0;
    if ([groupName isEqualToString:@"Personal"]) {
         itemsCount=[self.settingManager numberOfItemsOnKeypath:[NSString stringWithFormat:@"PersonalSetting.%@",groupName]];
    }else{
        itemsCount=[self.settingManager numberOfItemsOnKeypath:[NSString stringWithFormat:@"CompanySetting.%@",groupName]];
    }
    
    return itemsCount;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //get the setting keys
    NSString* groupName=[self.settingGroups objectAtIndex:indexPath.section];
    NSString* keypath=@"";
    if ([groupName isEqualToString:@"Personal"]) {
        keypath=[NSString stringWithFormat:@"PersonalSetting.%@",groupName];
    }else{
        keypath=[NSString stringWithFormat:@"CompanySetting.%@",groupName];
    }
    //NSLog(@"setting manage is %@",self.settingManager.settingDict);
    NSMutableDictionary* item=[self.settingManager getSettingForKeypath:keypath atIndex:indexPath.row];
    
    
    
    //static NSString *CellIdentifier = @"Cell";
    
    SettingInputCell* cell = (SettingInputCell*)[tableView dequeueReusableCellWithIdentifier:[self.cellFactory identifierWithData:item]];
    if (cell == nil) {
        //cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell=(SettingInputCell*)[self.cellFactory createSettingInputCellWithData:item];
        cell.delegate=self;
    }
    
    // Configure the cell...
   
    //cell.textLabel.text=[item objectForKey:@"Label"];
    cell.indexPath=indexPath;
    [cell configCellWithData:item];
    
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
#pragma mark update setting
-(void)updateValue:(id)data ForIndexpath:(NSIndexPath*)indexPath{
    //get the setting keys
    NSString* groupName=[self.settingGroups objectAtIndex:indexPath.section];
    NSString* keypath=@"";
    if ([groupName isEqualToString:@"Personal"]) {
        keypath=[NSString stringWithFormat:@"PersonalSetting.%@",groupName];
    }else{
        keypath=[NSString stringWithFormat:@"CompanySetting.%@",groupName];
        isAdvanceSettingChanged=YES;
    }
    
    [self.settingManager updateSettingForKeypath:keypath atIndex:indexPath.row withData:data];
}
-(void)saveSetting{
    if (isAdvanceSettingChanged) {
        [self showAuthorizeWarning];
    }else{
        BOOL isSuccess=[self.settingManager saveSetting];
        if (isSuccess) {
            [ArcosUtils showDialogBox:@"Setting is saved!" title:@"Warning" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
                
            }];
        }else{
            [ArcosUtils showDialogBox:@"Fail to save the setting!" title:@"Warning" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
                
            }];
        }
    }
}
#pragma mark authorize window
-(void)showAuthorizeWarning{
    if ([UIAlertController class]) {
        __weak typeof(self) weakSelf = self;
        UIAlertController* tmpDialogBox = [UIAlertController alertControllerWithTitle:@"" message:@"Please Enter Manager Password!\n" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
            UITextField* myTextField = [tmpDialogBox.textFields objectAtIndex:0];
            [weakSelf processTextFieldPassword:myTextField.text];
        }];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
            [weakSelf.settingManager reloadSetting];
            [weakSelf.tableView reloadData];
            isAdvanceSettingChanged=NO;
        }];
        [tmpDialogBox addAction:cancelAction];
        [tmpDialogBox addAction:okAction];
        [tmpDialogBox addTextFieldWithConfigurationHandler:^(UITextField* textField) {
            textField.secureTextEntry = true;
        }];
        [weakSelf presentViewController:tmpDialogBox animated:YES completion:nil];
    } else {
        AlertPrompt *prompt = [AlertPrompt alloc];
        prompt = [prompt initWithTitle:@"Please Enter Manager Password!\n\n" message:nil delegate:self cancelButtonTitle:@"Cancel" okButtonTitle:@"OK"];
        prompt.tag=88888;
        [prompt show];
        [prompt release];
    }
}
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

#pragma mark setting input cell delegate
-(void)editStartForIndexpath:(NSIndexPath*)theIndexpath{
    //[self showAuthorizeWarning];
    self.saveButton.enabled=NO;
}
-(void)inputFinishedWithData:(id)data forIndexpath:(NSIndexPath*)theIndexpath{
    
//    NSLog(@"input is completed with data %@",data);
    [self updateValue:data ForIndexpath:theIndexpath];
    
    self.saveButton.enabled=YES;
}
-(void)invalidDataForIndexpath:(NSString*)theIndexpath{
    
}
-(void)popoverShows:(UIPopoverController*)aPopover{
    self.tablecellPopover=aPopover;
}
#pragma mark alert view delegate
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (buttonIndex != [alertView cancelButtonIndex]&&alertView.tag==88888)
	{
		NSString *entered = [(AlertPrompt *)alertView enteredText];
//        NSLog(@"the text enter %@",entered);
        [self processTextFieldPassword:entered];
	}else{
        //reset the setting
        [self.settingManager reloadSetting];
        [self.tableView reloadData];
        isAdvanceSettingChanged=NO;
    }
}

- (void)processTextFieldPassword:(NSString*)aTextFieldPassword {
    NSString* passcode = [[GlobalSharedClass shared] currentPasscode];
    if (aTextFieldPassword != nil && [aTextFieldPassword caseInsensitiveCompare:passcode] == NSOrderedSame) {
        BOOL isSuccess=[self.settingManager saveSetting];
        if (isSuccess) {
            [ArcosUtils showDialogBox:@"Setting is saved!" title:@"Warning" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
                
            }];
        }else{
            [ArcosUtils showDialogBox:@"Fail to save the setting!" title:@"Warning" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
                
            }];
        }
        isAdvanceSettingChanged=NO;
    }else{
        //reset the setting
        [self.settingManager reloadSetting];
        [self.tableView reloadData];
        isAdvanceSettingChanged=NO;
    }
}

@end
