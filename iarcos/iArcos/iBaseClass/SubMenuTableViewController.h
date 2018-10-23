//
//  SubMenuTableViewController.h
//  iArcos
//
//  Created by David Kilmartin on 05/08/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalSharedClass.h"
#import "SubMenuTableViewControllerDelegate.h"

@interface SubMenuTableViewController : UITableViewController {
    id<SubMenuTableViewControllerDelegate> _subMenuDelegate;
    NSMutableArray* _displayList;
    NSIndexPath* _currentIndexPath;
    NSString* _requestSourceName;
}

@property(nonatomic, assign) id<SubMenuTableViewControllerDelegate> subMenuDelegate;
@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) NSIndexPath* currentIndexPath;
@property(nonatomic, retain) NSString* requestSourceName;

- (NSMutableDictionary*)createItemCellData:(NSString*)title imageFile:(NSString*)imageFile;
- (NSMutableDictionary*)createItemCellData:(NSString*)title imageFile:(NSString*)imageFile myCustomController:(UIViewController*)aViewController;
- (NSMutableDictionary*)createItemCellData:(NSString*)title imageFile:(NSString*)imageFile myCustomControllerIndex:(NSNumber*)aViewControllerIndex;
- (UIViewController*)pickCustomViewController:(NSString*)aTitle;
- (void)removeAllInstances;
- (void)selectBottomRecordByTitle:(NSString*)aTitle;
@end
