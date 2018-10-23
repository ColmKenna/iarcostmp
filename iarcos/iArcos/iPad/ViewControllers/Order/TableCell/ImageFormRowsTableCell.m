//
//  ImageFormRowsTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 22/10/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "ImageFormRowsTableCell.h"

@implementation ImageFormRowsTableCell
@synthesize delegate = _delegate;
@synthesize btn1;
@synthesize btn2;
@synthesize btn3;
@synthesize btn4;
@synthesize btn5;

@synthesize label1;
@synthesize label2;
@synthesize label3;
@synthesize label4;
@synthesize label5;

@synthesize btnList = _btnList;
@synthesize labelList = _labelList;
@synthesize indexPath = _indexPath;

@synthesize labelDividerAfter1;
@synthesize labelDividerAfter2;
@synthesize labelDividerAfter3;
@synthesize labelDividerAfter4;

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

- (void)dealloc {
//    if (self.delegate != nil) { self.delegate = nil; }
    if (self.btn1 != nil) { self.btn1 = nil; }
    if (self.btn2 != nil) { self.btn2 = nil; }
    if (self.btn3 != nil) { self.btn3 = nil; }
    if (self.btn4 != nil) { self.btn4 = nil; }
    if (self.btn5 != nil) { self.btn5 = nil; }
    
    if (self.label1 != nil) { self.label1 = nil; }
    if (self.label2 != nil) { self.label2 = nil; }
    if (self.label3 != nil) { self.label3 = nil; }
    if (self.label4 != nil) { self.label4 = nil; }
    if (self.label5 != nil) { self.label5 = nil; }            
    
    if (self.btnList != nil) { self.btnList = nil; }
    if (self.labelList != nil) { self.labelList = nil; }    
    if (self.indexPath != nil) { self.indexPath = nil; }    
    
    if (self.labelDividerAfter1 != nil) { self.labelDividerAfter1 = nil; }
    if (self.labelDividerAfter2 != nil) { self.labelDividerAfter2 = nil; }
    if (self.labelDividerAfter3 != nil) { self.labelDividerAfter3 = nil; }    
    if (self.labelDividerAfter4 != nil) { self.labelDividerAfter4 = nil; }    
    
    [super dealloc];
}

- (void)createPopulatedLists {
    int numberOfImages = 5;
    self.btnList = [NSMutableArray arrayWithCapacity:numberOfImages];
    self.labelList = [NSMutableArray arrayWithCapacity:numberOfImages];
    @try {
        for (int i = 1; i <= numberOfImages; i++) {
            NSString* btnName = [NSString stringWithFormat:@"btn%d", i];
            SEL btnSelector = NSSelectorFromString(btnName);
            [self.btnList addObject:[self performSelector:btnSelector]];
            NSString* labelName = [NSString stringWithFormat:@"label%d", i];
            SEL labelSelector = NSSelectorFromString(labelName);
            [self.labelList addObject:[self performSelector:labelSelector]];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@", [exception reason]);
    }
}

- (IBAction)pressButton:(id)sender {
    UIButton* btn = (UIButton*)sender;
    if (btn.imageView != nil) {
        [self.delegate imageFormRowsWithButton:btn indexPath:self.indexPath];    
    }    
}

- (void)disableAllButtons {
    for (int i = 0; i < [self.btnList count]; i++) {
        UIButton* tmpBtn = [self.btnList objectAtIndex:i];
        tmpBtn.enabled = NO;
    }
}
- (void)clearAllInfo {
    for (int i = 0; i < [self.btnList count]; i++) {
        UIButton* tmpBtn = [self.btnList objectAtIndex:i];
        tmpBtn.enabled = NO;        
        [tmpBtn setImage:nil forState:UIControlStateNormal];
        UILabel* tmpLabel = [self.labelList objectAtIndex:i];
        tmpLabel.text = @"";
    }
}

- (void)getCellReadyToUse {
    [self createPopulatedLists];
    [self clearAllInfo];
}

@end
