//
//  MAOutlineView.h
//  Martian
//
//  Created by Evan Schoffstall on 9/11/12.
//  Copyright (c) 2012 evan schoffstall. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "MAItemNode.h"
 
@interface NSOutlineView (Additions)

- (NSMenu*)menuForEvent:(NSEvent *)event;
- (void)restoreState;

@end
