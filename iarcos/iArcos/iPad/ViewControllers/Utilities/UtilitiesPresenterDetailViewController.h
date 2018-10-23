//
//  UtilitiesPresenterDetailViewController.h
//  Arcos
//
//  Created by David Kilmartin on 20/03/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UtilitiesDetailViewController.h"
#import "UtilitiesPresenterDetailTableCell.h"
#import "FileCommon.h"
#import "ArcosUtils.h"
#import "HumanReadableDataSizeHelper.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSData+MD5.h"
#import "FileMD5Calculator.h"

@interface UtilitiesPresenterDetailViewController : UtilitiesDetailViewController <UIActionSheetDelegate>{
    NSArray* _presenterFileList;
    IBOutlet UIView* tableHeader;
    NSMutableArray* _displayList;
    NSIndexPath* _globalIndexPath;
    FileMD5Calculator* _fileMD5Calculator;
}

@property(nonatomic, retain) NSArray* presenterFileList;
@property(nonatomic, retain) IBOutlet UIView* tableHeader;
@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) NSIndexPath* globalIndexPath;
@property(nonatomic, retain) FileMD5Calculator* fileMD5Calculator;

- (void)createDisplayList;

@end
