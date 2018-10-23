//
//  CustomerSurveyDetailsResponseTableCellDelegate.h
//  iArcos
//
//  Created by David Kilmartin on 27/06/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CustomerSurveyDetailsResponseTableCellDelegate <NSObject>

- (void)inputFinishedWithData:(id)data forIndexPath:(NSIndexPath*)theIndexPath;
- (void)booleanInputFinishedWithData:(id)data forIndexPath:(NSIndexPath*)theIndexPath;

@end
