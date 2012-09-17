//
//  MAItemNode.m
//  Martian
//
//  Created by Evan Schoffstall on 9/10/12.
//  Copyright (c) 2012 evan schoffstall. All rights reserved.
//

#import "MAItemNode.h"

@implementation MAItemNode

@synthesize children;
@synthesize isHeader;
@synthesize title;
@synthesize isExpanded;

#pragma mark -
#pragma mark Intialization

- (id)init
{
    if (self == [super init])
    {
        children = [NSMutableArray new];
        title = [NSString new];
    }
    
    return self;
}

#pragma mark -
#pragma mark Allocation

+ (MAItemNode*)nodeWithTitle:(NSString*)_title
{
    MAItemNode * node = [MAItemNode new];
    [node setTitle:_title];
    return node;
}

+ (MAItemNode*)nodeWithTitle:(NSString *)_title isHeader:(BOOL)_isHeader
{
    MAItemNode * node = [MAItemNode nodeWithTitle:_title];
    [node setIsHeader:_isHeader];
    return node;
}

#pragma mark -
#pragma mark Children

- (void)addChild:(MAItemNode *)child
{
    [children addObject:child];
    //[child setParent:self];
}

- (BOOL)hasChildren
{
    return (children.count != 0)? YES : NO;
}

#pragma mark -
#pragma mark NSCoder

- (id)initWithCoder:(NSCoder*)coder
{
    if (self = [super init])
    {
        [self setTitle:[coder decodeObjectForKey:@"title"]];
        [self setChildren:[coder decodeObjectForKey:@"children"]];
        [self setIsHeader:[coder decodeBoolForKey:@"isHeader"]];
        [self setIsExpanded:[coder decodeBoolForKey:@"isExpanded"]];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder*)coder
{
    [coder encodeObject:title forKey:@"title"];
    [coder encodeObject:children forKey:@"children"];
    [coder encodeBool:isHeader forKey:@"isHeader"];
    [coder encodeBool:isExpanded forKey:@"isExpanded"];
}

#pragma mark -

@end






