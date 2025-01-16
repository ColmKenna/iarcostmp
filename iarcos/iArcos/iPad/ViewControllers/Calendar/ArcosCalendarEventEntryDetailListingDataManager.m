//
//  ArcosCalendarEventEntryDetailListingDataManager.m
//  iArcos
//
//  Created by Richard on 02/02/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import "ArcosCalendarEventEntryDetailListingDataManager.h"

@implementation ArcosCalendarEventEntryDetailListingDataManager
@synthesize actionDelegate = _actionDelegate;
@synthesize journeyDictList = _journeyDictList;
@synthesize eventDictList = _eventDictList;
@synthesize displayList = _displayList;
@synthesize barTitleContent = _barTitleContent;
@synthesize hideEditButtonFlag = _hideEditButtonFlag;
@synthesize detailingCalendarEventBoxListingDataManager = _detailingCalendarEventBoxListingDataManager;
@synthesize showBorderFlag = _showBorderFlag;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.hideEditButtonFlag = NO;
        self.detailingCalendarEventBoxListingDataManager = [[[DetailingCalendarEventBoxListingDataManager alloc] init] autorelease];
        self.detailingCalendarEventBoxListingDataManager.actionDelegate = self;
        self.showBorderFlag = NO;
    }
    return self;
}

- (void)dealloc {
    self.journeyDictList = nil;
    self.eventDictList = nil;
    self.displayList = nil;
    self.barTitleContent = nil;
    self.detailingCalendarEventBoxListingDataManager = nil;
    
    [super dealloc];
}
//deprecated
- (void)processDataListWithDateFormatText:(NSString*)aDateFormatText bodyCellType:(NSNumber*)aBodyCellType {
    self.displayList = [NSMutableArray arrayWithCapacity:([self.journeyDictList count] + [self.eventDictList count])];
    NSDate* beginDate = [ArcosUtils dateFromString:[NSString stringWithFormat:@"%@ 09:00:00", aDateFormatText] format:[GlobalSharedClass shared].datetimeFormat];
    int minutesInterval = 60;
    if ([self.journeyDictList count] > 9) {
        minutesInterval = 30;
    }
    for (int i = 0; i < [self.journeyDictList count]; i++) {
        NSDictionary* locationDict = [self.journeyDictList objectAtIndex:i];
        NSMutableDictionary* dataDict = [NSMutableDictionary dictionaryWithCapacity:2];
        [dataDict setObject:[ArcosUtils convertNilToEmpty:[locationDict objectForKey:@"Name"]] forKey:@"Name"];
        [dataDict setObject:[ArcosUtils addMinutes:i * minutesInterval date:beginDate] forKey:@"Date"];
        NSString* tmpAddress = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",[ArcosUtils convertNilToEmpty:[locationDict objectForKey:@"Address1"]], [ArcosUtils convertNilToEmpty:[locationDict objectForKey:@"Address2"]], [ArcosUtils convertNilToEmpty:[locationDict objectForKey:@"Address3"]], [ArcosUtils convertNilToEmpty:[locationDict objectForKey:@"Address4"]], [ArcosUtils convertNilToEmpty:[locationDict objectForKey:@"Address5"]]];
        [dataDict setObject:tmpAddress forKey:@"Address"];
        [dataDict setObject:[NSNumber numberWithInt:5] forKey:@"CellType"];
        [self.displayList addObject:dataDict];
    }
    
    for (int i = 0; i < [self.eventDictList count]; i++) {
        NSMutableDictionary* eventDict = [self.eventDictList objectAtIndex:i];
//        NSMutableDictionary* dataDict = [NSMutableDictionary dictionaryWithCapacity:2];
        NSMutableDictionary* dataDict = [NSMutableDictionary dictionaryWithDictionary:eventDict];
        NSString* subjectStr = [ArcosUtils convertNilToEmpty:[eventDict objectForKey:@"Subject"]];
        NSString* locationStr = [ArcosUtils convertNilToEmpty:[eventDict objectForKey:@"Location"]];
        [dataDict setObject:locationStr forKey:@"Name"];
        [dataDict setObject:[eventDict objectForKey:@"StartDate"] forKey:@"Date"];
        [dataDict setObject:subjectStr forKey:@"Subject"];
        [dataDict setObject:aBodyCellType forKey:@"CellType"];//[NSNumber numberWithInt:4]
        [dataDict setObject:[ArcosUtils convertNilToZero:[eventDict objectForKey:@"LocationIUR"]] forKey:@"LocationIUR"];
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
    cell.timeLabel.textColor = [UIColor blackColor];
    if ([[self.actionDelegate retrieveEventEntryDetailListingLocationIUR] intValue] != 0 && [[self.actionDelegate retrieveEventEntryDetailListingLocationIUR] isEqualToNumber:[cellData objectForKey:@"LocationIUR"]]) {
        cell.timeLabel.textColor = [UIColor blueColor];
    }
    
    return cell;
}

- (NSString*)retrieveCalendarURIWithStartDate:(NSString*)aStartDate endDate:(NSString*)anEndDate {
    return [NSString stringWithFormat:@"https://graph.microsoft.com/v1.0/me/calendarview?$select=id,subject,bodyPreview,start,end,location,isAllDay&$top=1000&startdatetime=%@&enddatetime=%@&$orderby=start/dateTime asc", aStartDate, anEndDate];
}

- (void)createTemplateListingDisplayListWithEventList:(NSArray*)anEventList {
    self.displayList = [NSMutableArray arrayWithCapacity:[anEventList count]];
    for (int i = 0; i < [anEventList count]; i++) {
        NSMutableDictionary* resultCellDataDict = [NSMutableDictionary dictionaryWithCapacity:2];
        NSDictionary* myCellData = [anEventList objectAtIndex:i];
        NSDictionary* myCellStartDict = [myCellData objectForKey:@"start"];
        NSString* myCellStartDateStr = [myCellStartDict objectForKey:@"dateTime"];
        NSDate* myCellStartDate = [ArcosUtils dateFromString:myCellStartDateStr format:[GlobalSharedClass shared].datetimeCalendarFormat];
        [resultCellDataDict setObject:[ArcosUtils convertNilDateToNull:myCellStartDate] forKey:@"Date"];
        
        NSString* subjectStr = [ArcosUtils convertNilToEmpty:[myCellData objectForKey:@"subject"]];
        NSDictionary* locationDict = [myCellData objectForKey:@"location"];
        NSString* locationStr = [ArcosUtils convertNilToEmpty:[locationDict objectForKey:@"displayName"]];
        
        [resultCellDataDict setObject:[ArcosUtils trim:[NSString stringWithFormat:@"%@ %@",subjectStr, locationStr]] forKey:@"Name"];
        NSNumber* myLocationIUR = [self retrieveLocationIURWithEventDict:myCellData];
        [resultCellDataDict setObject:[ArcosUtils convertNilToZero:myLocationIUR] forKey:@"LocationIUR"];
        [self.displayList addObject:resultCellDataDict];
    }
}

- (NSNumber*)retrieveLocationIURWithEventDict:(NSDictionary*)anEventDict {
    NSNumber* locationIUR = [NSNumber numberWithInt:0];
    NSDictionary* locationDict = [anEventDict objectForKey:@"location"];
    NSString* locationUriStr = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:[locationDict objectForKey:@"locationUri"]]];
    NSArray* locationUriChildArray = [locationUriStr componentsSeparatedByString:@":"];
    if ([locationUriChildArray count] == 2) {
        NSString* tmpLocationIURStr = [locationUriChildArray objectAtIndex:0];
        locationIUR = [ArcosUtils convertStringToNumber:tmpLocationIURStr];
    }
    return locationIUR;
}

#pragma mark - DetailingCalendarEventBoxListingDataManagerDelegate
- (NSNumber*)retrieveDetailingCalendarEventBoxListingDataManagerLocationIUR {
    return [self.actionDelegate retrieveEventEntryDetailListingLocationIUR];
}

- (NSNumber*)retrieveDetailingCalendarEventBoxListingLocationIURWithEventDict:(NSDictionary*)anEventDict {
    return [NSNumber numberWithInt:0];
}

- (void)doubleTapListingBodyLabelWithIndexPath:(NSIndexPath*)anIndexPath {
    
}

- (void)doubleTapListingBodyLabelForPopOutWithIndexPath:(NSIndexPath*)anIndexPath {
    [self.actionDelegate doubleTapEventEntryDetailListingWithIndexPath:anIndexPath];
}

- (void)longInputListingForPopOutFinishedWithIndexPath:(NSIndexPath*)anIndexPath {
    [self.actionDelegate longInputEventEntryDetailListingFinishedWithIndexPath:anIndexPath];
}

@end
