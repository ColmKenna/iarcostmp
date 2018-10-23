//
//  SettingTableCellFactory.m
//  Arcos
//
//  Created by David Kilmartin on 05/09/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "SettingTableCellFactory.h"

@interface SettingTableCellFactory (Private)

-(SettingInputCell*)getCellWithIdentifier:(NSString*)idendifier;
@end

@implementation SettingTableCellFactory
+(id)factory{
    return [[[self alloc]init]autorelease];
}
-(NSString*)identifierWithData:(NSMutableDictionary*)data{
    NSNumber* settingType=[data objectForKey:@"SettingType"];
    if (data==nil) {
        return nil;
    }
    if (settingType==nil) {
        return nil;
    }
    NSString* identifier=nil;
    switch ([settingType intValue]) {
        case 0:
            identifier=@"SettingStringInputCell";
            break;
        case 1:
            identifier=@"SettingNumberInputCell";
            break;
        case 2:
            identifier=@"SettingSwitchInputCell";
            break;
        case 3:
            identifier=@"SettingSelectionInputCell";
            break;
        default:
            identifier=@"SettingStringInputCell";
            break;
    }
    
    return identifier;
}
-(SettingInputCell*)createSettingInputCellWithData:(NSMutableDictionary*)data{
    NSNumber* settingType=[data objectForKey:@"SettingType"];
    if (data==nil) {
        return nil;
    }
    if (settingType==nil) {
        return nil;
    }
    SettingInputCell* cell=nil;
    switch ([settingType intValue]) {
        case 0:
            cell=[self createStirngInputCell];
            break;
        case 1:
            cell=[self createNumberInputCell];
            break;
        case 2:
            cell=[self createSwithInputCell];
            break;
        case 3:
            cell=[self createSelectionInputCell];
            break;
        default:
            cell=[self createStirngInputCell];
            break;
    }
    
    return cell;
}
-(SettingInputCell*)createStirngInputCell{
    return [self getCellWithIdentifier:@"SettingStringInputCell"];
}
-(SettingInputCell*)createNumberInputCell{
    return [self getCellWithIdentifier:@"SettingNumberInputCell"];
}
-(SettingInputCell*)createSwithInputCell{
    return [self getCellWithIdentifier:@"SettingSwitchInputCell"];
}
-(SettingInputCell*)createSelectionInputCell{
    return [self getCellWithIdentifier:@"SettingSelectionInputCell"];
}

-(UITableViewCell*)getCellWithIdentifier:(NSString*)idendifier{
    UITableViewCell* cell=nil;
    
    NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"SettingTableViewCells" owner:self options:nil];
    
    for (id nibItem in nibContents) {
        //swith between editable and none editable order product cell
        if ([nibItem isKindOfClass:[UITableViewCell class]] && [[(UITableViewCell *)nibItem reuseIdentifier] isEqualToString: idendifier]) {
            cell= (UITableViewCell *) nibItem;
            //add taps
//            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
//            [cell.contentView addGestureRecognizer:singleTap];
//            
//            UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapGesture:)];
//            doubleTap.numberOfTapsRequired = 2;
//            [cell.contentView  addGestureRecognizer:doubleTap];
//            [singleTap requireGestureRecognizerToFail:doubleTap];
//            
//            [doubleTap release];
            
        }    
        
    }
    
    return cell;
}

@end
