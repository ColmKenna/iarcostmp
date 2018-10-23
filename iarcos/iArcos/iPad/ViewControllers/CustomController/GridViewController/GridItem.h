//
//  ItemIconView.h
//  Arcos
//
//  Created by David Kilmartin on 07/07/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GridItem : UIView {
    UIButton* itemButton;
    UILabel* itemDesc;
    NSObject* data;
    
    id target;
    SEL selctor;
}
@property(nonatomic,retain) UIButton* itemButton;
@property(nonatomic,retain) UILabel* itemDesc;
@property(nonatomic,assign) NSObject* data;

@property(nonatomic,assign) id target;
@property(nonatomic,assign) SEL selctor;

-(id)initWithImage:(UIImage*)anImage withDescription:(NSString*)desc;
-(void)setPosition:(CGPoint)aPoint;

-(void)setTarget:(id)aTarget withSelector:(SEL)aSelecotr;
@end
