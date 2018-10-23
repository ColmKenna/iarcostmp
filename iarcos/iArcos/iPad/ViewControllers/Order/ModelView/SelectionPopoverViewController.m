//
//  SelectionPopoverViewController.m
//  Arcos
//
//  Created by David Kilmartin on 18/07/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "SelectionPopoverViewController.h"


@implementation SelectionPopoverViewController
@synthesize delegate;
@synthesize totalBut;
@synthesize showBut;
@synthesize clearBut;
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
	return YES;
}


-(IBAction)buttonPressed:(id)sender{
    UIButton* aButton=(UIButton*)sender;
    switch (aButton.tag) {
        case 0:
            [self.delegate showTotalOfSelections];
            break;
        case 1:
            [self.delegate showOnlySelectionItems];
            break;
        case 2:
            [self.delegate clearAllSelections];
            break;
            
        default:
            break;
    }
//    NSLog(@"button %d is pressed in the selection popover!",aButton.tag);
}
@end
