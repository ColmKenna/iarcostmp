//
//  CustomerPresenterFilesViewController.h
//  Arcos
//
//  Created by David Kilmartin on 08/03/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileCommon.h"
#import "CustomerPresenterFilesTableCell.h"
#import "ArcosUtils.h"
#import "HumanReadableDataSizeHelper.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSData+MD5.h"
#import "SlideAcrossViewAnimationDelegate.h"

@interface CustomerPresenterFilesViewController : UITableViewController {
    id<SlideAcrossViewAnimationDelegate> _animateDelegate;
    NSArray* _presenterFileList;
    IBOutlet UIView* tableHeader;
    NSMutableArray* _displayList;
    NSIndexPath* _globalIndexPath;
}

@property(nonatomic, assign) id<SlideAcrossViewAnimationDelegate> animateDelegate;
@property(nonatomic, retain) NSArray* presenterFileList;
@property(nonatomic, retain) IBOutlet UIView* tableHeader;
@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) NSIndexPath* globalIndexPath;

- (void)createDisplayList;


@end
