//
//  UtilitiesCallDateRangePicker.m
//  Arcos
//
//  Created by David Kilmartin on 27/03/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "UtilitiesCallDateRangePicker.h"

@implementation UtilitiesCallDateRangePicker
@synthesize callStartDate;
@synthesize callEndDate;
@synthesize startDatePicker;
@synthesize endDatePicker;
@synthesize startDateLabel;
@synthesize endDateLabel;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc{
    if (self.callStartDate != nil) { self.callStartDate = nil; }    
    if (self.callEndDate != nil) { self.callEndDate = nil; }
    if (self.startDatePicker != nil) { self.startDatePicker = nil; }
    if (self.endDatePicker != nil) { self.endDatePicker = nil; }
    if (self.startDateLabel != nil) { self.startDateLabel = nil; }
    if (self.endDateLabel != nil) { self.endDateLabel = nil; }    
//    if (self.delegate != nil) { self.delegate = nil; }    
    
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
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    // Do any additional setup after loading the view from its nib.
    NSDateFormatter* formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    
    self.startDatePicker.date = self.callStartDate;
    self.endDatePicker.date = self.callEndDate;
    startDateLabel.text = [formatter stringFromDate:self.startDatePicker.date];
    endDateLabel.text = [formatter stringFromDate:self.endDatePicker.date];
    [formatter release];
    
    self.startDatePicker.maximumDate = [NSDate date];
    self.endDatePicker.maximumDate = [NSDate date];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

-(IBAction)datePicked:(id)sender{
    UIDatePicker* picker=(UIDatePicker*)sender;
    NSDateFormatter* formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    NSString* dateString=[formatter stringFromDate:picker.date]; 
    
    if (picker.tag==0) {
        self.callStartDate = picker.date;
        startDateLabel.text=dateString;
    }
    if (picker.tag==1) {
        self.callEndDate = picker.date;
        endDateLabel.text=dateString;
    }
    
    NSComparisonResult result=[self.startDatePicker.date compare:self.endDatePicker.date];
    
    if (result == NSOrderedDescending) {
        self.startDatePicker.date=self.endDatePicker.date;
        startDateLabel.text=[formatter stringFromDate:self.startDatePicker.date];
    }
    [formatter release];
}

-(IBAction)save:(id)sender {
    [self.delegate utilitiesCallDateSelectedForm:self.startDatePicker.date To:self.endDatePicker.date ];
}

@end
