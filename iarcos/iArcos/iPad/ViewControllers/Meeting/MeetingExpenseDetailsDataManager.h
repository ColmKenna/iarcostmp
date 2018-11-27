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
    NSString* _iurKey;
    NSString* _exTypeKey;
    NSString* _expDateKey;
    NSString* _commentsKey;
    NSString* _totalAmountKey;
    NSMutableDictionary* _headOfficeDataObjectDict;
}

@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) NSString* iurKey;
@property(nonatomic, retain) NSString* exTypeKey;
@property(nonatomic, retain) NSString* expDateKey;
@property(nonatomic, retain) NSString* commentsKey;
@property(nonatomic, retain) NSString* totalAmountKey;
@property(nonatomic, retain) NSMutableDictionary* headOfficeDataObjectDict;


- (void)createSkeletonData;
- (void)dataInputFinishedWithData:(id)aData atIndexPath:(NSIndexPath *)anIndexPath;
- (void)displayListHeadOfficeAdaptor;

@end

