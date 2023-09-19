//
//  ArcosMemoryUtils.m
//  Arcos
//
//  Created by David Kilmartin on 14/12/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "ArcosMemoryUtils.h"
#import "ArcosUtils.h"

@implementation ArcosMemoryUtils

- (void)dealloc {
    [super dealloc];
}

- (void)print_free_memory {
    mach_port_t host_port;
    mach_msg_type_number_t host_size;
    vm_size_t pagesize;
    
    host_port = mach_host_self();
    host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    host_page_size(host_port, &pagesize);
    vm_statistics_data_t vm_stat;
    
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS)
        NSLog(@"Failed to fetch vm statistics");
    int myPageSize = 4096;
    /* Stats in bytes */ 
    natural_t mem_used = (vm_stat.active_count +
                          vm_stat.inactive_count +
                          vm_stat.wire_count) * (unsigned int)myPageSize;
    natural_t mem_free = vm_stat.free_count * (unsigned int)myPageSize;
    natural_t mem_total = mem_used + mem_free;
    NSLog(@"used: %u free: %u total: %u", mem_used, mem_free, mem_total);
    NSLog(@"used: %@ free: %@ total: %@", [HumanReadableDataSizeHelper humanReadableSizeFromBytes:[NSNumber numberWithLongLong:mem_used] useSiPrefixes:YES useSiMultiplier:NO], [HumanReadableDataSizeHelper humanReadableSizeFromBytes:[NSNumber numberWithLongLong:mem_free] useSiPrefixes:YES useSiMultiplier:NO], [HumanReadableDataSizeHelper humanReadableSizeFromBytes:[NSNumber numberWithLongLong:mem_total] useSiPrefixes:YES useSiMultiplier:NO]);
//    [ArcosUtils showMsg:[NSString stringWithFormat:@"used: %@ free: %@ total: %@", [HumanReadableDataSizeHelper humanReadableSizeFromBytes:[NSNumber numberWithLongLong:mem_used] useSiPrefixes:YES useSiMultiplier:NO], [HumanReadableDataSizeHelper humanReadableSizeFromBytes:[NSNumber numberWithLongLong:mem_free] useSiPrefixes:YES useSiMultiplier:NO], [HumanReadableDataSizeHelper humanReadableSizeFromBytes:[NSNumber numberWithLongLong:mem_total] useSiPrefixes:YES useSiMultiplier:NO]] delegate:nil];
}

- (NSMutableDictionary*)retrieveSystemMemory {
    NSMutableDictionary* memoryDict = [NSMutableDictionary dictionaryWithCapacity:6];
    mach_port_t host_port;
    mach_msg_type_number_t host_size;
    vm_size_t pagesize;
    
    host_port = mach_host_self();
    host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    host_page_size(host_port, &pagesize);
    
    vm_statistics_data_t vm_stat;
    
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) {
        NSLog(@"Failed to fetch vm statistics");
        return memoryDict;
    }
    int myPageSize = 4096;
    
    /* Stats in bytes */
    natural_t mem_used = (vm_stat.active_count +
                          vm_stat.inactive_count +
                          vm_stat.wire_count) * (unsigned int)myPageSize;
    natural_t mem_active = vm_stat.active_count * (unsigned int)myPageSize;
    natural_t mem_inactive = vm_stat.inactive_count * (unsigned int)myPageSize;
    natural_t mem_wired = vm_stat.wire_count * (unsigned int)myPageSize;
    natural_t mem_free = vm_stat.free_count * (unsigned int)myPageSize;
    natural_t mem_total = mem_used + mem_free;
    [memoryDict setObject:[HumanReadableDataSizeHelper humanReadableSizeFromBytes:[NSNumber numberWithLongLong:mem_active] useSiPrefixes:YES useSiMultiplier:NO] forKey:@"Active"];
    [memoryDict setObject:[HumanReadableDataSizeHelper humanReadableSizeFromBytes:[NSNumber numberWithLongLong:mem_inactive] useSiPrefixes:YES useSiMultiplier:NO] forKey:@"Inactive"];
    [memoryDict setObject:[HumanReadableDataSizeHelper humanReadableSizeFromBytes:[NSNumber numberWithLongLong:mem_wired] useSiPrefixes:YES useSiMultiplier:NO] forKey:@"Wired"];
    [memoryDict setObject:[HumanReadableDataSizeHelper humanReadableSizeFromBytes:[NSNumber numberWithLongLong:mem_free] useSiPrefixes:YES useSiMultiplier:NO] forKey:@"Free"];
    [memoryDict setObject:[HumanReadableDataSizeHelper humanReadableSizeFromBytes:[NSNumber numberWithLongLong:mem_used] useSiPrefixes:YES useSiMultiplier:NO] forKey:@"Used"];
    [memoryDict setObject:[HumanReadableDataSizeHelper humanReadableSizeFromBytes:[NSNumber numberWithLongLong:mem_total] useSiPrefixes:YES useSiMultiplier:NO] forKey:@"Total"];
    return memoryDict;
}

@end
