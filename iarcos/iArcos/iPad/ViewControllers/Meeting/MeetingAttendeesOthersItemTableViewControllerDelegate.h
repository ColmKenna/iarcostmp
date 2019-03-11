//
//  MeetingAttendeesOthersItemTableViewControllerDelegate.h
//  iArcos
//
//  Created by David Kilmartin on 08/03/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol MeetingAttendeesOthersItemTableViewControllerDelegate <NSObject>

- (void)didDismissOthersItemPopover;
- (void)saveButtonPressedWithName:(NSString*)aName organisation:(NSString*)anOrganisation;

@end

