//
//  DetailingTableCellFactory.h
//  Arcos
//
//  Created by David Kilmartin on 05/10/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DetailingTableCell.h"


@interface DetailingTableCellFactory : NSObject {
    NSString* _actionType;
}
@property(nonatomic, retain) NSString* actionType;
+(id)factory;
-(DetailingTableCell*)createDetailingTableCellWithData:(NSMutableDictionary*)data;
-(DetailingTableCell*)createMainTableCell;
-(DetailingTableCell*)createQATableCell;
-(DetailingTableCell*)createKMTableCell;
-(DetailingTableCell*)createSampleTableCell;
-(DetailingTableCell*)createGivenRequestTableCell;
-(DetailingTableCell*)createPresenterTableCell;
-(DetailingTableCell*)createPresenterParentTableCell;
-(DetailingTableCell*)createPresentationsTableCell;
-(NSString*)identifierWithData:(NSMutableDictionary*)data;
@end
