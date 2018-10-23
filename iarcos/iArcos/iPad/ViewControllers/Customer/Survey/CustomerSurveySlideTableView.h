//
//  CustomerSurveySlideTableView.h
//  Arcos
//
//  Created by David Kilmartin on 15/02/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerSurveySlideDelegate.h"
#import "CustomerSurveySlidePageTableCell.h"

@interface CustomerSurveySlideTableView : UITableViewController {
    id<CustomerSurveySlideDelegate> delegate;
    NSMutableArray* displayList;
    NSIndexPath* accessoryIndexPath;
    NSString* _parentContentString;
    
}

@property (nonatomic,assign) id<CustomerSurveySlideDelegate> delegate;
@property (nonatomic,retain) NSMutableArray* displayList;
@property (nonatomic,retain) NSIndexPath* accessoryIndexPath;
@property (nonatomic,retain) NSString* parentContentString;

@end
