//
//  CustomerPopoverMenuViewController.m
//  Arcos
//
//  Created by David Kilmartin on 22/06/2011.
//  Copyright 2011  Strata IT. All rights reserved.
//

#import "CustomerPopoverMenuViewController.h"


@implementation CustomerPopoverMenuViewController

@synthesize delegate;

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
    [super dealloc];
    self.delegate = nil;
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return NO;
}


-(IBAction)buttonSelected:(id)sender{
    UIButton* tempBut=(UIButton*) sender;
//    NSLog(@"button click in popover view number %d",tempBut.tag);
    [self.delegate buttonSelectedIndex:tempBut.tag];
}
@end
