//
//  ArcosCalendarTableViewCell.m
//  iArcos
//
//  Created by Richard on 21/03/2022.
//  Copyright © 2022 Strata IT Limited. All rights reserved.
//

#import "ArcosCalendarTableViewCell.h"

@implementation ArcosCalendarTableViewCell
@synthesize actionDelegate = _actionDelegate;
@synthesize view0 = _view0;
@synthesize view1 = _view1;
@synthesize view2 = _view2;
@synthesize view3 = _view3;
@synthesize view4 = _view4;
@synthesize view5 = _view5;
@synthesize view6 = _view6;

@synthesize label0 = _label0;
@synthesize label1 = _label1;
@synthesize label2 = _label2;
@synthesize label3 = _label3;
@synthesize label4 = _label4;
@synthesize label5 = _label5;
@synthesize label6 = _label6;

@synthesize tableView0 = _tableView0;
@synthesize tableView1 = _tableView1;
@synthesize tableView2 = _tableView2;
@synthesize tableView3 = _tableView3;
@synthesize tableView4 = _tableView4;
@synthesize tableView5 = _tableView5;
@synthesize tableView6 = _tableView6;

@synthesize labelList = _labelList;
@synthesize viewList = _viewList;
@synthesize tableViewList = _tableViewList;
@synthesize dataManagerList = _dataManagerList;
@synthesize firTableViewDataManager = _firTableViewDataManager;
@synthesize secTableViewDataManager = _secTableViewDataManager;
@synthesize thiTableViewDataManager = _thiTableViewDataManager;
@synthesize fouTableViewDataManager = _fouTableViewDataManager;
@synthesize fifTableViewDataManager = _fifTableViewDataManager;
@synthesize sixTableViewDataManager = _sixTableViewDataManager;
@synthesize sevTableViewDataManager = _sevTableViewDataManager;
@synthesize myIndexPath = _myIndexPath;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    for (UILabel* auxLabel in self.labelList) {
        for (UIGestureRecognizer* recognizer in auxLabel.gestureRecognizers) {
            [auxLabel removeGestureRecognizer:recognizer];
        }
    }
    for (UIView* auxView in self.viewList) {
        for (UIGestureRecognizer* recognizer in auxView.gestureRecognizers) {
            [auxView removeGestureRecognizer:recognizer];
        }
    }
    self.view0 = nil;
    self.view1 = nil;
    self.view2 = nil;
    self.view3 = nil;
    self.view4 = nil;
    self.view5 = nil;
    self.view6 = nil;
    
    self.label0 = nil;
    self.label1 = nil;
    self.label2 = nil;
    self.label3 = nil;
    self.label4 = nil;
    self.label5 = nil;
    self.label6 = nil;
    
    self.tableView0 = nil;
    self.tableView1 = nil;
    self.tableView2 = nil;
    self.tableView3 = nil;
    self.tableView4 = nil;
    self.tableView5 = nil;
    self.tableView6 = nil;
    
    self.labelList = nil;
    self.viewList = nil;
    self.tableViewList = nil;
    self.dataManagerList = nil;
    self.firTableViewDataManager = nil;
    self.secTableViewDataManager = nil;
    self.thiTableViewDataManager = nil;
    self.fouTableViewDataManager = nil;
    self.fifTableViewDataManager = nil;
    self.sixTableViewDataManager = nil;
    self.sevTableViewDataManager = nil;
    self.myIndexPath = nil;
    
    [super dealloc];
}

- (void)configCellWithData:(NSMutableDictionary*)aCellData {
    
}

- (void)createPopulatedLists {
    int countOfItems = 7;
    self.labelList = [NSMutableArray arrayWithCapacity:countOfItems];
    self.viewList = [NSMutableArray arrayWithCapacity:countOfItems];
    self.tableViewList = [NSMutableArray arrayWithCapacity:countOfItems];
    
    self.firTableViewDataManager = [[[ArcosCalendarCellBaseTableViewDataManager alloc] init] autorelease];
    self.secTableViewDataManager = [[[ArcosCalendarCellBaseTableViewDataManager alloc] init] autorelease];
    self.thiTableViewDataManager = [[[ArcosCalendarCellBaseTableViewDataManager alloc] init] autorelease];
    self.fouTableViewDataManager = [[[ArcosCalendarCellBaseTableViewDataManager alloc] init] autorelease];
    self.fifTableViewDataManager = [[[ArcosCalendarCellBaseTableViewDataManager alloc] init] autorelease];
    self.sixTableViewDataManager = [[[ArcosCalendarCellBaseTableViewDataManager alloc] init] autorelease];
    self.sevTableViewDataManager = [[[ArcosCalendarCellBaseTableViewDataManager alloc] init] autorelease];
    self.dataManagerList = [NSMutableArray arrayWithObjects:self.firTableViewDataManager, self.secTableViewDataManager, self.thiTableViewDataManager, self.fouTableViewDataManager, self.fifTableViewDataManager, self.sixTableViewDataManager, self.sevTableViewDataManager, nil];
    self.tableView0.dataSource = self.firTableViewDataManager;
    self.tableView0.delegate = self.firTableViewDataManager;
    self.tableView1.dataSource = self.secTableViewDataManager;
    self.tableView1.delegate = self.secTableViewDataManager;
    self.tableView2.dataSource = self.thiTableViewDataManager;
    self.tableView2.delegate = self.thiTableViewDataManager;
    self.tableView3.dataSource = self.fouTableViewDataManager;
    self.tableView3.delegate = self.fouTableViewDataManager;
    self.tableView4.dataSource = self.fifTableViewDataManager;
    self.tableView4.delegate = self.fifTableViewDataManager;
    self.tableView5.dataSource = self.sixTableViewDataManager;
    self.tableView5.delegate = self.sixTableViewDataManager;
    self.tableView6.dataSource = self.sevTableViewDataManager;
    self.tableView6.delegate = self.sevTableViewDataManager;
    
    
    
    @try {
        for (int i = 0; i < countOfItems; i++) {
            NSString* labelName = [NSString stringWithFormat:@"label%d", i];
            SEL labelSelector = NSSelectorFromString(labelName);
            [self.labelList addObject:[self performSelector:labelSelector]];
            NSString* viewName = [NSString stringWithFormat:@"view%d", i];
            SEL viewSelector = NSSelectorFromString(viewName);
            [self.viewList addObject:[self performSelector:viewSelector]];
            NSString* tableViewName = [NSString stringWithFormat:@"tableView%d", i];
            SEL tableViewSelector = NSSelectorFromString(tableViewName);
            [self.tableViewList addObject:[self performSelector:tableViewSelector]];
        }
    } @catch (NSException *exception) {
        NSLog(@"%@", [exception reason]);
    }
    for (UILabel* auxLabel in self.labelList) {
        for (UIGestureRecognizer* recognizer in auxLabel.gestureRecognizers) {
            [auxLabel removeGestureRecognizer:recognizer];
        }
        
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
        [auxLabel addGestureRecognizer:singleTap];
        
//        UILongPressGestureRecognizer* longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
//        longPress.minimumPressDuration = 1.0;
//        [auxLabel addGestureRecognizer:longPress];
//
//        [longPress release];
        [singleTap release];
    }
    for (UIView* auxView in self.viewList) {
        for (UIGestureRecognizer* recognizer in auxView.gestureRecognizers) {
            [auxView removeGestureRecognizer:recognizer];
        }
        UILongPressGestureRecognizer* longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
        longPress.minimumPressDuration = 1.0;
        [auxView addGestureRecognizer:longPress];
        [longPress release];
    }
}

- (void)handleSingleTapGesture:(UITapGestureRecognizer*)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        UILabel* tapLabel = (UILabel*)sender.view;
        [self.actionDelegate inputFinishedWithIndexPath:self.myIndexPath labelIndex:[ArcosUtils convertNSIntegerToInt:tapLabel.tag]];
    }
}

- (void)handleLongPressGesture:(UILongPressGestureRecognizer*)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        UIView* tapView = (UIView*)sender.view;
        [self.actionDelegate longInputFinishedWithIndexPath:self.myIndexPath sourceView:tapView];
    }
}

- (void)clearAllInfo {
    for (int i = 0; i < [self.labelList count]; i++) {
        UILabel* tmpLabel = [self.labelList objectAtIndex:i];
        tmpLabel.text = @"";
        tmpLabel.backgroundColor = [UIColor clearColor];
        tmpLabel.textColor = [UIColor blackColor];
        UIView* tmpView = [self.viewList objectAtIndex:i];
        tmpView.backgroundColor = [UIColor whiteColor];
        UITableView* tmpTableView = [self.tableViewList objectAtIndex:i];
        [tmpTableView reloadData];
    }
}

- (void)makeCellReadyToUse {
    [self createPopulatedLists];
    [self clearAllInfo];
}

@end
