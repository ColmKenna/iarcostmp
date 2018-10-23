//
//  LeafSmallTemplateViewItemController.m
//  Arcos
//
//  Created by David Kilmartin on 21/08/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "LeafSmallTemplateViewItemController.h"
@interface LeafSmallTemplateViewItemController ()
//- (void)alignSubviews;
@end

@implementation LeafSmallTemplateViewItemController
@synthesize delegate = _delegate;
@synthesize btn1;
@synthesize btn2;
@synthesize btn3;
@synthesize btn4;
@synthesize btn5;
@synthesize btn6;

@synthesize label1;
@synthesize label2;
@synthesize label3;
@synthesize label4;
@synthesize label5;
@synthesize label6;

@synthesize btnList = _btnList;
@synthesize labelList = _labelList;

//@synthesize labelDividerBefore1;
//@synthesize labelDividerAfter1;
//@synthesize labelDividerAfter2;
//@synthesize labelDividerAfter3;
//@synthesize labelDividerAfter4;
//@synthesize labelDividerAfter5;
@synthesize indexPathRow = _indexPathRow;
@synthesize itemPerPage = _itemPerPage;
@synthesize separatorWidth = _separatorWidth;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.separatorWidth = 4;
    }
    return self;
}

- (void)dealloc {
    if (self.btn1 != nil) { self.btn1 = nil; }
    if (self.btn2 != nil) { self.btn2 = nil; }
    if (self.btn3 != nil) { self.btn3 = nil; }
    if (self.btn4 != nil) { self.btn4 = nil; }
    if (self.btn5 != nil) { self.btn5 = nil; }
    if (self.btn6 != nil) { self.btn6 = nil; }
    
    if (self.label1 != nil) { self.label1 = nil; }
    if (self.label2 != nil) { self.label2 = nil; }
    if (self.label3 != nil) { self.label3 = nil; }
    if (self.label4 != nil) { self.label4 = nil; }
    if (self.label5 != nil) { self.label5 = nil; }
    if (self.label6 != nil) { self.label6 = nil; }
    
    if (self.btnList != nil) { self.btnList = nil; }
    if (self.labelList != nil) { self.labelList = nil; }
    
//    if (self.labelDividerBefore1 != nil) { self.labelDividerBefore1 = nil; }
//    if (self.labelDividerAfter1 != nil) { self.labelDividerAfter1 = nil; }
//    if (self.labelDividerAfter2 != nil) { self.labelDividerAfter2 = nil; }
//    if (self.labelDividerAfter3 != nil) { self.labelDividerAfter3 = nil; }    
//    if (self.labelDividerAfter4 != nil) { self.labelDividerAfter4 = nil; }
//    if (self.labelDividerAfter5 != nil) { self.labelDividerAfter5 = nil; }
    
    
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self alignSubviews];
//    NSLog(@"view item will");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    NSLog(@"view item did");
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

- (void)createPopulatedLists {    
    self.btnList = [NSMutableArray arrayWithCapacity:self.itemPerPage];
    self.labelList = [NSMutableArray arrayWithCapacity:self.itemPerPage];
    @try {
        for (int i = 1; i <= self.itemPerPage; i++) {
            NSString* btnName = [NSString stringWithFormat:@"btn%d", i];
            SEL btnSelector = NSSelectorFromString(btnName);
            [self.btnList addObject:[self performSelector:btnSelector]];
            NSString* labelName = [NSString stringWithFormat:@"label%d", i];
            SEL labelSelector = NSSelectorFromString(labelName);
            [self.labelList addObject:[self performSelector:labelSelector]];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@", [exception reason]);
    }
}

- (void)clearAllInfo {
    for (int i = 0; i < [self.btnList count]; i++) {
        UIButton* tmpBtn = [self.btnList objectAtIndex:i];
        tmpBtn.enabled = NO;        
        [tmpBtn setImage:nil forState:UIControlStateNormal];
        UILabel* tmpLabel = [self.labelList objectAtIndex:i];
        tmpLabel.text = @"";
    }
}

- (void)getCellReadyToUse {
    [self createPopulatedLists];
    [self clearAllInfo];
}

- (IBAction)pressButton:(id)sender {
    UIButton* btn = (UIButton*)sender;
    if (btn.imageView != nil) {
        [self.delegate didSelectSmallTemplateViewItemWithButton:btn indexPathRow:self.indexPathRow];
    }
    
}

- (void)alignSubviews {
//    NSLog(@"alignSubviews ls");
    @try {
        int buttonWidth = (int)(self.view.frame.size.width - self.separatorWidth * (self.itemPerPage + 1)) / self.itemPerPage;
//        NSLog(@"%d %f %d", self.separatorWidth,self.view.frame.size.width, buttonWidth);
        float xOrigin = 0.0f;
        for (int i = 0; i < [self.btnList count]; i++) {
            xOrigin = i * buttonWidth + (i+1) * self.separatorWidth;
            UIButton* tmpBtn = [self.btnList objectAtIndex:i];
            tmpBtn.frame = CGRectMake(xOrigin, tmpBtn.frame.origin.y, buttonWidth, tmpBtn.frame.size.height);
            UILabel* tmpLabel = [self.labelList objectAtIndex:i];
            tmpLabel.frame = CGRectMake(xOrigin, tmpLabel.frame.origin.y, buttonWidth, tmpLabel.frame.size.height);
        }
    }
    @catch (NSException *exception) {
        [ArcosUtils showMsg:[exception reason] delegate:nil];
    }    
}

@end
