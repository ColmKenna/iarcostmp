//
//  CustomerSurveySlideDelegate.h
//  Arcos
//
//  Created by David Kilmartin on 15/02/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CustomerSurveySlideDelegate <NSObject>

-(void)slidePageFinishEditing:(id)data WithIndexPath:(NSIndexPath *)theIndexPath;

@end
