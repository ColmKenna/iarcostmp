//
//  TwoDatePickerWidgetViewController.m
//  Arcos
//
//  Created by David Kilmartin on 01/07/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "TwoDatePickerWidgetViewController.h"

@implementation TwoDatePickerWidgetViewController
@synthesize startDate = _startDate;
@synthesize endDate = _endDate;
@synthesize startDatePicker = _startDatePicker;
@synthesize endDatePicker = _endDatePicker;
@synthesize startDateLabel = _startDateLabel;
@synthesize endDateLabel = _endDateLabel;
@synthesize delegate = _delegate;

@synthesize startDateTitleLabel = _startDateTitleLabel;
@synthesize endDateTitleLabel = _endDateTitleLabel;
@synthesize saveButton = _saveButton;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc{
    if (self.startDate != nil) { self.startDate = nil; }
    if (self.endDate != nil) { self.endDate = nil; }
    if (self.startDatePicker != nil) { self.startDatePicker = nil; }
    if (self.endDatePicker != nil) { self.endDatePicker = nil; }      
    if (self.startDateLabel != nil) { self.startDateLabel = nil; }          
    if (self.endDateLabel != nil) { self.endDateLabel = nil; }
//    if (self.delegate != nil) { self.delegate = nil; }
    
    if (self.startDateTitleLabel != nil) { self.startDateTitleLabel = nil; }
    if (self.endDateTitleLabel != nil) { self.endDateTitleLabel = nil; }
    if (self.saveButton != nil) { self.saveButton = nil; }    
    
    
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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    if (self.startDatePicker != nil) { self.startDatePicker = nil; }
    if (self.endDatePicker != nil) { self.endDatePicker = nil; }      
    if (self.startDateLabel != nil) { self.startDateLabel = nil; }          
    if (self.endDateLabel != nil) { self.endDateLabel = nil; }
    
    if (self.startDateTitleLabel != nil) { self.startDateTitleLabel = nil; }
    if (self.endDateTitleLabel != nil) { self.endDateTitleLabel = nil; }
    if (self.saveButton != nil) { self.saveButton = nil; }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    // Do any additional setup after loading the view from its nib.
    NSDateFormatter* formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    
    self.startDatePicker.date = self.startDate;
    self.endDatePicker.date = self.endDate;
    self.startDateLabel.text = [formatter stringFromDate:self.startDatePicker.date];
    self.endDateLabel.text = [formatter stringFromDate:self.endDatePicker.date];
    [formatter release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

-(IBAction)dateComponentPicked:(id)sender {
    UIDatePicker* picker=(UIDatePicker*)sender;
    NSDateFormatter* formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    NSString* dateString=[formatter stringFromDate:picker.date]; 
    
    if (picker.tag==0) {
        self.startDate = picker.date;
        self.startDateLabel.text = dateString;
    }
    if (picker.tag==1) {
        self.endDate = picker.date;
        self.endDateLabel.text = dateString;
    }
    
    NSComparisonResult result = [self.startDatePicker.date compare:self.endDatePicker.date];
    
    if (result == NSOrderedDescending) {
        self.startDatePicker.date = self.endDatePicker.date;
        self.startDateLabel.text = [formatter stringFromDate:self.startDatePicker.date];
    }
    [formatter release];
}

-(IBAction)savePressed:(id)sender {
    [self.delegate dateSelectedFromDate:self.startDatePicker.date ToDate:self.endDatePicker.date];
}

@end
