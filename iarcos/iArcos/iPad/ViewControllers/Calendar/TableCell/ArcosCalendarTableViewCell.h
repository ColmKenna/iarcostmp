//
//  ArcosCalendarTableViewCell.h
//  iArcos
//
//  Created by Richard on 21/03/2022.
//  Copyright © 2022 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArcosCalendarCellBaseTableViewDataManager.h"
#import "ArcosCalendarTableViewCellDelegate.h"

@interface ArcosCalendarTableViewCell : UITableViewCell {
    id<ArcosCalendarTableViewCellDelegate> _actionDelegate;
    UIView* _view0;
    UIView* _view1;
    UIView* _view2;
    UIView* _view3;
    UIView* _view4;
    UIView* _view5;
    UIView* _view6;
    
    UILabel* _label0;
    UILabel* _label1;
    UILabel* _label2;
    UILabel* _label3;
    UILabel* _label4;
    UILabel* _label5;
    UILabel* _label6;
    
    UITableView* _tableView0;
    UITableView* _tableView1;
    UITableView* _tableView2;
    UITableView* _tableView3;
    UITableView* _tableView4;
    UITableView* _tableView5;
    UITableView* _tableView6;
    
    NSMutableArray* _labelList;
    NSMutableArray* _viewList;
    NSMutableArray* _tableViewList;
    
    NSMutableArray* _dataManagerList;
    ArcosCalendarCellBaseTableViewDataManager* _firTableViewDataManager;
    ArcosCalendarCellBaseTableViewDataManager* _secTableViewDataManager;
    ArcosCalendarCellBaseTableViewDataManager* _thiTableViewDataManager;
    ArcosCalendarCellBaseTableViewDataManager* _fouTableViewDataManager;
    ArcosCalendarCellBaseTableViewDataManager* _fifTableViewDataManager;
    ArcosCalendarCellBaseTableViewDataManager* _sixTableViewDataManager;
    ArcosCalendarCellBaseTableViewDataManager* _sevTableViewDataManager;
    NSIndexPath* _myIndexPath;
    
    UIButton* _btn0;
    UIButton* _btn01;
    UIButton* _btn1;
    UIButton* _btn11;
    UIButton* _btn2;
    UIButton* _btn21;
    UIButton* _btn3;
    UIButton* _btn31;
    UIButton* _btn4;
    UIButton* _btn41;
    UIButton* _btn5;
    UIButton* _btn51;
    UIButton* _btn6;
    UIButton* _btn61;
    NSMutableArray* _btnList;
    
}

@property(nonatomic, assign) id<ArcosCalendarTableViewCellDelegate> actionDelegate;
@property(nonatomic, retain) IBOutlet UIView* view0;
@property(nonatomic, retain) IBOutlet UIView* view1;
@property(nonatomic, retain) IBOutlet UIView* view2;
@property(nonatomic, retain) IBOutlet UIView* view3;
@property(nonatomic, retain) IBOutlet UIView* view4;
@property(nonatomic, retain) IBOutlet UIView* view5;
@property(nonatomic, retain) IBOutlet UIView* view6;

@property(nonatomic, retain) IBOutlet UILabel* label0;
@property(nonatomic, retain) IBOutlet UILabel* label1;
@property(nonatomic, retain) IBOutlet UILabel* label2;
@property(nonatomic, retain) IBOutlet UILabel* label3;
@property(nonatomic, retain) IBOutlet UILabel* label4;
@property(nonatomic, retain) IBOutlet UILabel* label5;
@property(nonatomic, retain) IBOutlet UILabel* label6;

@property(nonatomic, retain) IBOutlet UITableView* tableView0;
@property(nonatomic, retain) IBOutlet UITableView* tableView1;
@property(nonatomic, retain) IBOutlet UITableView* tableView2;
@property(nonatomic, retain) IBOutlet UITableView* tableView3;
@property(nonatomic, retain) IBOutlet UITableView* tableView4;
@property(nonatomic, retain) IBOutlet UITableView* tableView5;
@property(nonatomic, retain) IBOutlet UITableView* tableView6;

@property(nonatomic, retain) NSMutableArray* labelList;
@property(nonatomic, retain) NSMutableArray* viewList;
@property(nonatomic, retain) NSMutableArray* tableViewList;
@property(nonatomic, retain) NSMutableArray* dataManagerList;
@property(nonatomic, retain) ArcosCalendarCellBaseTableViewDataManager* firTableViewDataManager;
@property(nonatomic, retain) ArcosCalendarCellBaseTableViewDataManager* secTableViewDataManager;
@property(nonatomic, retain) ArcosCalendarCellBaseTableViewDataManager* thiTableViewDataManager;
@property(nonatomic, retain) ArcosCalendarCellBaseTableViewDataManager* fouTableViewDataManager;
@property(nonatomic, retain) ArcosCalendarCellBaseTableViewDataManager* fifTableViewDataManager;
@property(nonatomic, retain) ArcosCalendarCellBaseTableViewDataManager* sixTableViewDataManager;
@property(nonatomic, retain) ArcosCalendarCellBaseTableViewDataManager* sevTableViewDataManager;
@property(nonatomic, retain) NSIndexPath* myIndexPath;

@property(nonatomic, retain) IBOutlet UIButton* btn0;
@property(nonatomic, retain) IBOutlet UIButton* btn01;
@property(nonatomic, retain) IBOutlet UIButton* btn1;
@property(nonatomic, retain) IBOutlet UIButton* btn11;
@property(nonatomic, retain) IBOutlet UIButton* btn2;
@property(nonatomic, retain) IBOutlet UIButton* btn21;
@property(nonatomic, retain) IBOutlet UIButton* btn3;
@property(nonatomic, retain) IBOutlet UIButton* btn31;
@property(nonatomic, retain) IBOutlet UIButton* btn4;
@property(nonatomic, retain) IBOutlet UIButton* btn41;
@property(nonatomic, retain) IBOutlet UIButton* btn5;
@property(nonatomic, retain) IBOutlet UIButton* btn51;
@property(nonatomic, retain) IBOutlet UIButton* btn6;
@property(nonatomic, retain) IBOutlet UIButton* btn61;
@property(nonatomic, retain) NSMutableArray* btnList;

- (void)configCellWithData:(NSMutableDictionary*)aCellData;
- (void)makeCellReadyToUse;

@end

