//
//  CustomerInfoLinkedToTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 05/05/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "CustomerInfoLinkedToTableViewCell.h"

@implementation CustomerInfoLinkedToTableViewCell
@synthesize actionDelegate = _actionDelegate;
@synthesize infoTitle = _infoTitle;
@synthesize infoValue = _infoValue;
@synthesize actionBtn = _actionBtn;
@synthesize cellData = _cellData;
@synthesize factory = _factory;
@synthesize thePopover = _thePopover;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.infoTitle = nil;
    self.infoValue = nil;
    self.actionBtn = nil;
    self.cellData = nil;
    self.factory = nil;
    self.thePopover = nil;
    
    [super dealloc];
}

- (void)configCellWithData:(NSMutableDictionary*)aCustDict {
    self.cellData = aCustDict;
    UIImage* anImage = [[ArcosCoreData sharedArcosCoreData] thumbWithIUR:[NSNumber numberWithInt:102]];
    if (anImage == nil) {
        anImage = [UIImage imageNamed:[GlobalSharedClass shared].defaultCellImageName];
    }
    [self.actionBtn setImage:anImage forState:UIControlStateNormal];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    NSArray* recognizerList = self.contentView.gestureRecognizers;
//    for (UITapGestureRecognizer* tmpRecognizer in recognizerList) {
//        if ([tmpRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
//            [self.contentView removeGestureRecognizer:tmpRecognizer];
//        }
//    }
//    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
//    [self.contentView addGestureRecognizer:singleTap];
//    [singleTap release];
}

//- (void)handleSingleTapGesture:(id)sender {
//    [self.actionDelegate selectCustomerInfoLinkedToRecord:self.infoValue];
//}

- (IBAction)showContactListPopover {
    if (self.factory == nil) {
        self.factory = [WidgetFactory factory];
        self.factory.delegate = self;
    }
    NSMutableArray* contactList = [[ArcosCoreData sharedArcosCoreData]orderContactsWithLocationIUR:[self.cellData objectForKey:@"LocationIUR"]];
    int removeIndex = -1;
    for (int i = 0; i < [contactList count]; i++) {
        NSMutableDictionary* tmpContactDict = [contactList objectAtIndex:i];
        if ([[tmpContactDict objectForKey:@"IUR"] isEqualToNumber:[GlobalSharedClass shared].currentSelectedContactIUR]) {
            removeIndex = i;
        }
    }
    if (removeIndex != -1) {
        [contactList removeObjectAtIndex:removeIndex];
    }
    [contactList insertObject:[[GlobalSharedClass shared] createUnAssignedContact] atIndex:0];
    NSMutableDictionary* miscDataDict = [NSMutableDictionary dictionaryWithCapacity:3];
    [miscDataDict setObject:@"Contact" forKey:@"Title"];
    [miscDataDict setObject:[self.cellData objectForKey:@"LocationIUR"] forKey:@"LocationIUR"];
    [miscDataDict setObject:[self.cellData objectForKey:@"Name"] forKey:@"Name"];
    self.thePopover =[self.factory CreateTargetGenericCategoryWidgetWithPickerValue:contactList miscDataDict:miscDataDict];
    //do show the popover if there is no data
    if (self.thePopover!=nil) {
        self.thePopover.delegate = self;
        [self.thePopover presentPopoverFromRect:self.actionBtn.bounds inView:self.actionBtn permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

-(void)operationDone:(id)data {
    if (self.thePopover != nil) {
        [self.thePopover dismissPopoverAnimated:YES];
    }
    [self.actionDelegate selectCustomerInfoLinkedToRecord:data];
    self.thePopover = nil;
    self.factory.popoverController = nil;
}

#pragma mark UIPopoverControllerDelegate
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    self.thePopover = nil;
    self.factory.popoverController = nil;
}

-(BOOL)allowToShowAddContactButton {
    return YES;
}


@end
