//
//  PresenterZoomableImageViewController.m
//  Arcos
//
//  Created by David Kilmartin on 30/11/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "PresenterZoomableImageViewController.h"


@implementation PresenterZoomableImageViewController
@synthesize scroll;
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
    [image release];
    [self.scroll release];
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
    //UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	self.scroll.backgroundColor = [UIColor blackColor];
	self.scroll.delegate = self;
	image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Adpack Overview_181103-001.png"]];
	self.scroll.contentSize = image.frame.size;
	[self.scroll addSubview:image];
	self.scroll.minimumZoomScale = scroll.frame.size.width / image.frame.size.width;
	self.scroll.maximumZoomScale = 2.0;
	[scroll setZoomScale:scroll.minimumZoomScale];
    
	//self.view = scroll;
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
-(void)setImageForScorlling:(UIImageView*)aImageView{
    [image setImage:aImageView.image];    
    self.scroll.contentSize = image.frame.size;
	[self.scroll addSubview:image];
	self.scroll.minimumZoomScale = scroll.frame.size.width / image.frame.size.width;
	self.scroll.maximumZoomScale = 2.0;
	[scroll setZoomScale:scroll.minimumZoomScale];
    //[self.scrollView addSubview:self.image];
}

- (CGRect)centeredFrameForScrollView:(UIScrollView *)scroll andUIView:(UIView *)rView {
	CGSize boundsSize = self.scroll.bounds.size;
    CGRect frameToCenter = rView.frame;
    
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    }
    else {
        frameToCenter.origin.x = 0;
    }
    
    // center vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    }
    else {
        frameToCenter.origin.y = 0;
    }
	
	return frameToCenter;
}

#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    image.frame = [self centeredFrameForScrollView:scrollView andUIView:image];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return image;
}

@end
