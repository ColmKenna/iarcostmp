//
//  OrderProductTotalModelViewController.m
//  Arcos
//
//  Created by David Kilmartin on 20/07/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "OrderProductTotalModelViewController.h"


@implementation OrderProductTotalModelViewController
@synthesize totalValue;
@synthesize totalProducts;
@synthesize totalPoints;
@synthesize totalBonus;
@synthesize totalQty;
@synthesize delegate;
@synthesize theData;
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
    [totalPoints release];
    [totalProducts release];
    [totalValue release];
    [totalBonus release];
    [totalQty release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void)viewWillAppear:(BOOL)animated{
    self.view.backgroundColor=[UIColor colorWithWhite:0.0f alpha:.9f];

    totalProducts.text=[[self.theData objectForKey:@"totalProducts"]stringValue];
    totalValue.text=[[self.theData objectForKey:@"totalValue"]stringValue];
    totalPoints.text=[[self.theData objectForKey:@"totalPoints"]stringValue];
    totalBonus.text=[[self.theData objectForKey:@"totalBonus"]stringValue];
    totalQty.text=[[self.theData objectForKey:@"totalQty"]stringValue];
}
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

//actions
-(IBAction)donePressed:(id)sender{
    [self.delegate didDismissModalView];
    
}

@end
