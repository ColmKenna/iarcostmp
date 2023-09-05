//
//  ScrollPagingViewController.h
//  Arcos
//
//  Created by David Kilmartin on 10/08/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebPagingViewController.h"
#import "FileCommon.h"
#import "PresenterDetailViewProtocol.h"
#import "WidgetFactory.h"
@interface ScrollPagingViewController : UIViewController<UIScrollViewDelegate,UISplitViewControllerDelegate,PresenterDetailViewProtocol,WidgetFactoryDelegate,UIActionSheetDelegate,FileCommonDelegate,UIWebViewDelegate> {
    IBOutlet UIScrollView *scrollView;
	UIPageControl *pageControl;
    NSMutableArray *viewControllers;
    NSMutableArray *filesArray;
    int currentPageNum;
	
    // To be used when scrolls originate from the UIPageControl
    BOOL pageControlUsed;
    
    //split view
//    UIPopoverController* groupPopover;
    
    NSMutableDictionary* theData;
    
    //order input popover
//    UIPopoverController* inputPopover;
    WidgetFactory* factory;
    
    //groupType
    NSString* groupType;
    
    //hold the bar button
    UIBarButtonItem* myBarButtonItem;

}
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) NSMutableArray *viewControllers;
@property (nonatomic, retain)     NSMutableArray *filesArray;
@property (nonatomic, retain) NSMutableDictionary* theData;
@property(nonatomic,retain) WidgetFactory* factory;
@property (nonatomic,retain)     NSString* groupType;


- (IBAction)changePage:(id)sender;
@end
