//
//  DownloadedOrderPadViewController.m
//  iArcos
//
//  Created by Colm Kenna on 18/04/2025.
//  Copyright © 2025 Strata IT Limited. All rights reserved.
//

#import "DownloadedOrderPadViewController.h"
#import <UIKit/UIKit.h>
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>
#import <MobileCoreServices/MobileCoreServices.h>


@interface DownloadedOrderPadViewController ()

@end

@implementation DownloadedOrderPadViewController

@synthesize wipLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // Add Cancel and Download buttons to navigation bar
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Download" style:UIBarButtonItemStyleDone target:self action:@selector(downloadButtonTapped:)];
}

- (void)cancelButtonTapped:(id)sender {
    if (self.popoverPresentationController) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)downloadButtonTapped:(id)sender {
    // Present a file selector (UIDocumentPickerViewController) for importing only .xls, .xlsx, and .csv files
    UIDocumentPickerViewController *documentPicker;
    NSArray *types = @[@"com.microsoft.excel.xls", @"org.openxmlformats.spreadsheetml.sheet", @"public.comma-separated-values-text"];
    documentPicker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:types inMode:UIDocumentPickerModeImport];
    documentPicker.delegate = self;
    documentPicker.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:documentPicker animated:YES completion:nil];
}

#pragma mark - UIDocumentPickerDelegate

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls {
    if (urls.count > 0) {
        NSURL *fileURL = urls.firstObject;
        self.wipLabel.text = fileURL.lastPathComponent;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
