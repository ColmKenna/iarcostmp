//
//  CheckLocationIURTemplateProcessor.h
//  iArcos
//
//  Created by David Kilmartin on 19/11/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalSharedClass.h"
#import "OrderSharedClass.h"
#import "ArcosCoreData.h"
#import "CheckLocationIURTemplateDelegate.h"

@interface CheckLocationIURTemplateProcessor : NSObject <UIAlertViewDelegate> {
    id<CheckLocationIURTemplateDelegate> _delegate;
    UIViewController* _myParentViewController;
    NSMutableArray* _candidateSubMenuItemList;
    int _rowPointer;
    NSIndexPath* _previewIndexPath;
}

@property(nonatomic, assign) id<CheckLocationIURTemplateDelegate> delegate;
@property(nonatomic, assign) UIViewController* myParentViewController;
@property(nonatomic, retain) NSMutableArray* candidateSubMenuItemList;
@property(nonatomic, assign) int rowPointer;
@property(nonatomic, retain) NSIndexPath* previewIndexPath;

- (id)initWithParentViewController:(UIViewController*)aParentViewController;
- (void)checkLocationIUR:(NSNumber*)aNewLocationIUR locationName:(NSString*)aNewLocationName indexPath:(NSIndexPath*)anIndexPath;


@end
