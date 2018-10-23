//
//  HumanReadableDataSizeHelper.m
//  Arcos
//
//  Created by David Kilmartin on 09/03/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "HumanReadableDataSizeHelper.h"

@implementation HumanReadableDataSizeHelper

+ (NSString *)humanReadableSizeFromBytes:(NSNumber *)sizeInBytes
{
    return [self humanReadableSizeFromBytes:sizeInBytes  useSiPrefixes:NO  useSiMultiplier:NO];
}


+ (NSString *)humanReadableSizeFromBytes:(NSNumber *)sizeInBytes  useSiPrefixes:(BOOL)useSiPrefixes  useSiMultiplier:(BOOL)useSiMultiplier
{
    NSString *unitSymbol = @"B";
    NSInteger multiplier;
    NSArray *prefixes;
    
    if (useSiPrefixes)
    {
        /*  SI prefixes
         http://en.wikipedia.org/wiki/Kilo-
         kilobyte   (kB)    10^3    
         megabyte   (MB)    10^6    
         gigabyte   (GB)    10^9    
         terabyte   (TB)    10^12   
         petabyte   (PB)    10^15   
         exabyte    (EB)    10^18   
         zettabyte  (ZB)    10^21   
         yottabyte  (YB)    10^24   
         */
        
        prefixes = [NSArray arrayWithObjects: @"", @"K", @"M", @"G", @"T", @"P", @"E", @"Z", @"Y", nil];
    }
    else
    {
        /*  Binary prefixes
         http://en.wikipedia.org/wiki/Binary_prefix
         kibibyte   (KiB)   2^10 = 1.024 × 10^3
         mebibyte   (MiB)   2^20 ≈ 1.049 × 10^6
         gibibyte   (GiB)   2^30 ≈ 1.074 × 10^9
         tebibyte   (TiB)   2^40 ≈ 1.100 × 10^12
         pebibyte   (PiB)   2^50 ≈ 1.126 × 10^15
         exbibyte   (EiB)   2^60 ≈ 1.153 × 10^18
         zebibyte   (ZiB)   2^70 ≈ 1.181 × 10^21
         yobibyte   (YiB)   2^80 ≈ 1.209 × 10^24
         */
        
        prefixes = [NSArray arrayWithObjects: @"", @"ki", @"Mi", @"Gi", @"Ti", @"Pi", @"Ei", @"Zi", @"Yi", nil];
    }
    
    if (useSiMultiplier)
    {
        multiplier = 1000;
    }
    else
    {
        multiplier = 1024;
    }
    
    NSInteger exponent = 0;
    double size = [sizeInBytes doubleValue];
    
    while ( (size >= multiplier) && (exponent < [prefixes count]) )
    {
        size /= multiplier;
        exponent++;
    }
    
    NSNumberFormatter* formatter = [[[NSNumberFormatter alloc] init] autorelease];
    [formatter setMaximumFractionDigits:2];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // Uses localized number formats.
    
    NSString *sizeInUnits = [formatter stringFromNumber:[NSNumber numberWithDouble:size]];
    
    return [NSString stringWithFormat:@"%@ %@%@", sizeInUnits, [prefixes objectAtIndex:exponent], unitSymbol];
}


@end
