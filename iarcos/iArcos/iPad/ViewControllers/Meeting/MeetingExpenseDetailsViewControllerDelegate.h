//
//  MeetingExpenseDetailsViewControllerDelegate.h
//  iArcos
//
//  Created by David Kilmartin on 23/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol MeetingExpenseDetailsViewControllerDelegate <NSObject>

- (void)meetingExpenseDetailsSaveButtonWithData:(NSMutableDictionary*)aHeadOfficeDataObjectDict;

@end

