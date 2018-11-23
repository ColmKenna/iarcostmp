//
//  MeetingExpenseDetailsDataManager.h
//  iArcos
//
//  Created by David Kilmartin on 19/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MeetingExpenseDetailsDataManager : NSObject {
    NSMutableArray* _displayList;
    NSString* _iur;
    NSString* _exType;
    NSString* _expDate;
    NSString* _comments;
    NSString* _totalAmount;
}

@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) NSString* iur;
@property(nonatomic, retain) NSString* exType;
@property(nonatomic, retain) NSString* expDate;
@property(nonatomic, retain) NSString* comments;
@property(nonatomic, retain) NSString* totalAmount;


- (void)createSkeletonData;
- (void)dataInputFinishedWithData:(id)aData atIndexPath:(NSIndexPath *)anIndexPath;

@end

