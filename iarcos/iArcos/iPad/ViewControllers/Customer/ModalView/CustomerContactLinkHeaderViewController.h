//
//  CustomerContactLinkHeaderViewController.h
//  Arcos
//
//  Created by David Kilmartin on 02/08/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArcosTableViewHeaderUILabel.h"
#import "ArcosCoreData.h"
#import "CustomerSelectionListingTableViewController.h"

@protocol CustomerContactLinkHeaderViewControllerDelegate <NSObject>
@optional
- (void)didSelectCustomerSelectionListingRecord:(NSMutableDictionary*)aCustDict;
@end

typedef enum {
    CustomerContactLinkHeaderRequestContact = 0,
    CustomerContactLinkHeaderRequestLocation
} CustomerContactLinkHeaderRequestSource;

@interface CustomerContactLinkHeaderViewController : UIViewController<CustomerSelectionListingDelegate> {
    CustomerContactLinkHeaderRequestSource _linkHeaderRequestSource;
    ArcosTableViewHeaderUILabel* _linkText;
    UIButton* _addLinkButton;
    NSString* _linkTextValue;
    NSMutableArray* _locationList;
//    UIPopoverController* _locationPopover;
    UINavigationController* _globalNavigationController;
    id<CustomerContactLinkHeaderViewControllerDelegate> _linkHeaderViewControllerDelegate;
}
@property(nonatomic, assign) CustomerContactLinkHeaderRequestSource linkHeaderRequestSource;
@property(nonatomic, retain) IBOutlet ArcosTableViewHeaderUILabel* linkText;
@property(nonatomic, retain) IBOutlet UIButton* addLinkButton;
@property(nonatomic, retain) NSString* linkTextValue;
@property(nonatomic, retain) NSMutableArray* locationList;
@property(nonatomic, retain) UINavigationController* globalNavigationController;
//@property(nonatomic, retain) UIPopoverController* locationPopover;
@property(nonatomic, assign) id<CustomerContactLinkHeaderViewControllerDelegate> linkHeaderViewControllerDelegate;

- (IBAction)addLinkPressed:(id)sender;
- (void)processDisplayList;

@end
