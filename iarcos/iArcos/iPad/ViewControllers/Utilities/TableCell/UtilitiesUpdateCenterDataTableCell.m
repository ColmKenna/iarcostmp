//
//  UtilitiesUpdateCenterDataTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 03/12/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "UtilitiesUpdateCenterDataTableCell.h"

@implementation UtilitiesUpdateCenterDataTableCell
@synthesize icon = _icon;
@synthesize tableName = _tableName;
@synthesize downloadDate = _downloadDate;
@synthesize downloadModeName = _downloadModeName;
@synthesize tableRecordQty = _tableRecordQty;
@synthesize downloadRecordQty = _downloadRecordQty;
@synthesize indexPath = _indexPath;
@synthesize factory = _factory;
//@synthesize thePopover = _thePopover;
@synthesize globalWidgetViewController = _globalWidgetViewController;
@synthesize delegate = _delegate;
@synthesize sectionTitle = _sectionTitle;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    if (self.icon != nil) { self.icon = nil; }
    if (self.tableName != nil) { self.tableName = nil; }
    if (self.downloadDate != nil) { self.downloadDate = nil; }
    if (self.downloadModeName != nil) { self.downloadModeName = nil; }
    if (self.tableRecordQty != nil) { self.tableRecordQty = nil; }
    if (self.downloadRecordQty != nil) { self.downloadRecordQty = nil; }
    if (self.indexPath != nil) { self.indexPath = nil; }
    if (self.factory != nil) { self.factory = nil; }
//    self.thePopover = nil;
    self.globalWidgetViewController = nil;
//    if (self.delegate != nil) { self.delegate = nil; }
    self.sectionTitle = nil;
    
    [super dealloc];
}

-(void)configCellWithData:(NSMutableDictionary*)aCellData sectionTitle:(NSString*)aSectionTitle {
    self.sectionTitle = aSectionTitle;
    self.icon.image = [UIImage imageNamed:[aCellData objectForKey:@"ImageFileName"]];
    self.tableName.text = [aCellData objectForKey:@"TableName"];
//    NSLog(@"IsDownloaded is: %@", [aCellData objectForKey:@"IsDownloaded"]);
    if ([[aCellData objectForKey:@"IsDownloaded"] boolValue]) {
        self.downloadDate.text = [NSString stringWithFormat:@"Last %@ %@", aSectionTitle, [ArcosUtils stringFromDate:[aCellData objectForKey:@"DownloadDate"] format:@"dd/MM/yyyy"]];
    }    
    self.downloadModeName.text = [aCellData objectForKey:@"DownloadModeName"];
    self.tableRecordQty.text = [[aCellData objectForKey:@"TableRecordQty"] stringValue];
    self.downloadRecordQty.text = [[aCellData objectForKey:@"DownloadRecordQty"] stringValue];
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.contentView addGestureRecognizer:singleTap];
    [singleTap release];
}

-(void)handleSingleTapGesture:(id)sender {
    NSArray* downloadModeNames = [NSArray arrayWithObjects:@"FULL",@"PARTIAL",@"EXCLUDE", nil];
    NSArray* downloadModes = [NSArray arrayWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithInt:1], [NSNumber numberWithInt:2], nil];
    NSMutableArray* tableDataList = [NSMutableArray arrayWithCapacity:[downloadModeNames count]];
    for (int i = 0; i < [downloadModeNames count]; i++) {
        NSMutableDictionary* downloadModeDict = [NSMutableDictionary dictionaryWithCapacity:2];
        [downloadModeDict setObject:[downloadModeNames objectAtIndex:i] forKey:@"Title"];
        [downloadModeDict setObject:[downloadModes objectAtIndex:i] forKey:@"DownloadMode"];
        [tableDataList addObject:downloadModeDict];
    }
    
    if (self.factory == nil) {
        self.factory = [WidgetFactory factory];
        self.factory.delegate = self;
    }
    self.globalWidgetViewController = [self.factory CreateTableWidgetWithData:tableDataList withTitle:[NSString stringWithFormat:@"%@Mode",self.sectionTitle] withParentContentString:self.downloadModeName.text];
    
    //do show the popover if there is no data
    if (self.globalWidgetViewController != nil) {
//        self.thePopover.delegate = self;
//        [self.thePopover presentPopoverFromRect:self.downloadModeName.bounds inView:self.downloadModeName permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        self.globalWidgetViewController.modalPresentationStyle = UIModalPresentationPopover;
        self.globalWidgetViewController.popoverPresentationController.sourceView = self.downloadModeName;
        self.globalWidgetViewController.popoverPresentationController.sourceRect = self.downloadModeName.bounds;
        self.globalWidgetViewController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
        self.globalWidgetViewController.popoverPresentationController.delegate = self;
        [[self.delegate retrieveUtilitiesUpdateCenterParentViewController] presentViewController:self.globalWidgetViewController animated:YES completion:nil];
    }
}

-(void)operationDone:(id)data {
//    if (self.thePopover != nil) {
//        [self.thePopover dismissPopoverAnimated:YES];
//    }
    [[self.delegate retrieveUtilitiesUpdateCenterParentViewController] dismissViewControllerAnimated:YES completion:nil];
    self.downloadModeName.text = [data objectForKey:@"Title"];
    [self.delegate inputFinishedWithData:data forIndexpath:self.indexPath];
//    self.thePopover = nil;
//    self.factory.popoverController = nil;
    self.globalWidgetViewController = nil;
}

-(void)dismissPopoverController {
//    if (self.thePopover != nil) {
//        [self.thePopover dismissPopoverAnimated:YES];
//        self.thePopover = nil;
//        self.factory.popoverController = nil;
//    }
    [[self.delegate retrieveUtilitiesUpdateCenterParentViewController] dismissViewControllerAnimated:YES completion:^ {
        self.globalWidgetViewController = nil;
    }];
}
#pragma mark UIPopoverControllerDelegate
//- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
//    self.thePopover = nil;
//    self.factory.popoverController = nil;
//}
#pragma mark UIPopoverPresentationControllerDelegate
- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    self.globalWidgetViewController = nil;
}

@end
