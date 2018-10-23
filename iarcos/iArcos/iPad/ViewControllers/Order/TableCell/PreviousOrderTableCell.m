//
//  PreviousOrderTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 14/07/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "PreviousOrderTableCell.h"


@implementation PreviousOrderTableCell
@synthesize  number;
@synthesize  date;
@synthesize  name;
@synthesize  address;
@synthesize  value;
@synthesize  point;
@synthesize  deliveryDate;
@synthesize  selectIndicator;
@synthesize  data;
@synthesize  theIndexPath;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    if (self.number != nil) { self.number = nil; }
    if (self.date != nil) { self.date = nil; }        
    if (self.name != nil) { self.name = nil; }
    if (self.address != nil) { self.address = nil; }   
    if (self.value != nil) { self.value = nil; }
    if (self.point != nil) { self.point = nil; }        
    if (self.deliveryDate != nil) { self.deliveryDate = nil; }
    if (self.selectIndicator != nil) { self.selectIndicator = nil; }
    if (self.data != nil) { self.data = nil; }
    if (self.theIndexPath != nil) { self.theIndexPath = nil; }        


    
    [super dealloc];
}

-(void)flipSelectStatus{
    isSelected=!isSelected;
    [(NSMutableDictionary*) self.data setObject:[NSNumber numberWithBool:isSelected] forKey:@"IsSelected"];
    if (isSelected) {
        self.selectIndicator.backgroundColor=[UIColor redColor];

    }else{
        self.selectIndicator.backgroundColor=[UIColor whiteColor];

    }
}
-(void)setSelectStatus:(BOOL)select{
    isSelected=select;
    if (isSelected) {
        self.selectIndicator.backgroundColor=[UIColor redColor];
        
    }else{
        self.selectIndicator.backgroundColor=[UIColor whiteColor];
        
    }
}
@end
