//
//  PresenterCombinedSlideViewPdfItemController.m
//  iArcos
//
//  Created by David Kilmartin on 27/11/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "PresenterCombinedSlideViewPdfItemController.h"

@interface PresenterCombinedSlideViewPdfItemController ()

@end

@implementation PresenterCombinedSlideViewPdfItemController
@synthesize pdfView = _pdfView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.pdfView.delegate = self;
//    UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapGesture:)];
//    doubleTap.delegate = self;
//    doubleTap.numberOfTapsRequired = 2;
//    [self.pdfView addGestureRecognizer:doubleTap];
//    [doubleTap release];
    UILongPressGestureRecognizer* longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    longPress.delegate = self;
    [self.pdfView addGestureRecognizer:longPress];
    [longPress release];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.pdfView.scrollView.maximumZoomScale = 1.0;
    self.pdfView.scrollView.minimumZoomScale = 1.0;
}

#pragma mark Gesture recognizer delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void)handleDoubleTapGesture:(id)sender {
    [self.itemDelegate didSelectPresenterCombinedSlideViewItem];
}

-(void)handleLongPressGesture:(UILongPressGestureRecognizer*)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self.itemDelegate didSelectPresenterCombinedSlideViewItem];
    }    
}

- (void)dealloc {
    self.pdfView = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadContentWithPath:(NSString*)aPath {
    NSURL* fileURL = [NSURL fileURLWithPath:aPath];
    [self.pdfView loadRequest:[NSURLRequest requestWithURL:fileURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60]];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    CGFloat contentHeight = self.pdfView.scrollView.contentSize.height;
//    NSLog(@"end %f",self.pdfView.scrollView.contentSize.height);
}

@end
