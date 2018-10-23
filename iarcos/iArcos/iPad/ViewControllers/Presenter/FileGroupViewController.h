//
//  FileGroupViewController.h
//  Arcos
//
//  Created by David Kilmartin on 04/07/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilePresentViewController.h"
#import "Image.h"
#import "Product.h"
#import "PresenterDetailViewProtocol.h"
//#import "MGSplitViewController.h"
@interface FileGroupViewController : UITableViewController {
    NSMutableDictionary* myGroups;
    NSString* currentGroupType;
    NSMutableArray* groupName;
    NSArray* sortKeys;
    NSMutableDictionary* groupSelections;
    UIViewController<PresenterDetailViewProtocol> *myFilePresentViewController;
    
    NSMutableArray* resource;
    
    
    //navigation bar button
//    UISplitViewController *splitViewController;
    UISplitViewController *splitViewController;
    
    UIPopoverController *popoverController;    
    UIBarButtonItem *rootPopoverButtonItem;
    
}
@property (nonatomic, assign) IBOutlet UISplitViewController *splitViewController;
@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) UIBarButtonItem *rootPopoverButtonItem;

@property(nonatomic,retain) UIViewController<PresenterDetailViewProtocol>  *myFilePresentViewController;
@property(nonatomic,retain) NSMutableDictionary* myGroups;
@property(nonatomic,retain)    NSString* currentGroupType;
@property(nonatomic,retain) NSMutableArray* groupName;
@property(nonatomic,retain) NSArray* sortKeys;
@property(nonatomic,retain) NSMutableDictionary* groupSelections;
@property(nonatomic,retain)    NSMutableArray* resource;

-(void)sortGroups;
-(void)loadL5GroupList;
-(void)loadProductList;
-(void)loadFileTypeList;
-(void)resetDetailviewContent;
-(void)updateBarButtonItems;
@end
