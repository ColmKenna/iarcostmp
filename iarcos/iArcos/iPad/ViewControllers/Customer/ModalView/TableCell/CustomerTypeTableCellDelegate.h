//
//  CustomerTypeTableCellDelegate.h
//  Arcos
//
//  Created by David Kilmartin on 10/01/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CustomerTypeTableCellDelegate <NSObject>

-(void)inputFinishedWithData:(id)contentString actualData:(id)actualData forIndexpath:(NSIndexPath*)theIndexpath;
@optional
-(NSString*)getFieldNameWithIndexPath:(NSIndexPath*)theIndexpath;
- (NSString*)retrieveDescrDetailCodeWithDescrTypeCode:(NSString*)aDescrTypeCode;
- (NSString*)retrieveParentActionType;
- (UIViewController*)retrieveCustomerTypeParentViewController;

@end
