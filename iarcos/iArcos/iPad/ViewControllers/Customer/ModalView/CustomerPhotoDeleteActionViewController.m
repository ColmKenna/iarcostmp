//
//  CustomerPhotoDeleteActionViewController.m
//  Arcos
//
//  Created by David Kilmartin on 18/02/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "CustomerPhotoDeleteActionViewController.h"
#import "ArcosUtils.h"

@implementation CustomerPhotoDeleteActionViewController
@synthesize actionDelegate = _actionDelegate;
@synthesize deleteButton = _deleteButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
//    if (self.actionDelegate != nil) { self.actionDelegate = nil; }
    if (self.deleteButton != nil) { self.deleteButton = nil; }
    
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
//    self.deleteButton
//    UIImage* anImage = [UIImage imageNamed:@"red_button.png"];
//    anImage = [anImage stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0];
//    [self.deleteButton setBackgroundImage:anImage forState:UIControlStateNormal];
    
    [self.deleteButton.layer setBackgroundColor: [[UIColor blackColor]CGColor]];
    [self.deleteButton.layer setBorderWidth:1.0f];
    [self.deleteButton.layer setBorderColor:[[UIColor blackColor]CGColor]];
//    [self.deleteButton.layer setShadowOpacity:0.0f];
    [self.deleteButton.layer setCornerRadius:5.0f];
     
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

- (IBAction)deleteButtonPressed:(id)sender {
    UIButton* aButton = (UIButton*)sender;
    int tag = [ArcosUtils convertNSIntegerToInt:aButton.tag];
//    NSLog(@"deleteButtonPressed %d", tag);
    [self.actionDelegate didPressDeleteButton:tag];
}

@end
