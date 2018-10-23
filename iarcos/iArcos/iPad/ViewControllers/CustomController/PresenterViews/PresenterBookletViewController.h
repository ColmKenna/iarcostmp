//
//  PresenterBookletViewController.h
//  Arcos
//
//  Created by David Kilmartin on 23/11/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PresenterViewController.h"
@class ArcosRootViewController;

@interface PresenterBookletViewController : PresenterViewController {
    NSMutableArray* bookletImages;
    int currentBookletIndex;
    UIImageView* currentImageView;
    NSMutableArray* imagePaths;
    ArcosRootViewController* _myRootViewController;
}
@property(nonatomic,retain)    UIImageView* currentImageView;
@property(nonatomic,retain)     NSMutableArray* imagePaths;
@property(nonatomic, retain) ArcosRootViewController* myRootViewController;

-(void)loadContentWithPath:(NSString*)aPath forIndex:(int)index;
-(int)indexForFile:(NSString*)fileName;
@end
