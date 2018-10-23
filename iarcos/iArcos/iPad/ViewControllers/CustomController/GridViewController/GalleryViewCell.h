//
//  GalleryViewCell.h
//  Arcos
//
//  Created by David Kilmartin on 08/07/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GalleryItem.h"

@interface GalleryViewCell : UIView {
    NSMutableArray* items;
    
    id target;
    SEL selctor;
}
@property(nonatomic,retain) NSMutableArray* items;
@property(nonatomic,assign) id target;
@property(nonatomic,assign) SEL selctor;


-(void)addItem:(GalleryItem*)anItem;
-(void)addItems:(NSArray*)itemsArray;
-(void)rearrangeItemsWithWidth:(float)aWidth;
-(void)clearItemsFromView;
-(void)clearItems;
-(void)setTarget:(id)aTarget withSelector:(SEL)aSelecotr;
@end
