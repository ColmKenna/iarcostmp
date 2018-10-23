//
//  PresenterEbookViewController.m
//  iArcos
//
//  Created by David Kilmartin on 23/02/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import "PresenterEbookViewController.h"

@interface PresenterEbookViewController ()

@end

@implementation PresenterEbookViewController
@synthesize ebookBarButton = _ebookBarButton;
@synthesize docInteractionController = _docInteractionController;
@synthesize filePath = _filePath;
@synthesize fileURL = _fileURL;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.view.backgroundColor = [UIColor colorWithRed:211.0/255.0 green:215.0/255.0 blue:221.0/255.0 alpha:1.0];
    
    self.ebookBarButton = [[[UIBarButtonItem alloc] initWithTitle:@"eBook" style:UIBarButtonItemStylePlain target:self action:@selector(ebookButtonPressed)] autorelease];
    NSMutableArray* rightButtonList = [NSMutableArray arrayWithArray:self.navigationItem.rightBarButtonItems];
    [rightButtonList addObject:self.ebookBarButton];
    self.navigationItem.rightBarButtonItems = rightButtonList;
    NSString* fileName = @"";
    for (NSMutableDictionary* dict in self.files) {
        fileName = [dict objectForKey:@"Name"];
        self.currentFile = dict;
    }
    self.title = fileName;
    self.filePath = [NSString stringWithFormat:@"%@/%@", [FileCommon presenterPath], [self.currentFile objectForKey:@"Name"]];
    
    if (![FileCommon fileExistAtPath:self.filePath]) {
        fileDownloadCenter.delegate = self;
        [fileDownloadCenter addFileWithName:fileName];
        [fileDownloadCenter startDownload];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.ebookBarButton = nil;
    self.docInteractionController = nil;
    self.filePath = nil;
    self.fileURL = nil;
    
    [super dealloc];
}

- (void)ebookButtonPressed {
    self.fileURL = [NSURL fileURLWithPath:self.filePath];
    self.docInteractionController = [UIDocumentInteractionController interactionControllerWithURL:self.fileURL];
    self.docInteractionController.delegate = self;
    [self.docInteractionController presentOptionsMenuFromBarButtonItem:self.ebookBarButton animated:YES];
    if (![[ArcosConfigDataManager sharedArcosConfigDataManager] recordPresenterTransactionFlag] || self.presenterRequestSource == PresenterRequestSourceMainMenu) return;
    self.recordBeginDate = [NSDate date];
}

- (void)documentInteractionControllerDidDismissOptionsMenu:(UIDocumentInteractionController *)controller {
    self.docInteractionController = nil;
}

- (void)fileDownload:(FileCommon *)FC withError:(BOOL)error{
    
}
- (void)allFilesDownload{
    
}
- (void)didFailWithError:(NSError*)anError {
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    if (self.docInteractionController == nil) return;
    [self.docInteractionController presentOptionsMenuFromBarButtonItem:self.ebookBarButton animated:YES];
}



@end
