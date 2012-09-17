//
//  NSURL+Additions.m
//  Martian
//
//  Created by Evan Schoffstall on 9/12/12.
//  Copyright (c) 2012 evan schoffstall. All rights reserved.
//

#import "NSString+Additions.h"

@implementation NSString (Additions)

- (NSURL*)URLValue
{
    return [NSURL URLWithString:self];
}

@end
