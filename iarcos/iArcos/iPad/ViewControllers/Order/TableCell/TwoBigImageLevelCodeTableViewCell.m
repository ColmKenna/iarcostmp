//
//  TwoBigImageLevelCodeTableViewCell.m
//  Arcos
//
//  Created by David Kilmartin on 07/11/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "TwoBigImageLevelCodeTableViewCell.h"

@implementation TwoBigImageLevelCodeTableViewCell
@synthesize delegate = _delegate;
@synthesize btn1;
@synthesize btn2;
@synthesize btn3;
@synthesize labelDividerAfter1;
@synthesize labelDividerAfter2;
@synthesize btnList = _btnList;
@synthesize indexPath = _indexPath;

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.btn1 = nil;
    self.btn2 = nil;
    self.btn3 = nil;
    self.labelDividerAfter1 = nil;
    self.labelDividerAfter2 = nil;
    self.btnList = nil;
    self.indexPath = nil;
    
    [super dealloc];
}

- (IBAction)pressButton:(id)sender {
    UIButton* btn = (UIButton*)sender;
    if (btn.imageView != nil) {
        [self.delegate bigImageLevelCodeWithButton:btn indexPath:self.indexPath];
    }
}

- (void)getCellReadyToUse {
    [self createPopulatedLists];
    [self clearAllInfo];
}

- (void)createPopulatedLists {
    int numberOfImages = 3;
    self.btnList = [NSMutableArray arrayWithCapacity:numberOfImages];
//    self.labelList = [NSMutableArray arrayWithCapacity:numberOfImages];
    @try {
        for (int i = 1; i <= numberOfImages; i++) {
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

@end
