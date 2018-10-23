//
//  LargeImageL5FormRowsSlideViewController.h
//  Arcos
//
//  Created by David Kilmartin on 12/06/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LargeImageL5FormRowsDataManager.h"
#import "FormRowsTableViewController.h"

@interface LargeImageL5FormRowsSlideViewController : UIViewController <UIScrollViewDelegate, LargeImageSlideViewItemDelegate> {
    UIScrollView* _myScrollView;
    LargeImageL5FormRowsDataManager* _largeImageL5FormRowsDataManager;
    
}

@property(nonatomic, retain) IBOutlet UIScrollView* myScrollView;
@property(nonatomic, retain) LargeImageL5FormRowsDataManager* largeImageL5FormRowsDataManager;

@end
