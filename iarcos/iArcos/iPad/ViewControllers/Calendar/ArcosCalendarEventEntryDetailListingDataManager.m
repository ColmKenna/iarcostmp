//
//  ArcosCalendarEventEntryDetailListingDataManager.m
//  iArcos
//
//  Created by Richard on 02/02/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import "ArcosCalendarEventEntryDetailListingDataManager.h"

@implementation ArcosCalendarEventEntryDetailListingDataManager
@synthesize journeyDictList = _journeyDictList;
@synthesize eventDictList = _eventDictList;
@synthesize displayList = _displayList;

- (void)dealloc {
    self.journeyDictList = nil;
    self.eventDictList = nil;
    self.displayList = nil;
    
    [super dealloc];
}

- (void)processDataListWithDateFormatText:(NSString*)aDateFormatText {
    self.displayList = [NSMutableArray arrayWithCapacity:([self.journeyDictList count] + [self.eventDictList count])];
    NSDate* beginDate = [ArcosUtils dateFromString:[NSString stringWithFormat:@"%@ 09:00:00", aDateFormatText] format:[GlobalSharedClass shared].datetimeFormat];
    for (int i = 0; i < [self.journeyDictList count]; i++) {
        NSDictionary* locationDict = [self.journeyDictList objectAtIndex:i];
        NSMutableDictionary* dataDict = [NSMutableDictionary dictionaryWithCapacity:2];
        [dataDict setObject:[ArcosUtils convertNilToEmpty:[locationDict objectForKey:@"Name"]] forKey:@"Name"];
        [dataDict setObject:[ArcosUtils addMinutes:i * 15 date:beginDate] forKey:@"Date"];
        [self.displayList addObject:dataDict];
    }
    
    for (int i = 0; i < [self.eventDictList count]; i++) {
        NSMutableDictionary* eventDict = [self.eventDictList objectAtIndex:i];
        NSMutableDictionary* dataDict = [NSMutableDictionary dictionaryWithCapacity:2];
        [dataDict setObject:[eventDict objectForKey:@"Subject"] forKey:@"Name"];
        [dataDict setObject:[eventDict objectForKey:@"StartDate"] forKey:@"Date"];
        [self.displayList addObject:dataDict];
    }
    if ([self.displayList count] > 1) {
        NSSortDescriptor* dateDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"Date" ascending:YES selector:@selector(compare:)] autorelease];
        [self.displayList sortUsingDescriptors:[NSArray arrayWithObjects:dateDescriptor, nil]];
    }
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 22;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.displayList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* CellIdentifier = @"IdArcosCalendarEventEntryDetailListingTableViewCell";
    
    ArcosCalendarEventEntryDetailListingTableViewCell* cell = (ArcosCalendarEventEntryDetailListingTableViewCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"ArcosCalendarEventEntryDetailListingTableViewCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[ArcosCalendarEventEntryDetailListingTableViewCell class]] && [[(ArcosCalendarEventEntryDetailListingTableViewCell*)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell = (ArcosCalendarEventEntryDetailListingTableViewCell*)nibItem;
            }
        }
    }
    
    // Configure the cell...
    NSMutableDictionary* cellData = [self.displayList objectAtIndex:indexPath.row];
    [cell configCellWithData:cellData];
    
    return cell;
}


@end
