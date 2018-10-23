//
//  GalleryViewCell.m
//  Arcos
//
//  Created by David Kilmartin on 08/07/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "GalleryViewCell.h"


@implementation GalleryViewCell
@synthesize items;
@synthesize  target;
@synthesize selctor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //self.backgroundColor=[UIColor redColor];
        self.autoresizesSubviews=YES;
        self.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        self.items=[[NSMutableArray alloc]init ];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)addItem:(GalleryItem*)anItem{
//    [anItem setTarget:self withSelector:@selector(iconViewPressed:)];
//    // NSLog(@"grid view cell width is %f",self.contentView.frame.size.width);
//    float gap=(self.frame.size.width-anItem.frame.size.width*[items count]+1)/([items count]+2);
//    
//    NSLog(@"gap calculation: (%f-%f*%d)/%d =%f",self.frame.size.width,anItem.frame.size.width,[items count]+1,[items count]+2,gap);
//    int currentItemPos=gap;
//    
//    [self clearItemsFromView];
//    
//    [self.items addObject:anItem];
//    for (GalleryItem* anIconView in self.items) {
//        anIconView.frame=CGRectMake(currentItemPos, 10, anIconView.frame.size.width, anIconView.frame.size.height);
//        [self addSubview:anIconView];
//        currentItemPos+=gap+anItem.frame.size.width;
//    }
    [anItem setTarget:self withSelector:@selector(iconViewPressed:)];
    [self.items addObject:anItem];
    [self rearrangeItemsWithWidth:self.frame.size.width];
}
-(void)addItems:(NSArray*)itemsArray{
    [self clearItems];
    
    for (GalleryItem* anItem in itemsArray) {
        [self addItem:anItem];
    }
}
-(void)rearrangeItemsWithWidth:(float)aWidth{
    [self clearItemsFromView];
    
    if ([self.items count]>0) {
        GalleryItem* anItem=[self.items objectAtIndex:0];
        float gap=(aWidth-anItem.frame.size.width*[items count]+1)/([items count]+2);
        
        // NSLog(@"gap calculation: (%f-%f*%d)/%d =%f",aWidth,anItem.frame.size.width,[items count]+1,[items count]+2,gap);
        int currentItemPos=gap;
        
        for (GalleryItem* anIconView in self.items) {
            anIconView.frame=CGRectMake(currentItemPos, 10, anIconView.frame.size.width, anIconView.frame.size.height);
            [self addSubview:anIconView];
            currentItemPos+=gap+anItem.frame.size.width;
        }
    }
}
-(void)clearItemsFromView{
    for (GalleryItem* anIconView in self.items) {
        [anIconView removeFromSuperview];
    }
}
-(void)clearItems{
    [self clearItemsFromView];
    [self.items removeAllObjects];
}

-(void)setTarget:(id)aTarget withSelector:(SEL)aSelecotr{
    self.target=aTarget;
    self.selctor=aSelecotr;
}
-(void)iconViewPressed:(id)sender{
    [target performSelector:self.selctor withObject:sender];
}     
- (void)dealloc
{
    [items release];
    [super dealloc];
}

@end
