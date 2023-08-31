//
//  CustomerInfoLinkedToTableViewCell.h
//  iArcos
//
//  Created by David Kilmartin on 05/05/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArcosCoreData.h"
#import "CustomerInfoLinkedToTableViewCellDelegate.h"
#import "WidgetFactory.h"

@interface CustomerInfoLinkedToTableViewCell : UITableViewCell <WidgetFactoryDelegate, UIPopoverPresentationControllerDelegate>{
    id<CustomerInfoLinkedToTableViewCellDelegate> _actionDelegate;
    UILabel* _infoTitle;
    UILabel* _infoValue;
    UIButton* _actionBtn;
    NSMutableDictionary* _cellData;
    WidgetFactory* _factory;
//    UIPopoverController* _thePopover;
    WidgetViewController* _globalWidgetViewController;
}

@property(nonatomic,assign) id<CustomerInfoLinkedToTableViewCellDelegate> actionDelegate;
@property(nonatomic,retain) IBOutlet UILabel* infoTitle;
@property(nonatomic,retain) IBOutlet UILabel* infoValue;
@property(nonatomic,retain) IBOutlet UIButton* actionBtn;
@property(nonatomic,retain) NSMutableDictionary* cellData;
@property(nonatomic,retain) WidgetFactory* factory;
//@property(nonatomic,retain) UIPopoverController* thePopover;
@property(nonatomic,retain) WidgetViewController* globalWidgetViewController;

- (void)configCellWithData:(NSMutableDictionary*)aCustDict;
- (IBAction)showContactListPopover;

@end
