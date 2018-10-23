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
@end

@interface WidgetViewController : UIViewController {
    id Data;
    id <WidgetViewControllerDelegate> delegate;
    BOOL anyDataSource;
}
@property(nonatomic,retain)id Data;
@property(nonatomic,assign)BOOL anyDataSource;

@property(nonatomic,assign)id <WidgetViewControllerDelegate> delegate;

-(IBAction)operationDone:(id)sender;

@end
