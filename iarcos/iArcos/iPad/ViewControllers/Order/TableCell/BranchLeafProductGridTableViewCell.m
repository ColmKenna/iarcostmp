//
//  BranchLeafProductGridTableViewCell.m
//  Arcos
//
//  Created by David Kilmartin on 03/09/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "BranchLeafProductGridTableViewCell.h"

@implementation BranchLeafProductGridTableViewCell
@synthesize btn1;
@synthesize btn2;
@synthesize btn3;
@synthesize btn4;

@synthesize labelDividerAfter1;
@synthesize labelDividerAfter2;
@synthesize labelDividerAfter3;

@synthesize btnList = _btnList;
@synthesize indexPath = _indexPath;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc {
    if (self.btn1 != nil) { self.btn1 = nil; }
    if (self.btn2 != nil) { self.btn2 = nil; }
    if (self.btn3 != nil) { self.btn3 = nil; }
    if (self.btn4 != nil) { self.btn4 = nil; }
    if (self.labelDividerAfter1 != nil) { self.labelDividerAfter1 = nil; }
    if (self.labelDividerAfter2 != nil) { self.labelDividerAfter2 = nil; }
    if (self.labelDividerAfter3 != nil) { self.labelDividerAfter3 = nil; }
    if (self.btnList != nil) { self.btnList = nil; }
    if (self.indexPath != nil) { self.indexPath = nil; }
    
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)createPopulatedLists {
    int itemPerRow = 4;
    self.btnList = [NSMutableArray arrayWithCapacity:itemPerRow];
//    self.labelList = [NSMutableArray arrayWithCapacity:numberOfImages];
    @try {
        for (int i = 1; i <= itemPerRow; i++) {
            NSString* btnName = [NSString stringWithFormat:@"btn%d", i];
            SEL btnSelector = NSSelectorFromString(btnName);
            [self.btnList addObject:[self performSelector:btnSelector]];
//            NSString* labelName = [NSString stringWithFormat:@"label%d", i];
//            SEL labelSelector = NSSelectorFromString(labelName);
//            [self.labelList addObject:[self performSelector:labelSelector]];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@", [exception reason]);
    }
}

- (void)clearAllInfo {
    for (int i = 0; i < [self.btnList count]; i++) {
        UIButton* tmpBtn = [self.btnList objectAtIndex:i];
        tmpBtn.enabled = NO;        
        [tmpBtn setImage:nil forState:UIControlStateNormal];
//        UILabel* tmpLabel = [self.labelList objectAtIndex:i];
//        tmpLabel.text = @"";
    }
}

- (void)getCellReadyToUse {
    [self createPopulatedLists];
    [self clearAllInfo];
}

@end
