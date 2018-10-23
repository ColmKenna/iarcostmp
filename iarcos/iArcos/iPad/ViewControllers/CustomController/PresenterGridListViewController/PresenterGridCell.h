//
//  PresenterGridCell.h
//  Arcos
//
//  Created by David Kilmartin on 12/08/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PresenterGridCellDelegate;


@interface PresenterGridCell : UITableViewCell {
    
    IBOutlet UIButton* but1;
    IBOutlet UIButton* but2;
    IBOutlet UIButton* but3;
    IBOutlet UIButton* but4;
    IBOutlet UIButton* but5;

    IBOutlet UILabel* lab1;
    IBOutlet UILabel* lab2;
    IBOutlet UILabel* lab3;
    IBOutlet UILabel* lab4;
    IBOutlet UILabel* lab5;
    id<PresenterGridCellDelegate>delegate;
    //
    NSMutableArray* buttons;
    NSMutableArray* labels;
}
@property(nonatomic,retain)  IBOutlet UIButton* but1;
@property(nonatomic,retain)  IBOutlet UIButton* but2;
@property(nonatomic,retain)  IBOutlet UIButton* but3;
@property(nonatomic,retain)  IBOutlet UIButton* but4;
@property(nonatomic,retain)  IBOutlet UIButton* but5;

@property(nonatomic,retain)  IBOutlet UILabel* lab1;
@property(nonatomic,retain)  IBOutlet UILabel* lab2;
@property(nonatomic,retain)  IBOutlet UILabel* lab3;
@property(nonatomic,retain)  IBOutlet UILabel* lab4;
@property(nonatomic,retain)  IBOutlet UILabel* lab5;



@property(nonatomic,retain)    id<PresenterGridCellDelegate>delegate;


@property(nonatomic,retain) NSMutableArray* buttons;
@property(nonatomic,retain) NSMutableArray* labels;

-(IBAction)buttonAction:(id)sender;
-(void)fillOutletArray;
-(void)enableButtonAtIndex:(int)index enable:(BOOL)enable;
@end

@protocol PresenterGridCellDelegate
-(void)PresenterGridCell:(PresenterGridCell*)presenterGridCell buttonTouched:(UIButton*)button;
@end