//
//  ArcosTableViewHeaderUILabel.m
//  Arcos
//
//  Created by David Kilmartin on 06/08/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "ArcosTableViewHeaderUILabel.h"

@implementation ArcosTableViewHeaderUILabel

- (void)drawTextInRect:(CGRect)rect {
    self.backgroundColor = [UIColor clearColor];
    self.font = [UIFont systemFontOfSize:14];
//    self.shadowColor = [UIColor colorWithWhite:1.0 alpha:1];
//    self.shadowOffset = CGSizeMake(0, 1);
//    self.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1.000];
    self.textColor = [UIColor colorWithRed:109.0/255.0 green:109.0/255.0 blue:114.0/255.0 alpha:1.0];
    //self.textColor = [UIColor grayColor];
    [super drawTextInRect:rect];
}

@end
