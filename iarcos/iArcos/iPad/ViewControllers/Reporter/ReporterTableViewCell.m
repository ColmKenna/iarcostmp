//
//  ReporterTableViewCell.m
//  Arcos
//
//  Created by David Kilmartin on 06/02/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "ReporterTableViewCell.h"

@implementation ReporterTableViewCell
@synthesize mainButton = _mainButton;
@synthesize subBgImage = _subBgImage;
@synthesize dividerImage = _dividerImage;
//@synthesize mainImage;
@synthesize myDescription;
@synthesize extraDesc;
@synthesize title;
@synthesize bgImageView;
@synthesize startEndDateBgButton = _startEndDateBgButton;
@synthesize startDateLabel = _startDateLabel;
@synthesize endDateLabel = _endDateLabel;
@synthesize isEventSet = _isEventSet;
@synthesize thePopover = _thePopover;
@synthesize startDateTitleLabel = _startDateTitleLabel;
@synthesize endDateTitleLabel = _endDateTitleLabel;
@synthesize indexPath = _indexPath;
//@synthesize startDate = _startDate;
//@synthesize endDate = _endDate;
@synthesize dateDict = _dateDict;
@synthesize delegate = _delegate;
@synthesize locationBgButton = _locationBgButton;
@synthesize locationTitleLabel = _locationTitleLabel;
@synthesize locationLabel = _locationLabel;
@synthesize locationPopover = _locationPopover;
@synthesize locationList = _locationList;
@synthesize sortByTitleLabel = _sortByTitleLabel;
@synthesize sortByValueLabel = _sortByValueLabel;
@synthesize reporterHolder = _reporterHolder;
@synthesize widgetFactory = _widgetFactory;
@synthesize productTitleLabel = _productTitleLabel;
@synthesize productValueLabel = _productValueLabel;
@synthesize resProductIURList = _resProductIURList;
@synthesize resProductIURMap = _resProductIURMap;

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

- (void)dealloc
{
    self.mainButton = nil;
    self.subBgImage = nil;
    self.dividerImage = nil;
//    if (self.mainImage != nil) { self.mainImage = nil; }
    if (self.title != nil) { self.title = nil; }
    if (self.myDescription != nil) { self.myDescription = nil; }
    if (self.extraDesc != nil) { self.extraDesc = nil; }
    if (self.startEndDateBgButton != nil) { self.startEndDateBgButton = nil; }
    if (self.bgImageView != nil) { self.bgImageView = nil; }
    if (self.startDateLabel != nil) { self.startDateLabel = nil; }      
    if (self.endDateLabel != nil) { self.endDateLabel = nil; }
    if (self.thePopover != nil) { self.thePopover = nil; }
    if (self.startDateTitleLabel != nil) { self.startDateTitleLabel = nil; }
    if (self.endDateTitleLabel != nil) { self.endDateTitleLabel = nil; }
    if (self.indexPath != nil) { self.indexPath = nil; }
//    if (self.startDate != nil) { self.startDate = nil; }
//    if (self.endDate != nil) { self.endDate = nil; }
    if (self.dateDict != nil) { self.dateDict = nil; }
//    if (self.delegate != nil) { self.delegate = nil; }
    if (self.locationBgButton != nil) { self.locationBgButton = nil; }    
    if (self.locationTitleLabel != nil) { self.locationTitleLabel = nil; }
    if (self.locationLabel != nil) { self.locationLabel = nil; }
    if (self.locationPopover != nil) { self.locationPopover = nil; }
    if (self.locationList != nil) { self.locationList = nil; }
    self.sortByTitleLabel = nil;
    self.sortByValueLabel = nil;
    self.reporterHolder = nil;
    self.widgetFactory = nil;
    self.productTitleLabel = nil;
    self.productValueLabel = nil;
    self.resProductIURList = nil;
    self.resProductIURMap = nil;
    
    [super dealloc];
}

-(void)configCellWithData:(NSMutableDictionary*)aDateDict {
    self.dateDict = aDateDict;
    if (![[ArcosUtils trim:[ArcosUtils convertNilToEmpty:self.reporterHolder.Field15]] isEqualToString:@""]) {
        self.sortByTitleLabel.text = @"Sort By:";
        self.sortByValueLabel.text = [aDateDict objectForKey:@"SortBy"];
        for (UIGestureRecognizer* recognizer in self.sortByValueLabel.gestureRecognizers) {
            [self.sortByValueLabel removeGestureRecognizer:recognizer];
        }
        UITapGestureRecognizer* sortBySingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSortBySingleTapGesture:)];
        [self.sortByValueLabel addGestureRecognizer:sortBySingleTap];
        [sortBySingleTap release];
    } else {
        self.sortByTitleLabel.text = @"";
        self.sortByValueLabel.text = @"";
    }
    if (!self.isEventSet) {        
        UITapGestureRecognizer* startDateSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
        [self.startDateLabel addGestureRecognizer:startDateSingleTap];
        [startDateSingleTap release];
        UITapGestureRecognizer* endDateSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
        [self.endDateLabel addGestureRecognizer:endDateSingleTap];
        [endDateSingleTap release];
        UITapGestureRecognizer* locationSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleLocationSingleTapGesture:)];
        [self.locationLabel addGestureRecognizer:locationSingleTap];
        [locationSingleTap release];
        self.isEventSet = YES;
    }
    NSString* productsContent = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:self.reporterHolder.Field18]];
    NSArray* productIURList = [productsContent componentsSeparatedByString:@","];
    self.resProductIURList = [NSMutableArray arrayWithCapacity:[productIURList count]];
    self.resProductIURMap = [NSMutableDictionary dictionaryWithCapacity:[productIURList count]];
    if (![productsContent isEqualToString:@""]) {
        self.productTitleLabel.text = @"Product:";
        self.productValueLabel.text = @"";
        if ([productsContent isEqualToString:@"0"]) {
            self.productValueLabel.text = @"All";
        } else if ([productIURList count] == 1) {
            NSString* auxProductIURStr = [productIURList objectAtIndex:0];
            if ([ArcosValidator isInteger:auxProductIURStr]) {
                NSNumber* resProductIUR = [ArcosUtils convertStringToNumber:auxProductIURStr];
                if ([resProductIUR intValue] != 0) {
                    NSMutableArray* resProductList = [[ArcosCoreData sharedArcosCoreData] productWithIUR:resProductIUR withResultType:NSDictionaryResultType];
                    if ([resProductList count] > 0) {
                        NSDictionary* resProduct = [resProductList objectAtIndex:0];
                        self.productValueLabel.text = [resProduct objectForKey:@"Description"];
                        [self.resProductIURList addObject:resProductIUR];
                        [self.resProductIURMap setObject:resProductIUR forKey:resProductIUR];
                    }
                }
            }
        } else if ([productIURList count] > 1) {
            BOOL validFlag = YES;
            for (int i = 0; i < [productIURList count]; i++) {
                NSString* auxProductIURStr = [productIURList objectAtIndex:i];
                if (![ArcosValidator isInteger:auxProductIURStr]) {
                    validFlag = NO;
                    break;
                } else {
                    NSNumber* resProductIUR = [ArcosUtils convertStringToNumber:auxProductIURStr];
                    [self.resProductIURList addObject:resProductIUR];
                    [self.resProductIURMap setObject:resProductIUR forKey:resProductIUR];
                }
            }
            if (validFlag) {
                self.productValueLabel.text = @"Selected";
            } else {
                self.resProductIURList = [NSMutableArray arrayWithCapacity:[productIURList count]];
                self.resProductIURMap = [NSMutableDictionary dictionaryWithCapacity:[productIURList count]];
            }
        }
        for (UIGestureRecognizer* recognizer in self.productValueLabel.gestureRecognizers) {
            [self.productValueLabel removeGestureRecognizer:recognizer];
        }
        UITapGestureRecognizer* productSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleProductSingleTapGesture:)];
        [self.productValueLabel addGestureRecognizer:productSingleTap];
        [productSingleTap release];
    } else {
        self.productTitleLabel.text = @"";
        self.productValueLabel.text = @"";
    }
    if (![self.productValueLabel.text isEqualToString:@""] && ![self.productValueLabel.text isEqualToString:@"All"]) {
        self.title.text = [NSString stringWithFormat:@"%@ - %@", [self.reporterHolder Field6], self.productValueLabel.text];
    } else {
        self.title.text = [self.reporterHolder Field6];
    }
    if (self.thePopover != nil && ![self.thePopover isPopoverVisible]) {
        self.thePopover = nil;
    }
    if (self.locationPopover != nil && ![self.locationPopover isPopoverVisible]) {
        self.locationPopover = nil;
    }
}

- (void)handleProductSingleTapGesture:(id)sender {
    UITapGestureRecognizer* recognizer = (UITapGestureRecognizer*)sender;
    if (recognizer.state != UIGestureRecognizerStateEnded) return;
    ProductSelectionListingTableViewController* productSelectionListingTableViewController = [[ProductSelectionListingTableViewController alloc] initWithNibName:@"ProductSelectionListingTableViewController" bundle:nil];
    productSelectionListingTableViewController.actionDelegate = self;
    NSMutableArray* auxProductList = [productSelectionListingTableViewController.productSelectionListingDataManager retrieveActiveProductList];
    for (int i = 0; i < [auxProductList count]; i++) {
        NSMutableDictionary* auxProductDict = [auxProductList objectAtIndex:i];
        if ([self.resProductIURMap objectForKey:[auxProductDict objectForKey:@"ProductIUR"]] != nil) {
            [auxProductDict setObject:[NSNumber numberWithBool:YES] forKey:@"IsSelected"];
        }
    }
    [productSelectionListingTableViewController resetProduct:auxProductList];
    UINavigationController* tmpNavigationController = [[UINavigationController alloc] initWithRootViewController:productSelectionListingTableViewController];
    tmpNavigationController.preferredContentSize = CGSizeMake(700.0f, 700.0f);
    tmpNavigationController.modalPresentationStyle = UIModalPresentationPopover;
    tmpNavigationController.popoverPresentationController.sourceView = self.contentView;
    
    [[self.delegate retrieveReporterTableViewController] presentViewController:tmpNavigationController animated:YES completion:nil];
    [tmpNavigationController release];
    [productSelectionListingTableViewController release];
}

#pragma mark ProductSelectionListingDelegate
- (void)didDismissProductSelectionPopover {
    [[self.delegate retrieveReporterTableViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)didPressProductSaveButtonSelectionListing:(NSMutableArray*)aProductList {
    if ([aProductList count] == 0) {
        self.reporterHolder.Field18 = @"0";
        [self.delegate reloadReporterTableView];
        return;
    }
    NSMutableArray* tmpProductIURList = [NSMutableArray arrayWithCapacity:[aProductList count]];
    for (int i = 0; i < [aProductList count]; i++) {
        NSMutableDictionary* tmpProductDict = [aProductList objectAtIndex:i];
        [tmpProductIURList addObject:[tmpProductDict objectForKey:@"ProductIUR"]];
    }
    self.reporterHolder.Field18 = [tmpProductIURList componentsJoinedByString:@","];
    [self.delegate reloadReporterTableView];
}

- (void)didPressProductAllButton {
    self.reporterHolder.Field18 = @"0";
    [self.delegate reloadReporterTableView];
}

- (void)didShowErrorMsg:(NSString *)anErrorMsg {
    [ArcosUtils showDialogBox:anErrorMsg title:@"" delegate:nil target:[self.delegate retrieveReporterTableViewController] tag:0 handler:nil];
}

- (void)handleSortBySingleTapGesture:(id)sender {
    if (self.thePopover != nil) {
        self.thePopover = nil;
    }
    NSArray* sortByArray = [[ArcosUtils trim:[ArcosUtils convertNilToEmpty:self.reporterHolder.Field15]] componentsSeparatedByString:@"|"];
    NSMutableArray* pickerData = [NSMutableArray arrayWithCapacity:[sortByArray count]];
    for (int i = 0; i < [sortByArray count]; i++) {
        NSMutableDictionary* sortByDict = [NSMutableDictionary dictionaryWithCapacity:1];
        NSString* auxTitle = [sortByArray objectAtIndex:i];
        [sortByDict setObject:auxTitle forKey:@"Title"];
        [pickerData addObject:sortByDict];
    }
    if (self.widgetFactory == nil) {
        self.widgetFactory = [WidgetFactory factory];
        self.widgetFactory.delegate = self;
    }
    self.thePopover = [self.widgetFactory CreateGenericCategoryWidgetWithPickerValue:pickerData title:@"Sort By"];
    if (self.thePopover != nil) {
        self.thePopover.delegate = self;
        [self.thePopover presentPopoverFromRect:self.sortByValueLabel.bounds inView:self.sortByValueLabel permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

-(void)operationDone:(id)data {
    if (self.thePopover != nil) {
        [self.thePopover dismissPopoverAnimated:YES];
    }
    self.sortByValueLabel.text = [data objectForKey:@"Title"];
    [self.dateDict setObject:[data objectForKey:@"Title"] forKey:@"SortBy"];
    self.thePopover = nil;
    self.widgetFactory.popoverController = nil;
}

-(void)handleSingleTapGesture:(id)sender {
    if (self.thePopover != nil) {
        self.thePopover = nil;
    }
    TwoDatePickerWidgetViewController* TDPWVC = [[TwoDatePickerWidgetViewController alloc] initWithNibName:@"TwoDatePickerWidgetViewController" bundle:nil];
    TDPWVC.delegate = self;
    TDPWVC.startDate = [self.dateDict objectForKey:@"StartDate"];
    TDPWVC.endDate = [self.dateDict objectForKey:@"EndDate"];
    self.thePopover = [[[UIPopoverController alloc] initWithContentViewController:TDPWVC] autorelease];
    self.thePopover.popoverContentSize = CGSizeMake(328, 500);
    self.thePopover.delegate = self;
    [TDPWVC release];
    [self.thePopover presentPopoverFromRect:self.startDateLabel.bounds inView:self.startDateLabel permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}
#pragma mark TwoDatePickerWidgetDelegate
- (void)dateSelectedFromDate:(NSDate*)aStartDate ToDate:(NSDate*)anEndDate {
//    NSLog(@"dateSelectedFromDate: %@ %@", aStartDate, anEndDate);
    self.startDateLabel.text = [ArcosUtils stringFromDate:aStartDate format:[GlobalSharedClass shared].dateFormat];
    self.endDateLabel.text = [ArcosUtils stringFromDate:anEndDate format:[GlobalSharedClass shared].dateFormat];
    [self.delegate dateSelectedFromDate:aStartDate ToDate:anEndDate indexPath:self.indexPath];
    [self.thePopover dismissPopoverAnimated:YES];
    self.thePopover = nil;
}

- (void)handleLocationSingleTapGesture:(id)sender {
    if (self.locationPopover != nil) {
        self.locationPopover = nil;
    }    
    CustomerSelectionListingTableViewController* CSLTVC = [[CustomerSelectionListingTableViewController alloc] initWithNibName:@"CustomerSelectionListingTableViewController" bundle:nil];
    CSLTVC.selectionDelegate = self;
    CSLTVC.isNotShowingAllButton = NO;
    UINavigationController* tmpNavigationController = [[UINavigationController alloc] initWithRootViewController:CSLTVC];
    self.locationPopover = [[[UIPopoverController alloc] initWithContentViewController:tmpNavigationController] autorelease];    
    self.locationPopover.popoverContentSize = CGSizeMake(700, 700);
    self.locationPopover.delegate = self;
    [self.locationPopover presentPopoverFromRect:self.locationLabel.bounds inView:self.locationLabel permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    [CSLTVC resetCustomer:self.locationList];
    [CSLTVC release];
    CSLTVC = nil;
    [tmpNavigationController release];
    tmpNavigationController = nil;
}

#pragma mark CustomerSelectionListingDelegate
- (void)didDismissSelectionPopover {
    if (self.locationPopover != nil && [self.locationPopover isPopoverVisible]) {
        [self.locationPopover dismissPopoverAnimated:YES];
        self.locationPopover = nil;
    }    
}

- (void)didSelectCustomerSelectionListingRecord:(NSMutableDictionary*)aCustDict {
//    NSLog(@"aCustDict %@", aCustDict);
    self.locationLabel.text = [aCustDict objectForKey:@"Name"];
    [self.delegate didSelectCustomerSelectionListingRecord:aCustDict indexPath:self.indexPath];
    [self didDismissSelectionPopover];
}
#pragma mark UIPopoverControllerDelegate
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    self.locationPopover = nil;
    self.thePopover = nil;
}

@end
