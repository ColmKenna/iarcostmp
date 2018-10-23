//
//  MapPopoverViewController.m
//  Arcos
//
//  Created by David Kilmartin on 24/06/2011.
//  Copyright 2011  Strata IT. All rights reserved.
//

#import "MapPopoverViewController.h"


@implementation MapPopoverViewController

@synthesize annotaion;
@synthesize delegate;
@synthesize aroundMe;
@synthesize removePin;
@synthesize radiusLabel;
@synthesize radiusSlider;
@synthesize childDelegate = _childDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    
    [aroundMe release];
    [removePin release];
    [radiusSlider release];
    [aroundMe release];
    [radiusLabel release];
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
    radiusValue=1000;//1KM
    radiusLabel.text=[NSString stringWithFormat:@"%1.2f",radiusValue/1000.0f];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

-(IBAction)lookAround:(id)sender{
    [self.delegate searchRadius:radiusValue AroundMe:self.annotaion];
}
-(IBAction)removePin:(id)sender{
    [self.delegate removePin:(AddressAnnotation*) self.annotaion];

}
-(IBAction)radiusChange:(id)sender{
    UISlider* tempSlider=(UISlider*)sender;
    radiusValue=tempSlider.value;
    radiusLabel.text=[NSString stringWithFormat:@"%1.2f",radiusValue/1000.0f];
    
}
-(IBAction)detailTouched:(id)sender{
    
    [self.delegate detailTouched:self.annotaion];
}
-(IBAction)stockistPressed:(id)sender {
//    NSLog(@"def");
    [self.delegate stockistPressed:self.annotaion];
}


@end
