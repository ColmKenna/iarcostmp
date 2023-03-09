//
//  DetailingTableCellFactory.m
//  Arcos
//
//  Created by David Kilmartin on 05/10/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "DetailingTableCellFactory.h"
#import "ArcosConfigDataManager.h"
@interface DetailingTableCellFactory (Private)

-(DetailingTableCell*)getCellWithIdentifier:(NSString*)idendifier;
- (NSString*)retrievePIIdentifier;
@end

@implementation DetailingTableCellFactory
@synthesize actionType = _actionType;

- (void)dealloc {
    self.actionType = nil;
    
    [super dealloc];
}

+(id)factory{
    return [[[self alloc]init]autorelease];
}
-(DetailingTableCell*)createDetailingTableCellWithData:(NSMutableDictionary*)data{
    NSString* DetailLevel=[data objectForKey:@"DetailLevel"];
    if (DetailLevel==nil) {
        return nil;
    }
    
    if ([DetailLevel isEqualToString:@"MA"]) {
        return [self createMainTableCell];
    }else if ([DetailLevel isEqualToString:@"DT"]) {
        return [self createQATableCell];
    }else if ([DetailLevel isEqualToString:@"KM"]) {
        return [self createKMTableCell];
    }else if ([DetailLevel isEqualToString:@"SM"]) {
        return [self createSampleTableCell];
    }else if ([DetailLevel isEqualToString:@"RG"]) {
        return [self createGivenRequestTableCell];
    }else if ([DetailLevel isEqualToString:@"PS"] || [DetailLevel isEqualToString:@"MC"]) {
        return [self createPresenterTableCell];
    } else if ([DetailLevel isEqualToString:@"PPHEADER"]) {
        return [self createPresenterParentTableCell];
    } else if ([DetailLevel isEqualToString:@"PP"]) {
        return [self createPresentationsTableCell];
    }
    
    return nil;
}
-(DetailingTableCell*)createMainTableCell{
    return [self getCellWithIdentifier:@"DetailingMainTableCell"];
}
-(DetailingTableCell*)createQATableCell{
    return [self getCellWithIdentifier:@"DetailingQATableCell"];
}
-(DetailingTableCell*)createKMTableCell{
    return [self getCellWithIdentifier:@"DetailingKMTableCell"];
}
-(DetailingTableCell*)createSampleTableCell{
    return [self getCellWithIdentifier:@"DetailingSampleTableCell"];
}
-(DetailingTableCell*)createGivenRequestTableCell{
    return [self getCellWithIdentifier:[self retrievePIIdentifier]];
}
-(DetailingTableCell*)createPresenterTableCell {
    return [self getCellWithIdentifier:@"DetailingPSTableCell"];
}
-(DetailingTableCell*)createPresenterParentTableCell {
    return [self getCellWithIdentifier:@"IdDetailingPPHEADERTableCell"];
}
-(DetailingTableCell*)createPresentationsTableCell {
    return [self getCellWithIdentifier:@"IdDetailingPPTableCell"];
}
-(NSString*)identifierWithData:(NSMutableDictionary*)data{
    NSString* DetailLevel=[data objectForKey:@"DetailLevel"];
    if (DetailLevel==nil) {
        return nil;
    }
    
    if ([DetailLevel isEqualToString:@"MA"]) {
        return @"DetailingMainTableCell";
    }else if ([DetailLevel isEqualToString:@"DT"]) {
        return @"DetailingQATableCell";
    }else if ([DetailLevel isEqualToString:@"KM"]) {
        return @"DetailingKMTableCell";
    }else if ([DetailLevel isEqualToString:@"SM"]) {
        return @"DetailingSampleTableCell";
    }else if ([DetailLevel isEqualToString:@"RG"]) {
        return [self retrievePIIdentifier];
    }else if ([DetailLevel isEqualToString:@"PS"] || [DetailLevel isEqualToString:@"MC"]) {
        return @"DetailingPSTableCell";
    }else if ([DetailLevel isEqualToString:@"PP"]) {
        return @"IdDetailingPPTableCell";
    }else if ([DetailLevel isEqualToString:@"PPHEADER"]) {
        return @"IdDetailingPPHEADERTableCell";
    }
    
    return nil;
}

-(UITableViewCell*)getCellWithIdentifier:(NSString*)idendifier{
    UITableViewCell* cell=nil;
    
    NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"DetailingTableCells" owner:self options:nil];
    
    for (id nibItem in nibContents) {
        //swith between editable and none editable order product cell
        if ([nibItem isKindOfClass:[UITableViewCell class]] && [[(UITableViewCell *)nibItem reuseIdentifier] isEqualToString: idendifier]) {
            cell= (UITableViewCell *) nibItem;
            break;
        }    
        
    }
    
    return cell;
}

- (NSString*)retrievePIIdentifier {
    if ([self.actionType isEqualToString:@"create"]) {
        if ([[ArcosConfigDataManager sharedArcosConfigDataManager] recordPIRequestFlag] && [[ArcosConfigDataManager sharedArcosConfigDataManager] recordPIGivenFlag]) {
            return @"DetailingGivenRequestTableCell";
        }
        if ([[ArcosConfigDataManager sharedArcosConfigDataManager] recordPIRequestFlag]) {
            return @"DetailingRequestTableCell";
        }
        if ([[ArcosConfigDataManager sharedArcosConfigDataManager] recordPIGivenFlag]) {
            return @"DetailingGivenTableCell";
        }
    } else {
        return @"DetailingGivenRequestTableCell";
    }
    return @"DetailingGivenRequestTableCell";
}

@end
