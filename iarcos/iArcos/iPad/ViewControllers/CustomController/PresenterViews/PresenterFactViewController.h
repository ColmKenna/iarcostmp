//
//  PresenterFactViewController.h
//  Arcos
//
//  Created by David Kilmartin on 22/11/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PresenterZoomableImageViewController.h"
#import "PresenterPDFViewController.h"
#import "PresenterViewController.h"

@interface PresenterFactViewController : PresenterViewController<UIWebViewDelegate> {
    NSMutableArray* imageUrls;
   IBOutlet UIImageView* image1;
   IBOutlet UIImageView* image2;
    IBOutlet UIButton* infoButton;
    IBOutlet UIScrollView* myScrollView;
    IBOutlet PresenterZoomableImageViewController* zoomableView;
    PresenterPDFViewController* imageViewer;
    ArcosRootViewController* _myRootViewController;
}
@property(nonatomic,retain) IBOutlet UIImageView* image1;
@property(nonatomic,retain) IBOutlet UIImageView* image2;
@property(nonatomic,retain) IBOutlet UIButton* infoButton;
@property(nonatomic,retain) IBOutlet UIScrollView* myScrollView;
@property(nonatomic,retain) IBOutlet PresenterZoomableImageViewController* zoomableView;
@property(nonatomic,retain) PresenterPDFViewController* imageViewer;
@property(nonatomic,retain) NSMutableArray* imageUrls;
@property(nonatomic, retain) ArcosRootViewController* myRootViewController;

-(void)loadContentWithURL:(NSURL*)aUrl forIndex:(int)index;
-(int)indexForFile:(NSString*)fileName;
-(IBAction)infoPressed:(id)sender;

@end
