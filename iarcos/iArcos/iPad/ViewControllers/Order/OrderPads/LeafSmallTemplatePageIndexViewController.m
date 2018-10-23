//
//  LeafSmallTemplatePageIndexViewController.m
//  Arcos
//
//  Created by David Kilmartin on 04/09/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "LeafSmallTemplatePageIndexViewController.h"

@interface LeafSmallTemplatePageIndexViewController ()
- (void)alignSubviews;
- (void)calculateUsedCellHeight;
@end

@implementation LeafSmallTemplatePageIndexViewController
@synthesize pageIndexDelegate = _pageIndexDelegate;
@synthesize displayList = _displayList;
@synthesize pageIndexViewWidth = _pageIndexViewWidth;
@synthesize labelList = _labelList;
@synthesize separateHeight = _separateHeight;
@synthesize cellHeight = _cellHeight;
@synthesize usedCellHeight = _usedCellHeight;
@synthesize labelHeight = _labelHeight;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.pageIndexViewWidth = 30;
        self.separateHeight = 50;
        self.cellHeight = 44;
        self.usedCellHeight = 44;
        self.labelHeight = 21;
    }
    return self;
}

- (void)dealloc {
    if (self.displayList != nil) { self.displayList = nil; }
    if (self.labelList != nil) { self.labelList = nil; }
    
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
//    NSLog(@"self.displayList: %@", self.displayList);
    self.view.backgroundColor = [UIColor clearColor];
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    NSLog(@"pageIndexView: %@", NSStringFromCGRect(self.view.frame));
    self.labelList = [NSMutableArray arrayWithCapacity:[self.displayList count]];
//    float viewHeight = self.view.frame.size.height;
//    float averageCellHeight = viewHeight / [self.displayList count];
//    if (averageCellHeight < self.cellHeight) {
//        self.usedCellHeight = averageCellHeight;
//    } else {
//        self.usedCellHeight = self.cellHeight;        
//    }
    [self calculateUsedCellHeight];
    for (int i = 0; i < [self.displayList count]; i++) {
        float yOrigin = i * self.usedCellHeight;
        UILabel* indexViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, yOrigin, self.pageIndexViewWidth, self.labelHeight)]; 
        indexViewLabel.backgroundColor = [UIColor clearColor];
        indexViewLabel.textAlignment = NSTextAlignmentCenter;
        indexViewLabel.text = [self.displayList objectAtIndex:i];
        [indexViewLabel setTextColor:[UIColor colorWithRed:30.0/255.0 green:144.0/255.0 blue:1.0 alpha:1.0]];
        [indexViewLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
        indexViewLabel.tag = i;
        indexViewLabel.userInteractionEnabled = YES;
        
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
        [indexViewLabel addGestureRecognizer:singleTap];        
        [singleTap release];
        
        [self.labelList addObject:indexViewLabel];
        
        [self.view addSubview:indexViewLabel];
        [indexViewLabel release];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[self.view subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
										 duration:(NSTimeInterval)duration {
    [self alignSubviews];
}

-(void)handleSingleTapGesture:(UITapGestureRecognizer*)sender {    
    UITapGestureRecognizer* recognizer = (UITapGestureRecognizer*)sender;
    UILabel* anIndexViewLabel = (UILabel*)recognizer.view;
    [self.pageIndexDelegate pressPageIndexWithLabel:anIndexViewLabel];
}

- (void)alignSubviews {
    [self calculateUsedCellHeight];
    for (int i = 0; i < [self.labelList count]; i++) {
        UILabel* tmpLabel = [self.labelList objectAtIndex:i];
        float yOrigin = i * self.usedCellHeight; 
        tmpLabel.frame = CGRectMake(0, yOrigin, self.pageIndexViewWidth, self.labelHeight);
    }
}

- (void)calculateUsedCellHeight {
    float viewHeight = self.view.frame.size.height;
    float averageCellHeight = viewHeight / [self.displayList count];
    if (averageCellHeight < self.cellHeight) {
        self.usedCellHeight = averageCellHeight;
    } else {
        self.usedCellHeight = self.cellHeight;        
    }
}

- (IBAction)indexViewTouchUpInside:(id)sender {
    self.view.backgroundColor = [UIColor blueColor];
}

- (IBAction)indexViewTouchUpOutside:(id)sender {
    self.view.backgroundColor = [UIColor clearColor];
}


@end
