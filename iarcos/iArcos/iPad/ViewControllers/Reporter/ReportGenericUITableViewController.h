//
//  ReportGenericUITableViewController.h
//  Arcos
//
//  Created by David Kilmartin on 17/04/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelViewDelegate.h"
#import "ArcosCoreData.h"
#import "ArcosUtils.h"
#import "ArcosCustomiseAnimation.h"
#import "GenericUITableDetailViewController.h"

@interface ReportGenericUITableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, SlideAcrossViewAnimationDelegate> {
    id<SlideAcrossViewAnimationDelegate> _animateDelegate;
    int cellWidth;
    int cellHeight;
    UIView* customiseTableHeaderView;
    IBOutlet UIScrollView* customiseScrollView;
    NSMutableDictionary* parentCellData;
    NSArray* attrNameList;
    NSArray* attrNameTypeList;
    NSDictionary* attrDict;
    UITableView* customiseTableView;
    NSMutableArray* _displayList;
    ArcosCustomiseAnimation* arcosCustomiseAnimation;
    
    UINavigationController* _globalNavigationController;
    UIViewController* _rootView;
    
}

@property(nonatomic, assign) id<SlideAcrossViewAnimationDelegate> animateDelegate;
@property(nonatomic, assign) int cellWidth;
@property(nonatomic, assign) int cellHeight;
@property(nonatomic, retain) UIView* customiseTableHeaderView;
@property(nonatomic, retain) IBOutlet UIScrollView* customiseScrollView;
@property(nonatomic, retain) NSMutableDictionary* parentCellData;
@property(nonatomic, retain) NSArray* attrNameList;
@property(nonatomic, retain) NSArray* attrNameTypeList;
@property(nonatomic, retain) NSDictionary* attrDict;
@property(nonatomic, retain) UITableView* customiseTableView;
@property(nonatomic, retain) NSMutableArray* displayList;

@property(nonatomic, retain) UINavigationController* globalNavigationController;
@property(nonatomic, retain) UIViewController* rootView;

-(void)insertRow:(NSMutableDictionary*)rowData;

@end
