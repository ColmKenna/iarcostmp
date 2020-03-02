//
//  GenericUITableViewController.m
//  Arcos
//
//  Created by David Kilmartin on 21/03/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "GenericUITableViewController.h"
#import "ArcosAppDelegate_iPad.h"
#import "ArcosEmailValidator.h"
@interface GenericUITableViewController ()
-(void)clearGlobalNavigationController;
- (void)processTextFieldPassword:(NSString*)aTextFieldPassword;
@end

@implementation GenericUITableViewController
@synthesize animateDelegate = _animateDelegate;
@synthesize customiseTableHeaderView;
@synthesize customiseScrollView;
@synthesize parentCellData;
@synthesize cellWidth,cellHeight;
@synthesize attrNameList;
@synthesize attrNameTypeList;
@synthesize attrDict;
@synthesize customiseTableView;
@synthesize displayList = _displayList;
@synthesize globalNavigationController = _globalNavigationController;
@synthesize rootView = _rootView;
@synthesize clearDelegate = _clearDelegate;
@synthesize mailController = _mailController;
@synthesize filePath = _filePath;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    if (self.customiseTableHeaderView != nil) { self.customiseTableHeaderView = nil; }
    if (self.customiseScrollView != nil) {
        self.customiseScrollView = nil;
    }
    if (self.parentCellData != nil) { self.parentCellData = nil; }
    if (self.attrNameList != nil) {
        self.attrNameList = nil;
    }
    if (self.attrNameTypeList != nil) {
        self.attrNameTypeList = nil;
    }
    if (self.attrDict != nil) {
        self.attrDict = nil;
    }
    if (self.customiseTableView != nil) {
        self.customiseTableView = nil;
    }
    if (self.displayList != nil) {
        self.displayList = nil;
    }
    if (arcosCustomiseAnimation != nil) {
        [arcosCustomiseAnimation release];
    }
    if (self.globalNavigationController != nil) { self.globalNavigationController = nil; }    
    if (self.rootView != nil) { self.rootView = nil; }    
    if (self.mailController != nil) { self.mailController = nil; }
    self.filePath = nil;
    
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
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(closePressed:)];
    NSMutableArray* rightButtonList = [NSMutableArray arrayWithCapacity:2];
    UIBarButtonItem* emailButton = [[UIBarButtonItem alloc] initWithTitle:@"Email" style:UIBarButtonItemStylePlain target:self action:@selector(emailAttachment:)];
    [rightButtonList addObject:emailButton];
    [emailButton release];
    
    UIBarButtonItem *clearTableButton = [[UIBarButtonItem alloc] initWithTitle:@"ClearTable" style:UIBarButtonItemStylePlain target:self action:@selector(clearTablePressed:)];
    [rightButtonList addObject:clearTableButton];
    [self.navigationItem setLeftBarButtonItem:closeButton];     
    [self.navigationItem setRightBarButtonItems:rightButtonList];
    [closeButton release];
    [clearTableButton release];
    self.cellWidth = 128;
    self.cellHeight = 44;
//    self.attrNameList = [self.parentCellData objectForKey:@"AttributeName"];
//    self.attrDict = [self.parentCellData objectForKey:@"AttributeDict"];
//    self.displayList = [[ArcosCoreData sharedArcosCoreData] entityContent:[self.parentCellData objectForKey:@"TableName"]];
    /*
    ArcosAppDelegate_iPad* arcosDelegate = [[UIApplication sharedApplication] delegate];
    UITabBarController* tabbar = (UITabBarController*) arcosDelegate.mainTabbarController;
    */
    
    self.rootView = [ArcosUtils getRootView];
    
    arcosCustomiseAnimation = [[ArcosCustomiseAnimation alloc] init];
    arcosCustomiseAnimation.delegate = self;
    [ArcosUtils configEdgesForExtendedLayout:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
//    self.customiseTableHeaderView = nil;
    self.customiseScrollView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
//    NSLog(@"shouldAutorotateToInterfaceOrientation");
	return YES;
}


- (void)viewWillAppear:(BOOL)animated
{
//    NSLog(@"customiseScrollView.frame.size.width: %f %f", customiseScrollView.frame.size.width, self.view.frame.size.height);
    [super viewWillAppear:animated];
    float totalCellWidth = self.cellWidth * [self.attrNameList count];
    float customiseWidth = self.customiseScrollView.frame.size.width > totalCellWidth ? self.customiseScrollView.frame.size.width : totalCellWidth;
    if (customiseWidth < 1024) {
        customiseWidth = 1024;
    }
    self.customiseScrollView.contentSize = CGSizeMake(customiseWidth, self.view.frame.size.height);
    
    self.customiseTableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, customiseWidth, self.view.frame.size.height) style:UITableViewStylePlain] autorelease];
    SEL cellLayoutMarginsFollowReadableWidthSelector = NSSelectorFromString(@"setCellLayoutMarginsFollowReadableWidth:");
    if([self.customiseTableView respondsToSelector:cellLayoutMarginsFollowReadableWidthSelector])
    {
//        self.customiseTableView.cellLayoutMarginsFollowReadableWidth = NO;
        BOOL myBoolValue = NO;
        NSMethodSignature* signature = [[self.customiseTableView class] instanceMethodSignatureForSelector:cellLayoutMarginsFollowReadableWidthSelector];
        NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:self.customiseTableView];
        [invocation setSelector:cellLayoutMarginsFollowReadableWidthSelector];
        [invocation setArgument:&myBoolValue atIndex:2];
        [invocation invoke];
    }
    self.customiseTableView.autoresizingMask =  UIViewAutoresizingFlexibleHeight;
    self.customiseTableView.delegate = self;
    self.customiseTableView.dataSource = self;
    
    [self.customiseScrollView addSubview:self.customiseTableView];
    self.customiseTableHeaderView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.customiseScrollView.contentSize.width, self.cellHeight)] autorelease];
    self.customiseTableHeaderView.backgroundColor = [UIColor darkGrayColor];
    for (int i = 0; i < [self.attrNameList count]; i++) {
        CGFloat xOrigin = i * self.cellWidth;
        UILabel* headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(xOrigin, 0, self.cellWidth, self.cellHeight)];
        headerLabel.textAlignment = NSTextAlignmentCenter;
        headerLabel.text = [self.attrNameList objectAtIndex:i];
        headerLabel.backgroundColor = [UIColor clearColor];
        [headerLabel setTextColor:[UIColor whiteColor]];
        [headerLabel setFont:[UIFont systemFontOfSize:17.0f]];
        [self.customiseTableHeaderView addSubview:headerLabel];
        [headerLabel release];
    }
    
    self.customiseScrollView.pagingEnabled = YES; 

//    NSLog(@"self.customiseScrollView.contentInset %f, %f, %f, %f", self.customiseScrollView.scrollIndicatorInsets.top,self.customiseScrollView.scrollIndicatorInsets.left,self.customiseScrollView.scrollIndicatorInsets.bottom,self.customiseScrollView.scrollIndicatorInsets.right);
//    self.customiseScrollView.bounds = CGRectMake(0, 0, self.cellWidth, self.customiseScrollView.frame.size.height);
//    self.customiseScrollView.clipsToBounds = NO;
//    NSLog(@"viewWillAppear with rotaion.");
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[self.customiseTableHeaderView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.customiseTableView removeFromSuperview];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

#pragma mark - Table view data source
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{   
    return self.customiseTableHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (self.displayList != nil) {
        return [self.displayList count];
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{        
    static NSString *CellIdentifier = @"Cell";
    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
//    }
    GenericUITableTableCell* cell = [[[GenericUITableTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    // Configure the cell...    
    NSMutableDictionary* recordCellData = [self.displayList objectAtIndex:indexPath.row];
//    NSDictionary* attrDict = [self.parentCellData objectForKey:@"AttributeDict"];
    
    
    for (int i = 0; i < [self.attrNameList count]; i++) {
//        NSAttributeDescription* attrDesc = [self.attrDict objectForKey:[self.attrNameList objectAtIndex:i]];
//        NSString* attrType = [attrDesc attributeValueClassName];
        NSString* attrNameType = [self.attrNameTypeList objectAtIndex:i];
        CGFloat xOrigin = i * self.cellWidth;
        cell.frame = CGRectMake(0, 0, self.customiseScrollView.contentSize.width, 44);
        UILabel* cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(xOrigin, 11, self.cellWidth, 21)];        
        cellLabel.textAlignment = NSTextAlignmentCenter;
        cellLabel.text = [ArcosUtils convertToString:[recordCellData objectForKey:[self.attrNameList objectAtIndex:i]] fieldType:attrNameType];
        [cellLabel setTextColor:[UIColor blackColor]];
        [cellLabel setFont:[UIFont systemFontOfSize:17.0f]];
        [cell addSubview:cellLabel];
        [cell.cellLabelList addObject:cellLabel];
        [cellLabel release];
    }
    return cell;
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
    
    NSLog(@"GenericUITableDetailViewController is clicked.");
    GenericUITableDetailViewController* cuitdvc = [[GenericUITableDetailViewController alloc] initWithNibName:@"GenericUITableDetailViewController" bundle:nil];
    cuitdvc.title = [NSString stringWithFormat:@"%@ Details", [ArcosUtils convertNilToEmpty:self.title]];
    cuitdvc.attrNameList = self.attrNameList;
    cuitdvc.attrNameTypeList = self.attrNameTypeList;
//    cuitdvc.attrDict = self.attrDict;
    cuitdvc.animateDelegate = self;
    cuitdvc.recordCellData = [self.displayList objectAtIndex:indexPath.row];
    self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:cuitdvc] autorelease];
    
    [cuitdvc release];
    [self.customiseTableView deselectRowAtIndexPath:indexPath animated:YES];
    [arcosCustomiseAnimation addPushViewAnimation:self.rootView withController:self.globalNavigationController];

    
}

-(void)closePressed:(id)sender {
    [self.animateDelegate dismissSlideAcrossViewAnimation];
}

- (void)dismissUIViewAnimation {
    [arcosCustomiseAnimation dismissPushViewAnimation:self.rootView withController:self.globalNavigationController];
}
- (void)dismissSlideAcrossViewAnimation {
    [arcosCustomiseAnimation dismissPushViewAnimation:self.rootView withController:self.globalNavigationController];
}


-(void)insertRow:(NSMutableDictionary*)rowData{
    [self.displayList addObject:rowData];
    
    NSIndexPath* indexPath=[NSIndexPath indexPathForRow:[self.displayList count] inSection:0];
    [self.customiseTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]withRowAnimation:UITableViewRowAnimationFade];
}

-(void)clearTablePressed:(id)sender {
    NSLog(@"clearTablePressed");
    if ([UIAlertController class]) {
        __weak typeof(self) weakSelf = self;
        UIAlertController* tmpDialogBox = [UIAlertController alertControllerWithTitle:@"" message:@"Please Enter Manager Password!\n" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
            UITextField* myTextField = [tmpDialogBox.textFields objectAtIndex:0];
            [weakSelf processTextFieldPassword:myTextField.text];
        }];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){}];
        
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

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (buttonIndex != [alertView cancelButtonIndex]&&alertView.tag==88888)
	{
		NSString *entered = [(AlertPrompt *)alertView enteredText];
//        NSLog(@"the text enter %@",entered);
        [self processTextFieldPassword:entered];
	}
    if (alertView.tag == 99999) {
        [self closePressed:nil];
    }
}

-(void)clearGlobalNavigationController {
    self.globalNavigationController = nil;
}

#pragma mark ArcosCustomiseAnimationDelegate
- (void)dismissPushViewCallBack {
    [self performSelector:@selector(clearGlobalNavigationController) withObject:nil afterDelay:0.3];
}

- (void)processTextFieldPassword:(NSString*)aTextFieldPassword {
    NSString* passcode = [[GlobalSharedClass shared] currentPasscode];
    if (aTextFieldPassword != nil && [aTextFieldPassword caseInsensitiveCompare:passcode] == NSOrderedSame) {
        [[ArcosCoreData sharedArcosCoreData] clearTableWithName:self.title];
        [self.clearDelegate refreshClearTableOperation];
        NSString* message = [NSString stringWithFormat:@"The contents of %@ have been deleted.",self.title];
        [ArcosUtils showDialogBox:message title:@"" delegate:self target:self tag:99999 handler:^(UIAlertAction *action) {
            [self closePressed:nil];
        }];
    } else {
        NSLog(@"self.title is: %@",self.title);
        [ArcosUtils showDialogBox:@"The password you entered is incorrect." title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
    }
}


- (void)emailAttachment:(id)sender {
    NSMutableString* fileContent = [[NSMutableString alloc] init];
    NSString* fileName = [NSString stringWithFormat:@"%@.csv", self.title];
    self.filePath = [NSString stringWithFormat:@"%@/%@",[FileCommon documentsPath], fileName];
    for (int i = 0; i < [self.attrNameList count]; i++) {
        [fileContent appendString:[self.attrNameList objectAtIndex:i]];
        [fileContent appendString:[GlobalSharedClass shared].fieldDelimiter];
    }
    [fileContent appendString:[GlobalSharedClass shared].rowDelimiter];
    for (int m = 0; m < [self.displayList count]; m++) {
        NSMutableDictionary* auxRecordCellData = [self.displayList objectAtIndex:m];
        for (int i = 0; i < [self.attrNameList count]; i++) {
            NSString* attrNameType = [self.attrNameTypeList objectAtIndex:i];
            [fileContent appendString:[ArcosUtils convertNilToEmpty:[ArcosUtils convertToString:[auxRecordCellData objectForKey:[self.attrNameList objectAtIndex:i]] fieldType:attrNameType]]];
            [fileContent appendString:[GlobalSharedClass shared].fieldDelimiter];
        }
        [fileContent appendString:[GlobalSharedClass shared].rowDelimiter];
    }
    
    NSError* fileError = nil;
    [fileContent writeToFile:self.filePath atomically:YES encoding:NSUTF8StringEncoding error:&fileError];
    [fileContent release];
    if (fileError != nil) {
        [ArcosUtils showDialogBox:[fileError localizedDescription] title:[GlobalSharedClass shared].errorTitle delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
        return;
    }
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] useMailLibFlag] || [[ArcosConfigDataManager sharedArcosConfigDataManager] useOutlookFlag]) {
        ArcosMailWrapperViewController* amwvc = [[ArcosMailWrapperViewController alloc] initWithNibName:@"ArcosMailWrapperViewController" bundle:nil];
        amwvc.mailDelegate = self;
        amwvc.subjectText = fileName;
        if ([FileCommon fileExistAtPath:self.filePath]) {
            NSData* data = [NSData dataWithContentsOfFile:self.filePath];
            if ([[ArcosConfigDataManager sharedArcosConfigDataManager] useOutlookFlag]) {
                [amwvc.attachmentList addObject:[ArcosAttachmentContainer attachmentWithData:data fileName:fileName]];
            } else {
                [amwvc.attachmentList addObject:[MCOAttachment attachmentWithData:data filename:fileName]];
            }
            
        }
        amwvc.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:.5f];
        self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:amwvc] autorelease];
        CGRect parentNavigationRect = [ArcosUtils getCorrelativeRootViewRect:self.rootView];
        self.globalNavigationController.view.frame = CGRectMake(0, parentNavigationRect.size.height, parentNavigationRect.size.width, parentNavigationRect.size.height);
        [self.rootView addChildViewController:self.globalNavigationController];
        [self.rootView.view addSubview:self.globalNavigationController.view];
        [self.globalNavigationController didMoveToParentViewController:self.rootView];
        [amwvc release];
        [UIView animateWithDuration:0.3f animations:^{
            self.globalNavigationController.view.frame = parentNavigationRect;
        } completion:^(BOOL finished){
            
        }];
        return;
    }
    
    if (![ArcosEmailValidator checkCanSendMailStatus]) return;
    self.mailController = [[[MFMailComposeViewController alloc] init] autorelease];
    self.mailController.mailComposeDelegate = self;
    
    @try {
        if ([FileCommon fileExistAtPath:self.filePath]) {
            [self.mailController setSubject:fileName];
            NSData* data = [NSData dataWithContentsOfFile:self.filePath];            
            [self.mailController addAttachmentData:data mimeType:@"application/csv" fileName:fileName];
            [FileCommon removeFileAtPath:self.filePath];
        } else {
            [ArcosUtils showDialogBox:[NSString stringWithFormat:@"%@ does not exist.",fileName] title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
                
            }];
        }
    }
    @catch (NSException *exception) {
        [ArcosUtils showDialogBox:[exception reason] title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
    }
    [self presentViewController:self.mailController animated:YES completion:nil];    
}

#pragma mark ArcosMailTableViewControllerDelegate
- (void)arcosMailDidFinishWithResult:(ArcosMailComposeResult)aResult error:(NSError *)anError {
    [UIView animateWithDuration:0.3f animations:^{
        CGRect parentNavigationRect = [ArcosUtils getCorrelativeRootViewRect:self.rootView];
        self.globalNavigationController.view.frame = CGRectMake(0, parentNavigationRect.size.height, parentNavigationRect.size.width, parentNavigationRect.size.height);
    } completion:^(BOOL finished){
        [self.globalNavigationController willMoveToParentViewController:nil];
        [self.globalNavigationController.view removeFromSuperview];
        [self.globalNavigationController removeFromParentViewController];
        self.globalNavigationController = nil;
    }];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    NSString* message = nil;
    switch (result) {
        case MFMailComposeResultCancelled:
            message = @"Result: canceled";
            break;
            
        case MFMailComposeResultSaved:
            message = @"Result: saved";
            break;
            
        case MFMailComposeResultSent: {
            message = @"Sent Email OK";
        }
            break;
            
        case MFMailComposeResultFailed: {
            message = @"Failed to Send Email";
            [ArcosUtils showDialogBox:message title:@"Error !" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
                
            }];
        }            
            break;
            
        default:
            message = @"Result: not sent";
            break;
    }        
    
    [self becomeFirstResponder];
    
    if (result != MFMailComposeResultFailed) {
        [self alertViewCallBack];
    } else {
        [ArcosUtils showDialogBox:message title:@"" delegate:nil target:controller tag:0 handler:^(UIAlertAction *action) {
            [self alertViewCallBack];
        }];
    }    
}

- (void)alertViewCallBack {
    [self dismissViewControllerAnimated:YES completion:^ {
        self.mailController.mailComposeDelegate = nil;
        self.mailController = nil;
//        [FileCommon removeFileAtPath:self.filePath];
    }];
}

@end
