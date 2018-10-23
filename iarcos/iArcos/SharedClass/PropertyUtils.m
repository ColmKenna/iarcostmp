//
//  PropertyUtils.m
//  Arcos
//
//  Created by David Kilmartin on 12/01/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "PropertyUtils.h"

@implementation PropertyUtils

/*
static const char * getPropertyType(objc_property_t property) {
    NSLog(@"versiona");
    const char *attributes = property_getAttributes(property);
//    printf("attributes=%s\n", attributes);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T' && attribute[1] != '@') {
            // it's a C primitive type:
 
//             if you want a list of what will be returned for these primitives, search online for
//             "objective-c" "Property Attribute Description Examples"
//             apple docs list plenty of examples of what you get for int "i", long "l", unsigned "I", struct, etc.            
 
            return (const char *)[[NSData dataWithBytes:(attribute + 1) length:strlen(attribute) - 1] bytes];
        }        
        else if (attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2) {
            // it's an ObjC id type:
            return "id";
        }
        else if (attribute[0] == 'T' && attribute[1] == '@') {
            // it's another ObjC object type:
            return (const char *)[[NSData dataWithBytes:(attribute + 3) length:strlen(attribute) - 4] bytes];
        }
    }
    return "";
}
*/

static const char *getPropertyType(objc_property_t property) {
    const char *attributes = property_getAttributes(property);
    //printf("attributes=%s\n", attributes);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T' && attribute[1] != '@') {
            // it's a C primitive type:
            
//             if you want a list of what will be returned for these primitives, search online for
//             "objective-c" "Property Attribute Description Examples"
//             apple docs list plenty of examples of what you get for int "i", long "l", unsigned "I", struct, etc.
            
            NSString *name = [[NSString alloc] initWithBytes:attribute + 1 length:strlen(attribute) - 1 encoding:NSASCIIStringEncoding];
            return (const char *)[name cStringUsingEncoding:NSASCIIStringEncoding];
        }
        else if (attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2) {
            // it's an ObjC id type:
            return "id";
        }
        else if (attribute[0] == 'T' && attribute[1] == '@') {
            // it's another ObjC object type:
            NSString *name = [[NSString alloc] initWithBytes:attribute + 3 length:strlen(attribute) - 4 encoding:NSASCIIStringEncoding];
            return (const char *)[name cStringUsingEncoding:NSASCIIStringEncoding];
        }
    }
    return "";
}

+ (NSDictionary *)classPropsFor:(Class)klass
{    
    if (klass == NULL) {
        return nil;
    }
    
    NSMutableDictionary *results = [[[NSMutableDictionary alloc] init] autorelease];
    
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(klass, &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        if(propName) {
            const char *propType = getPropertyType(property);
            NSString *propertyName = [NSString stringWithUTF8String:propName];
            NSString *propertyType = [NSString stringWithUTF8String:propType];
            [results setObject:propertyType forKey:propertyName];
        }
    }
    free(properties);
    
    // returning a copy here to make sure the dictionary is immutable
    return [NSDictionary dictionaryWithDictionary:results];
}

//just for location at this moment
+ (void)updateRecord:(id)tableNameObj fieldName:(NSString*)aFieldName fieldValue:(NSString*)aFieldValue propDict:(NSDictionary*)aPropsDict {
    NSString* propertyType = @"";
    NSArray* allKeyList = [aPropsDict allKeys];
    bool isFound = false;
    for (int i = 0; i < [allKeyList count]; i++) {
        NSString* aKey = [allKeyList objectAtIndex:i];
        if ([aKey caseInsensitiveCompare:aFieldName] == NSOrderedSame)  {
            aFieldName = aKey;
            propertyType = [aPropsDict objectForKey:aKey];
            isFound = true;
            break;
        }
    }
    if (!isFound) {
        NSLog(@"Core Data field name is incompatible with the one which is %@ in the server.", aFieldName);
        return;
    }
    NSString* methodName = [NSString stringWithFormat:@"set%@:", aFieldName];
//    NSLog(@"methodName is %@, %@", propertyType, methodName);
    SEL selector = NSSelectorFromString(methodName);        
    
    if ([propertyType isEqualToString:@"NSNumber"]) {
        [tableNameObj performSelector:selector withObject:[ArcosUtils convertStringToNumber:aFieldValue]];
    } else if ([propertyType isEqualToString:@"NSString"]) {
        [tableNameObj performSelector:selector withObject:aFieldValue];
    }
    
}

@end
