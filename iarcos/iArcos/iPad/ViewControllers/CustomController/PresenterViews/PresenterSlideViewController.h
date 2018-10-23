//
//  PresenterSlideViewController.h
//  Arcos
//
//  Created by David Kilmartin on 26/01/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PresenterSlideViewController.h"
#import "PresenterViewController.h"
@class ArcosRootViewController;
@interface PresenterSlideViewController : PresenterViewController{
    UIScrollView* _scrollView;
	NSMutableArray *views;
	int currentPage;
    NSMutableArray* viewItems;
    NSMutableArray* imagePaths;
    BOOL pageControlUsed;
    ArcosRootViewController* _arcosRootViewController;
}
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) NSMutableArray* viewItems;
@property(nonatomic,retain)     NSMutableArray* imagePaths;
@property(nonatomic, retain) ArcosRootViewController* arcosRootViewController;
-(void)loadContentWithPath:(NSString*)aPath forIndex:(int)index;


@end
