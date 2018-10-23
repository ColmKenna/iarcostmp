//
//  FilePresentViewController.h
//  Arcos
//
//  Created by David Kilmartin on 04/07/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GridViewController.h"
#import "ArcosCoreData.h"
#import "FileReaderViewController.h"
#import "PresenterDetailViewProtocol.h"
#import "FileCommon.h"

@interface FilePresentViewController : GridViewController <UISplitViewControllerDelegate,PresenterDetailViewProtocol>{
    UIPopoverController* groupPopover;
    
    FileReaderViewController* myFileReader;
    
    NSString* groupType;
}
@property(nonatomic,retain)    NSString* groupType;

-(void)sortIconsWithColumnNumber:(int)columns;
@end
