//
//  MAItemNode.h
//  Martian
//
//  Created by Evan Schoffstall on 9/10/12.
//  Copyright (c) 2012 evan schoffstall. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MAItemNode : NSObject <NSCoding>

#pragma mark -
#pragma mark Allocation

+ (MAItemNode*)nodeWithTitle:(NSString*)_title;
+ (MAItemNode*)nodeWithTitle:(NSString*)_title isHeader:(BOOL)_isHeader;

#pragma mark -
#pragma mark Properties

//@property (strong) MAItemNode * parent;
@property (strong) NSMutableArray * children;
@property (strong) NSString * title;
@property (assign) BOOL isHeader;
@property (assign) BOOL isExpanded;

#pragma mark -
#pragma mark Methods

- (void)addChild:(MAItemNode*)child;
- (BOOL)hasChildren;

#pragma mark -

@end
