//
//  OrderDateRangePicker.m
//  Arcos
//
//  Created by David Kilmartin on 10/02/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "OrderDateRangePicker.h"

@implementation OrderDateRangePicker
@synthesize  startDate;
@synthesize   endDate;
@synthesize   startDateLabel;
@synthesize   endDateLabel;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    
    self.startDate.date=[NSDate date];
    self.endDate.date=[NSDate date];
    startDateLabel.text=[formatter stringFromDate:self.startDate.date];
    endDateLabel.text=[formatter stringFromDate:self.endDate.date];
    [formatter release];
    
    self.startDate.maximumDate=[NSDate date];
    self.endDate.maximumDate=[NSDate date];
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
        startDateLabel.text=dateString;
    }
    if (picker.tag==1) {
        endDateLabel.text=dateString;
    }
    
    NSComparisonResult result=[self.startDate.date compare:self.endDate.date];
    
    if (result>0) {
        self.startDate.date=self.endDate.date;
    }
    
    [formatter release];
}
-(IBAction)search:(id)sender{
    [self.delegate dateSelectedForm:self.startDate.date To:self.endDate.date ];
}

-(void)dealloc{
    self.startDate = nil;
    self.endDate = nil;
    self.startDateLabel = nil;
    self.endDateLabel = nil;
    
    [super dealloc];
//    self.delegate=nil;
}
@end
