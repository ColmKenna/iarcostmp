//
//  MeetingAttendeesOthersItemTableViewCellDelegate.h
//  iArcos
//
//  Created by David Kilmartin on 08/03/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol MeetingAttendeesOthersItemTableViewCellDelegate <NSObject>

- (void)inputFinishedWithData:(NSString*)aData atIndexPath:(NSIndexPath*)anIndexPath;

@end

