//
//  NewPresenterDataManager.h
//  Arcos
//
//  Created by David Kilmartin on 11/08/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosCoreData.h"
#import "HumanReadableDataSizeHelper.h"

@interface NewPresenterDataManager : NSObject {
    int _rowPointer;
    NSMutableArray* _candidateRemovedFileList;
    NSMutableArray* _removedFileList;
    NSDictionary* _auxEmailCellData;
    NSMutableArray* _resultFileList;
    NSString* _groupName;
}

@property(nonatomic, assign) int rowPointer;
@property(nonatomic, retain) NSMutableArray* candidateRemovedFileList;
@property(nonatomic, retain) NSMutableArray* removedFileList;
@property(nonatomic, retain) NSDictionary* auxEmailCellData;
@property(nonatomic, retain) NSMutableArray* resultFileList;
@property(nonatomic, retain) NSString* groupName;

- (NSMutableArray*)getGroupPresenterItems:(NSMutableArray*)aPresenterProducts;
- (NSString*)getMimeTypeWithFileName:(NSString*)aFileName;

- (void)getOverSizeFileListFromDataList:(NSMutableArray*)aDataList;
- (BOOL)isFileInRemovedList:(NSString*)fileName;



@end
