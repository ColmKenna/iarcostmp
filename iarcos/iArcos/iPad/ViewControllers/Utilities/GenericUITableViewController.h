//
//  GenericUITableViewController.h
//  Arcos
//
//  Created by David Kilmartin on 21/03/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelViewDelegate.h"
#import "ArcosCoreData.h"
#import "ArcosUtils.h"
#import "ArcosCustomiseAnimation.h"
#import "GenericUITableDetailViewController.h"
#import "AlertPrompt.h"
#import "SlideAcrossViewAnimationDelegate.h"
#import "GenericUITableTableCell.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "ArcosMailWrapperViewController.h"
@protocol ClearTableDelegate <NSObject>
@optional
-(void)refreshClearTableOperation;

@end

@interface GenericUITableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,SlideAcrossViewAnimationDelegate,ArcosCustomiseAnimationDelegate,MFMailComposeViewControllerDelegate,ArcosMailTableViewControllerDelegate> {
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
    id<ClearTableDelegate> _clearDelegate;
    MFMailComposeViewController* _mailController;
    NSString* _filePath;
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
@property(nonatomic, assign) id<ClearTableDelegate> clearDelegate;
@property(nonatomic, retain) MFMailComposeViewController* mailController;
@property(nonatomic, retain) NSString* filePath;

-(void)insertRow:(NSMutableDictionary*)rowData;

@end
