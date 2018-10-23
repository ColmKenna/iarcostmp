//
//  DatePickerWidgetViewController.m
//  Arcos
//
//  Created by David Kilmartin on 29/07/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "DatePickerWidgetViewController.h"
#import "GlobalSharedClass.h"

@implementation DatePickerWidgetViewController
@synthesize type;
@synthesize picker;
@synthesize defaultPickerDate = _defaultPickerDate;
@synthesize pickerFormatType = _pickerFormatType;
@synthesize bottomButton = _bottomButton;
@synthesize myBarButtonItem = _myBarButtonItem;
@synthesize myNavigationItem = _myNavigationItem;
@synthesize myNavigationBar = _myNavigationBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
-(id)initWithType:(DatePickerWidgetType)aType{
    [self initWithNibName:@"DatePickerWidgetViewController" bundle:nil];
    self.type=aType;
    

    
    self.anyDataSource=YES;
    return self;
}
-(id)initWithType:(DatePickerWidgetType)aType defaultPickerDate:(NSDate*)aDefaultPickerDate {
    self.defaultPickerDate = aDefaultPickerDate;
    return [self initWithType:aType];
}
-(id)initWithType:(DatePickerWidgetType)aType pickerFormatType:(DatePickerFormatType)aPickerFormatType {
    self.pickerFormatType = aPickerFormatType;
    return [self initWithType:aType];
}
-(id)initWithType:(DatePickerWidgetType)aType pickerFormatType:(DatePickerFormatType)aPickerFormatType defaultPickerDate:(NSDate*)aDefaultPickerDate {
    self.pickerFormatType = aPickerFormatType;
    self.defaultPickerDate = aDefaultPickerDate;
    return [self initWithType:aType];
}

- (void)dealloc
{    
    if (self.picker != nil) { self.picker = nil; }
    if (self.defaultPickerDate != nil) { self.defaultPickerDate = nil; }
    self.bottomButton = nil;
    self.myBarButtonItem = nil;
    self.myNavigationItem = nil;
    self.myNavigationBar = nil;
    
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
    // Custom initialization
    if (self.pickerFormatType == DatePickerFormatDateTime && [ArcosConfigDataManager sharedArcosConfigDataManager].includeCallTimeFlag) {
        self.picker.datePickerMode = UIDatePickerModeDateAndTime;
    }
    if (self.pickerFormatType == DatePickerFormatForceDateTime) {
        self.picker.datePickerMode = UIDatePickerModeDateAndTime;
    }
    switch (self.type) {
        case DatePickerDeliveryDateType:
            //date must after now
            self.picker.minimumDate=[NSDate date];
            self.picker.maximumDate=[[GlobalSharedClass shared]dateFor:DateMonth offset:12];
            break;
        case DatePickerOrderDateType:
            //date might be with in last week
            self.picker.minimumDate=[[GlobalSharedClass shared]dateFor:DateMonth offset:-12];
            self.picker.maximumDate=[NSDate date];
            break;
        case DatePickerNormalDateType:
            //whole year
            break;
        default:
            break;
    }    
    if (self.defaultPickerDate != nil) {
        self.picker.date = self.defaultPickerDate;
    } else {
        self.picker.date=[NSDate date];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    if (self.picker != nil) { self.picker = nil; }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

-(IBAction)operationDone:(id)sender{
//    NSLog(@"operation is done");
    [self.delegate operationDone:self.picker.date];
}
@end
