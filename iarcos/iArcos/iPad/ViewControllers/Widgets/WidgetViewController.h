//
//  WidgetViewController.h
//  Arcos
//
//  Created by David Kilmartin on 29/07/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WidgetViewControllerDelegate 

-(void)operationDone:(id)data;
@optional
-(void)dismissPopoverController;
-(BOOL)allowToShowAddContactButton;
-(void)emailPressedFromTablePopoverRow:(NSDictionary*)cellData groupName:(NSString*)aGroupName;
-(BOOL)allowToShowAddAccountNoButton;
- (BOOL)allowToShowAddContactFlagButton;
@end

@interface WidgetViewController : UIViewController {
    id Data;
    id <WidgetViewControllerDelegate> delegate;
    BOOL anyDataSource;
    NSNumber* _locationIUR;
    BOOL _isWidgetEditable;
}
@property(nonatomic,retain)id Data;
@property(nonatomic,assign)BOOL anyDataSource;

@property(nonatomic,assign)id <WidgetViewControllerDelegate> delegate;
@property(nonatomic,retain) NSNumber* locationIUR;
@property(nonatomic,assign) BOOL isWidgetEditable;

-(IBAction)operationDone:(id)sender;

@end
