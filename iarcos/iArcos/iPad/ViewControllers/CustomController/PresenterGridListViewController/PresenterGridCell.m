//
//  PresenterGridCell.m
//  Arcos
//
//  Created by David Kilmartin on 12/08/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "PresenterGridCell.h"


@implementation PresenterGridCell
@synthesize but1;
@synthesize but2;
@synthesize but3;
@synthesize but4;
@synthesize but5;
@synthesize lab1;
@synthesize lab2;
@synthesize lab3;
@synthesize lab4;
@synthesize lab5;

@synthesize delegate;

@synthesize buttons;
@synthesize labels;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        //self.buttons=[NSMutableArray arrayWithObjects:but1, but2,but3,but4,but5,nil];
        //self.labels=[NSMutableArray arrayWithObjects:lab1,lab2,lab3,lab4,lab5, nil];
        NSLog(@"preseter grid cell init with style!!");
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(IBAction)buttonAction:(id)sender{
//    UIButton* aButton=(UIButton*)sender;
    [self.delegate PresenterGridCell:self buttonTouched:sender];
    
//    NSLog(@"Button index %d pressed",aButton.tag);
}
-(void)fillOutletArray{
    // Initialization code
    self.buttons=[NSMutableArray arrayWithObjects:but1, but2,but3,but4,but5,nil];
    self.labels=[NSMutableArray arrayWithObjects:lab1,lab2,lab3,lab4,lab5, nil];
    
    for (int i=0; i<[buttons count]; i++) {
        [self enableButtonAtIndex:i enable:NO];
    }
}
-(void)enableButtonAtIndex:(int)index enable:(BOOL)enable{
    UIButton* but=[self.buttons objectAtIndex:index];
    but.hidden=!enable;
    but.userInteractionEnabled=enable;
    UILabel* lab=[self.labels objectAtIndex:index];
    lab.hidden=!enable;
    lab.userInteractionEnabled=enable;   
}
- (void)dealloc
{
    if (self.but1 != nil) { self.but1 = nil; }
    if (self.but2 != nil) { self.but2 = nil; }
    if (self.but3 != nil) { self.but3 = nil; }    
    if (self.but4 != nil) { self.but4 = nil; }
    if (self.but5 != nil) { self.but5 = nil; }
    
    if (self.lab1 != nil) { self.lab1 = nil; }
    if (self.lab2 != nil) { self.lab2 = nil; }
    if (self.lab3 != nil) { self.lab3 = nil; }
    if (self.lab4 != nil) { self.lab4 = nil; }    
    if (self.lab5 != nil) { self.lab5 = nil; }
    
    if (self.delegate != nil) { self.delegate = nil; }
    if (self.buttons != nil) { self.buttons = nil; }    
    if (self.labels != nil) { self.labels = nil; }
    
    [super dealloc];
}

@end

