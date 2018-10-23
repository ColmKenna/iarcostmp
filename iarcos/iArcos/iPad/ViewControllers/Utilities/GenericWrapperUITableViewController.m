//
//  GenericWrapperUITableViewController.m
//  Arcos
//
//  Created by David Kilmartin on 16/04/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "GenericWrapperUITableViewController.h"

@implementation GenericWrapperUITableViewController
@synthesize animateDelegate = _animateDelegate;
@synthesize customiseScrollContentView = _customiseScrollContentView;
@synthesize globalNavigationController = _globalNavigationController;
@synthesize rootView = _rootView;
@synthesize attrNameList = _attrNameList;
@synthesize attrNameTypeList = _attrNameTypeList;
@synthesize displayList = _displayList;
@synthesize genericUITableViewController = _genericUITableViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {    
    if (self.customiseScrollContentView != nil) { self.customiseScrollContentView = nil; }
    if (self.globalNavigationController != nil) {
        self.globalNavigationController = nil;
    }
    if (self.rootView != nil) {
        self.rootView = nil;
    }
    if (arcosCustomiseAnimation != nil) {
        [arcosCustomiseAnimation release];
    }
    if (self.attrNameList != nil) { self.attrNameList = nil; }
    if (self.attrNameTypeList != nil) { self.attrNameTypeList = nil; }
    if (self.displayList != nil) { self.displayList = nil; }    
    if (self.genericUITableViewController != nil) { self.genericUITableViewController = nil; }
        
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
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backPressed:)];
    
    [self.navigationItem setLeftBarButtonItem:backButton];     
    
    [backButton release];
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
}

- (void)viewDidAppear:(BOOL)animated
{      
    self.genericUITableViewController = [[[GenericUITableViewController alloc] initWithNibName:@"GenericUITableViewController" bundle:nil] autorelease];
    self.genericUITableViewController.attrNameList = self.attrNameList;    
    self.genericUITableViewController.attrNameTypeList = self.attrNameTypeList;
    self.genericUITableViewController.displayList = self.displayList;
    
    [self.customiseScrollContentView addSubview:self.genericUITableViewController.view];
    self.genericUITableViewController.view.frame = self.customiseScrollContentView.frame;
    NSLog(@"%f, %f, %f, %f", self.customiseScrollContentView.frame.origin.x, self.customiseScrollContentView.frame.origin.y, self.customiseScrollContentView.frame.size.width, self.customiseScrollContentView.frame.size.height);
//    self.genericUITableViewController.customiseTableView.delegate = self;
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

-(void)backPressed:(id)sender {
    [self.animateDelegate dismissSlideAcrossViewAnimation];
}

#pragma mark - Table view delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{   
    return self.genericUITableViewController.customiseTableHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

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
    
    NSLog(@"GenericUITableDetailViewController is clicked2.");
    GenericUITableDetailViewController* cuitdvc = [[GenericUITableDetailViewController alloc] initWithNibName:@"GenericUITableDetailViewController" bundle:nil];
    cuitdvc.title = [NSString stringWithFormat:@"%@ Details", self.title];
    cuitdvc.attrNameList = self.attrNameList;
    cuitdvc.attrNameTypeList = self.attrNameTypeList;
    //    cuitdvc.attrDict = self.attrDict;
    cuitdvc.animateDelegate = self;
    cuitdvc.recordCellData = [self.displayList objectAtIndex:indexPath.row];
    self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:cuitdvc] autorelease];
    
    [cuitdvc release];
    [self.genericUITableViewController.customiseTableView deselectRowAtIndexPath:indexPath animated:YES];
    [arcosCustomiseAnimation addPushViewAnimation:self.rootView withController:self.globalNavigationController];    
    
}

- (void)dismissUIViewAnimation {
    [arcosCustomiseAnimation dismissPushViewAnimation:self.rootView withController:self.globalNavigationController];
}

- (void)dismissSlideAcrossViewAnimation {
    [arcosCustomiseAnimation dismissPushViewAnimation:self.rootView withController:self.globalNavigationController];
}

@end
