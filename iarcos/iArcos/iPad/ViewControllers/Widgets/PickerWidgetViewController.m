//
//  PickerWidgetViewController.m
//  Arcos
//
//  Created by David Kilmartin on 29/07/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "PickerWidgetViewController.h"
#import "GlobalSharedClass.h"
#import "CustomerContactWrapperModalViewController.h"


@implementation PickerWidgetViewController
@synthesize type;
@synthesize picker;
@synthesize pickerData;
@synthesize tempData;
@synthesize defaultIURValue = _defaultIURValue;
@synthesize customiseNavigationBarTitle = _customiseNavigationBarTitle;
@synthesize customiseNavagationItem = _customiseNavagationItem;
@synthesize miscDataDict = _miscDataDict;
@synthesize bottomButton = _bottomButton;
@synthesize myNavigationBar = _myNavigationBar;

@synthesize globalNavigationController = _globalNavigationController;
@synthesize myRootViewController = _myRootViewController;
@synthesize dynamicWidthFlag = _dynamicWidthFlag;
@synthesize maxTextLength = _maxTextLength;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)initWithType:(PickerWidgetType)aType{
    [self initWithNibName:@"PickerWidgetViewController" bundle:nil];    
    self.type=aType;
    NSString* descrTypeCode = @"";
    switch (self.type) {
        case PickerOrderStatusType: {
            self.pickerData=[[ArcosCoreData sharedArcosCoreData]orderStatus];
            descrTypeCode = @"OS";
        }
            break;
        case PickerOrderWholesalerType: {
            self.pickerData=[[ArcosCoreData sharedArcosCoreData]orderWholeSalers];
            self.customiseNavigationBarTitle = @"Wholesaler";
        }
            break;
        case PickerOrderType: {
            self.pickerData=[[ArcosCoreData sharedArcosCoreData]orderTypes];
            descrTypeCode = @"OT";
        }            
            break;
        case PickerCallType: {
            self.pickerData=[[ArcosCoreData sharedArcosCoreData]callTypes];
            descrTypeCode = @"CT";
        }            
            break;
        case PickerContactType:
            if ([GlobalSharedClass shared].currentSelectedLocationIUR != nil) {
                self.pickerData=[[ArcosCoreData sharedArcosCoreData]orderContactsWithLocationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR];
                self.customiseNavigationBarTitle = @"Contact";
            }
            break;
        case PickerLocationType:{//use in setting
            self.pickerData=[[ArcosCoreData sharedArcosCoreData]settingSelectionWithType:@"LT"];
            descrTypeCode = @"LT";
        }            
            break;
        case PickerSettingContactType:{//use in setting
            self.pickerData=[[ArcosCoreData sharedArcosCoreData]settingSelectionWithType:@"CO"];
            descrTypeCode = @"CO";
        }
            break;
        case PickerFormType:{//use in setting
            self.pickerData=[[ArcosCoreData sharedArcosCoreData]settingOrderForms];
            self.customiseNavigationBarTitle = @"Form";
        }
            break;
        case PickerMemoType:{//use in setting
            self.pickerData=[[ArcosCoreData sharedArcosCoreData]settingSelectionWithType:@"MT"];
            descrTypeCode = @"MT";
        }
            break;
        case PickerDetailingType:{//use in detailling
            self.pickerData=[[ArcosCoreData sharedArcosCoreData]settingSelectionWithType:@"SC"];
            descrTypeCode = @"SC";
        }
            break;
        case PickerDetailingBatchType:{//use in detailling
            self.pickerData=[[ArcosCoreData sharedArcosCoreData]batchsWithProductIUR:self.tempData];
            self.customiseNavigationBarTitle = @"Batch";
            NSLog(@"temp data in picker wideget view  is %@",self.tempData);
        }
            break;
        case PickerTitleType:{
            self.pickerData = [[ArcosCoreData sharedArcosCoreData]settingSelectionWithType:@"CL"];
            descrTypeCode = @"CL";
        }
            break;
        case PickerCustomerSurvey: {
            self.pickerData = [[ArcosCoreData sharedArcosCoreData] allSurvey];
            self.customiseNavigationBarTitle = @"Survey";
        }            
            break;
        case PickerPriceGroup: {
            self.pickerData = [[ArcosCoreData sharedArcosCoreData]settingSelectionWithType:@"PG"];
            descrTypeCode = @"PG";
        }
            break;
        default:
            break;
            
    }
    if (![descrTypeCode isEqualToString:@""]) {
        NSDictionary* descrDict = [[ArcosCoreData sharedArcosCoreData] descrTypeAllRecordsWithTypeCode:descrTypeCode];
        if (descrDict != nil) {
            self.customiseNavigationBarTitle = [descrDict objectForKey:@"Details"];
        }        
    }
    //any data source for the widget
    if (self.pickerData ==nil || [self.pickerData count]<=0) {
        anyDataSource=NO;
    }else{
        anyDataSource=YES;
    }
    return self;
}

-(id)initWithType:(PickerWidgetType)aType pickerDefaultValue:(NSNumber*)aDefaultIURValue {
    self.defaultIURValue = aDefaultIURValue;
    return [self initWithType:aType];
}

-(id)initWithPickerValue:(NSMutableArray*)aPickerValue {
    [self initWithNibName:@"PickerWidgetViewController" bundle:nil];
    self.pickerData = aPickerValue;
    
    //any data source for the widget
    if (self.pickerData ==nil || [self.pickerData count]<=0) {
        anyDataSource=NO;
    }else{
        anyDataSource=YES;
    }
    return self;
}

-(id)initWithPickerValue:(NSMutableArray*)aPickerValue title:(NSString*)aTitle {
    self.customiseNavigationBarTitle = aTitle;
    return [self initWithPickerValue:aPickerValue];     
}

-(id)initWithPickerValue:(NSMutableArray*)aPickerValue miscDataDict:(NSMutableDictionary*)aDataDict delegate:(id<WidgetViewControllerDelegate>)aDelegate {
    self.customiseNavigationBarTitle = [aDataDict objectForKey:@"Title"];
    self.miscDataDict = aDataDict;
    self.delegate = aDelegate;
    return [self initWithPickerValue:aPickerValue];
}

-(void)resetPickerData{
    
    //dirty fit for batch finding
    self.pickerData=[[ArcosCoreData sharedArcosCoreData]batchsWithProductIUR:self.tempData];
    //any data source for the widget
    if (self.pickerData ==nil || [self.pickerData count]<=0) {
        anyDataSource=NO;
    }else{
        anyDataSource=YES;
    }
}
- (void)dealloc
{    
    if (self.picker != nil) { self.picker = nil; }
    if (self.pickerData != nil) { self.pickerData = nil; }
    if (self.tempData != nil) { self.tempData = nil; }  
    if (self.defaultIURValue != nil) { self.defaultIURValue = nil; }
    if (self.customiseNavigationBarTitle != nil) { self.customiseNavigationBarTitle = nil; }
    if (self.customiseNavagationItem != nil) { self.customiseNavagationItem = nil; }
    if (self.miscDataDict != nil) { self.miscDataDict = nil; }
    self.bottomButton = nil;
    self.myNavigationBar = nil;
    self.globalNavigationController = nil;
    self.myRootViewController = nil;
    
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
    self.myRootViewController = [ArcosUtils getRootView];
    self.customiseNavagationItem.title = self.customiseNavigationBarTitle;
    UIBarButtonItem* saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(operationDone:)];
    [self.customiseNavagationItem setRightBarButtonItem:saveButton];
    [saveButton release];
    if ([self.customiseNavagationItem.title isEqualToString:@"Contact"] && [self.delegate allowToShowAddContactButton]) {        
        UIBarButtonItem* addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addContactPressedFromPopover:)];
        [self.customiseNavagationItem setLeftBarButtonItem:addButton];
        [addButton release];
    }
    if ([self.customiseNavagationItem.title isEqualToString:[GlobalSharedClass shared].accountNoText] && [self.delegate allowToShowAddAccountNoButton]) {
        UIBarButtonItem* addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAccountNoPressedFromPopover)];
        [self.customiseNavagationItem setLeftBarButtonItem:addButton];
        [addButton release];
    }
    if ([self.customiseNavagationItem.title isEqualToString:@"Contact Flag"] && [self.delegate allowToShowAddContactFlagButton]) {
        UIBarButtonItem* addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addContactFlagPressedFromPopover)];
        [self.customiseNavagationItem setLeftBarButtonItem:addButton];
        [addButton release];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.picker = nil;
}
- (void)viewWillAppear:(BOOL)animated{
//    NSLog(@"defaultIURValue is: %@", self.defaultIURValue);
    [super viewWillAppear:animated];
    if (self.defaultIURValue != nil) {
        return;
    } 
    for (int i=0; i<[self.pickerData count]; i++) {
        NSMutableDictionary* aDict=[self.pickerData objectAtIndex:i];

        //set the default row
        NSNumber* isDefault=[aDict objectForKey:@"IsDefault"];
        if ([isDefault boolValue]) {
            [self.picker selectRow:i inComponent:0 animated:YES];
        }
        
    }
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark picker view delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent :(NSInteger)component {
    if (self.pickerData != nil) {
        return [self.pickerData count];
    }else{
        return 0;
    }
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSMutableDictionary* aDict=[self.pickerData objectAtIndex:row];
    
    return [aDict objectForKey:@"Title"];
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *retval = (id)view;
    if (!retval) {
        retval= [[[UILabel alloc] initWithFrame:CGRectMake(5.0f, 0.0f, [pickerView rowSizeForComponent:component].width-10, [pickerView rowSizeForComponent:component].height)] autorelease];
        retval.textAlignment = NSTextAlignmentCenter;
        retval.adjustsFontSizeToFitWidth=YES;
    }
    if (self.dynamicWidthFlag) {
        if (self.maxTextLength <= [GlobalSharedClass shared].popoverMinimumWidth) {
            retval.adjustsFontSizeToFitWidth = NO;
        } else if (self.maxTextLength <= [GlobalSharedClass shared].popoverMediumWidth) {
            retval.adjustsFontSizeToFitWidth = NO;
        } else if(self.maxTextLength <= [GlobalSharedClass shared].popoverLargeWidth) {
            retval.adjustsFontSizeToFitWidth = NO;
        } else if(self.maxTextLength <= [GlobalSharedClass shared].popoverMaximumWidth) {
            retval.adjustsFontSizeToFitWidth = NO;
        } else {
            retval.adjustsFontSizeToFitWidth = YES;
            retval.minimumScaleFactor = 0.5f;
        }
    }
    
    NSMutableDictionary* aDict=[self.pickerData objectAtIndex:row];
    retval.text = [aDict objectForKey:@"Title"];
    retval.font = [UIFont systemFontOfSize:22];
    return retval;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{

    //NSMutableDictionary* aDict=[self.pickerData objectAtIndex:row];
    
    //NSLog(@"%@ is picked!!",[aDict objectForKey:@"Title"]);
}

-(IBAction)operationDone:(id)sender{
//    NSLog(@"operation is done");
    NSInteger row=[self.picker selectedRowInComponent:0];
    if (self.pickerData !=nil && [self.pickerData count]>0) {
        NSMutableDictionary* aDict=[self.pickerData objectAtIndex:row];
        //[self.delegate operationDone:[aDict objectForKey:@"Title"]];
        [self.delegate operationDone:aDict];
    }
}

-(void)addContactPressedFromPopover:(id)sender {
    CustomerContactWrapperModalViewController* ccwmvc = [[CustomerContactWrapperModalViewController alloc] initWithNibName:@"CustomerContactWrapperModalViewController" bundle:nil];
    ccwmvc.myDelegate = self;
    ccwmvc.delegate = self;
    ccwmvc.refreshDelegate = self;
    ccwmvc.navgationBarTitle = [NSString stringWithFormat:@"Create Contact for %@", [self.miscDataDict objectForKey:@"Name"]];
    ccwmvc.locationIUR = [self.miscDataDict objectForKey:@"LocationIUR"];
    ccwmvc.actionType = @"createFromContactPopover";
    ccwmvc.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:.5f];
//    [self presentModalViewController:ccwmvc animated:YES];
    self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:ccwmvc] autorelease];
    self.globalNavigationController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:self.globalNavigationController animated:YES completion:nil];
    [ccwmvc release];
}

-(void)addAccountNoPressedFromPopover {
    AccountNumberWrapperViewController* anwvc = [[AccountNumberWrapperViewController alloc] initWithNibName:@"AccountNumberWrapperViewController" bundle:nil];
    anwvc.delegate = self;
    anwvc.refreshDelegate = self;
    anwvc.locationIUR = [self.miscDataDict objectForKey:@"LocationIUR"];
    anwvc.fromLocationIUR = [self.miscDataDict objectForKey:@"FromLocationIUR"];
    
    anwvc.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:.5f];
    self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:anwvc] autorelease];
    self.globalNavigationController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:self.globalNavigationController animated:YES completion:nil];
    [anwvc release];
}

- (void)addContactFlagPressedFromPopover {
    FlagsContactFlagWrapperViewController* fcfwvc = [[FlagsContactFlagWrapperViewController alloc] initWithNibName:@"FlagsContactFlagWrapperViewController" bundle:nil];
    fcfwvc.actionDelegate = self;
    fcfwvc.refreshDelegate = self;
    fcfwvc.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:.5f];
    self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:fcfwvc] autorelease];
    self.globalNavigationController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:self.globalNavigationController animated:YES completion:nil];
    [fcfwvc release];
}

#pragma mark GenericRefreshParentContentDelegate
- (void)refreshParentContent {
    
}

- (void)refreshParentContentWithIUR:(NSNumber*)anIUR {
    self.pickerData = [[ArcosCoreData sharedArcosCoreData]orderContactsWithLocationIUR:[self.miscDataDict objectForKey:@"LocationIUR"]];
    [self.pickerData insertObject:[GlobalSharedClass shared].createUnAssignedContact atIndex:0];
    [self.picker reloadAllComponents];
    for (int i = 0; i < [self.pickerData count]; i++) {
        NSMutableDictionary* aDict = [self.pickerData objectAtIndex:i];
        if ([[aDict objectForKey:@"IUR"] isEqualToNumber:anIUR]) {
            [self.picker selectRow:i inComponent:0 animated:YES];
            break;
        }
    }
}

- (void)refreshParentContentWithData:(NSMutableDictionary*)aDataDict {
    [self.pickerData addObject:aDataDict];
    [self.picker reloadAllComponents];
    for (int i = 0; i < [self.pickerData count]; i++) {
        NSMutableDictionary* aDict = [self.pickerData objectAtIndex:i];
        if ([[aDict objectForKey:@"Title"] isEqualToString:[aDataDict objectForKey:@"Title"]]) {
            [self.picker selectRow:i inComponent:0 animated:YES];
            break;
        }
    }
}

#pragma mark ModelViewDelegate
- (void)didDismissModalView {
//    [self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^ {
        self.globalNavigationController = nil;
    }];
}

#pragma mark CustomisePresentViewControllerDelegate
- (void)didDismissCustomisePresentView {
    [self didDismissModalView];
}

#pragma mark - FlagsContactFlagTableViewControllerDelegate
- (void)refreshParentContentWithContactFlagIUR:(NSNumber*)anIUR {
    self.pickerData = [[ArcosCoreData sharedArcosCoreData] retrieveContactFlagData];
    [self.picker reloadAllComponents];
    for (int i = 0; i < [self.pickerData count]; i++) {
        NSMutableDictionary* aDict = [self.pickerData objectAtIndex:i];
        if ([[aDict objectForKey:@"DescrDetailIUR"] isEqualToNumber:anIUR]) {
            [self.picker selectRow:i inComponent:0 animated:YES];
            break;
        }
    }
}

@end
