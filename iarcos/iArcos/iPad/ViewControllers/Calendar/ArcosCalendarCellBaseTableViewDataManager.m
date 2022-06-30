//
//  ArcosCalendarCellBaseTableViewDataManager.m
//  iArcos
//
//  Created by Richard on 09/04/2022.
//  Copyright © 2022 Strata IT Limited. All rights reserved.
//

#import "ArcosCalendarCellBaseTableViewDataManager.h"

@implementation ArcosCalendarCellBaseTableViewDataManager
@synthesize actionDelegate = _actionDelegate;
@synthesize displayList = _displayList;
@synthesize weekOfMonthIndexPath = _weekOfMonthIndexPath;
@synthesize weekdaySeqIndex = _weekdaySeqIndex;

- (void)dealloc {
    self.displayList = nil;
    self.weekOfMonthIndexPath = nil;
    
    [super dealloc];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.displayList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 22;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* CellIdentifier = @"IdArcosCalendarEventEntryTableViewCell";
    
    ArcosCalendarEventEntryTableViewCell* cell = (ArcosCalendarEventEntryTableViewCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"ArcosCalendarEventEntryTableViewCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[ArcosCalendarEventEntryTableViewCell class]] && [[(ArcosCalendarEventEntryTableViewCell*)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell = (ArcosCalendarEventEntryTableViewCell*)nibItem;
            }
        }
    }
    
    // Configure the cell...
    cell.myIndexPath = indexPath;
    cell.actionDelegate = self;
    NSMutableDictionary* cellData = [self.displayList objectAtIndex:indexPath.row];
    [cell configCellWithData:cellData];
    
    return cell;
}

#pragma mark - ArcosCalendarEventEntryTableViewCellDelegate
- (void)eventEntryInputFinishedWithIndexPath:(NSIndexPath *)anIndexPath sourceView:(UIView *)aView {
    [self.actionDelegate eventEntryInputFinishedWithIndexPath:anIndexPath dataList:self.displayList sourceView:aView];
}

@end
