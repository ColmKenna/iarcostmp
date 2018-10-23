//
//  CustomerMasterTabBarItemTableCell.h
//  iArcos
//
//  Created by David Kilmartin on 19/09/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomerMasterTabBarItemTableCell : UITableViewCell {
    
    UIButton* _tabItemButton;
    UILabel* _tabItemTitleLabel;
    UIView* _auxView;
    UIView* _dividerView;
    int _clickTimes;
    NSString* _myImageFile;
    NSIndexPath* _indexPath;
    UIImage* _mySelectedImage;
    UIImage* _myUnSelectedImage;
//    BOOL _isImageCalculated;
    UIViewController* _myCustomController;
}

@property(nonatomic, retain) IBOutlet UIButton* tabItemButton;
@property(nonatomic, retain) IBOutlet UILabel* tabItemTitleLabel;
@property(nonatomic, retain) IBOutlet UIView* auxView;
@property(nonatomic, retain) IBOutlet UIView* dividerView;
@property(nonatomic, assign) int clickTimes;
@property(nonatomic, retain) NSString* myImageFile;
@property(nonatomic, retain) NSIndexPath* indexPath;
@property(nonatomic, retain) UIImage* mySelectedImage;
@property(nonatomic, retain) UIImage* myUnSelectedImage;
//@property(nonatomic, assign) BOOL isImageCalculated;
@property(nonatomic, retain) UIViewController* myCustomController;

- (void)configCellWithData:(NSMutableDictionary*)theData currentIndexPath:(NSIndexPath*)aCurrentIndexPath;
- (void)selectedImageProcessor;
- (void)unSelectedImageProcessor;
- (void)handleSingleTapGesture;

@end
