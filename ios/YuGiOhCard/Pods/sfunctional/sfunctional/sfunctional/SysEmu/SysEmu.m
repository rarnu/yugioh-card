//
//  SysEmu.m
//  sfunctional
//
//  Created by rarnu on 27/03/2018.
//  Copyright © 2018 rarnu. All rights reserved.
//

#import "SysEmu.h"
#import <sys/sysctl.h>

@implementation SysEmu

+(NSString*)platform {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString* platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
}

+(BOOL) isEmulator {
    NSString* p = [self platform];
    return [p isEqualToString:@"i386"] || [p isEqualToString:@"x86_64"];
}

@end
