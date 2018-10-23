//
//  CustomerSurveyPreviewPhotoViewController.h
//  iArcos
//
//  Created by David Kilmartin on 27/04/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileCommon.h"
#import "CustomisePresentViewControllerDelegate.h"
#import "CustomerSurveyPreviewPhotoDelegate.h"
#import "ArcosUtils.h"
#import "GlobalSharedClass.h"
#import "CustomerPhotoDeleteActionViewController.h"
#import "CustomerSurveyPreviewDataManager.h"

@interface CustomerSurveyPreviewPhotoViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, CustomerPhotoDeleteActionViewControllerDelegate, UIScrollViewDelegate> {
    id<CustomisePresentViewControllerDelegate> _myDelegate;
    id<CustomerSurveyPreviewPhotoDelegate> _actionDelegate;
    UIImageView* _myImageView;
    NSString* _myFileNamesStr;
    NSIndexPath* _myIndexPath;
    UIBarButtonItem* _deleteBarButton;
    UIPopoverController* _trashPopover;
    UIScrollView* _myScrollView;
    NSMutableArray* _myFileNameList;
    CustomerSurveyPreviewDataManager* _customerSurveyPreviewDataManager;
}

@property(nonatomic, assign) id<CustomisePresentViewControllerDelegate> myDelegate;
@property(nonatomic, assign) id<CustomerSurveyPreviewPhotoDelegate> actionDelegate;
@property(nonatomic, retain) IBOutlet UIImageView* myImageView;
@property(nonatomic, retain) NSString* myFileNamesStr;
@property(nonatomic, retain) NSIndexPath* myIndexPath;
@property(nonatomic, retain) UIBarButtonItem* deleteBarButton;
@property(nonatomic,retain) UIPopoverController* trashPopover;
@property(nonatomic, retain) IBOutlet UIScrollView* myScrollView;
@property(nonatomic, retain) NSMutableArray* myFileNameList;
@property(nonatomic, retain) CustomerSurveyPreviewDataManager* customerSurveyPreviewDataManager;

@end
