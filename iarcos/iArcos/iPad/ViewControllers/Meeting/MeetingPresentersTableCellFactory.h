//
//  MeetingPresentersTableCellFactory.h
//  iArcos
//
//  Created by Richard on 24/06/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MeetingPresentersCompositeObject.h"
#import "MeetingPresentersBaseTableViewCell.h"

@interface MeetingPresentersTableCellFactory : NSObject {
    NSString* _headerTableCellId;
    NSString* _presenterTableCellId;
}

@property(nonatomic, retain) NSString* headerTableCellId;
@property(nonatomic, retain) NSString* presenterTableCellId;

- (NSString*)identifierWithData:(MeetingPresentersCompositeObject*)aData;
- (MeetingPresentersBaseTableViewCell*)createMeetingPresentersBaseTableCellWithData:(MeetingPresentersCompositeObject*)aData;

@end


