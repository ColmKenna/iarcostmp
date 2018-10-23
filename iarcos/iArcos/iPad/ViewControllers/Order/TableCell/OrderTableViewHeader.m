//
//  OrderTableViewHeader.m
//  Arcos
//
//  Created by David Kilmartin on 08/08/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "OrderTableViewHeader.h"


@implementation OrderTableViewHeader
@synthesize locationName;
@synthesize locationPhone;
@synthesize locationAddress;
@synthesize name;
@synthesize address;
@synthesize phone;
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
    if (self.locationName != nil) { self.locationName = nil; }
    if (self.locationAddress != nil) { self.locationAddress = nil; }        
    if (self.locationPhone != nil) { self.locationPhone = nil; }
    if (self.name != nil) { self.name = nil; }        
    if (self.address != nil) { self.address = nil; }
    if (self.phone != nil) { self.phone = nil; }           
        
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
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.locationName.text=self.name;
    self.locationAddress.text=self.address;
    self.locationPhone.text=self.phone;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
