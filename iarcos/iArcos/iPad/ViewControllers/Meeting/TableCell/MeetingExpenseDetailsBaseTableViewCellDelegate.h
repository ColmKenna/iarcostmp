//
//  MeetingExpenseDetailsBaseTableViewCellDelegate.h
//  iArcos
//
//  Created by David Kilmartin on 19/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MeetingExpenseDetailsBaseTableViewCellDelegate <NSObject>

- (void)inputFinishedWithData:(id)aData atIndexPath:(NSIndexPath*)anIndexPath;
- (UIViewController*)retrieveMeetingExpenseDetailsParentViewController;

@end

