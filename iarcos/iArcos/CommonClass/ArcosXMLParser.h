//
//  ArcosXMLParser.h
//  Arcos
//
//  Created by David Kilmartin on 12/06/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ArcosXMLParser : NSObject


+ (id)doXMLParse:(NSString*)aFileName deserializeTo:(id)aDeserializeTo;

@end
