//
//  Image.h
//  Arcos
//
//  Created by David Kilmartin on 10/08/2011.
//  Copyright (c) 2011 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Image : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * Rowguid;
@property (nonatomic, retain) NSString * URL;
@property (nonatomic, retain) NSNumber * IUR;
@property (nonatomic, retain) NSString * Title;
@property (nonatomic, retain) NSData * Thumbnail;
@property (nonatomic, retain) NSData * Image;
@property (nonatomic, retain) NSString * Filename;

@end
