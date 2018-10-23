//
//  ItemIconView.m
//  Arcos
//
//  Created by David Kilmartin on 07/07/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "GridItem.h"


@implementation GridItem
@synthesize  itemButton;
@synthesize  itemDesc;
@synthesize data;
@synthesize  target;
@synthesize selctor;

-(id)initWithImage:(UIImage*)anImage withDescription:(NSString*)desc{
    self=[super init];
    if (self!=nil) {
        self.frame=CGRectMake(0, 0, 80, 90 );
        //item button image
        self.itemButton=[[UIButton alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
        UIImage *buttonImageNormal=anImage;
        [self.itemButton setBackgroundImage:buttonImageNormal	forState:UIControlStateNormal];
        [self.itemButton setContentMode:UIViewContentModeCenter];
        
        [self.itemButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        //item description
        self.itemDesc = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, 80, 10)];
        self.itemDesc.text = desc;
        self.itemDesc.textColor = [UIColor blackColor];
        self.itemDesc.backgroundColor = [UIColor clearColor];
        //self.itemDesc.backgroundColor = [UIColor blueColor];
        self.itemDesc.textAlignment = NSTextAlignmentCenter;
        self.itemDesc.font = [UIFont fontWithName:@"ArialMT" size:12]; 
        
        [self addSubview:self.itemButton];
        [self addSubview:self.itemDesc];
        self.backgroundColor=[UIColor clearColor];
        
        //self.autoresizingMask = UIViewAutoresizingNone;
    }
    return self;
}

-(void)buttonPressed:(id)sender{
    [self.target performSelector:self.selctor withObject:self];
}
-(void)setPosition:(CGPoint)aPoint{
    self.frame=CGRectMake(aPoint.x, aPoint.y, self.frame.size.width, self.frame.size.height);
}

-(void)setTarget:(id)aTarget withSelector:(SEL)aSelecotr{
    self.target=aTarget;
    self.selctor=aSelecotr;
}
@end
