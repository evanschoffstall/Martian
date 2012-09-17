//
//  MAOutlineView.m
//  Martian
//
//  Created by Evan Schoffstall on 9/11/12.
//  Copyright (c) 2012 evan schoffstall. All rights reserved.
//

#import "NSOutlineView+Additions.h"
#import "MAOutlineController.h"

@implementation NSOutlineView (Additions)

- (NSMenu*)menuForEvent:(NSEvent *)event
{
    if ([_delegate respondsToSelector:@selector(menuForEvent:)])
        return [_delegate menuForEvent:event];
    
    return nil;
}

- (void)restoreState
{
    [super reloadData];
    
    for (int i = 0; i < [self numberOfRows]; ++i)
    {
        MAItemNode * item = [self itemAtRow:i];
        
        if ([item isExpanded])
            [self expandItem:item];
        if ([[[(MAOutlineController*)[self delegate] lastSelectedItem] title] isEqualTo:[item title]])
            [self selectRowIndexes:[NSIndexSet indexSetWithIndex:[self rowForItem:item]] byExtendingSelection:NO];
    }
}

- (void)textDidEndEditing:(NSNotification *)notification
{
    NSLog(@"textDidEndEditing:");
}

@end
