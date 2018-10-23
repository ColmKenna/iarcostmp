//
//  ImageL5FormRowsTableViewController.h
//  Arcos
//
//  Created by David Kilmartin on 23/10/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageL5FormRowsDataManager.h"
#import "ImageFormRowsTableCell.h"
#import "OrderSharedClass.h"
#import "FormRowsTableViewController.h"
#import "ProductFormRowConverter.h"
#import "SlideAcrossViewAnimationDelegate.h"

@interface ImageL5FormRowsTableViewController : UITableViewController <ImageFormRowsDelegate, UIActionSheetDelegate, SlideAcrossViewAnimationDelegate, UISearchBarDelegate> {
    id<SlideAcrossViewAnimationDelegate> _animateDelegate;
    NSString* _descrDetailCode;
    ImageL5FormRowsDataManager* _imageL5FormRowsDataManager;
    
    ArcosCustomiseAnimation* _arcosCustomiseAnimation;
    UINavigationController* _globalNavigationController;
    UIViewController* _rootView;
    UISearchBar* _mySearchBar;
}

@property(nonatomic, assign) id<SlideAcrossViewAnimationDelegate> animateDelegate;
@property(nonatomic, retain) NSString* descrDetailCode;
@property(nonatomic, retain) ImageL5FormRowsDataManager* imageL5FormRowsDataManager;
@property(nonatomic, retain) ArcosCustomiseAnimation* arcosCustomiseAnimation;
@property(nonatomic, retain) UINavigationController* globalNavigationController;
@property(nonatomic, retain) UIViewController* rootView;
@property(nonatomic, retain) IBOutlet UISearchBar* mySearchBar;


- (NSMutableDictionary*)createFormRowWithProduct:(NSMutableDictionary*) product;
- (void)reloadTableViewData;

@end
