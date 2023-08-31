//
//  CustomerInfoLinkedToTableViewCellDelegate.h
//  iArcos
//
//  Created by David Kilmartin on 05/05/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CustomerInfoLinkedToTableViewCellDelegate <NSObject>

//- (void)selectCustomerInfoLinkedToRecord:(UILabel*)aValueLabel;
- (void)selectCustomerInfoLinkedToRecord:(NSMutableDictionary*)aCellDict;
- (UIViewController*)retrieveCustomerInfoLinkedToParentViewController;

@end
