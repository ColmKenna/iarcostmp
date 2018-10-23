//
//  CustomerPopoverMenuViewController.h
//  Arcos
//
//  Created by David Kilmartin on 22/06/2011.
//  Copyright 2011  Strata IT. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ORDER_BUTTON_TAG 1
#define CALLS_BUTTON_TAG 2
#define INVOICES_BUTTON_TAG 3
#define MEMOS_BUTTON_TAG 4
#define ANALYSIS_BUTTON_TAG 5
#define NOTBUY_BUTTON_TAG 6
#define TYVLY_BUTTON_TAG 7
#define DETAILS_BUTTON_TAG 8
#define CREATE_CONTACT_BUTTON_TAG 8

@protocol customerPopoverMenuDelegate 

@optional
-(void)buttonSelectedIndex:(NSInteger)index;
    
@end

@interface CustomerPopoverMenuViewController : UIViewController {
    id <customerPopoverMenuDelegate> delegate;

}
@property (nonatomic,retain)     id <customerPopoverMenuDelegate> delegate;
-(IBAction)buttonSelected:(id)sender;

@end
