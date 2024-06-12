//
//  ReporterCsvDataManager.h
//  iArcos
//
//  Created by Richard on 10/06/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalSharedClass.h"
#import "ArcosUtils.h"

@interface ReporterCsvDataManager : NSObject {
    NSArray* _attrNameList;
    NSMutableArray* _displayList;
    int _cellWidth;
    int _cellHeight;
}

@property (nonatomic, retain) NSArray* attrNameList;
@property (nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, assign) int cellWidth;
@property(nonatomic, assign) int cellHeight;

- (void)processRawDataWithFilePath:(NSString*)aFilePath;

@end


