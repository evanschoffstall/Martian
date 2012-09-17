//
//  MAOutlineController.m
//  Martian
//
//  Created by Evan Schoffstall on 9/10/12.
//  Copyright (c) 2012 evan schoffstall. All rights reserved.
//

#import "MAOutlineController.h"
#import "MASaveController.h"

@implementation MAOutlineController

@synthesize postController;
@synthesize data, lastSelectedItem;
@synthesize _outlineView;
@synthesize headerMenu,itemMenu;

#pragma mark -
#pragma mark Intialization

- (id)init
{
    if (self == [super self])
    {
        [self commonInitializer:nil];
        
        if (!data)
        {
            NSLog(@"No data exists, we need to create some.");
            data = [NSMutableArray new];
            
            MAItemNode * node1 = [MAItemNode nodeWithTitle:@"Dashboard" isHeader:YES];
            MAItemNode * node2 = [MAItemNode nodeWithTitle:@"Frontpage"];
            MAItemNode * node3 = [MAItemNode nodeWithTitle:@"Inbox"];
            MAItemNode * node4 = [MAItemNode nodeWithTitle:@"Subscriptions" isHeader:YES];
            MAItemNode * node5 = [MAItemNode nodeWithTitle:@"Science"];
            MAItemNode * node6 = [MAItemNode nodeWithTitle:@"Apple"];
            
            [node1 addChild:node2];
            [node1 addChild:node3];
            
            [node4 addChild:node5];
            [node4 addChild:node6];
            
            [data addObject:node1];
            [data addObject:node4];
        }
    }
    
    return self;
}

- (void)commonInitializer:(NSCoder*)coder
{
    if (!coder)
    {
        data = [(MAOutlineController*)[[MASaveController sharedInstance] database][@"outlineController"] data];
        lastSelectedItem = [(MAOutlineController*)[[MASaveController sharedInstance] database][@"outlineController"] lastSelectedItem];
    }
    else
    {
        [self setData:[coder decodeObjectForKey:@"data"]];
        [self setLastSelectedItem:[coder decodeObjectForKey:@"lastSelectedItem"]];
    }
}

#pragma mark -
#pragma mark NSOutlineViewDataSource

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    return (!item)? [data count] : [[item children] count];
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    return (!item)? data[index] : [item children][index];
}

- (NSView*)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    NSTableCellView * cell = [outlineView makeViewWithIdentifier:([item isHeader]) ? @"HeaderCell" : @"DataCell" owner:self];
    
    [[cell textField] setStringValue:[item title]];
    
    if ([item isHeader])
    {
        [[cell imageView] setImage:nil];
        [cell setImageView:nil];
    }
    
    return cell;
}

#pragma mark -
#pragma mark NSOutlineViewDelegate

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    return [item hasChildren];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item
{
    return [item isHeader];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item
{
    return ![item isHeader];
}

#pragma mark -
#pragma mark Saving

- (void)outlineViewItemDidExpand:(NSNotification *)notification
{
    [[notification userInfo][@"NSObject"] setIsExpanded:YES];
}

- (void)outlineViewItemDidCollapse:(NSNotification *)notification
{
    [[notification userInfo][@"NSObject"] setIsExpanded:NO];
}

- (void)outlineViewSelectionDidChange:(NSNotification *)notification
{
    MAItemNode * item = [self selectedItem];
    
    [self setLastSelectedItem:item];
    [postController outlineViewSelectionDidChange:item];
}

#pragma mark -
#pragma mark NSCoder

- (id)initWithCoder:(NSCoder*)coder
{
    if (self == [super self])
    {
        [self commonInitializer:coder];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder*)coder
{
    [coder encodeObject:data forKey:@"data"];
    [coder encodeObject:lastSelectedItem forKey:@"lastSelectedItem"];
}

#pragma mark -
#pragma mark Item Quickies

- (MAItemNode*)itemForTitle:(NSString*)title
{
    for (MAItemNode * item in data)
    {
        if ([[item title] isEqualToString:title]) return item;
    }
    
    return nil;
}
                         
- (MAItemNode*)selectedItem
{
    return [_outlineView itemAtRow:[_outlineView selectedRow]];
}

- (void)selectRow:(NSInteger)row
{
    [_outlineView selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
}

- (void)editRow:(NSInteger)row
{
    [_outlineView editColumn:0 row:row withEvent:[NSApp currentEvent] select:YES];
}

- (id)itemViewForRow:(NSInteger)row
{
    return [_outlineView viewAtColumn:0 row:row makeIfNecessary:YES];
}

#pragma mark -
#pragma mark NSMenu

- (NSMenu*)menuForEvent:(NSEvent*)event
{
    NSInteger row = [_outlineView rowAtPoint:[_outlineView convertPoint:[event locationInWindow] fromView:nil]];
    MAItemNode * item = [_outlineView itemAtRow:row];
    
    if ([item isHeader] && ![[item title] isEqualToString:@"Dashboard"])
    {
        return headerMenu;
    }
    else if (![item isHeader] && ![[[self itemForTitle:@"Dashboard"] children] containsObject:item])
    {
        [self selectRow:row];
        return itemMenu;
    }
    else
    {
        return nil;
    }
}

- (IBAction)addSubscripton:(id)sender
{
    MAItemNode * parentItem = [self itemForTitle:@"Subscriptions"];
    MAItemNode * item = [MAItemNode nodeWithTitle:@"untitled"];
    
    [[parentItem children] addObject:item];
    [_outlineView reloadData];
    
    NSInteger selectionIndex = [_outlineView rowForItem:item];
    
    [self selectRow:selectionIndex];
    [[[self itemViewForRow:selectionIndex] textField] setEditable:YES];
    [[[self itemViewForRow:selectionIndex] textField] setDelegate:self];
    [self editRow:selectionIndex];
}

- (IBAction)removeSubscripton:(id)sender
{
    MAItemNode * parentItem = [self itemForTitle:@"Subscriptions"];
    MAItemNode * item = [self selectedItem];
    
    [[parentItem children] removeObject:item];
    [_outlineView reloadData];
}

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor
{
    NSInteger selectedRow = [_outlineView selectedRow];
    MAItemNode * selectedItem = [self selectedItem];
    
    [fieldEditor setEditable:NO];
    [selectedItem setTitle:[fieldEditor string]];
    
    [self selectRow:selectedRow];
    
    return YES;
}

#pragma mark -

@end




