//
//  CustomerPhotoDeleteActionViewController.h
//  Arcos
//
//  Created by David Kilmartin on 18/02/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@protocol CustomerPhotoDeleteActionViewControllerDelegate <NSObject>

- (void)didPressDeleteButton:(int)aTag;
@end


@interface CustomerPhotoDeleteActionViewController : UIViewController {
    id<CustomerPhotoDeleteActionViewControllerDelegate> _actionDelegate;
    UIButton* _deleteButton;
}

@property(nonatomic, assign) id<CustomerPhotoDeleteActionViewControllerDelegate> actionDelegate;
@property(nonatomic, retain) IBOutlet UIButton* deleteButton;

- (IBAction)deleteButtonPressed:(id)sender;
@end
