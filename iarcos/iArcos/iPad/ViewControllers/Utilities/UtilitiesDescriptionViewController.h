//
//  UtilitiesDescriptionViewController.h
//  Arcos
//
//  Created by David Kilmartin on 24/04/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UtilitiesDetailViewController.h"
#import "ArcosCoreData.h"
#import "UtilitiesDescriptionTableCell.h"
#import "UtilitiesDescriptionDetailViewController.h"
#import "ChartTestViewController.h"

@interface UtilitiesDescriptionViewController : UtilitiesDetailViewController <ControllNavigationBarDelegate> {    
    NSMutableArray* _displayList;
    UILabel* _codeLabel;
    UILabel* _detailLabel;
    UIView* tableHeader;
    UIBarButtonItem* _testButton;
    UIBarButtonItem* _numberButton;
    UIBarButtonItem* _stopButton;
    NSTimer* _testTimer;
    int _currentNumber;
}

@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) IBOutlet UILabel* codeLabel;
@property(nonatomic, retain) IBOutlet UILabel* detailLabel;
@property(nonatomic, retain) IBOutlet UIView* tableHeader;
@property(nonatomic, retain) UIBarButtonItem* testButton;
@property(nonatomic, retain) UIBarButtonItem* numberButton;
@property(nonatomic, retain) UIBarButtonItem* stopButton;
@property(nonatomic, retain) NSTimer* testTimer;
@property(nonatomic, assign) int currentNumber;

@end
