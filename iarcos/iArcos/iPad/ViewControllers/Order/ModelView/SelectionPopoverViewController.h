//
//  SelectionPopoverViewController.h
//  Arcos
//
//  Created by David Kilmartin on 18/07/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectionPopoverDelegate 

@optional
-(void)showTotalOfSelections;
-(void)showOnlySelectionItems;
-(void)clearAllSelections;
@end

@interface SelectionPopoverViewController : UIViewController {
    id <SelectionPopoverDelegate> delegate;
    
    IBOutlet UIButton* totalBut;
    IBOutlet UIButton* showBut;
    IBOutlet UIButton* clearBut;

}
@property(nonatomic,retain)id <SelectionPopoverDelegate> delegate;

@property(nonatomic,retain) IBOutlet UIButton* totalBut;
@property(nonatomic,retain) IBOutlet UIButton* showBut;
@property(nonatomic,retain) IBOutlet UIButton* clearBut;

-(IBAction)buttonPressed:(id)sender;
@end
