//
//  MainPresenterTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 29/03/2016.
//  Copyright (c) 2016 Strata IT Limited. All rights reserved.
//

#import "MainPresenterTableViewCell.h"

@implementation MainPresenterTableViewCell
@synthesize myDelegate = _myDelegate;
@synthesize indexPath = _indexPath;
@synthesize view1 = _view1;
@synthesize view2 = _view2;
@synthesize view3 = _view3;
@synthesize view4 = _view4;
@synthesize view5 = _view5;
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

@synthesize viewList = _viewList;
@synthesize btnList = _btnList;
@synthesize labelList = _labelList;

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.indexPath = nil;
    self.view1 = nil;
    self.view2 = nil;
    self.view3 = nil;
    self.view4 = nil;
    self.view5 = nil;
    self.btn1 = nil;
    self.btn2 = nil;
    self.btn3 = nil;
    self.btn4 = nil;
    self.btn5 = nil;
    
    self.label1 = nil;
    self.label2 = nil;
    self.label3 = nil;
    self.label4 = nil;
    self.label5 = nil;
    
    self.viewList = nil;
    self.btnList = nil;
    self.labelList = nil;
    
    [super dealloc];
}

- (void)handleSingleTapGesture:(id)sender {
    UITapGestureRecognizer* recognizer = (UITapGestureRecognizer*)sender;
    UIView* aView = (UIView*)recognizer.view;
    [self.myDelegate mainPresenterPressedWithView:aView indexPath:self.indexPath];
}

- (void)createPopulatedLists {
    int numberOfImages = 5;
    self.viewList = [NSMutableArray arrayWithCapacity:numberOfImages];
    self.btnList = [NSMutableArray arrayWithCapacity:numberOfImages];
    self.labelList = [NSMutableArray arrayWithCapacity:numberOfImages];
    @try {
        for (int i = 1; i <= numberOfImages; i++) {
            NSString* viewName = [NSString stringWithFormat:@"view%d", i];
            SEL viewSelector = NSSelectorFromString(viewName);
            [self.viewList addObject:[self performSelector:viewSelector]];
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

- (void)clearAllInfo {
    for (int i = 0; i < [self.btnList count]; i++) {
        UIView* tmpView = [self.viewList objectAtIndex:i];
        tmpView.userInteractionEnabled = NO;
        UIButton* tmpBtn = [self.btnList objectAtIndex:i];
        tmpBtn.enabled = NO;
        [tmpBtn setImage:nil forState:UIControlStateNormal];
        UILabel* tmpLabel = [self.labelList objectAtIndex:i];
        tmpLabel.text = @"";
    }
}

- (void)addEventToView {
    UITapGestureRecognizer* singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.view1 addGestureRecognizer:singleTap1];
    [singleTap1 release];
    UITapGestureRecognizer* singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.view2 addGestureRecognizer:singleTap2];
    [singleTap2 release];
    UITapGestureRecognizer* singleTap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.view3 addGestureRecognizer:singleTap3];
    [singleTap3 release];
    UITapGestureRecognizer* singleTap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.view4 addGestureRecognizer:singleTap4];
    [singleTap4 release];
    UITapGestureRecognizer* singleTap5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.view5 addGestureRecognizer:singleTap5];
    [singleTap5 release];
}

- (void)makeCellReadyToUse {
    [self createPopulatedLists];
    [self clearAllInfo];
    [self addEventToView];
}

@end
