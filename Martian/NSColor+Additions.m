//
//  NSColor+Additions.m
//  Martian
//
//  Created by Evan Schoffstall on 10/11/12.
//  Copyright (c) 2012 evan schoffstall. All rights reserved.
//

#import "NSColor+Additions.h"

@implementation NSColor (Additions)

/* This will give us a sleek, clean alternating background for the NSTableView. */

+ (NSArray*)controlAlternatingRowBackgroundColors
{
    float primary = 0.9200;
    float secondary = 0.9500;
    
    NSColor * primaryColor = [NSColor colorWithDeviceRed:primary green:primary blue:primary alpha:1];
    NSColor * secondaryColor = [NSColor colorWithDeviceRed:secondary green:secondary blue:secondary alpha:1];
    
    return [NSArray arrayWithObjects:primaryColor,secondaryColor,nil];
}


@end
