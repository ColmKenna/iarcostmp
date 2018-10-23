//
//  FormRowDividerTableViewController.h
//  Arcos
//
//  Created by David Kilmartin on 05/11/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormRowDividerDataManager.h"
#import "FormRowDividerDelegate.h"
#import "OrderSharedClass.h"

@interface FormRowDividerTableViewController : UIViewController {
    id<FormRowDividerDelegate> _delegate;
    NSNumber* _formIUR;
    NSString* _formName;
    FormRowDividerDataManager* _formRowDividerDataManager;    
    UINavigationBar* _tableNavigationBar;
    UITableView* _formRowDividerTableView;
}

@property(nonatomic, retain) id<FormRowDividerDelegate> delegate;
@property(nonatomic, retain) NSNumber* formIUR;
@property(nonatomic, retain) NSString* formName;
@property(nonatomic, retain) FormRowDividerDataManager* formRowDividerDataManager;
@property(nonatomic, retain) IBOutlet UINavigationBar* tableNavigationBar;
@property(nonatomic, retain) IBOutlet UITableView* formRowDividerTableView;

@end
