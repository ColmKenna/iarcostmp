//
//  SavedOrderTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 14/07/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "SavedOrderTableCell.h"


@implementation SavedOrderTableCell
@synthesize  number;
@synthesize  date;
@synthesize  name;
@synthesize  address;
@synthesize  value;
@synthesize  point;
@synthesize  deliveryDate;
@synthesize sendButton;
@synthesize  selectIndicator;
@synthesize icon;
@synthesize  data;
@synthesize theIndexPath;
@synthesize indicator;
@synthesize delegate;
@synthesize type;
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
-(IBAction)sendOrder:(id)sender{
    UIButton* aButton=(UIButton*)sender;
    aButton.hidden=YES;
    aButton.enabled=NO;
//    NSLog(@"button in save order cell is pressed! with data %@",self.data);
    [self.delegate sendPressedForCell:self];
    //[self sendTheOrder];
}

-(void)animate{
    self.userInteractionEnabled=NO;
    indicator.hidden=NO;
    [indicator startAnimating];
}
-(void)stopAnimateWithStatus:(BOOL)status{
    self.userInteractionEnabled=YES;
    sendButton.hidden=status;
    sendButton.enabled=status;
    [indicator stopAnimating];
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
    if (self.sendButton != nil) { self.sendButton = nil; }
    if (self.selectIndicator != nil) { self.selectIndicator = nil; }    
    if (self.icon != nil) { self.icon = nil; }        
    if (self.data != nil) { self.data = nil; }
    if (self.theIndexPath != nil) { self.theIndexPath = nil; }
    if (self.indicator != nil) { self.indicator = nil; }
//    if (self.delegate != nil) { self.delegate = nil; }
    
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
-(void)needEditable:(BOOL)editable{
    
    self.editing=!editable;
    self.sendButton.hidden=!editable;

    
    if (!editable) {
//        [self.value setTextColor:[UIColor colorWithRed:0.003f green:0.296f blue:0.125f alpha:1]];
//        [self.date setTextColor:[UIColor colorWithRed:0.003f green:0.296f blue:0.125f alpha:1]];
//        [self.deliveryDate setTextColor:[UIColor colorWithRed:0.003f green:0.296f blue:0.125f alpha:1]];

    }else{
//        [self.value setTextColor:[UIColor redColor]];
//        [self.date setTextColor:[UIColor redColor]];
//        [self.deliveryDate setTextColor:[UIColor redColor]];
        self.sendButton.enabled=YES;

    }
}
-(void)inSending:(BOOL)sending{
    if (sending) {
        self.userInteractionEnabled=NO;
        [self.indicator startAnimating];
        self.sendButton.hidden=YES;
    }else{
        self.userInteractionEnabled=YES;
        [self.indicator stopAnimating];
        self.sendButton.enabled=YES;
    }
}
@end
