//
//  DownloadedOrderPadViewController.h
//  iArcos
//
//  Created by Colm Kenna on 18/04/2025.
//  Copyright © 2025 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DownloadedOrderPadViewController : UIViewController

@property (nonatomic, weak) IBOutlet UILabel *wipLabel;

- (void)cancelButtonTapped:(id)sender;
- (void)downloadButtonTapped:(id)sender;

@end

NS_ASSUME_NONNULL_END
