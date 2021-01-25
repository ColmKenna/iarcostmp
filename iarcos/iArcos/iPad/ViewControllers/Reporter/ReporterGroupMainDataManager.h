//
//  ReporterGroupMainDataManager.h
//  iArcos
//
//  Created by Richard on 18/01/2021.
//  Copyright © 2021 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosGenericClass.h"
#import "ArcosUtils.h"


@interface ReporterGroupMainDataManager : NSObject {
    NSMutableArray* _originalDisplayList;
    int _numberOfBtn;
    NSMutableArray* _displayList;
}

@property(nonatomic, retain) NSMutableArray* originalDisplayList;
@property(nonatomic, assign) int numberOfBtn;
@property(nonatomic, retain) NSMutableArray* displayList;

- (void)processRawData:(NSMutableArray*)aDisplayList;
- (NSMutableArray*)retrieveReporterListWithGroupDetail:(NSString*)aGroupDetail;

@end


