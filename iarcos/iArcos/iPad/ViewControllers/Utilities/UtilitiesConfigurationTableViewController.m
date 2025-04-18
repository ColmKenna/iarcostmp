//
//  UtilitiesConfigurationTableViewController.m
//  iArcos
//
//  Created by David Kilmartin on 23/04/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import "UtilitiesConfigurationTableViewController.h"

@interface UtilitiesConfigurationTableViewController ()

@end

@implementation UtilitiesConfigurationTableViewController
@synthesize saveDelegate = _saveDelegate;
@synthesize utilitiesConfigurationDataManager = _utilitiesConfigurationDataManager;
@synthesize globalNavigationController = _globalNavigationController;
@synthesize rootView = _rootView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.rootView = [ArcosUtils getRootView];
    self.title = @"Configuration";
    self.utilitiesConfigurationDataManager = [[[UtilitiesConfigurationDataManager alloc] init] autorelease];
    [self.utilitiesConfigurationDataManager retrieveDescrDetailIOData];
    /*
    NSMutableArray* rightButtonList = [NSMutableArray arrayWithCapacity:2];
    
    UIBarButtonItem* saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(savePressed)];
    [rightButtonList addObject:saveButton];
    [saveButton release];
    UIBarButtonItem* mailButton = [[UIBarButtonItem alloc] initWithTitle:@"Mail" style:UIBarButtonItemStylePlain target:self action:@selector(mailPressed)];
    [rightButtonList addObject:mailButton];
    [mailButton release];
//    [self.navigationItem setRightBarButtonItem:saveButton];
    [self.navigationItem setRightBarButtonItems:rightButtonList];
    */
    [self configButtonList];
}

- (void)configButtonList {
    NSMutableArray* rightButtonList = [NSMutableArray arrayWithCapacity:2];
        
    UIBarButtonItem* saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(savePressed)];
    [rightButtonList addObject:saveButton];
    [saveButton release];
//    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] useOutlookFlag]) {
//        UIBarButtonItem* mailButton = [[UIBarButtonItem alloc] initWithTitle:@"Mail" style:UIBarButtonItemStylePlain target:self action:@selector(mailPressed)];
//        [rightButtonList addObject:mailButton];
//        [mailButton release];
//    }
    [self.navigationItem setRightBarButtonItems:rightButtonList];
}

- (void)savePressed {
    [self.utilitiesConfigurationDataManager retrieveChangedList];
    if ([self.utilitiesConfigurationDataManager.changedList count] == 0) {
//        [ArcosUtils showMsg:@"There is no change." delegate:nil];
        [ArcosUtils showDialogBox:@"There is no change." title:@"" target:self handler:nil];
        return;
    }
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
    
}

- (void)processTextFieldPassword:(NSString*)aTextFieldPassword {
    NSString* passcode = [[GlobalSharedClass shared] currentPasscode];
    if (aTextFieldPassword != nil && [aTextFieldPassword caseInsensitiveCompare:passcode] == NSOrderedSame) {
        [self.utilitiesConfigurationDataManager saveChangedList];
        [ArcosUtils showDialogBox:@"Configuration has been saved." title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
        [self.saveDelegate didSaveButtonPressed];
    } else {
        [ArcosUtils showDialogBox:@"The password you entered is incorrect." title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
    }
}

- (void)mailPressed {
    UtilitiesMailViewController* umvc = [[UtilitiesMailViewController alloc] initWithNibName:@"UtilitiesMailViewController" bundle:nil];
    umvc.presentDelegate = self;
//    umvc.modalPresentationStyle = UIModalPresentationFormSheet;
//    umvc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:umvc] autorelease];
//    [[ArcosUtils getRootView] presentViewController:tmpNavigationController animated:YES completion:nil];
//    [tmpNavigationController release];
    [umvc release];
    CGRect parentNavigationRect = [ArcosUtils getCorrelativeRootViewRect:self.rootView];
    self.globalNavigationController.view.frame = CGRectMake(0, parentNavigationRect.size.height, parentNavigationRect.size.width, parentNavigationRect.size.height);
    [self.rootView addChildViewController:self.globalNavigationController];
    [self.rootView.view addSubview:self.globalNavigationController.view];
    [self.globalNavigationController didMoveToParentViewController:self.rootView];
    [UIView animateWithDuration:0.3f animations:^{
        self.globalNavigationController.view.frame = parentNavigationRect;
    } completion:^(BOOL finished){
        
    }];
}

#pragma mark CustomisePresentViewControllerDelegate
- (void)didDismissCustomisePresentView {
//    [[ArcosUtils getRootView] dismissViewControllerAnimated:YES completion:nil];
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

- (void)dealloc {
    self.utilitiesConfigurationDataManager = nil;
    self.globalNavigationController = nil;
    self.rootView = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.utilitiesConfigurationDataManager.displayList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"IdUtilitiesConfigurationTableCell";
    
    UtilitiesConfigurationTableCell* cell=(UtilitiesConfigurationTableCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"UtilitiesConfigurationTableCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[UtilitiesConfigurationTableCell class]] && [[(UtilitiesConfigurationTableCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell= (UtilitiesConfigurationTableCell *) nibItem;
                cell.myDelegate = self;
            }
        }
    }
    // Configure the cell...
    cell.myIndexPath = indexPath;
    NSMutableDictionary* cellData = [self.utilitiesConfigurationDataManager.displayList objectAtIndex:indexPath.row];
    cell.detail.text = [cellData objectForKey:@"Detail"];
    cell.tooltip.text = [cellData objectForKey:@"Tooltip"];
    NSNumber* toggle1Number = [cellData objectForKey:@"Toggle1"];
    cell.toggleSwitch.on = [toggle1Number boolValue];
    
    return cell;
}

- (void)inputFinishedWithData:(id)data forIndexpath:(NSIndexPath *)theIndexpath {
    [self.utilitiesConfigurationDataManager inputFinishedWithData:data forIndexpath:theIndexpath];
}


@end
