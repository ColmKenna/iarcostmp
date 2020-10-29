//
//  DetailingMainTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 05/10/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailingTableCell.h"
#import <QuartzCore/QuartzCore.h>
#import "WidgetFactory.h"
#import "ArcosConfigDataManager.h"

@interface DetailingMainTableCell : DetailingTableCell<WidgetFactoryDelegate,UIPopoverControllerDelegate,UITextViewDelegate> {
    UILabel* OrderDate;
    IBOutlet UILabel* CallType;
    IBOutlet UILabel* Contact;
    IBOutlet UITextView* Memo;
    
    NSInteger currentLabelIndex;

    //widget factory
    WidgetFactory* factory;
    UIPopoverController* _thePopover;
    
    UILabel* _orderDateTitle;
    UILabel* _callTypeTitle;
    UILabel* _contactTitle;
    UILabel* _memoTitle;
    
    //cell data
    //NSMutableDictionary* cellData;
    UILabel* _dueDateTitle;
    UILabel* _taskTypeTitle;
    UILabel* _employeeTitle;
    UILabel* _detailsTitle;
    
    UILabel* _dueDateContent;
    UILabel* _taskTypeContent;
    UILabel* _employeeContent;
    UITextView* _detailsContent;
    NSMutableArray* _secondFieldList;
    NSMutableArray* _thirdFieldList;
    NSMutableArray* _fourthFieldList;
    
    UITextView* _previousMemo;
}
@property(nonatomic,retain) IBOutlet UILabel* OrderDate;
@property(nonatomic,retain) IBOutlet UILabel* CallType;
@property(nonatomic,retain) IBOutlet UILabel* Contact;
@property(nonatomic,retain) IBOutlet UITextView* Memo;
@property(nonatomic,retain)    WidgetFactory* factory;
@property(nonatomic,retain) UIPopoverController* thePopover;
//@property(nonatomic,retain) NSMutableDictionary* cellData;

@property(nonatomic,retain) IBOutlet UILabel* orderDateTitle;
@property(nonatomic,retain) IBOutlet UILabel* callTypeTitle;
@property(nonatomic,retain) IBOutlet UILabel* contactTitle;
@property(nonatomic,retain) IBOutlet UILabel* memoTitle;

@property(nonatomic,retain) IBOutlet UILabel* dueDateTitle;
@property(nonatomic,retain) IBOutlet UILabel* taskTypeTitle;
@property(nonatomic,retain) IBOutlet UILabel* employeeTitle;
@property(nonatomic,retain) IBOutlet UILabel* detailsTitle;

@property(nonatomic,retain) IBOutlet UILabel* dueDateContent;
@property(nonatomic,retain) IBOutlet UILabel* taskTypeContent;
@property(nonatomic,retain) IBOutlet UILabel* employeeContent;
@property(nonatomic,retain) IBOutlet UITextView* detailsContent;

@property(nonatomic,retain) NSMutableArray* secondFieldList;
@property(nonatomic,retain) NSMutableArray* thirdFieldList;
@property(nonatomic,retain) NSMutableArray* fourthFieldList;
@property(nonatomic,retain) IBOutlet UITextView* previousMemo;

-(IBAction)memoInput:(id)sender;

@end
